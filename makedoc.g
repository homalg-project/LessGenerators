##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "AutoDoc" );

bib := ParseBibFiles( "doc/LessGenerators.bib" );
WriteBibXMLextFile( "doc/LessGeneratorsBib.xml", bib );

AutoDoc(
    "LessGenerators" : 
    autodoc := rec( files := [ "doc/Intros.g" ] ),
    scaffold := false
);


PrintTo( "VERSION", PackageInfo( "LessGenerators" )[1].Version );

QUIT;
