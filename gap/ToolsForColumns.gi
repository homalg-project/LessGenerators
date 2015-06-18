#############################################################################
##
##  ToolsForColumns.gi                                LessGenerators package
##
##  Copyright 2012-2015, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Implementations for tools for columns.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( CleanColumnUsingMonicUptoUnit,
        "for a homalg matrix and a positive integer",
        [ IsHomalgMatrix, IsPosInt ],
        
  function( col, o )
    local R, r, rows, a1, s, T, TI, a, col_old, t, o_new, l;
    
    if NrColumns( col ) > 1 then
        Error( "only for column matrices\n" );
    fi;
    
    R := HomalgRing( col );
    
    r := NrRows( col );
    
    rows := [ 1 .. r ];
    Remove( rows, o );
    
    a1 := MatElm( col, o, 1 );
    
    Assert( 4, IsMonicUptoUnit( a1 ) );
    
    s := Degree( MatElm( col, o, 1 ) );
    
    if s = 0 then
        
        T := HomalgInitialIdentityMatrix( r, R );
        Perform( rows, function( j ) SetMatElm( T, j, o, -MatElm( col, j, 1 ) / a1 ); end );
        SetMatElm( T, o, o, 1 / a1 );
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( r, R );
        Perform( rows, function( j ) SetMatElm( TI, j, o, MatElm( col, j, 1 ) / a1 ); end );
        SetMatElm( TI, o, o, 1 / a1 );
        MakeImmutable( TI );
        
        col := T * col;
        
        SetIsSubidentityMatrix( col, true );
        
        Assert( 4, NonZeroRows( col ) = [ o ] );
        SetNonZeroRows( col, [ o ] );
        
        return [ col, T, TI, o ];
        
    fi;
    
    a := EntriesOfHomalgMatrix( col );
    
    if ForAll( a{ rows }, a -> Degree( a ) < s ) then
        
        T := HomalgIdentityMatrix( r, R );
        TI := HomalgIdentityMatrix( r, R );
        return [ col, T, TI, o ];
        
    fi;
    
    col_old := col;
    
    a1 := CertainRows( col, [ o ] );
    
    t := HomalgVoidMatrix( r, 1, R );
    
    col := DecideZeroRowsEffectively( col, a1, t );
    col := UnionOfRows(
                   UnionOfRows( CertainRows( col, [ 1 .. o - 1 ] ), a1 ),
                   CertainRows( col, [ o + 1 .. r ] ) );
    
    rows := [ 1 .. r ];
    Remove( rows, o );
    
    T := HomalgInitialIdentityMatrix( r, R );
    Perform( rows, function( j ) SetMatElm( T, j, o, MatElm( t, j, 1 ) ); end );
    MakeImmutable( T );
    
    TI := HomalgInitialIdentityMatrix( r, R );
    Perform( rows, function( j ) SetMatElm( TI, j, o, -MatElm( t, j, 1 ) ); end );
    MakeImmutable( TI );
    
    Assert( 4, col = T * col_old );
    
    o_new := GetFirstMonicOfSmallestDegreeInColumn( col, o );
    
    if o = o_new then
        return [ col, T, TI, o ];
    fi;
    
    l := CleanColumnUsingMonicUptoUnit( col, o_new );
    
    return [ l[1], l[2] * T, TI * l[3], l[4] ];
    
end );

##
InstallMethod( CleanColumnUsingMonicUptoUnit,
        "for a matrix over fake local ring and a positive integer",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsPosInt ],
        
  function( col, o )
    local bool_inv, R, l, bool_id;
    
    if HasIsLeftInvertibleMatrix( col ) then
        bool_inv := IsLeftInvertibleMatrix( col );
    fi;
    
    R := HomalgRing( col );
    
    l := CleanColumnUsingMonicUptoUnit( Eval( col ), o );
    
    if HasIsSubidentityMatrix( l[1] ) then
        bool_id := IsSubidentityMatrix( l[1] );
    fi;
    
    col := R * l[1];
    
    if IsBound( bool_id ) then
        SetIsSubidentityMatrix( col, bool_id );
    elif IsBound( bool_inv ) then
        SetIsRightInvertibleMatrix( col, bool_inv );
    fi;
    
    return [ col, R * l[2], R * l[3], l[4] ];
    
end );

##
## Given column, and given list of n positions, checks whether any 
## (n-1) elements of column at these positions generate unit ideal.
##
InstallMethod( GetAllButOneGcd1RowPosition,
        "for homalg column matrices",
        [ IsHomalgMatrix, IsList ],
        
  function( col, unclean_rows )
    local lr, i, c, f, h;
    
    if not NrColumns( col ) = 1 then 
        TryNextMethod( );
    fi;
    
    lr := Length( unclean_rows );
    
    for i in [ 1 .. lr ] do
        c := ShallowCopy( unclean_rows );
        Remove( c, i );
        f := CertainRows( col, c );
        h := LeftInverse( f );
        
        ## Eval(h) throws an error, if h = fail.
        if not h = fail then
            ## i = Except j-th entry, all other elements generate 1
            ## c = list of positions of entries that generate 1
            ## h = the left inverse of r-row
            return [ i, c, h ];
        fi;
    od;

    return fail;
    
end );

##
InstallMethod( GetAllButOneGcd1RowPosition,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( col )
    
    if not NrColumns( col ) = 1 then
        TryNextMethod( );
    fi;
    
    return GetAllButOneGcd1RowPosition( col, [ 1 .. NrRows( col ) ] );
    
end );

##
InstallMethod( GetAllButOneGcd1RowPosition,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    return fail;
    
end );

##
InstallMethod( GetFirstMonicOfSmallestDegreeInColumn,
        "for a homalg column matrix and positive integer",
        [ IsHomalgMatrix, IsInt ],
  function( col, o )
    local r, rows, deg_h, l, min;
    
    if NrColumns( col ) > 1 then
        Error( "only for column matrices\n" );
    fi;
    
    r := NrRows( col );
    rows := [ 1 .. r ];
    
    deg_h := Degree( MatElm( col, o, 1 ) );

    l := List( rows, function( i )
        local a, deg_a;
        a := MatElm( col, i, 1 );
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
