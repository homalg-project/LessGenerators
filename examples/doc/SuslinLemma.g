#! @Chunk SuslinLemma:3arg

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := ( Q * "x" ) * "y";
#! Q[x][y]
AssignGeneratorVariables( R );
#! #I  Assigned the global variables [ x, y ]
f := x^2*y^4+23*x*y^5+y^6+7*x-y^2;;
g := (4*x*y^2+x^2+x^2*y-x*y^3);;
h := y^2 * g;;
G := (4*x*y^2+x^2+2*y-x*y^3);;
SuslinLemma( f, g, 3 );
#! [ -x^3*y^3-23*x^2*y^4-x*y^5+x^4*y+27*x^3*y^2+93*x^2*y^3+4*x*y^4+x^4+23*x^3*y+
#!   x^2*y^2, 0, x^2+23*x*y+y^2 ]
SuslinLemma( f, g, 2 );
#! [ x^4*y^2+27*x^3*y^3+93*x^2*y^4+4*x*y^5+x^4*y+23*x^3*y^2+x^2*y^3-x*y^2+7*x^2,
#!   x, x^2*y+23*x*y^2+y^3 ]
SuslinLemma( f, g, 1 );
#! [ x^4*y^3+23*x^3*y^4+x^2*y^5+x^4*y^2+23*x^3*y^3+x^2*y^4+6*x^2*y-29*x^2,
#!   x*y-4*x, x^2*y^2+23*x*y^3+y^4-1 ]
SuslinLemma( f, g, 0 );
#! [ x^4*y^3+23*x^3*y^4+x^2*y^5+7*x^2*y^2-7*x^3-29*x^2*y, x*y^2-x^2-4*x*y,
#!   x^2*y^3+23*x*y^4+y^5-y ]
SuslinLemma( f, h, 5 );
#! [ -x*y^5+x^2*y^3+4*x*y^4+x^2*y^2, 0, 1]
SuslinLemma( f, h, 4 );
#! [ x^3*y^4+23*x^3*y^3+93*x^2*y^4+4*x*y^5+23*x^3*y^2+x^2*y^3-x*y^2+7*x^2, x,
#!   23*x+y ]
SuslinLemma( f, h, 3 );
#! [ x^4*y^3+23*x^3*y^4+x^2*y^5+x^4*y^2+23*x^3*y^3+x^2*y^4-x*y^3+7*x^2*y+
#!   4*x*y^2-28*x^2, x*y-4*x, x^2+23*x*y+y^2 ]
SuslinLemma( f, h, 2 );
#! [ x^4*y^3+23*x^3*y^4+x^2*y^5-x*y^4+8*x^2*y^2+4*x*y^3-7*x^3-28*x^2*y,
#!   x*y^2-x^2-4*x*y, x^2*y+23*x*y^2+y^3 ]
SuslinLemma( f, h, 1 );
#! [ 0, 0, 0 ]
SuslinLemma( f, h, 0 );
#! [ 0, 0, 0 ]
SuslinLemma( f, G, 1 );
#! [ x^4*y^2+23*x^3*y^3+x^2*y^4+2*x^2*y^3+46*x*y^4+2*y^5+7*x^2*y-29*x^2-2*y,
#!   x*y-4*x, x^2*y^2+23*x*y^3+y^4-1 ]
#! @EndExample


#! @Chunk SuslinLemma:4arg

#! Continuing of the previous example:
#! @Example
row := HomalgMatrix( [ h, G, f, g + h ], 1, 4, R );;
sus := SuslinLemma( row, 3, 2, 1 );
#! [ <An unevaluated 1 x 4 matrix over an external ring>,
#!   <A 4 x 4 matrix over an external ring>, <A 4 x 4 matrix over an external ring>,
#!   1, 2 ]
EntriesOfHomalgMatrix( sus[1] );
#! [ 1/2*x^5*y^2+23/2*x^4*y^3+1/2*x^3*y^4+1/2*x^4*y^2+25/2*x^3*y^3+47/2*x^2*y^4+
#!   2*x^2*y^3+27*x*y^4+y^5+7/2*x^3*y+x^2*y^2-29/2*x^3+7/2*x^2*y-29/2*x^2-x*y-y, 
#!   -x*y^3+4*x*y^2+x^2+2*y, x^2*y^4+23*x*y^5+y^6-y^2+7*x, -x*y^5+x^2*y^3+4*x*y^4+
#!   x^2*y^2-x*y^3+x^2*y+4*x*y^2+x^2 ]
EntriesOfHomalgMatrix( sus[2] );
#! [ 1, 0, 0, 0, 1/2*x^3*y^2+23/2*x^2*y^3+1/2*x*y^4+1/2*x^2*y^2+23/2*x*y^3+
#!   1/2*y^4-1/2*x-1/2, 1, 0, 0, 1/2*x^2*y-2*x^2+1/2*x*y-2*x, 0, 1, 0, 0, 0, 0, 1 ]
EntriesOfHomalgMatrix( sus[3] );
#! [ 1, 0, 0, 0, -1/2*x^3*y^2-23/2*x^2*y^3-1/2*x*y^4-1/2*x^2*y^2-23/2*x*y^3-1/2*y^4+
#!   1/2*x+1/2, 1, 0, 0, -1/2*x^2*y+2*x^2-1/2*x*y+2*x, 0, 1, 0, 0, 0, 0, 1 ]
#! @EndExample

