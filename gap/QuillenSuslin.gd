#############################################################################
##
##  QuillenSuslin.gd                                  LessGenerators package
##
##  Copyright 2007-2015, Mohamed Barakat, University of Kaiserslautern
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
#!  For the given <M>r \times c</M>-matrix <A>mat</A>, compute a square 
#!  matrix <M>V</M> such that <A>mat</A> <M>* V</M> is equal to the first 
#!  <M>r</M> rows of the <M>c \times c</M> identity matrix.
#! @Arguments mat
#! @Returns a &homalg; matrix
DeclareOperation( "QuillenSuslin",
                  [ IsHomalgMatrix ] );

#! @Description
#!  For the given row <A>row</A>, check whether all but one elements in the
#!  right inverse generate the unit ideal.
#!   It returns a list [ <C>V</C>, <C>VI</C> ] such that
#!   <A>row</A> * <C>V</C> = [ 1 0 0 ... 0 ] and the first row
#!   of <C>VI</C> is the given row.
#! @Arguments row
#! @Returns a list
DeclareOperation( "EliminateAllButOneGcd1RowsAsRightInverse",
                  [ IsHomalgMatrix ] );

#! @Description
#!  For the given row <A>row</A>, check whether the right inverse
#!  contains a unit.
#!   It returns a list [ <C>V</C>, <C>VI</C> ] such that
#!   <A>row</A> * <C>V</C> = [ 1 0 0 ... 0 ] and the first row
#!   of <C>VI</C> is the given row.
#! @Arguments row
#! @Returns a list
DeclareOperation( "EliminateUnitInAColumnAsRightInverse",
                  [ IsHomalgMatrix ] );

#! @Description
#!  For the given row <A>row</A>, check whether any two elements in the
#!  right inverse are coprime.
#!   It returns a list [ <C>V</C>, <C>VI</C> ] such that
#!   <A>row</A> * <C>V</C> = [ 1 0 0 ... 0 ] and the first row
#!   of <C>VI</C> is the given row.
#! @Arguments row
#! @Returns a list
DeclareOperation( "EliminatePairOfGcd1PositionPerColumnAsRightInverse",
                  [ IsHomalgMatrix ] );
