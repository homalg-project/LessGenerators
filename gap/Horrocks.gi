#############################################################################
##
##  Horrocks.gi                                       LessGenerators package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Anna Fabiańska, RWTH-Aachen University
##                       Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Implementations for core procedures for Quillen-Suslin.
##
#############################################################################

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
        return [ g, zero, One( R ) ];
    fi;
    
    t := Degree( g );
    
    if not j in [ 0 .. t ] then
        Error( "the last parameter is not between zero and the degree of the second polynomial\n" );
    fi;
    
    if s - ( j + 1 ) = 0 then
        return [ g, zero, One( R ) ];
    fi;
    
    cg := CoefficientsOfUnivariatePolynomial( g );
    
    b := MatElm( cg, 1, ( j ) + 1 );
    
    if IsZero( b ) then
        return [ zero, zero, zero ];
    fi;
    
    cf := CoefficientsOfUnivariatePolynomial( f );
    
    cf := CertainColumns( cf, [ ( j + 1 ) + 1 .. ( s ) + 1 ] );
    cg := CertainColumns( cg, [ ( j + 1 ) + 1 .. ( t ) + 1 ] );
    
    Y := List( [ 0 .. s - ( j + 1 ) ], i -> Concatenation( y, "^", String( i ) ) );
    Y := Concatenation( "[", JoinStringsWithSeparator( Y ), "]" );
    Y := HomalgMatrix( Y, s - j, 1, R );
    
    cf := MatElm( cf * Y, 1, 1 );
    
    if t - j = 0 then
        cg := zero;
    else
        Y := List( [ 0 .. t - ( j + 1 ) ], i -> Concatenation( y, "^", String( i ) ) );
        Y := Concatenation( "[", JoinStringsWithSeparator( Y ), "]" );
        Y := HomalgMatrix( Y, t - j, 1, R );
        
        cg := -MatElm( cg * Y, 1, 1 );
    fi;
    
    e := cg * f + cf * g;
    
    Assert( 6, Degree( e ) = Degree( f ) - 1 );
    Assert( 6, LeadingCoefficient( e ) = b );
    
    return [ e, cg, cf ];
    
end );

## apply Suslin Lemma with specified input
InstallMethod( SuslinLemma,
        "for a homalg matrix and three integers",
        [ IsHomalgMatrix, IsInt, IsInt, IsInt ],
        
  function( row, pos_f, pos_g, j )
    local c, f, g, bj, pos_h, h, deg_h, e, af, ag, lc, a, R, T, TI;
    
    if not NrRows( row ) = 1 then
        Error( "Number of rows should be 1\n" );
    fi;
    
    c := NrColumns( row );
    
    if c < 3 then
        Error( "the row has less than three columns\n" );
    fi;
    
    f := MatElm( row, 1, pos_f );
    g := MatElm( row, 1, pos_g );
    
    bj := CoefficientOfUnivariatePolynomial( g, j );
    
    Assert( 4, IsUnit( bj ) );	## in the local base ring
    
    pos_h := First( [ 1 .. c ], i -> not i in [ pos_f, pos_g ] );
    h := MatElm( row, 1, pos_h );
    
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
    
    SetMatElm( T, pos_f, pos_h, a * af );
    SetMatElm( T, pos_g, pos_h, a * ag );
    
    SetMatElm( TI, pos_f, pos_h, -a * af );
    SetMatElm( TI, pos_g, pos_h, -a * ag );
    
    MakeImmutable( T );
    MakeImmutable( TI );
    
    return [ row * T, T, TI, pos_h, bj ];
    
end );

