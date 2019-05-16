#! @Chunk QuillenSuslin

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := ( Q * "x" ) * "y";
#! Q[x][y]
row1 := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );
#! <A 1 x 3 matrix over an external ring>
V1 := QuillenSuslin( row1 );
#! <An unevaluated 3 x 3 matrix over an external ring>
Assert( 0, row1 * V1 = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
row2 := HomalgMatrix( "[ 1+x*y+x^4, y^2+x-1, x*y-1 ]", 1, 3, R );
#! <A 1 x 3 matrix over an external ring>
V2 := QuillenSuslin( row2 );
#! <An unevaluated 3 x 3 matrix over an external ring>
Assert( 0, row2 * V2 = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
row3 := HomalgMatrix( "[ x^2*y+1, x+y-2, 2*x*y ]", 1, 3, R );;
V3 := QuillenSuslin( row3 );
#! <An unevaluated 3 x 3 matrix over an external ring>
Assert( 0, row3 * V3 = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
R2 := Q * "x,y,z";
#! Q[x,y,z]
row4 := HomalgMatrix( "[\
2*x^2+2*x*y-2*x*z+z, \
2*x^3+2*x^2*y-2*z*x^2+x*z+2*x+2*y-z, \
2*z*x^2+2*z*x*y-2*x*z^2+2*x*z+2*z*y+1, \
2*x^3+2*x^2*y-2*z*x^2+x*z+2*x*y+2*y^2-z*y+y]", 1, 4, R2 );
#! <A 1 x 4 matrix over an external ring>
V4 := QuillenSuslin( row4 );
#! <An unevaluated 4 x 4 matrix over an external ring>
Assert( 0, row4 * V4 = CertainRows( HomalgIdentityMatrix( 4, R2 ), [ 1 ] ) );
R3 := R2 * "t";
#! Q[x,y,z][t]
row5 := HomalgMatrix( "[ 2*t*x*z+t*y^2+1, 2*t*x*y+t^2, t*x^2 ]", 1, 3, R3 );
#! <A 1 x 3 matrix over an external ring>
V5 := QuillenSuslin( row5 );
#! <An unevaluated 3 x 3 matrix over an external ring>
Assert( 0, row5 * V5 = CertainRows( HomalgIdentityMatrix( 3, R3 ), [ 1 ] ) );
#! @EndExample
