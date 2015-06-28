#############################################################################
##
##  Tools.gd                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for tools.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

DeclareOperation( "CauchyBinetColumn",
        [ IsHomalgMatrix ] );

DeclareOperation( "CauchyBinetBaseChange",
        [ IsHomalgMatrix ] );

DeclareOperation( "CauchyBinetCompletion",
        [ IsHomalgMatrix ] );

DeclareGlobalFunction( "InstallHeuristicForRightInverseOfARow" );

DeclareGlobalFunction( "InstallQuillenSuslinHeuristic" );
