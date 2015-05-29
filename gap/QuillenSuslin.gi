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
          Delta1, I, o, H, m, R_m, row_m, H_m, V, new_row, T, c, P;
    
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
        
        m := AMaximalIdealContaining( LeftSubmodule( Delta1 ) );
        
        m := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m ) );
        
        R_m := LocalizeBaseRingAtPrime( R, m );
        
        row_m := R_m * row;
        
        Assert( 0, IsRightInvertibleMatrix( row_m ) );
        
        H_m := Horrocks( row_m, o );
        
        Add( H, H_m );
        
        Delta1 := Denominator( H_m[1] ) / baseR;
        
        Assert( 4, not Delta1 in I );
        
        I := I + LeftSubmodule( Delta1 );
        
    until IsOne( I );
    
    H := TransposedMat( H );
    
    V := Patch( row, H[1], H[2] );
    
    V := S * V;
    
    new_row := row * V;
    
    Assert( 4, new_row = Value( row, y, Zero( y ) ) );
    
    l := GetMonicUptoUnit( new_row );
    
    if l = fail then
        Error ( "need Noether Normalization\n" );
    fi;
    
    T := CleanRowUsingMonicUptoUnit( new_row, l[2][2] );
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
        
        u := MatElm( U, 1, 1 );
        IsOne( u );
        IsMinusOne( u );
        
        return u * V * P;
    fi;
    
    ## at least one less variable
    V := V * QuillenSuslin( row );
    
    if IsHomalgRingMap( noether[4] ) then
        V := Pullback( noether[4], V );
    fi;
    
    Assert( 4, row * V = CertainRows( HomalgIdentityMatrix( NrColumns( row ), S ), [ 1 ] ) );
    
    return V;
    
end );

#! @Code QuillenSuslinUnipotent_code:matrix
InstallMethod( QuillenSuslinUnipotent,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( _M )
    local M, m, n, R, V, i, j, E;
    
    M := _M;
    
    m := NrRows( M );
    n := NrColumns( M );
    
    if m > n then
        Error( "more rows than columns\n" );
    fi;
    
    R := HomalgRing( M );
    
    if m = 0 then
        return HomalgIdentityMatrix( n, R );
    elif m = 1 then
        if n = 1 then
            return RightInverse( M );
        elif n = 2 then
            return RightInverse( CauchyBinetCompletion( M ) );
        fi;
        return QuillenSuslin( M );
    fi;
    
    if not IsRightInvertibleMatrix( M ) then
        Error( "the matrix is not right invertible\n" );
    fi;
    
    V := [ ];
    
    for i in [ 1 .. m ] do
        
        V[i] := QuillenSuslin( CertainRows( M, [ 1 ] ) );
        
        M := M * V[i];
        
        E := HomalgIdentityMatrix( i - 1, R );
        V[i] := DiagMat( [ E, V[i] ] );
        
        M := CertainRows( CertainColumns( M, [ 2 .. n ] ), [ 2 .. m ] );
        
        m := NrRows( M );
        n := NrColumns( M );
        
    od;
    
    V := Product( V );
    
    Assert( 4, IsZero( CertainColumns( _M * V, [ NrRows( _M ) + 1 .. NrRows( V ) ] ) ) );
    
    return V;
    
end );
#! @EndCode

#! @Code QuillenSuslin_code:matrix
InstallMethod( QuillenSuslin,
        "for a homalg matrix",
        [ IsHomalgMatrix ],
        
  function( M )
    local m, n, R, V, E;
    
    m := NrRows( M );
    n := NrColumns( M );
    
    R := HomalgRing( M );
    
    if m = 0 then
        return HomalgIdentityMatrix( n, R );
    elif m = 1 then
        TryNextMethod( );
    fi;
    
    V := QuillenSuslinUnipotent( M );
    
    M := M * V;
    
    E := HomalgIdentityMatrix( n - m, R );
    V := V * DiagMat( [ CertainColumns( M, [ 1 .. m ] ), E ] );
    
    return V;
    
end );
#! @EndCode
