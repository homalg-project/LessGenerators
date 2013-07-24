LoadPackage( "AutoDoc" );

CreateAutomaticDocumentation( "LessGenerators", "gap/AutoDocEntries.g", "doc/", false,
        [
         [ "Quillen-Suslin",
           [ "Intro for the chapter",
             "..." ] ],
         [ "Quillen-Suslin", "Core_procedures",
           [ "Intro for the section",
             "..." ] ]
         ] );

QUIT;
