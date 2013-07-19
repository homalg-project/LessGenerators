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
