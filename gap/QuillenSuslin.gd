#############################################################################
##
##  QuillenSuslin.gd                                  LessGenerators package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Anna Fabiańska, RWTH-Aachen University
##                       Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for core procedures for Quillen-Suslin.
##
#############################################################################

DeclareInfoClass( "InfoQuillenSuslin" );
SetInfoLevel( InfoQuillenSuslin, 1 );

#! @Chapter Quillen-Suslin

####################################
#
# global functions and operations:
#
####################################

# basic operations:

##
#! @Section Main_procedures
##

#! @Description
#!  Compute for the <M>r \times c</M>-matrix <A>mat</A> a square matrix <M>V</M>
#!  such that <A>mat</A> <M>* V</M> is a lower unipotent matrix.
#! @Arguments mat
#! @Returns a list of two &homalg; matrices
DeclareOperation( "QuillenSuslinUnipotent",
                  [ IsHomalgMatrix ] );

#! @Description
#!  Compute for the <M>r \times c</M>-matrix <A>mat</A> a square matrix <M>V</M>
#!  such that <A>mat</A> <M>* V</M> is equal to the first <M>r</M> rows
#!  of the <M>c \times c</M> identity matrix.
#! @Arguments mat
#! @Returns a list of two &homalg; matrices
DeclareOperation( "QuillenSuslin",
                  [ IsHomalgMatrix ] );
