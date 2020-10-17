# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Implementations
#

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( CleanRowUsingMonicUptoUnit,
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
    
    a1 := row[ 1, o ];
    
    Assert( 4, IsMonicUptoUnit( a1 ) );
    
    s := Degree( row[ 1, o ] );
    
    if s = 0 then
        
        T := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) T[ o, j ] := -row[ 1, j ] / a1; end );
        T[ o, o ] := 1 / a1;
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) TI[ o, j ] := row[ 1, j ] / a1; end );
        TI[ o, o ] := 1 / a1;
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
    Perform( cols, function( j ) T[ o, j ] := t[ 1, j ]; end );
    MakeImmutable( T );
    
    TI := HomalgInitialIdentityMatrix( c, R );
    Perform( cols, function( j ) TI[ o, j ] := -t[ 1, j ]; end );
    MakeImmutable( TI );
    
    Assert( 4, row = row_old * T );
    
    o_new := GetFirstMonicOfSmallestDegreeInRow( row, o );
    
    if o = o_new then
        return [ row, T, TI, o ];
    fi;
    
    l := CleanRowUsingMonicUptoUnit( row, o_new );
    
    return [ l[1], T * l[2], l[3] * TI, l[4] ];
    
end );

##
InstallMethod( CleanRowUsingMonicUptoUnit,
        "for a matrix over fake local ring and a positive integer",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsPosInt ],
        
  function( row, o )
    local bool_inv, R, l, bool_id;
    
    if HasIsRightInvertibleMatrix( row ) then
        bool_inv := IsRightInvertibleMatrix( row );
    fi;
    
    R := HomalgRing( row );
    
    l := CleanRowUsingMonicUptoUnit( Eval( row ), o );
    
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

##
## Given row, and given list of n positions, checks whether any 
## (n-1) elements of row at these positions generate unit ideal.
##
InstallMethod( GetObsoleteColumnForUnimodularity,
        "for homalg row matrices",
        [ IsHomalgMatrix, IsList ],
        
  function( row, unclean_cols )
    local lc, j, r, f, h;
    
    if not NrRows( row ) = 1 then 
        TryNextMethod( );
    fi;
    
    lc := Length( unclean_cols );
    
    for j in [ 1 .. lc ] do
        r := ShallowCopy( unclean_cols );
        Remove( r, j );
        f := CertainColumns( row, r );
        h := RightInverse( f );
        
        ## Eval(h) throws an error, if h = fail.
        if not h = fail then
            ## j = Except j-th entry, all other elements generate 1
            ## r = list of positions of entries that generate 1
            ## h = the right inverse of r-column
            return [ j, r, h ];
        fi;
    od;

    return fail;
    
end );

##
## For each row in unclean_rows, apply GetObsoleteColumnForUnimodularity
##
InstallMethod( GetObsoleteColumnForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList, IsList ],
        
  function( M, unclean_rows, unclean_cols )
    local l, i;
    
    if Length( unclean_rows ) = 1 then
        l := GetObsoleteColumnForUnimodularity( CertainRows( M, unclean_rows ), unclean_cols );
        if not l = fail then
            return [ l[1], l[2], l[3], unclean_rows[1] ];
        fi;
    fi;
    
    if Length( unclean_cols ) = 1 then
        l := GetObsoleteRowForUnimodularity( CertainColumns( M, unclean_cols ), unclean_rows );
        if not l = fail then
            return [ l[1], l[2], l[3], unclean_cols[1] ];
        fi;
    fi;
    
    for i in unclean_rows do
        l := GetObsoleteColumnForUnimodularity( CertainRows( M, [ i ] ), unclean_cols );
        
        if not l = fail then            
            ## i = the position of the row
            ## j = Excet j-th entry, all other elements generate 1
            ## r = list of positions of entries that generate 1
            ## h = the right inverse of r-column of the i-th row
            return [ l[1], l[2], l[3], i ];            
        fi;
    od;
    
    return fail;
    
end );

##
InstallMethod( GetObsoleteColumnForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return GetObsoleteColumnForUnimodularity( M, [ 1 .. NrRows( M ) ], [ 1 .. NrColumns( M ) ] );
    
end );

##
InstallMethod( GetObsoleteColumnForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( row )
    
    if not NrRows( row ) = 1 then
        TryNextMethod( );
    fi;
    
    return GetObsoleteColumnForUnimodularity( row, [ 1 .. NrColumns( row ) ] );
    
end );

##
InstallMethod( GetObsoleteColumnForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    return fail;
    
end );

