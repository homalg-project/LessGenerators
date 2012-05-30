#############################################################################
##
##  LessGenerators.gd           LessGenerators package       Mohamed Barakat
##                                                            Anna Fabianska
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for LessGenerators.
##
#############################################################################


# our info class:
DeclareInfoClass( "InfoLessGenerators" );
SetInfoLevel( InfoLessGenerators, 1 );

# a central place for configurations:
# DeclareGlobalVariable( "LESS_GENERATORS" );

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

