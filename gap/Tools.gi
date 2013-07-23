#############################################################################
##
##  Tools.gi                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Implementations for tools.
##
#############################################################################


####################################
#
# global variables:
#
####################################

## the Cauchy-Binet column of a unimodular (n-1) x n matrix
HOMALG_IO.Pictograms.CauchyBinetColumn := "CBc";
HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits := "gru";

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( CauchyBinetColumn,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local c, R, RP, row;
    
    c := NrColumns( M );
    
    R := HomalgRing( M );
    
    if NrRows( M ) + 1 <> c then
        Error( "the input is not an (p-1) x p matrix\n" );
    elif c = 1 then
        return HomalgIdentityMatrix( 1, 1, R );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.CauchyBinetColumn) then
        row := RP!.CauchyBinetColumn( M );
        return HomalgMatrix( row, c, 1, R );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    row := List( [ 1 .. c ],
                 i -> (-1)^(c + i) * Determinant(
                         CertainColumns( M,
                                 Concatenation(
                                         [ 1 .. i - 1 ],
                                         [ i + 1 .. c ]
                                         )
                                 )
                         )
                 );
    
    return HomalgMatrix( row, c, 1, R );
    
end );

##
InstallMethod( CauchyBinetBaseChange,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return UnionOfColumns( RightInverseLazy( M ), CauchyBinetColumn( M ) );
    
end );

##
InstallMethod( CauchyBinetCompletion,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return LeftInverseLazy( CauchyBinetBaseChange( M ) );
    
end );

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList, IsList ],
        
  function( M, unclean_rows, unclean_columns )
    local lr, j, i, r, f, h;
    
    lr := Length( unclean_rows );
    
    for j in unclean_columns do
        for i in [ 1 .. lr ] do
            r := ShallowCopy( unclean_rows );
            Remove( r, i );
            f := CertainRows( CertainColumns( M, [ j  ] ), r );
            h := LeftInverse( f );
            if Eval( h ) <> fail then
                ## i = the position of the obsolete row
                ## j = the position of the column where all the entries but the i-th row generate 1
                ## r = the number of rows in the j-th column that generate 1
                ## h = the left inverse of r-rows of the j-th column
                return [ i, j, r, h ];
            fi;
        od;
    od;
    
    return fail;
    
end );

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return GetAllButOneGcd1ColumnPosition( M, [ 1 .. NrRows( M ) ], [ 1 .. NrColumns( M ) ] );
    
end );

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    return fail;
    
end );

##
InstallMethod( GetFirstMonicOfSmallestDegree,
        "for a homalg row matrix and positive integer",
        [ IsHomalgMatrix, IsInt ],
  function( row, o )
    local c, cols, deg_h, l, min;
    
    if NrRows( row ) > 1 then
        Error( "only for row matrices\n" );
    fi;
    
    c := NrColumns( row );
    cols := [ 1 .. c ];
    
    deg_h := Degree( MatElm( row, 1, o ) );

    l := List( cols, function( i )
        local a, deg_a;
        a := MatElm( row, 1, i );
        deg_a := Degree( a );
        
        if deg_a < deg_h and IsMonic( a ) then
            return deg_a;
        fi;
        return deg_h;
    end );
    
    min := Minimum( l );
    if min < deg_h then
        o := Position( l, min );
    fi;
    
    return o;
    
end );

##
InstallMethod( CleanRowUsingMonics,
        "for a homalg matrix and a positive integer",
        [ IsHomalgMatrix, IsPosInt ],
        
  function( row, o )
    local R, c, cols, a1, s, T, TI, a, row_old, t, o_new, l;
    
    if NrRows( row ) > 1 then
        Error( "only for row matrices\n" );
    fi;
    
    R := HomalgRing( row );
    
    c := NrColumns( row );
    
    cols := [ 1 .. c ];
    Remove( cols, o );
    
    a1 := MatElm( row, 1, o );
    
    Assert( 4, IsMonic( a1 ) );
    
    s := Degree( MatElm( row, 1, o ) );
    
    if s = 0 then
        
        T := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) SetMatElm( T, o, j, -MatElm( row, 1, j ) / a1 ); end );
        SetMatElm( T, o, o, 1 / a1 );
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) SetMatElm( TI, o, j, MatElm( row, 1, j ) / a1 ); end );
        SetMatElm( TI, o, o, 1 / a1 );
        MakeImmutable( TI );
        
        row := row * T;
        
        SetIsSubidentityMatrix( row, true );
        
        Assert( 4, NonZeroColumns( row ) = [ o ] );
        SetNonZeroColumns( row, [ o ] );
        
        return [ row, T, TI, o ];
        
    fi;
    
    a := EntriesOfHomalgMatrix( row );
    
    if ForAll( a{ cols }, a -> Degree( a ) < s ) then
        
        T := HomalgIdentityMatrix( c, R );
        TI := HomalgIdentityMatrix( c, R );
        return [ row, T, TI, o ];
        
    fi;
    
    row_old := row;
    
    a1 := CertainColumns( row, [ o ] );
    
    t := HomalgVoidMatrix( 1, c, R );
    
    row := DecideZeroColumnsEffectively( row, a1, t );
    row := UnionOfColumns(
                   UnionOfColumns( CertainColumns( row, [ 1 .. o - 1 ] ), a1 ),
                   CertainColumns( row, [ o + 1 .. c ] ) );
    
    cols := [ 1 .. c ];
    Remove( cols, o );
    
    T := HomalgInitialIdentityMatrix( c, R );
    Perform( cols, function( j ) SetMatElm( T, o, j, MatElm( t, 1, j ) ); end );
    MakeImmutable( T );
    
    TI := HomalgInitialIdentityMatrix( c, R );
    Perform( cols, function( j ) SetMatElm( TI, o, j, -MatElm( t, 1, j ) ); end );
    MakeImmutable( TI );
    
    Assert( 4, row = row_old * T );
    
    o_new := GetFirstMonicOfSmallestDegree( row, o );
    
    if o = o_new then
        return [ row, T, TI, o ];
    fi;
    
    l := CleanRowUsingMonics( row, o_new );
    
    return [ row, T * l[2], l[3] * TI, l[4] ];
    
end );

##
InstallMethod( CleanRowUsingMonics,
        "for a matrix over fake local ring and a positive integer",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsPosInt ],
        
  function( row, o )
    local bool_inv, R, l, bool_id;
    
    if HasIsRightInvertibleMatrix( row ) then
        bool_inv := IsRightInvertibleMatrix( row );
    fi;
    
    R := HomalgRing( row );
    
    l := CleanRowUsingMonics( Eval( row ), o );
    
    if HasIsSubidentityMatrix( l[1] ) then
        bool_id := IsSubidentityMatrix( l[1] );
    fi;
    
    row := R * l[1];
    
    if IsBound( bool_id ) then
        SetIsSubidentityMatrix( row, bool_id );
    elif IsBound( bool_inv ) then
        SetIsRightInvertibleMatrix( row, bool_inv );
    fi;
    
    return [ row, R * l[2], R * l[3], l[4] ];
    
end );
