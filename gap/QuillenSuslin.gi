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

##
InstallMethod( QuillenSuslin,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( row )
    local row_orig, S, noether, l, monic, u, U, monic_var_index, y, R, baseR,
          Delta1, I, o, H, m, R_m, row_m, H_m, V, row_new, T, c, P;
    
    Info( InfoQuillenSuslin, 4, "Entering QuillenSuslin for row" );
    
    row_orig := row;
    
    if not NrRows( row ) = 1 then
        TryNextMethod( );
    fi;
    
    S := HomalgRing( row );
    
    noether := NoetherNormalization( row );
    
    l := noether[2];
    
    monic := l[1];
    
    u := LeadingCoefficient( monic ) / S;
    
    Assert( 4, IsUnit( u ) );
    
    U := HomalgMatrix( [ u^-1 ], 1, 1, S );
    
    ## this gives the index of the variable w.r.t. which
    ## the new row has a monic upto a unit
    monic_var_index := l[3];
    
    if HasRelativeIndeterminatesOfPolynomialRing( S ) then
        y := RelativeIndeterminatesOfPolynomialRing( S )[monic_var_index];
    elif HasIndeterminatesOfPolynomialRing( S ) then
        y := IndeterminatesOfPolynomialRing( S )[monic_var_index];
    else
        Error( "the ring is not a polynomial ring\n" );
    fi;
    
    row := U * noether[1];
    
    Assert( 4, IsRightInvertibleMatrix( row ) );
    SetIsRightInvertibleMatrix( row, true );
    
    # l[1] is the monic (upto a unit) element in a univariate polynomial ring over a base ring
    R := HomalgRing( monic );
    
    if HasBaseRing( R ) then
        baseR := BaseRing( R );
    else
        baseR := CoefficientsRing( R );
    fi;
    
    Delta1 := Zero( baseR );
    
    I := ZeroLeftSubmodule( baseR );
    
    # l[2][2] gives the position of the monic (upto a unit) l[1] in the row.
    o := l[2][2];
    H := [ ];
    
    repeat
        
        m := AMaximalIdealContaining( I );
        
        m := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m ) );
        
        R_m := LocalizeBaseRingAtPrime( R, m );
        
        row_m := R_m * row;
        
        Assert( 4, IsRightInvertibleMatrix( row_m ) );
        SetIsRightInvertibleMatrix( row_m, true );
        
        H_m := Horrocks( row_m, o );
        
        Assert( 4, row_m * H_m[1] = CertainRows( HomalgIdentityMatrix( NrColumns( row_m ), R_m ), NonZeroColumns( row_m * H_m[1] ) ) );
        
        Add( H, H_m );
        
        Delta1 := Denominator( H_m[1] ) / baseR;
        
        Assert( 4, not Delta1 in I );
        
        I := I + LeftSubmodule( Delta1 );
        
        OnBasisOfPresentation( I );
        
    until IsOne( I );
    
    H := TransposedMat( H );
    
    V := Patch( row, H[1], H[2] );
    
    row_new := row * V;
    Assert( 4, row_new = Value( row, y, Zero( y ) ) );
    row := row_new;
    
    u := U[ 1, 1 ];
    IsOne( u );
    IsMinusOne( u );
    
    V := u * V;
    
    l := GetMonicUptoUnit( row );
    
    if l = fail then
        Error ( "need Noether normalization\n" );
    fi;
    
    T := CleanRowUsingMonicUptoUnit( row, l[2][2] );
    
    Assert( 4, row * T[2] = T[1] );
    
    V := V * T[2];
    row := T[1];
    
    if HasIsSubidentityMatrix( row ) and IsSubidentityMatrix( row ) then
        
        if IsHomalgRingMap( noether[4] ) then
            V := Pullback( noether[4], V );
        fi;
        
        c := NrColumns( row );
        P := HomalgIdentityMatrix( c, S );
        
        o := NonZeroColumns( row )[1];
        
        if not o = 1 then
            P := CertainColumns( P, ListPerm( (1,o), c ) );
        fi;
        
        V := V * P;
        
        Assert( 4, row_orig * V = CertainRows( HomalgIdentityMatrix( NrColumns( row ), S ), [ 1 ] ) );
        
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin row" );
        
        return V;
    fi;
    
    ## at least one less variable
    row_new := baseR * row;
    Assert( 4, S * row_new = row );
    row := row_new;
    
    V := V * ( S * QuillenSuslin( row ) );
    
    if IsHomalgRingMap( noether[4] ) then
        V := Pullback( noether[4], V );
    fi;
    
    Assert( 4, row_orig * V = CertainRows( HomalgIdentityMatrix( NrColumns( row ), S ), [ 1 ] ) );
    
    Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin for row" );
    
    return V;
    
