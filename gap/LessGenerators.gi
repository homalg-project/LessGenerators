#############################################################################
##
##  LessGenerators.gi                                 LessGenerators package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Anna Fabiańska, RWTH-Aachen University
##                       Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Implementation stuff for LessGenerators.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

#InstallValue( LESS_GENERATORS,
#        rec(
#            
#            )
#);

####################################
#
# global functions and operations:
#
####################################

## stably free modules of rank 1 are free
InstallGlobalFunction( OnLessGenerators_ForStablyFreeRank1OverCommutative,
  function( M )
    local R, rel, n, empty, T, TI;
    
    if NrRelations( M ) = 0 then
        return M;
    fi;
    
    if FiniteFreeResolution( M ) = fail then
        TryNextMethod( );
    fi;
    
    SetRankOfObject( M, 1 );
    SetIsFree( M, true );
    
    ShortenResolution( M );
    
    OnPresentationByFirstMorphismOfResolution( M );
    
    R := HomalgRing( M );
    
    rel := MatrixOfRelations( M );
    
    n := NrGenerators( M );
    
    if NrRelations( M ) + 1 = NrGenerators( M ) then
        ## apply Cauchy-Binet trick
        if IsHomalgLeftObjectOrMorphismOfLeftObjects( M ) then
            empty := HomalgZeroMatrix( 0, 1, R );
            empty := HomalgRelationsForLeftModule( empty, M );
            T := HomalgMatrix( R );
            SetNrRows( T, n );
            SetNrColumns( T, 1 );
            SetEvalMatrixOperation( T, [ CauchyBinetColumn, [ rel ] ] );
            TI := LeftInverseLazy( T );
        else
            empty := HomalgZeroMatrix( 1, 0, R );
            empty := HomalgRelationsForRightModule( empty, M );
            T := HomalgMatrix( R );
            SetNrRows( T, 1 );
            SetNrColumns( T, n );
            SetEvalMatrixOperation( T, [ r -> Involution( CauchyBinetColumn( Involution( r ) ) ), [ rel ] ] );
            TI := RightInverseLazy( T );
        fi;
        
    else
        TryNextMethod( );
    fi;
    
    AddANewPresentation( M, empty, T, TI );
    
    return M;
    
end );

##
InstallGlobalFunction( OnLessGenerators_UsingParametrization,
  function( M )
    local par;
    
    par := Parametrization( M );
    
    if not IsIsomorphism( par ) then
        TryNextMethod( );
    fi;
    
    PushPresentationByIsomorphism( par^-1 );
    
    return M;
    
end );

##
InstallMethod( OnLessGenerators,
        "for stably free modules of rank 1",
        [ IsFinitelyPresentedModuleRep and
          IsStablyFree and FiniteFreeResolutionExists ],
        
  OnLessGenerators_ForStablyFreeRank1OverCommutative );

##
InstallMethod( OnLessGenerators,
        "for modules",
        [ IsFinitelyPresentedModuleRep  ], 101,
        
  OnLessGenerators_UsingParametrization );

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
    local c, f, g, bj, pos_h, h, deg_h, e, af, ag, lc, a, R, T;
    
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
    
    SetMatElm( T, pos_f, pos_h, a * af );
    SetMatElm( T, pos_g, pos_h, a * ag );
    
    MakeImmutable( T );
    
    return [ row * T, T, pos_h, bj ];
    
end );

#InstallMethodWithDocumentation( Horrocks,
InstallMethod( Horrocks,
        "for a row matrix",
        [ IsHomalgMatrix, IsPosInt ],
        # The paramaters are a matrix and an integers.
        # The matrix is a row matrix with at least 3 entries.
        # The int indicates position of first monic entry.
  function( row, o )
    local R, c, a1, s, cols, a, m, Rm, i, a2, coeffs, j, U;
    
    R := HomalgRing( row );
    Assert( 4, Length( RelativeIndeterminatesOfPolynomialRing( R ) ) = 1 );
    
    if not NrRows( row ) = 1 then
        TryNextMethod( );
    fi;
    
    c := NrColumns( row );
    
    if not c >= 3 then
        TryNextMethod( );
    fi;
    
    a1 := MatElm( row, 1, o );
    
    Assert( 4, IsMonic( a1 ) );
    
    s := Degree( a1 );
    
    if s = 0 then
        TryNextMethod( );
    fi;
    
    cols := [ 1 .. c ];
    Remove( cols, o );
    
    a := EntriesOfHomalgMatrix( row );
    
    if ForAny( a{ cols }, a -> not ( Degree( a ) < s ) ) then
        TryNextMethod( );
    fi;
    
    # We will assume the base field is Q,
    # This is necessary as primary decomposition in Singular is implemented only for rationals.
    # To have this algorithm working for other baserings, we need to find PrimDec algorithms.
    
    m := AMaximalIdealContaining( ZeroLeftSubmodule( BaseRing( R ) ) );
    Rm := R * m;
    
    i := First( cols, i -> not a[i] in Rm );
    
    Assert( 0, not i = fail );
    
    a2 := a[i];
    coeffs := Reversed( EntriesOfHomalgMatrix( CoefficientsOfUnivariatePolynomial( a2 ) ) );
    
    j := First( [ 1 .. Length( coeffs ) ], i -> IsUnit( coeffs[ i ] ) );
    
    U := SuslinLemma( row, o, i, j );
    
    return Horrocks( row * U, 1 );
    
end );