#InstallMethodWithDocumentation( Horrocks,
InstallMethod( Horrocks,
        "for a row matrix",
        [ IsHomalgMatrix and IsRightInvertibleMatrix, IsPosInt ],
        # The paramaters are a matrix and an integer.
        # The matrix is a unimodular row matrix with at least 3 entries.
        # The int indicates position of first monic entry.
  function( row, o )
    local R, c, a1, s, cols, a, B, resR, i, a2, coeffs, j, V, row_old, quotR, t, T, TI, H;
    
    R := HomalgRing( row );
    
     Assert( 4, Length( Indeterminates( R ) ) = 1 );
    
    if not NrRows( row ) = 1 then
        Error( "number of rows should be 1\n" );
    fi;
    
    c := NrColumns( row );
    
    if not c >= 3 then
        TryNextMethod( );
    fi;
    
    a1 := MatElm( row, 1, o );
    
    Assert( 4, IsMonic( a1 ) );
    
    s := Degree( a1 );
    
    cols := [ 1 .. c ];
    Remove( cols, o );
    
    if s = 0 then
        
        T := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) SetMatElm( T, o, j, -MatElm( row, 1, j ) / a1 ); end );
        SetMatElm( T, o, o, 1 / a1 );
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( c, R );
        Perform( cols, function( j ) SetMatElm( TI, o, j, MatElm( row, 1, j ) / a1 ); end );
        SetMatElm( TI, o, o, 1 / a1 );
        MakeImmutable( TI );
        
        return [ T, TI ];
        
    fi;
    
    a := EntriesOfHomalgMatrix( row );
    
    if ForAny( a{ cols }, a -> not ( Degree( a ) < s ) ) then
        row_old := row;
        
        quotR := AssociatedComputationRing( R );
        
        row := Eval( row );
        
        a1 := CertainColumns( row, [ o ] );
        
        t := HomalgVoidMatrix( 1, c, quotR );
        
        row := DecideZeroColumnsEffectively( row, a1, t );
        row := UnionOfColumns(
                       UnionOfColumns( CertainColumns( row, [ 1 .. o - 1 ] ), a1 ),
                       CertainColumns( row, [ o + 1 .. c ] ) );
        
        cols := [ 1 .. c ];
        Remove( cols, o );
        
        T := HomalgInitialIdentityMatrix( c, quotR );
        Perform( cols, function( j ) SetMatElm( T, o, j, MatElm( t, 1, j ) ); end );
        MakeImmutable( T );
        
        TI := HomalgInitialIdentityMatrix( c, quotR );
        Perform( cols, function( j ) SetMatElm( TI, o, j, -MatElm( t, 1, j ) ); end );
        MakeImmutable( TI );
        
        row := R * row;
        T := R * T;
        TI := R * TI;
        
        ## We cannot algorithmically verify the line below.
        SetIsRightInvertibleMatrix( row, true );
        
        Assert( 0, row = row_old * T );
        
    else
        
        T := HomalgIdentityMatrix( c, R );
        TI := HomalgIdentityMatrix( c, R );
        
    fi;
    
    a := EntriesOfHomalgMatrix( row );
    
    Assert( 0, ForAll( a{ cols }, a -> Degree( a ) < s ) );
    
    # We will assume the base field is Q,
    # This is necessary as primary decomposition in Singular is implemented only for rationals.
    # To have this algorithm working for other baserings, we need to find PrimDec algorithms.
    
    B := BaseRing( R );
    resR := AssociatedResidueClassRing( R );
    
    i := First( cols, i -> not IsZero( Numerator( a[i] ) / resR ) );
    
    Assert( 0, not i = fail );
    
    a2 := a[i];
    coeffs := EntriesOfHomalgMatrix( CoefficientsOfUnivariatePolynomial( a2 ) );
    
    j := First( [ 1 .. Length( coeffs ) ], i -> IsUnit( coeffs[ i ] ) );
    Assert( 0, not j = fail );
    
    j := j - 1;
    
    V := SuslinLemma( row, o, i, j );
    
    row := row * V[2];
    
    ## We cannot algorithmically verify the line below.
    SetIsRightInvertibleMatrix( row, true );
    
    o := V[4];
    
    H := Horrocks( row, o );
    
    Assert( 0, IsOne( H[1] * H[2] ) );
    
    return [ T * V[2] * H[1], H[2] * V[3] * TI ];
    
end );

##
InstallMethod( Patch,
        "patch local solutions obtained by Horrocks",
        [ IsHomalgMatrix and IsRightInvertibleMatrix, IsList, IsList ],
        # The paramaters are: a unimodular row matrix and an integer
        # The list of V's obtained by Horrocks
        # The list of VI's obtained by Horrocks
  function( row, Vs, VIs )
    local R, globalR, quotR, Rz, quotRz, indets, y, z, n, DeltaI, d, i, D, dinv, yy, V;
    
    ## (k[x]_p)[y]
    R := HomalgRing( Vs[1] );
    
    ## k[x][y]
    globalR := AssociatedGlobalRing( R );
    
    ## k(x)[y]
    quotR := AssociatedComputationRing( R );
    
    ## (k[x]_<x>)[y,z]
    Rz := R * "z__";
    
    ## k(x)[y,z]
    quotRz := AssociatedComputationRing( Rz );
    
    ## [y,z]
    indets := Indeterminates( quotRz );
    
    Assert( 0, Length( indets ) = 2 );
    
    y := indets[1];
    z := indets[2];
    
    n := Length( Vs );
    
    DeltaI := [ ];
    d := [ ];
    
    for i in [ 1 .. n ] do
        
        DeltaI[i] := ( quotRz * Vs[i] ) * Value( ( quotRz * VIs[i] ), y, y + z ); 
        d[i] := Denominator( Rz * DeltaI[i] );
        d[i] := d[i] / quotRz;
        
    od;
    
    D := HomalgMatrix( d, 1, Length( d ), quotRz );
    
    dinv := quotRz * RightInverse( globalR * D );
    
    yy := y;
    
    V := Value( DeltaI[1], z, -y * d[1] * MatElm( dinv, 1, 1 ) );
    
    for i in [ 2 .. n ] do
        yy := yy - y * d[i - 1] * MatElm( dinv, i - 1, 1 );
        V := V * Value( Value( DeltaI[i], y, yy ), z, -y * d[i] * MatElm( dinv, i, 1 ) );
    od;
    
    V := globalR * V;
    
    Assert( 4, ForAll( EntriesOfHomalgMatrix( row * V ), e -> Degree( e ) < 1 ) );
    
    return V;
    
end );
