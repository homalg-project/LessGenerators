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
    
    a1 := col[ o, 1 ];
    
    Assert( 4, IsMonicUptoUnit( a1 ) );
    
    s := Degree( col[ o, 1 ] );
    
    if s = 0 then
        
        T := HomalgInitialIdentityMatrix( r, R );
        Perform( rows, function( j ) T[ j, o ] := -col[ j, 1 ] / a1; end );
        T[ o, o ] := 1 / a1;
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( r, R );
        Perform( rows, function( j ) TI[ j, o ] := col[ j, 1 ] / a1; end );
        TI[ o, o ] := 1 / a1;
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
    Perform( rows, function( j ) T[ j, o ] := t[ j, 1 ]; end );
    MakeImmutable( T );
    
    TI := HomalgInitialIdentityMatrix( r, R );
    Perform( rows, function( j ) TI[ j, o ] := -t[ j, 1 ]; end );
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
InstallMethod( GetObsoleteRowForUnimodularity,
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
## For each column in unclean_cols, apply GetObsoleteRowForUnimodularity
##
InstallMethod( GetObsoleteRowForUnimodularity,
        "for homalg column matrices",
        [ IsHomalgMatrix, IsList, IsList ],
        
  function( M, unclean_cols, unclean_rows )
    local l, i;
    
    if Length( unclean_cols ) = 1 then
        l := GetObsoleteRowForUnimodularity( CertainColumns( M, unclean_cols ), unclean_rows );
        if not l = fail then
            return [ l[1], l[2], l[3], unclean_cols[1] ];
        fi;
    fi;
    
    if Length( unclean_rows ) = 1 then
        l := GetObsoleteColumnForUnimodularity( CertainRows( M, unclean_rows ), unclean_cols );
        if not l = fail then
            return [ l[1], l[2], l[3], unclean_rows[1] ];
        fi;
    fi;
    
    for i in unclean_cols do
        l := GetObsoleteRowForUnimodularity( CertainColumns( M, [ i ] ), unclean_rows );
        
        if not l = fail then            
            ## i = the position of the column
            ## j = Excet j-th entry, all other elements generate 1
            ## r = list of positions of entries that generate 1
            ## h = the left inverse of r-row of the i-th column
            return [ l[1], l[2], l[3], i ];            
        fi;
    od;
    
    return fail;
    
end );

##
InstallMethod( GetObsoleteRowForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return GetObsoleteRowForUnimodularity( M, [ 1 .. NrColumns( M ) ], [ 1 .. NrRows( M ) ] );
    
end );

##
InstallMethod( GetObsoleteRowForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( col )
    
    if not NrColumns( col ) = 1 then
        TryNextMethod( );
    fi;
    
    return GetObsoleteRowForUnimodularity( col, [ 1 .. NrRows( col ) ] );
    
end );

##
InstallMethod( GetObsoleteRowForUnimodularity,
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
    
    deg_h := Degree( col[ o, 1 ] );

    l := List( rows, function( i )
        local a, deg_a;
        a := col[ i, 1 ];
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
InstallMethod( EliminateIfRowObsoleteForUnimodularity,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( col )
    local l, R, n, W, WI, fj, colinv, i, gi, T, P, V, VI;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-If-Obsolete-For-Unimodularity-Row" );
    
    if not NrColumns( col ) = 1 then 
        TryNextMethod( );
    fi;
    
    l := GetObsoleteRowForUnimodularity( col );
    
    if l = fail then
        return fail;
    fi;
    
    R := HomalgRing( col );
    
    n := NrRows( col );
    
    W := HomalgInitialIdentityMatrix( n, R );
    WI := HomalgInitialIdentityMatrix( n, R );
    
    fj := col[ l[1], 1 ];
    colinv := l[3];
    
    for i in [ 1 .. n ] do
        if i < l[1] then
            gi := (1 - fj) * colinv[ 1, i ];
            W[ l[1], i ] := gi;
            WI[ l[1], i ] := -gi;
        elif i > l[1] then
            gi := (1 - fj) * colinv[ 1, i - 1 ];
            W[ l[1], i ] := gi;
            WI[ l[1], i ] := -gi;
        fi;
    od;
    MakeImmutable( W );
    MakeImmutable( WI );
    
    col := W * col;
    Assert( 4, IsOne( col[ l[1], 1 ] ) );
    
    T := CleanColumnUsingMonicUptoUnit( col, l[1] );
    
    P := HomalgIdentityMatrix( n, R );
    if not l[1] = 1 then
        P := CertainColumns( P, ListPerm( ( 1, l[1] ), n ) );
    fi;
    
    col := P * T[2] * col;
    Assert( 4, IsOne( col[ 1, 1 ] ) );
    Assert( 4, ZeroRows( col ) = [ 2 .. n ] );
    
    V := P * T[2] * W;
    VI := WI * T[3] * P;
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-If-Obsolete-For-Unimodularity-Row" );
    
    return [ V, VI ];
    
end );

##
InstallMethod( GetUnimodularPairPositionPerColumn,
        "for a homalg Column matrix",
        [ IsHomalgMatrix ],
  function( col )
    local n, i, j, l, R, W, WI;
    
    Info( InfoQuillenSuslin, 4, "Entering Get-Unimodular-Pair-Position-Per-Column" );
    
    if not NrColumns( col ) = 1 then 
        TryNextMethod( );
    fi;
    
    n := NrRows( col );
    
    for i in IteratorOfCombinations( [ 1 .. n ], 2 ) do
        l := LeftInverse( CertainRows( col, i ) );
        if not l = fail then
            break;
        fi;
    od;
    
    if l = fail then
        Info( InfoQuillenSuslin, 4, "None of the pairs are coprime" );
        Info( InfoQuillenSuslin, 4, "Leaving Get-Unimodular-Pair-Position-Per-Column" );
        return fail;
    fi;
    
    Info( InfoQuillenSuslin, 4, "Coprime pair found" );
    Info( InfoQuillenSuslin, 4, "Leaving Get-Unimodular-Pair-Position-Per-Column" );
    
    return [ l, i ];
    
end );

##
InstallMethod( EliminateUnimodularPairPositionPerColumn,
        "for a homalg column matrix",
        [ IsHomalgMatrix ],
  function( col )
    local l, i, j, R, n, W, WI, T, P, V, VI;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-Unimodular-Pair-Position-Per-Column" );
    
    l := GetUnimodularPairPositionPerColumn( col );
    
    if l = fail then
        Info( InfoQuillenSuslin, 4, "Leaving Eliminate-Unimodular-Pair-Position-Per-Column" );
        return fail;
    fi;
    
    i := l[2][1];
    j := l[2][2];
    
    l := l[1];
    
    R := HomalgRing( col );
    n := NrRows( col );
    
    W := HomalgInitialIdentityMatrix( n, R );
    WI := HomalgInitialIdentityMatrix( n, R );
    
    W[ i, i ] := l[ 1, 1 ];
    W[ i, j ] := l[ 1, 2 ];
    W[ j, i ] := -col[ j, 1 ];
    W[ j, j ] := col[ i, 1 ];
    
    WI[ i, i ] := col[ i, 1 ];
    WI[ i, j ] := -l[ 1, 2 ];
    WI[ j, i ] := col[ j, 1 ];
    WI[ j, j ] := l[ 1, 1 ];
    
    MakeImmutable( W );
    MakeImmutable( WI );
    
    col := W * col;
    
    Assert( 4, IsOne( col[ i, 1 ] ) );
    Assert( 4, IsZero( col[ j, 1 ] ) );
    
    T := CleanColumnUsingMonicUptoUnit( col, i );
    
    P := HomalgIdentityMatrix( n, R );
    if not i = 1 then
        P := CertainColumns( P, ListPerm( ( 1, i ), n ) );
    fi;
    
    col := P * T[2] * col;
    Assert( 4, IsOne( col[ 1, 1 ] ) );
    Assert( 4, ZeroRows( col ) = [ 2 .. n ] );
    
    V := P * T[2] * W;
    VI := WI * T[3] * P;
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-Unimodular-Pair-Position-Per-Row" );
    return [ V, VI ];
    
end );

##
InstallMethod( EliminateUnitInAColumn,
        "for a homalg column matrix",
        [ IsHomalgMatrix ],
  function( col )
    local n, rows, i, l;
    
    Info( InfoQuillenSuslin, 4, "Entering Eliminate-unit-in-a-Column" );
    
    n := NrRows( col );
    rows := [ 1 .. n ];
    
    ## Check whether the col contains a unit
    i := First( [ 1 .. n ], i -> IsUnit( col[ i, 1 ] ) );
    
    if i = fail then
        return fail;
    fi;
    
    l := CleanColumnUsingMonicUptoUnit( col, i );
    
    Info( InfoQuillenSuslin, 4, "Leaving Eliminate-unit-in-a-Column" );
    return [ l[2], l[2] ];
    
end );
