#############################################################################
##
##  ToolsForColumns.gd                                LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for tools for columns.
##
#############################################################################

#! @Chapter Tools

####################################
#
# global functions and operations:
#
####################################

##
#! @Section Tools for columns
##

#! @Description
#!   Checks whether there is any other monic of smaller degree than
#!   <A>o</A>-th position element. If found, returns the position of
#!   new monic, else returns <A>o</A>.
#!   It returns the position of the monic.
#! @Arguments col, o
#! @Returns a positive integer
DeclareOperation( "GetFirstMonicOfSmallestDegreeInColumn",
        [ IsHomalgMatrix, IsInt ] );

#! @Description
#!   Cleans <A>col</A> using a monic at <A>o</A>-th position.
#!   It returns a list with the modified column and transformation matrices.
#! @Arguments col, o
#! @Returns a list
DeclareOperation( "CleanColumnUsingMonicUptoUnit",
        [ IsHomalgMatrix, IsInt ] );

#! @Description
#!   Checks whether any $(n-1)$ elements among the $n$ <A>unclean_rows</A>
#!   positions of <A>col</A> generate a unit ideal.
#!   It returns a list [ <C>j</C>, <C>r</C>, <C>h</C> ] where
#!   * <C>j</C> = Except <C>j</C>-th entry, all other elements generate $1$
#!   * <C>r</C> = list of positions of entries that generate $1$
#!   * <C>h</C> = the left inverse of <C>r</C>-subcolumn
#! @Arguments col, unclean_rows
#! @Returns a list
DeclareOperation( "GetAllButOneGcd1RowPosition",
        [ IsHomalgMatrix, IsList ] );

#! @Description
#!   Checks whether any $(n-1)$ elements among the $n$ <A>unclean_rows</A>
#!   positions of one of the columns among <A>unclean_cols</A> generate a
#!   unit ideal.
#!   It returns a list [ <C>j</C>, <C>r</C>, <C>h</C>, <C>i</C> ] where
#!   * <C>j</C> = Except <C>j</C>-th entry, all other elements of the <C>i</C>-th
#!                column generate $1$
#!   * <C>r</C> = list of positions of entries that generate $1$
#!   * <C>h</C> = the left inverse of <C>r</C>-subcolumn
#!   * <C>i</C> = <C>i</C>-th column
#! @Arguments M, unclean_cols, unclean_rows
#! @Returns a list
DeclareOperation( "GetAllButOneGcd1RowPosition",
        [ IsHomalgMatrix, IsList, IsList ] );

#! @Description
#!   Checks whether any $(n-1)$ elements of some column of <A>M</A>
#!   generate a unit ideal.
#!   It returns a list [ <C>j</C>, <C>r</C>, <C>h</C>, <C>i</C> ] where
#!   * <C>j</C> = Except <C>j</C>-th entry, all other elements of the <C>i</C>-th
#!                column generate $1$
#!   * <C>r</C> = list of positions of entries that generate $1$
#!   * <C>h</C> = the right inverse of <C>r</C>-subcolumn
#!   * <C>i</C> = <C>i</C>-th column
#! @Arguments M
#! @Returns a list
DeclareOperation( "GetAllButOneGcd1RowPosition",
        [ IsHomalgMatrix ] );

#! @Description
#!   If any $(n-1)$ elements of the column generate $1$, then this function
#!   cleans the <A>col</A> and returns the transformation matrix and its
#!   inverse.
#!   It returns a list of two matrices <C>U</C> and <C>UI</C> such that
#!   <C>U</C> * <A>col</A> = Column( [ 1 0 0 ... 0 ] ) and the first column
#!   of <C>UI</C> is the given column.
#! @InsertSystem Eliminate-All-But-One-Gcd-1-Rows
#! @Arguments col
#! @Returns a list
DeclareOperation( "EliminateAllButOneGcd1Rows",
        [ IsHomalgMatrix ] );

#! @Description
#!   Checks whether any two elements of <A>col</A> are coprime.
#!   It returns a list [ <C>l</C>, [ <C>i</C>, <C>j</C> ] ] where
#!   * <C>i</C> and  <C>j</C>-th elements are coprime with each other
#!   * <C>l</C> is the syzygy of these two elements.
#! @Arguments col
#! @Returns a list
DeclareOperation( "GetPairOfGcd1PositionPerColumn",
        [ IsHomalgMatrix ] );

#! @Description
#!   If any two elements of <A>col</A> are coprime, then this function
#!   cleans the <A>col</A> and returns the transformation matrix and
#!   its inverse.
#!   It returns a list of two matrices <C>U</C> and <C>UI</C> such that
#!   <C>U</C> * <A>col</A> = Column( [ 1 0 0 ... 0 ] ) and the first column
#!   of <C>UI</C> is the given column.
#! @InsertSystem Eliminate-Pair-Of-Gcd-1-Position-Per-Column
#! @Arguments col
#! @Returns a list
DeclareOperation( "EliminatePairOfGcd1PositionPerColumn",
        [ IsHomalgMatrix ] );

#! @Description
#!   The <A>col</A> contains a unit, then this function cleans 
#!   the <A>col</A> using this unit and return the transformation
#!   matrices.
#!   It returns a list of two matrices <C>U</C> and <C>UI</C> such that
#!   <C>U</C> * <A>col</A> = Column( [ 1 0 0 ... 0 ] ) and the first column
#!   of <C>UI</C> is the given column.
#! @Arguments col
#! @Returns a list
DeclareOperation( "EliminateUnitInAColumn",
        [ IsHomalgMatrix ] );
