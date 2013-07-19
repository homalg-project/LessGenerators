#############################################################################
##
##  Horrocks.gd                                       LessGenerators package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Anna Fabiańska, RWTH-Aachen University
##                       Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for core procedures for Quillen-Suslin.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "SuslinLemma",
        [ IsHomalgRingElement, IsHomalgRingElement, IsInt ] );

DeclareOperation( "SuslinLemma",
        [ IsHomalgMatrix, IsInt, IsInt, IsInt ] );

DeclareOperation( "Horrocks",
        [ IsHomalgMatrix, IsInt ] );

DeclareOperation( "Horrocks",
        [ IsHomalgMatrix ] );

DeclareOperation( "Patch",
        [ IsHomalgMatrix, IsList, IsList ] );