end );

InstallHeuristicForRightInverseOfARow( EliminateIfRowObsoleteForUnimodularity );

InstallHeuristicForRightInverseOfARow( EliminateUnimodularPairPositionPerColumn );

InstallHeuristicForRightInverseOfARow( EliminateUnitInAColumn );

InstallQuillenSuslinHeuristic( EliminateIfColumnObsoleteForUnimodularity );
    
InstallQuillenSuslinHeuristic( EliminateIfRowObsoleteForUnimodularityAsRightInverse );

InstallQuillenSuslinHeuristic( EliminateUnitInARow );

InstallQuillenSuslinHeuristic( EliminateUnitInAColumnAsRightInverse );

InstallQuillenSuslinHeuristic( EliminateUnimodularPairPositionPerRow );

InstallQuillenSuslinHeuristic( EliminateUnimodularPairPositionPerColumnAsRightInverse );


#! @BeginCode QuillenSuslinUnipotent_code:matrix
InstallMethod( QuillenSuslinUnipotent,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( _M )
    local M, m, n, R, V;
    
    Info( InfoQuillenSuslin, 4, "Entering QuillenSuslin-unipotent" );
    
    M := _M;
    
    m := NrRows( M );
    n := NrColumns( M );
    
    if m > n then
        Error( "more rows than columns\n" );
    fi;
    
    R := HomalgRing( M );
    
    if not IsRightInvertibleMatrix( M ) then
        Error( "the matrix is not right invertible\n" );
    fi;
    
    if m = 0 then
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin for matrix" );
        return HomalgIdentityMatrix( n, R );
    elif m = n then
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin-unipotent" );
        return RightInverse( M );
    elif m = n - 1 then
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin-unipotent" );
        return RightInverse( CauchyBinetCompletion( M ) );
    elif m = 1 then
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin-unipotent" );
        return QuillenSuslin( M );
    fi;
    
    V := [ ];
    
    V[1] := QuillenSuslin( CertainRows( M, [ 1 ] ) );
    
    M := M * V[1];
    
    M := CertainRows( CertainColumns( M, [ 2 .. n ] ), [ 2 .. m ] );
    
    V[2] := QuillenSuslinUnipotent( M );
    
    V[2] := DiagMat( [ HomalgIdentityMatrix( 1, R ), V[2] ] );
    
    V := Product( V );
    
    Assert( 4, IsZero( CertainColumns( _M * V, [ NrRows( _M ) + 1 .. NrRows( V ) ] ) ) );
    
    Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin-unipotent" );
    
    return V;
    
end );
#! @EndCode

#! @BeginCode QuillenSuslin_code:matrix
InstallMethod( QuillenSuslin,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( M )
    local m, n, R, V, E;
    
    Info( InfoQuillenSuslin, 4, "Entering QuillenSuslin for matrix" );
    
    m := NrRows( M );
    n := NrColumns( M );
    
    R := HomalgRing( M );
    
    if not IsRightInvertibleMatrix( M ) then
        Error( "the matrix is not right invertible\n" );
    fi;
    
    if m = 0 then
        Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin for matrix" );
        return HomalgIdentityMatrix( n, R );
    elif m = 1 then
        TryNextMethod( );
    fi;
    
    V := QuillenSuslinUnipotent( M );
    
    M := M * V;
    
    E := HomalgIdentityMatrix( n - m, R );
    V := V * DiagMat( [ RightInverse( CertainColumns( M, [ 1 .. m ] ) ), E ] );
    
    Info( InfoQuillenSuslin, 4, "Leaving QuillenSuslin for matrix" );
    
    return V;
    
end );
#! @EndCode
