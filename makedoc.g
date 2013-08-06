##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );
LoadPackage( "Modules" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/LessGenerators.bib" );
WriteBibXMLextFile( "doc/LessGeneratorsBib.xml", bib );

Read( "ListOfDocFiles.g" );

PrintTo( "VERSION", PackageInfo( "LessGenerators" )[1].Version );

MakeGAPDocDoc( "doc", "LessGenerators", list, "LessGenerators", "MathJax" );

CopyHTMLStyleFiles( "doc" );

GAPDocManualLab( "LessGenerators" );

QUIT;
