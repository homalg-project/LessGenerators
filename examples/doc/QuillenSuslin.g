LoadPackage( "LessGenerators" );

Q := HomalgFieldOfRationalsInSingular( );

R := ( Q * "x" ) * "y";

row1 := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );

UV1 := QuillenSuslin( row1 );

## Just to make sure whether the row * V is subidentity
Assert( 0, NonZeroColumns( UV1[1] * row1 * UV1[2] ) = [ 1 ] );

###################################################

row2 := HomalgMatrix( "[ 1+x*y+x^4, y^2+x-1, x*y-1 ]", 1, 3, R );

UV2 := QuillenSuslin( row2 );

Assert( 0, NonZeroColumns( UV2[1] * row2 * UV2[2] ) = [ 1 ] );

###################################################

row3 := HomalgMatrix( "[ x^2*y+1, x+y-2, 2*x*y ]", 1, 3, R );

UV3 := QuillenSuslin( row3 );

Assert( 0, NonZeroColumns( UV3[1] * row3 * UV3[2] ) = [ 1 ] );

###################################################


R2 := ( Q * "x,y,z" ) * "t";

row4 := HomalgMatrix( "[ 2*t*x*z+t*y^2+1, 2*t*x*y+t^2, t*x^2 ]", 1, 3, R2 );

UV4 := QuillenSuslin( row4 );

Assert( 0, NonZeroColumns( UV4[1] * row4 * UV4[2] ) = [ 1 ] );
