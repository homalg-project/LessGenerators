#############################################################################
##
##  Tools.gd                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
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

DeclareOperation( "GetAllButOneGcd1ColumnPosition",
        [ IsHomalgMatrix, IsList, IsList ] );

DeclareOperation( "GetAllButOneGcd1ColumnPosition",
        [ IsHomalgMatrix ] );

DeclareOperation( "EliminateAllButOneGcd1Columns",
        [ IsHomalgMatrix, IsList, IsList ] );

DeclareOperation( "GetFirstMonicOfSmallestDegree",
        [ IsHomalgMatrix, IsInt ] );

DeclareOperation( "CleanRowUsingMonics",
        [ IsHomalgMatrix, IsInt ] );

