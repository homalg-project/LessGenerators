#############################################################################
##
##  Tools.gi                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
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
