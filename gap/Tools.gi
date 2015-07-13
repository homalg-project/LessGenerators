#############################################################################
##
##  Tools.gi                                          LessGenerators package
##
##  Copyright 2015, Mohamed Barakat, University of Kaiserslautern
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
InstallGlobalFunction( InstallHeuristicForRightInverseOfARow,
  function( heuristic )
    local name;
    
    name := NameFunction( heuristic );
    name := Concatenation( name, "AsRightInverse" );
    
    # Declaration moved to QuillenSuslin.gd
    # DeclareOperation( name, [ IsHomalgMatrix ] );
    
    InstallMethod( ValueGlobal( name ),
            "for rows",
            [ IsHomalgMatrix ],
            
      function( row )
        local RI, U, V, l;
        
        RI := RightInverse( row );
        
        U := heuristic( RI );
        
        V := U[2];
        U := U[1];
        
        row := row * V;
        
        l := CleanRowUsingMonicUptoUnit( row, 1 );
        
        Assert( 4, IsOne( MatElm( l[1], 1, 1 ) ) );
        Assert( 4, ZeroColumns( l[1] ) = [ 2 .. NrColumns( row ) ] );
        
        return [ V * l[2], l[3] * U ];
        
    end );
    
end );
##
InstallGlobalFunction( InstallQuillenSuslinHeuristic,
  function( heuristic )
    local name;
    
    name := NameFunction( heuristic );
    
    InstallMethod( QuillenSuslin,
            "for a homalg matrix",
            [ IsHomalgMatrix ],
            
      function( row )
        local l;
        
        Info( InfoQuillenSuslin, 4, Concatenation( "Entering ", name ) );
        
        l := heuristic( row );
        
        if l = fail then
            TryNextMethod( );
        fi;
        
        Info( InfoQuillenSuslin, 4, Concatenation( "Leaving ", name ) );
        return l[1];
        
    end );
    
end );
