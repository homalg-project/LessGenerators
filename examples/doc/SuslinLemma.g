LoadPackage( "LessGenerators" );

Q := HomalgFieldOfRationalsInSingular( );

R := ( Q * "x" ) * "y";

AssignGeneratorVariables( R );

f := x^2*y^4+23*x*y^5+y^6+7*x-y^2;
g := (4*x*y^2+x^2+x^2*y-x*y^3);
h := y^2 * g;

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
