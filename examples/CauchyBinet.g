LoadPackage( "LessGenerators" );
R := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y";
m := HomalgMatrix( "[ \
2*x^2+2*x*y+y^2+1,x*y+y^2+x,x+y,\
x*y+y^2+x,        y^2+1,    y   \
]", 2, 3, R );
M := LeftPresentation( m );
IsStablyFree( M );
