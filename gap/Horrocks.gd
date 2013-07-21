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
	  "<C>T</C> is a square transformation matrix which transforms <C>pos_h</C>-th entry of the <A>row</A>",
	  "to the linear combination of the monic entry <M>f</M> and <M>g</M>",
	  "(at <A>pos_f</A> and <A>pos_g</A>-th positions, respectively)",
	  "with leading coefficient being the <A>j</A>-th coefficient <C>bj</C> of <M>g</M> and",
	  "<C>TI</C> is the inverse matrix of <C>T</C>.<Br/>",
	  "<M>f</M> has to be monic and <C>bj</C> is a unit.",
          "<#Include Label=\"SuslinLemma:4arg\">" ],
        "a list",
        "row, pos_f, pos_g, j",
        [ "Quillen-Suslin", "Core_procedures" ] );

DeclareOperationWithDocumentation( "Horrocks",
        [ IsHomalgMatrix, IsInt ],
	[ "Returns a list of 2 matrices: [ <C>T</C> and <C>TI</C> ].<Br/>",
	  "<C>T</C> is a square transformation matrix which transforms <A>row</A> to unit row.",
	  "<C>TI</C> is the inverse matrix of <C>T</C>.<Br/>",
	  "<A>row</A> is a unimodular matrix with at least 3 entries",
	  "in which the <A>o</A>-th entry is monic.",
          "<#Include Label=\"Horrocks\">" ],
	"a list",
	"row, o",
        [ "Quillen-Suslin", "Core_procedures" ] );

DeclareOperationWithDocumentation( "Patch",
        [ IsHomalgMatrix, IsList, IsList ],
	[ "Returns a square matrix <A>V</A> over a univariate polynomial ring <M>R=B[y]</M>",
	  "over a (polynomial) base ring <M>B</M>, such that <A>row</A>*<C>V</C> is equal to",
	  "<A>row</A> with <M>y</M> set to <M>0</M>.<Br/>",
	  "The arguments <A>Vs</A> and <A>VIs</A> are lists of matrices obtained from <C>Horrocks</C>",
	  "over a localization of <M>R</M> defined by various maximal ideals of <M>B</M>.<Br/>",
	  "<A>VIs</A><M>[j]</M> is the inverse of <A>Vs</A><M>[j]</M>. The denominators of <A>Vs</A><M>[j]</M>",
	  "must generate the unit ideal of <M>B</M>.",
          "<#Include Label=\"Patch\">" ],
	"a matrix",
	"row, Vs, VIs",
        [ "Quillen-Suslin", "Core_procedures" ] );
