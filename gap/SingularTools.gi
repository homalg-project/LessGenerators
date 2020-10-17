# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# Implementations
#

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
    
    ## loads LIBs that alter the behavior of Singular which affect the package Blocks
    #load_LessGeneratorsSingular := Concatenation( "LIB \"", PackageInfo( "LessGenerators" )[1].InstallationPath, "/Singular/LessGenerators.lib\";" ),
    
    )

);

##
UpdateMacrosOfCAS( LessGeneratorsMacrosForSingular, SingularMacros );
UpdateMacrosOfLaunchedCASs( LessGeneratorsMacrosForSingular );

##
InstallValue( LessGeneratorsTableForSingularTools,
        
        rec(
               ## needs Singular/LessGenerators.lib which is disabled, see comment above
               X_CauchyBinetColumn :=
                 function( M )
                   
                   return homalgSendBlocking( [ "CauchyBinetRow( ", M, " )" ], [ "matrix" ], HOMALG_IO.Pictograms.CauchyBinetColumn );
                   
                 end,
               
               X_GetRidOfRowsAndColumnsWithUnits :=
                 function( M )
                   local r, c, R, l, deleted_rows, deleted_columns, rows, columns, n, i, m;
                   
                   r := NrRows( M );
                   c := NrColumns( M );
                   
                   R := HomalgRing( M );
                   
                   l := homalgSendBlocking( [ "complete_cleanup( ", M, " )" ], [ "list" ], HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits );
                   
                   deleted_rows := [ ];
                   deleted_columns := [ ];
                   
                   if Int( homalgSendBlocking( [ "size(", l, ")<>1" ], "need_output", HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits ) ) = 1 then
                       
                       rows := StringToIntList( homalgSendBlocking( [ "string(",l, "[3])" ], "need_output", HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits ) );
                       
                       columns := StringToIntList( homalgSendBlocking( [ "string(",l, "[2])" ], "need_output", HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits ) );
                       
                       n := Length( rows );
                       
                       M := homalgSendBlocking( [ l, "[1]" ], [ "matrix" ], HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits );
                       
                       M := HomalgMatrix( M, r - n, c - n, R );
                       
                       for i in [ 1 .. n ] do
                           
                           ## the rows
                           m := homalgSendBlocking( [ l, "[5][", i, "]" ], [ "matrix" ], HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits );
                           m := HomalgMatrix( m, 1, c - i, R );
                           
                           Add( deleted_rows, m );
                           
                           ## the columns
                           m := homalgSendBlocking( [ l, "[4][", i, "]" ], [ "matrix" ], HOMALG_IO.Pictograms.GetRidOfRowsAndColumnsWithUnits );
                           m := HomalgMatrix( m, r - i, 1, R );
                           
                           Add( deleted_columns, m );
                           
                       od;
                       
                   else
                       
                       rows := [ ];
                       columns := [ ];
                       
                   fi;
                   
                   return [ M, rows, columns, deleted_rows, deleted_columns ];
                   
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
