# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Implementations
#

####################################
#
# global functions and operations:
#
####################################

## [Rotman09, Lemma. 4.97], [ Fabianska09, QuillenSuslin package: SuslinLemma ]
InstallMethod( SuslinLemma,
        "for two homalg ring elements and an integer",
        [ IsHomalgRingElement, IsHomalgRingElement, IsInt ],
  function( f, g, j )
    local R, indets, y, s, zero, t, cf, cg, b, Y, e;
    
    Info( InfoQuillenSuslin, 4, "Entering SuslinLemma" );
    
    R := HomalgRing( f );
    
    if not IsIdenticalObj( R, HomalgRing( g ) ) then
        Error( "the two polynomials must be defined over the same ring\n" );
    fi;
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        indets := RelativeIndeterminatesOfPolynomialRing( R );
    elif HasIndeterminatesOfPolynomialRing( R ) then
        indets := IndeterminatesOfPolynomialRing( R );
    fi;
    
    if not Length( indets ) = 1 then
        Error( "Suslin's Lemma only applies for univariate polynomials over a commutative base ring\n" );
    fi;
    
    y := String( indets[1] );
    
    if not IsMonic( f ) then
        Error( "the first polynomial is not monic\n" );
    fi;
    
    s := Degree( f );
    
    if Degree( g ) >= s then
        Error( "the degree of the first polynomial must be greater than that of the second\n" );
    fi;
    
    zero := Zero( R );
    
    if IsZero( g ) then
        Info( InfoQuillenSuslin, 4, "Leaving SuslinLemma" );
        return [ g, zero, One( R ) ];
    fi;
    
    t := Degree( g );
    
    if not j in [ 0 .. t ] then
        Error( "the last parameter is not between zero and the degree of the second polynomial\n" );
    fi;
    
    if s - ( j + 1 ) = 0 then
        Info( InfoQuillenSuslin, 4, "Leaving SuslinLemma" );
        return [ g, zero, One( R ) ];
    fi;
    
    cg := CoefficientsOfUnivariatePolynomial( g );
    
    b := cg[ 1, j + 1 ];
    
    if IsZero( b ) then
        Info( InfoQuillenSuslin, 4, "Leaving SuslinLemma" );
        return [ zero, zero, zero ];
    fi;
    
    cf := CoefficientsOfUnivariatePolynomial( f );
    
    cf := CertainColumns( cf, [ ( j + 1 ) + 1 .. ( s ) + 1 ] );
    cg := CertainColumns( cg, [ ( j + 1 ) + 1 .. ( t ) + 1 ] );
    
    Y := List( [ 0 .. s - ( j + 1 ) ], i -> Concatenation( y, "^", String( i ) ) );
    Y := Concatenation( "[", JoinStringsWithSeparator( Y ), "]" );
    Y := HomalgMatrix( Y, s - j, 1, R );
    
    cf := cf * Y;
    cf := cf[ 1, 1 ];
    
    if t - j = 0 then
        cg := zero;
    else
        Y := List( [ 0 .. t - ( j + 1 ) ], i -> Concatenation( y, "^", String( i ) ) );
        Y := Concatenation( "[", JoinStringsWithSeparator( Y ), "]" );
        Y := HomalgMatrix( Y, t - j, 1, R );
        
        cg := cg * Y;
        cg := -cg[ 1, 1 ];
    fi;
    
    e := cg * f + cf * g;
    
    Assert( 6, Degree( e ) = Degree( f ) - 1 );
    Assert( 6, LeadingCoefficient( e ) = b );
    
    Info( InfoQuillenSuslin, 4, "Leaving SuslinLemma" );
    
    return [ e, cg, cf ];
    
end );

#! @BeginCode SuslinLemmaCode:4arg
InstallMethod( SuslinLemma,
        "for a homalg matrix and three integers",
        [ IsHomalgMatrix, IsInt, IsInt, IsInt ],
        
  function( row, pos_f, pos_g, j )
    local c, bool_inv, f, g, bj, pos_h, h, deg_h, e, af, ag, lc, a, R, T, TI;
    
    Info( InfoQuillenSuslin, 4, "Entering SuslinLemma for row" );
    
    if not NrRows( row ) = 1 then
        Error( "Number of rows should be 1\n" );
    fi;
    
    c := NrColumns( row );
    
    if c < 3 then
        Error( "the row has less than three columns\n" );
    fi;
    
    if HasIsRightInvertibleMatrix( row ) then
        bool_inv := IsRightInvertibleMatrix( row );
    fi;
    
    f := row[ 1, pos_f ];
    g := row[ 1, pos_g ];
    
    bj := CoefficientOfUnivariatePolynomial( g, j );
    
    Assert( 4, IsUnit( bj ) ); ## in the local base ring
    
    pos_h := First( [ 1 .. c ], i -> not i in [ pos_f, pos_g ] );
    h := row[ 1, pos_h ];
    
    deg_h := Degree( h );
    
    Assert( 0, deg_h < Degree( f ) and not IsMonic( h ) );
    
    e := SuslinLemma( f, g, j );
    
    af := e[2];
    ag := e[3];
    e := e[1];
    
    Assert( 4, LeadingCoefficient( e ) = bj );
    
    if deg_h < Degree( f ) - 1 then
        a := bj^-1;
    else
        lc := LeadingCoefficient( h );
        a := ( 1 - lc ) * bj^-1;
    fi;
    
    R := HomalgRing( row );
    T := HomalgInitialIdentityMatrix( c, R );
    TI := HomalgInitialIdentityMatrix( c, R );
    
    T[ pos_f, pos_h ] := a * af;
    T[ pos_g, pos_h ] := a * ag;
    
    TI[ pos_f, pos_h ] := -a * af;
    TI[ pos_g, pos_h ] := -a * ag;
    
    MakeImmutable( T );
    MakeImmutable( TI );
    
    Assert( 4, IsOne( T * TI ) );
    
    row := row * T;
    
    if IsBound( bool_inv ) then
        ## We cannot algorithmically verify the line below.
        ## TODO: should become obsolete with ToDo-lists in MatricesForHomalg.
        SetIsRightInvertibleMatrix( row, bool_inv );
    fi;
    
    Info( InfoQuillenSuslin, 4, "Leaving SuslinLemma for row" );
    
    return [ row, T, TI, pos_h, bj ];
    
end );
#! @EndCode

