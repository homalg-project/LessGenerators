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
          "leading coefficient being the <A>j</A>-th coefficient of <A>g</A>.",
	  "<A>f</A> has to be monic.",
          "<#Include Label=\"SuslinLemma:3arg\">" ],
        "a homalg ring element",
        "f, g, j",
        [ "Quillen-Suslin", "Core_procedures" ] );

DeclareOperationWithDocumentation( "SuslinLemma",
        [ IsHomalgMatrix, IsInt, IsInt, IsInt ],
        [ "Returns a list of 5 objects:",
	  "[ <A>row</A> * <C>T</C>, <C>T</C>, <C>TI</C>, <C>pos_h</C>, <C>bj</C> ].<Br/>",
	  "T is a square transformation matrix which transforms <C>pos_h</C>-th entry of the <A>row</A>",
	  "to the linear combination of the monic entry <C>f</C> and <C>g</C>",
	  "(at <A>pos_f</A> and <A>pos_g</A>-th positions, respectively)",
	  "with leading coefficient being the <A>j</A>-th coefficient <C>bj</C> of <C>g</C> and",
	  "<C>TI</C> is the inverse matrix of <C>T</C>.<Br/>",
	  "<C>f</C> has to be monic and <C>bj</C> is a unit.",
          "<#Include Label=\"SuslinLemma:4arg\">" ],
        "a list",
        "row, pos_f, pos_g, j",
        [ "Quillen-Suslin", "Core_procedures" ] );

DeclareOperation( "Horrocks",
# DeclareOperationWithDocumentation( "Horrocks",
        [ IsHomalgMatrix, IsInt ] );

DeclareOperation( "Horrocks",
# DeclareOperationWithDocumentation( "Horrocks",
        [ IsHomalgMatrix ] );

DeclareOperation( "Patch",
# DeclareOperationWithDocumentation( "Patch",
        [ IsHomalgMatrix, IsList, IsList ] );
