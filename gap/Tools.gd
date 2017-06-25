#############################################################################
##
##  Tools.gd                                          LessGenerators package
##
##  Copyright 2015, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for tools.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

DeclareOperation( "CauchyBinetColumn",
        [ IsHomalgMatrix ] );

DeclareOperation( "CauchyBinetBaseChange",
        [ IsHomalgMatrix ] );

DeclareOperation( "CauchyBinetCompletion",
        [ IsHomalgMatrix ] );

DeclareGlobalFunction( "InstallHeuristicForRightInverseOfARow" );

DeclareGlobalFunction( "InstallQuillenSuslinHeuristic" );

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

DeclareOperation( "IsOneInLocalizationZxReturnUnit",
        [ IsHomalgModule ] );

DeclareOperation( "IsZeroInLocalizationZx",
        [ IsHomalgModule ] );