##
InstallMethod( Horrocks,
        "for a row matrix",
        [ IsHomalgMatrix and IsRightInvertibleMatrix, IsPosInt ],
        
  function( row, o )
    local R, c, l, T, TI, pos, cols, a, resR, i, coeffs, j, H;
    
    Info( InfoQuillenSuslin, 4, "Entering Horrocks" );
    
    R := HomalgRing( row );
    
    if not Length( Indeterminates( R ) ) = 1 then
        Error( "Horrocks assumes the ring to be univariate polynomial ring over a local ring" );
    fi;
    
    if not NrRows( row ) = 1 then
        Error( "number of rows should be 1\n" );
    fi;
    
    c := NrColumns( row );
    
    if c < 3 then
        Error( "the row has less than three columns\n" );
    fi;
    
    ## we ensure that the entry at the o-th position is the only monic
    ## and that all other entries are of lower degree
    l := CleanRowUsingMonicUptoUnit( row, o );
    
    row := l[1];
    T := l[2];
    TI := l[3];
    
    pos := NonZeroColumns( row );
    
    if Length( pos ) = 1 and IsOne( row[ 1, pos[1] ] ) then
        Info( InfoQuillenSuslin, 4, "Subidentity row achieved" );
        Info( InfoQuillenSuslin, 4, "Leaving Horrocks" );
        return [ T, TI ];
    fi;
    
    o := l[4];
    
    a := EntriesOfHomalgMatrix( row );
    
    cols := [ 1 .. c ];
    Remove( cols, o );
    
    resR := AssociatedResidueClassRing( R );
    
    ## we now search for the first i such that a[i] is not in Rm
    i := First( cols, i -> not IsZero( Numerator( a[i] ) / resR ) );
    
    Assert( 0, not i = fail );
    
    coeffs := EntriesOfHomalgMatrix( CoefficientsOfUnivariatePolynomial( a[i] ) );
    
    ## the first j such that the coefficient of y^j in a[i] is a unit
    j := First( [ 0 .. Length( coeffs ) - 1 ], j -> IsUnit( coeffs[j + 1] ) );
    Assert( 0, not j = fail );
    
    l := SuslinLemma( row, o, i, j );
    
    row := l[1];
    T := T * l[2];
    TI := l[3] * TI;
    o := l[4];
    
    H := Horrocks( row, o );
    Info( InfoQuillenSuslin, 4, "Leaving Horrocks" );
    
    return [ T * H[1], H[2] * TI ];
    
end );

##
InstallMethod( Patch,
        "patch local solutions obtained by Horrocks",
        [ IsHomalgMatrix and IsRightInvertibleMatrix, IsList, IsList ],
        # The paramaters are: a unimodular row matrix and an integer
        # The list of V's obtained by Horrocks
        # The list of VI's obtained by Horrocks
  function( row, Vs, VIs )
    local R, globalR, fracR, Rz, fracRz, indets, y, z, n, DeltaI, d, i, D, dinv, yy, V;
    
    Info( InfoQuillenSuslin, 4, "Entering Patch" );

    Vs := ShallowCopy( Vs );
    VIs := ShallowCopy( VIs );
    
    ## (k[x]_p)[y]
    R := HomalgRing( Vs[1] );
    
    ## k[x][y]
    globalR := AssociatedGlobalRing( R );
    
    ## k(x)[y]
    fracR := AssociatedComputationRing( R );
    
    ## (k[x]_<x>)[y,z]
    Rz := R * "z__";
    
    ## k(x)[y,z]
    fracRz := AssociatedComputationRing( Rz );
    
    ## [y,z]
    indets := Indeterminates( fracRz );
    
    Assert( 0, Length( indets ) = 2 );
    
    y := indets[1];
    z := indets[2];
    
    n := Length( Vs );
    
    DeltaI := [ ];
    d := [ ];
    
    for i in [ 1 .. n ] do
        
        Vs[i] := fracRz * Vs[i];
        VIs[i] := fracRz * VIs[i];
        
        DeltaI[i] := Vs[i] * Value( VIs[i], y, y + z );
        d[i] := Denominator( Rz * DeltaI[i] );
        d[i] := d[i] / fracRz;
        
    od;
    
    D := HomalgMatrix( d, 1, Length( d ), fracRz );
    
    dinv := fracRz * RightInverse( globalR * D );
    dinv := EntriesOfHomalgMatrix( dinv );
    
    yy := y;
    
    V := Value( DeltaI[1], z, -y * d[1] * dinv[1] );
    
    for i in [ 2 .. n ] do
        yy := yy - y * d[i - 1] * dinv[i - 1];
        V := V * Value( Value( DeltaI[i], y, yy ), z, -y * d[i] * dinv[i] );
    od;
    
    V := globalR * V;
    
    Assert( 4, ForAll( EntriesOfHomalgMatrix( ( globalR * row ) * V ), e -> Degree( e ) < 1 ) );
    
    Info( InfoQuillenSuslin, 4, "Leaving Patch" );

    return HomalgRing( row ) * V;
    
end );
