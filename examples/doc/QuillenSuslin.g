#! @System QuillenSuslin

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := ( Q * "x" ) * "y";
#! Q[x][y]
row1 := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );
#! <A 1 x 3 matrix over an external ring>
UV1 := QuillenSuslin( row1 );
#! [ <A 1 x 1 matrix over an external ring>, <An unevaluated 3 x 3 matrix over an external ring> ]
Assert( 0, UV1[1] * row1 * UV1[2] = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
row2 := HomalgMatrix( "[ 1+x*y+x^4, y^2+x-1, x*y-1 ]", 1, 3, R );
#! <A 1 x 3 matrix over an external ring>
UV2 := QuillenSuslin( row2 );
#! [ <A 1 x 1 matrix over an external ring>, <An unevaluated 3 x 3 matrix over an external ring> ]
Assert( 0, UV2[1] * row2 * UV2[2] = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
row3 := HomalgMatrix( "[ x^2*y+1, x+y-2, 2*x*y ]", 1, 3, R );;
UV3 := QuillenSuslin( row3 );
#! [ <A 1 x 1 matrix over an external ring>, <An unevaluated 3 x 3 matrix over an external ring> ]
Assert( 0, UV3[1] * row3 * UV3[2] = CertainRows( HomalgIdentityMatrix( 3, R ), [ 1 ] ) );
R2 := ( Q * "x,y,z" ) * "t";
#! Q[x,y,z][t]
row4 := HomalgMatrix( "[ 2*t*x*z+t*y^2+1, 2*t*x*y+t^2, t*x^2 ]", 1, 3, R2 );
#! <A 1 x 3 matrix over an external ring>
UV4 := QuillenSuslin( row4 );
#! [ <A 1 x 1 matrix over an external ring>, <An unevaluated 3 x 3 matrix over an external ring> ]
Assert( 0, UV4[1] * row4 * UV4[2] = CertainRows( HomalgIdentityMatrix( 3, R2 ), [ 1 ] ) );
#! @EndExample
