LoadPackage( "AutoDoc" );

AutoDoc( "LessGenerators" :
        
        scaffold := rec( entities := [ "homalg", "GAP4" ],
                         ),
        
        autodoc := rec( files := [ "doc/Intros.autodoc" ] ),
        
        maketest := rec( folder := ".",
                         commands :=
                         [ "LoadPackage( \"LessGenerators\" );",
                           "LoadPackage( \"IO_ForHomalg\" );",
                           "HOMALG_IO.show_banners := false;",
                           "HOMALG_IO.suppress_PID := true;",
                           "HOMALG_IO.use_common_stream := true;",
                           #"HOMALG.SuppressParityInViewObjForCommutativeStructureObjects := true;",
                           ],
                         ),
        
        Bibliography := "LessGenerators.bib"
        
);

# Create VERSION file for "make towww"
PrintTo( "VERSION", PackageInfo( "LessGenerators" )[1].Version );

QUIT;
