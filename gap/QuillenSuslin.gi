#############################################################################
##
##  QuillenSuslin.gi                                  LessGenerators package
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


##
InstallMethod( QuillenSuslin,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( row )
    local S, noether, row_monic, l, monic, u, U, monic_var_index, y, R, baseR,
          Delta1, I, o, H, m, R_m, row_m, H_m, V, new_row, T, c, P, UV;
    
    if not NrRows( row ) = 1 then
        TryNextMethod( );
    elif not IsRightInvertibleMatrix( row ) then
        Error( "the matrix is not right invertible\n" );
    fi;
    
    S := HomalgRing( row );
    
    noether := NoetherNormalization( row );
    
    row_monic := noether[1];
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
    
    row := U * row_monic;
    
    Assert( 4, IsRightInvertibleMatrix( row ) );
    SetIsRightInvertibleMatrix( row, true );
    
    # l[1] is the monic (upto a unit) element in a univariate polynomial ring over a base ring
    R := HomalgRing( monic );
    baseR := BaseRing( R );
    
    Delta1 := Zero( baseR );
    
    I := ZeroLeftSubmodule( baseR );
    
    # l[2][2] gives the position of the monic (upto a unit) l[1] in the row.
    o := l[2][2];
    H := [ ];
    
    repeat
        
        m := AMaximalIdealContaining(  LeftSubmodule( Delta1 ) );
        
        m := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m ) );
        
        R_m := LocalizeBaseRingAtPrime( R, m );
        
        row_m := R_m * row;
        
        Assert( 0, IsRightInvertibleMatrix( row_m ) );
        
        H_m := Horrocks( row_m, o );
        
        Add( H, H_m );
        
        Delta1 := Denominator( H_m[1] ) / baseR;
        
        I := I + LeftSubmodule( Delta1 );
        
    until IsOne( I );
    
    H := TransposedMatMutable( H );
    
    V := Patch( row, H[1], H[2] );
    
    V := S * V;
    
    new_row := row * V;
    
    Assert( 4, new_row = Value( row, y, Zero( y ) ) );
    
    l := GetMonicUptoUnit( new_row );
    
    if l = fail then
        Error ( "need Noether Normalization\n" );
    fi;
    
    T := CleanRowUsingMonics( new_row, l[2][2] );
    V := V * T[2];
    row := T[1];
    
    if HasIsSubidentityMatrix( row ) and IsSubidentityMatrix( row ) then
        
        if IsHomalgRingMap( noether[4] ) then
            U := Pullback( noether[4], U );
            V := Pullback( noether[4], V );
        fi;
        
        c := NrColumns( row );
        P := HomalgIdentityMatrix( c, S );
        
        o := NonZeroColumns( row )[1];
        
        if not o = 1 then
            P := CertainColumns( P, ListPerm( (1,o), c ) );
        fi;
        
        return [ U, V * P ];
    fi;
    
    ## at least one less variable
    UV := QuillenSuslin( row );
    
    U := UV[1] * U;
    V := V * UV[2];
    
    if IsHomalgRingMap( noether[4] ) then
        U := Pullback( noether[4], U );
        V := Pullback( noether[4], V );
    fi;
    
    Assert( 4, NonZeroColumns( row * V ) = [ 1 ] );
    
    return [ U, V ];
    
end );

##
InstallMethod( QuillenSuslin,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, m, n, U, V, i, UV, j, E;
    
    if NrRows( M ) = 1 then
        TryNextMethod( );
    fi;
    
    if not IsRightInvertibleMatrix( M ) then
        Error( "the matrix is not right invertible\n" );
    fi;
    
    R := HomalgRing( M );
    
    m := NrRows( M );
    n := NrColumns( M );
    
    U := [ ];
    V := [ ];
    
    for i in [ 1 .. m ] do
        
        U[i] := HomalgIdentityMatrix( m, R );
        
        if n = 2 then
            V[i] := RightInverse( CauchyBinetCompletion( M ) );
        elif n = 1 then
            V[i] := RightInverse( M );
        else
            UV := QuillenSuslin( CertainRows( M, [ 1 ] ) );
            U[i] := DiagMat( [ UV[1], HomalgIdentityMatrix( m - 1, R ) ] );
            V[i] := UV[2];
        fi;
        
        M := M * V[i];
        
        E := HomalgInitialIdentityMatrix( m, R );
        
        for j in [ 2 .. m ] do
            SetMatElm( E, j, 1, -MatElm( M, j, 1 ) );
        od;
        
        U[i] := E * U[i];
        
        E := HomalgIdentityMatrix( i - 1, R );
        U[i] := DiagMat( [ E, U[i] ] );
        V[i] := DiagMat( [ E, V[i] ] );
        
        M := CertainRows( CertainColumns( M, [ 2 .. n ] ), [ 2 .. m ] );
        
        m := NrRows( M );
        n := NrColumns( M );
        
    od;
    
    U := Product( Reversed( U ) );
    V := Product( V );
    
    return [ U, V ];
    
end );
