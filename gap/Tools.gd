#############################################################################
##
##  Tools.gd                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinai Wagh, Indian Institute of Technology Guwahati
##
##  Declarations for tools.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

DeclareOperation( "GetAllButOneGcd1ColumnPosition",
        [ IsHomalgMatrix, IsList, IsList ] );

DeclareOperation( "GetAllButOneGcd1ColumnPosition",
        [ IsHomalgMatrix ] );

DeclareOperation( "EliminateAllButOneGcd1Columns",
        [ IsHomalgMatrix, IsList, IsList ] );
