LoadPackage( "AutoDoc" );

CreateAutomaticDocumentation( "LessGenerators", "gap/AutoDocEntries.g", "doc/", false,
        [
         [ "Quillen-Suslin",
           [ "Intro for the chapter",
             "..." ] ],
         [ "Quillen-Suslin", "Tool_procedures",
           [ "Intro for the section",
             "..." ] ],
         [ "Quillen-Suslin", "Main_procedures",
           [ "Intro for the section",
             "..." ] ],
         ] );

QUIT;
