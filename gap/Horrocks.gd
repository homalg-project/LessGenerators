# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Declarations
#

#! @Chapter Quillen-Suslin

####################################
#
# global functions and operations:
#
####################################

# basic operations:

##
#! @Section Tool procedures
##

#! @Description
#!  Returns a linear combination of <A>f</A> and <A>g</A> with
#!  leading coefficient being the <A>j</A>-th coefficient of <A>g</A>.
#!  <A>f</A> has to be monic.
#!  @InsertChunk SuslinLemma:3arg
#! @Arguments f, g, j
#! @Returns a &homalg; ring element
DeclareOperation( "SuslinLemma",
                  [ IsHomalgRingElement, IsHomalgRingElement, IsInt ] );

#! @Description
#!  Returns a list of 5 objects:
#!  [ <A>row</A> * <C>T</C>, <C>T</C>, <C>TI</C>, <C>pos_h</C>, <C>bj</C> ].<Br/>
#!  <C>T</C> is a square transformation matrix which transforms <C>pos_h</C>-th
#!  entry of the <A>row</A> to the linear combination of the monic entry
#!  <M>f</M> and <M>g</M> (at <A>pos_f</A> and <A>pos_g</A>-th positions,
#!  respectively) with leading coefficient being the <A>j</A>-th coefficient
#!  <C>bj</C> of <M>g</M> and <C>TI</C> is the inverse matrix of <C>T</C>.<Br/>
#!  <M>f</M> has to be monic and <C>bj</C> is a unit.<Br/>
#!  The corresponding method should make use of the three argument <Ref Oper="SuslinLemma" Label="for IsHomalgRingElement, IsHomalgRingElement, IsInt"/>.
#!  @InsertCode SuslinLemmaCode:4arg
#!  @InsertChunk SuslinLemma:4arg
#! @Arguments row, pos_f, pos_g, j
#! @Returns a list
DeclareOperation( "SuslinLemma",
                  [ IsHomalgMatrix, IsInt, IsInt, IsInt ] );

#! @Description
#!  Returns a list of two matrices: [ <C>T</C>, <C>TI</C> ].<Br/>
#!  <C>T</C> is a square transformation matrix which transforms <A>row</A> to unit row.
#!  <C>TI</C> is the inverse matrix of <C>T</C>.<Br/>
#!  <A>row</A> is a unimodular matrix with at least 3 entries
#!  in which the <A>o</A>-th entry is monic.
#!  @InsertChunk Horrocks
#! @Arguments row, o
#! @Returns a list
DeclareOperation( "Horrocks",
                  [ IsHomalgMatrix, IsInt ] );

#! @Description
#!  Returns a square matrix <A>V</A> over a univariate polynomial ring <M>R=B[y]</M>
#!  over a (polynomial) base ring <M>B</M>, such that <A>row</A>*<C>V</C> is equal to
#!  <A>row</A> with <M>y</M> set to <M>0</M>.<Br/>
#!  The arguments <A>Vs</A> and <A>VIs</A> are lists of matrices obtained from <C>Horrocks</C>
#!  over a localization of <M>R</M> defined by various maximal ideals of <M>B</M>.<Br/>
#!  <A>VIs</A><M>[j]</M> is the inverse of <A>Vs</A><M>[j]</M>. The denominators of <A>Vs</A><M>[j]</M>
#!  must generate the unit ideal of <M>B</M>.
#!  @InsertChunk Patch
#! @Arguments row, Vs, VIs
#! @Returns a &homalg; matrix
DeclareOperation( "Patch",
                  [ IsHomalgMatrix, IsList, IsList ] );

