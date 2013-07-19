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

DeclareOperationWithDocumentation( "SuslinLemma",
        [ IsHomalgRingElement, IsHomalgRingElement, IsInt ],
        [ "Returns a linear combination of <A>f</A> and <A>g</A> with",
          "leading coefficient being the <A>o</A>-th coefficient in <A>g</A>." ],
        "a homalg ring element",
        "f, g, o",
        [ "Quillen-Suslin", "Core_procedures" ] );

DeclareOperation( "SuslinLemma",
        [ IsHomalgMatrix, IsInt, IsInt, IsInt ] );

DeclareOperation( "Horrocks",
        [ IsHomalgMatrix, IsInt ] );

DeclareOperation( "Horrocks",
        [ IsHomalgMatrix ] );

DeclareOperation( "Patch",
        [ IsHomalgMatrix, IsList, IsList ] );
