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
#!  Compute for the <M>r \times c</M>-matrix <A>mat</A> a list of two square matrices <M>U</M>,<M>V</M>
#!  such that <M>U *</M> <A>mat</A> <M>* V</M> is equal to the first <M>r</M> rows
#!  of the <M>c \times c</M> identity matrix.
#! @Returns a list of two &homalg; matrices
#! @Arguments mat
DeclareOperation( "QuillenSuslin",
                  [ IsHomalgMatrix ] );