Assert( 0, SuslinLemma( f, g, 3 ) =
        [ -x^3*y^3-23*x^2*y^4-x*y^5+x^4*y+27*x^3*y^2+93*x^2*y^3+4*x*y^4+x^4+23*x^3*y+x^2*y^2, 0, x^2+23*x*y+y^2 ] );

Assert( 0, SuslinLemma( f, g, 2 ) =
        [ x^4*y^2+27*x^3*y^3+93*x^2*y^4+4*x*y^5+x^4*y+23*x^3*y^2+x^2*y^3-x*y^2+7*x^2, x, x^2*y+23*x*y^2+y^3 ] );

Assert( 0, SuslinLemma( f, g, 1 ) =
        [ x^4*y^3+23*x^3*y^4+x^2*y^5+x^4*y^2+23*x^3*y^3+x^2*y^4+6*x^2*y-29*x^2, x*y-4*x, x^2*y^2+23*x*y^3+y^4-1 ] );

Assert( 0, SuslinLemma( f, g, 0 ) =
        [ x^4*y^3+23*x^3*y^4+x^2*y^5+7*x^2*y^2-7*x^3-29*x^2*y, x*y^2-x^2-4*x*y, x^2*y^3+23*x*y^4+y^5-y ] );

Assert( 0, SuslinLemma( f, h, 5 ) =
        [ -x*y^5+x^2*y^3+4*x*y^4+x^2*y^2, 0, 1 ] );

Assert( 0, SuslinLemma( f, h, 4 ) =
        [ x^3*y^4+23*x^3*y^3+93*x^2*y^4+4*x*y^5+23*x^3*y^2+x^2*y^3-x*y^2+7*x^2, x, 23*x+y ] );

Assert( 0, SuslinLemma( f, h, 3 ) =
        [ x^4*y^3+23*x^3*y^4+x^2*y^5+x^4*y^2+23*x^3*y^3+x^2*y^4-x*y^3+7*x^2*y+4*x*y^2-28*x^2, x*y-4*x, x^2+23*x*y+y^2 ] );

Assert( 0, SuslinLemma( f, h, 2 ) =
        [ x^4*y^3+23*x^3*y^4+x^2*y^5-x*y^4+8*x^2*y^2+4*x*y^3-7*x^3-28*x^2*y, x*y^2-x^2-4*x*y, x^2*y+23*x*y^2+y^3 ] );

Assert( 0, SuslinLemma( f, h, 1 ) =
        [ 0, 0, 0 ] );

Assert( 0, SuslinLemma( f, h, 0 ) =
        [ 0, 0, 0 ] );

Assert( 0, SuslinLemma( f, G, 1 ) =
        [ x^4*y^2+23*x^3*y^3+x^2*y^4+2*x^2*y^3+46*x*y^4+2*y^5+7*x^2*y-29*x^2-2*y, x*y-4*x, x^2*y^2+23*x*y^3+y^4-1 ] );

row := HomalgMatrix( [ h, G, f, g + h ], 1, 4, R );

sus := SuslinLemma( row, 3, 2, 1 );

entries := EntriesOfHomalgMatrix( sus[1] );

IsMonic( entries[1] );

Assert( 0, entries =
        [ 1/2*x^5*y^2+23/2*x^4*y^3+1/2*x^3*y^4+1/2*x^4*y^2+25/2*x^3*y^3+47/2*x^2*y^4+2*x^2*y^3+27*x*y^4+y^5+7/2*x^3*y+x^2*y^2-29/2*x^3+7/2*x^2*y-29/2*x^2-x*y-y, -x*y^3+4*x*y^2+x^2+2*y, x^2*y^4+23*x*y^5+y^6-y^2+7*x, -x*y^5+x^2*y^3+4*x*y^4+x^2*y^2-x*y^3+x^2*y+4*x*y^2+x^2 ] );