##
InstallMethod( GetFirstMonicOfSmallestDegreeInRow,
        "for a homalg row matrix and positive integer",
        [ IsHomalgMatrix, IsInt ],
  function( row, o )
    local c, cols, deg_h, l, min;
    
    if NrRows( row ) > 1 then
        Error( "only for row matrices\n" );
    fi;
    
    c := NrColumns( row );
    cols := [ 1 .. c ];
    
    deg_h := Degree( row[ 1, o ] );

    l := List( cols, function( i )
        local a, deg_a;
        a := row[ 1, i ];
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
InstallMethod( EliminateIfColumnObsoleteForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( row )
    local l, R, n, W, WI, fj, rowinv, i, gi, T, P, V, VI;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-If-Obsolete-For-Unimodularity-Column" );
    
    if not NrRows( row ) = 1 then 
        TryNextMethod( );
    fi;
    
    l := GetObsoleteColumnForUnimodularity( row );
    
    if l = fail then
        return fail;
    fi;
    
    R := HomalgRing( row );
    
    n := NrColumns( row );
    
    W := HomalgInitialIdentityMatrix( n, R );
    WI := HomalgInitialIdentityMatrix( n, R );
    
    fj := row[ 1, l[1] ];
    rowinv := l[3];
    
    for i in [ 1 .. n ] do
        if i < l[1] then
            gi := rowinv[ i, 1 ] * (1 - fj);
            W[ i, l[1] ] := gi;
            WI[ i, l[1] ] := -gi;
        elif i > l[1] then
            gi := rowinv[ i - 1, 1 ] * (1 - fj);
            W[ i, l[1] ] := gi;
            WI[ i, l[1] ] := -gi;
        fi;
    od;
    MakeImmutable( W );
    MakeImmutable( WI );
    
    row := row * W;
    Assert( 4, IsOne( row[ 1, l[1] ] ) );
    
    T := CleanRowUsingMonicUptoUnit( row, l[1] );
    
    P := HomalgIdentityMatrix( n, R );
    if not l[1] = 1 then
        P := CertainRows( P, ListPerm( ( 1, l[1] ), n ) );
    fi;
    
    row := row * T[2] * P;
    Assert( 4, IsOne( row[ 1, 1 ] ) );
    Assert( 4, ZeroColumns( row ) = [ 2 .. n ] );
    
    V := W * T[2] * P;
    VI := P * T[3] * WI;
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-If-Obsolete-For-Unimodularity-Column" );
    
    return [ V, VI ];
    
end );

##
InstallMethod( GetUnimodularPairPositionPerRow,
        "for a homalg row matrix",
        [ IsHomalgMatrix ],
  function( row )
    local n, i, j, l, R, W, WI;
    
    Info( InfoQuillenSuslin, 4, "Entering Get-Unimodular-Pair-Position-Per-Row" );
    
    if not NrRows( row ) = 1 then 
        TryNextMethod( );
    fi;
    
    n := NrColumns( row );
    
    for i in IteratorOfCombinations( [ 1 .. n ], 2 ) do
        l := RightInverse( CertainColumns( row, i ) );
        if not l = fail then
            break;
        fi;
    od;
    
    if l = fail then
        Info( InfoQuillenSuslin, 4, "None of the pairs are coprime" );
        Info( InfoQuillenSuslin, 4, "Leaving Get-Unimodular-Pair-Position-Per-Row" );
        return fail;
    fi;
    
    Info( InfoQuillenSuslin, 4, "Coprime pair found" );
    Info( InfoQuillenSuslin, 4, "Leaving Get-Unimodular-Pair-Position-Per-Row" );
    
    return [ l, i ];
    
end );

##
InstallMethod( EliminateUnimodularPairPositionPerRow,
        "for a homalg row matrix",
        [ IsHomalgMatrix ],
  function( row )
    local l, i, j, R, n, W, WI, T, P, V, VI;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-Unimodular-Pair-Position-Per-Row" );
    
    l := GetUnimodularPairPositionPerRow( row );
    
    if l = fail then
        Info( InfoQuillenSuslin, 4, "Leaving Eliminate-Unimodular-Pair-Position-Per-Row" );
        return fail;
    fi;
    
    i := l[2][1];
    j := l[2][2];
    
    l := l[1];
    
    R := HomalgRing( row );
    n := NrColumns( row );

    W := HomalgInitialIdentityMatrix( n, R );
    WI := HomalgInitialIdentityMatrix( n, R );
    
    W[ i, i ] := l[ 1, 1 ];
    W[ j, i ] := l[ 2, 1 ];
    W[ i, j ] := -row[ 1, j ];
    W[ j, j ] := row[ 1, i ];
    
    WI[ i, i ] := row[ 1, i ];
    WI[ j, i ] := -l[ 2, 1 ];
    WI[ i, j ] := row[ 1, j ];
    WI[ j, j ] := l[ 1, 1 ];
    
    MakeImmutable( W );
    MakeImmutable( WI );
    
    row := row * W;
    
    Assert( 4, IsOne( row[ 1, i ] ) );
    Assert( 4, IsZero( row[ 1, j ] ) );
    
    T := CleanRowUsingMonicUptoUnit( row, i );
    
    P := HomalgIdentityMatrix( n, R );
    if not i = 1 then
        P := CertainRows( P, ListPerm( ( 1, i ), n ) );
    fi;
    
    row := row * T[2] * P;
    Assert( 4, IsOne( row[ 1, 1 ] ) );
    Assert( 4, ZeroColumns( row ) = [ 2 .. n ] );
    
    V := W * T[2] * P;
    VI := P * T[3] * WI;
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-Unimodular-Pair-Position-Per-Row" );
    return [ V, VI ];
    
end );

##
InstallMethod( EliminateUnitInARow,
        "for a homalg row matrix",
        [ IsHomalgMatrix ],
  function( row )
    local n, cols, i, l;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-unit-in-a-Row" );
    
    n := NrColumns( row );
    cols := [ 1 .. n ];
    
    ## Check whether the row contains a unit
    i := First( [ 1 .. n ], i -> IsUnit( row[ 1, i ] ) );
    
    if i = fail then
        return fail;
    fi;
    
    l := CleanRowUsingMonicUptoUnit( row, i );
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-unit-in-a-Row" );
    return [ l[2], l[2] ];
    
end );
