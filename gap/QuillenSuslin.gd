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

SetCurrentAutoDocChapter( "Quillen-Suslin" );

####################################
#
# global functions and operations:
#
####################################

# basic operations:

##
SetCurrentAutoDocSection( "Main_procedures" );
##

DeclareOperationWithDocumentation( "QuillenSuslin",
        [ IsHomalgMatrix ],
	[ " " ],
	"a &homalg; matrix",
	"row",
        [ "Quillen-Suslin", "Core_procedures" ] );
