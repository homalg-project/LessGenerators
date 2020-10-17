# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Declarations
#

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
