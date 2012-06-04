#############################################################################
##
##  SingularTools.gi                                  LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinai Wagh, Indian Institute of Technology Guwahati
##
##  Implementations for the rings provided by Singular.
##
#############################################################################

####################################
#
# global variables:
#
####################################

##
InstallValue( LessGeneratorsMacrosForSingular,
        rec(
            
    _CAS_name := "Singular",
    
    _Identifier := "LessGenerators",
    
    load_LessGeneratorsSingular := Concatenation( "< \"", PackageInfo( "LessGenerators" )[1].InstallationPath, "/LessGeneratorsSingular/Cauchy-Binet.sing\";" ),
    
    )

);

##
UpdateMacrosOfCAS( LessGeneratorsMacrosForSingular, SingularMacros );
UpdateMacrosOfLaunchedCASs( LessGeneratorsMacrosForSingular );

##
InstallValue( LessGeneratorsTableForSingularTools,
        
        rec(
               CauchyBinetColumn :=
                 function( M )
                   
                   return homalgSendBlocking( [ "CauchyBinetRow( ", M, " )" ], [ "matrix" ], HOMALG_IO.Pictograms.CauchyBinetColumn );
                   
                 end,
               
               
        )
 );

## enrich the global and the created homalg tables for Singular:
AppendToAhomalgTable( CommonHomalgTableForSingularTools, LessGeneratorsTableForSingularTools );
AppendTohomalgTablesOfCreatedExternalRings( LessGeneratorsTableForSingularTools, IsHomalgExternalRingInSingularRep );

####################################
#
# methods for operations:
#
####################################
