# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Declarations
#

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

DeclareGlobalFunction( "OnLessGenerators_ForStablyFreeRank1OverCommutative" );

DeclareGlobalFunction( "OnLessGenerators_UsingParametrization" );
