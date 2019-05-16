#! @Chunk Horrocks

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := ( Q * "x" ) * "y";
#! Q[x][y]
row := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );
#! <A 1 x 3 matrix over an external ring>
IsRightInvertibleMatrix( row );
#! true
m1 := AMaximalIdealContaining( ZeroLeftSubmodule( BaseRing( R ) ) );;
m1 := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m1 ) );;
S1 := LocalizeBaseRingAtPrime( R, m1 );
#! ( Q[x]_< x > )[y]
row1 := S1 * row;
#! <A 1 x 3 matrix over a (fake) local ring>
IsRightInvertibleMatrix( row1 );
#! true
H1 := Horrocks( row1, 2 );
#! [ <An unevaluated 3 x 3 matrix over a (fake) local ring>,
#!   <An unevaluated 3 x 3 matrix over a (fake) local ring> ]
EntriesOfHomalgMatrix( H1[1] );
#! [ 1, -y-1/2, (-x^5+2)/4, (4*x^7-4*x^5)/(x^5-2)*y+(-2*x^2+2), 
#!   (-4*x^7+4*x^5)/(x^5-2)*y^2+(-4*x^2+4)/(x^5-2)*y+(x^2), 
#!   (-x^7)*y+(x^7-2*x^2)/2, (-4*x^2+4)/(x^5-2), 
#!   (4*x^2-4)/(x^5-2)*y+(2*x^2-2)/(x^5-2), (x^2) ]
EntriesOfHomalgMatrix( H1[2] );
#! [ (x^2), y+1/2, (x^5)*y^2+y, 0, 1, (x^5)*y+(-x^5+2)/2, 
#!   (4*x^2-4)/(x^5-2), 0, 1 ]
Delta1 := Denominator( H1[1] ) / BaseRing( R );
#! x^5-2
m2 := AMaximalIdealContaining( LeftSubmodule( [ Delta1 ] ) );;
m2 := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m2 ) );;
S2 := LocalizeBaseRingAtPrime( R, m2 );
#! ( Q[x]_< x^5-2 > )[y]
row2 := S2 * row;;
IsRightInvertibleMatrix( row2 );
#! true
H2 := Horrocks( row2, 2 );
#! [ <An unevaluated 3 x 3 matrix over a (fake) local ring>,
#!   <An unevaluated 3 x 3 matrix over a (fake) local ring> ]
EntriesOfHomalgMatrix( H2[1] );
#! [ (x^5-2)/4, (x^5-6)/(4*x^2)*y+(x^5-6)/(8*x^2), (-x^5+6)/(4*x^2), 
#!   (x^7)*y+(-x^7+2*x^2)/2, (x^5)*y^2+y+(-x^5+6)/4, (-x^5)*y+(x^5-2)/2, 
#!   (-x^2), -y-1/2, 1 ]
EntriesOfHomalgMatrix( H2[2] );
#! [ 1, 0, (x^5-6)/(4*x^2), 0, 1, (x^5)*y+(-x^5+2)/2, (x^2), y+1/2, 
#!   (x^5)*y^2+y ]
Delta2 := Denominator( H2[1] ) / BaseRing( R );
#! 4*x^2
I := LeftSubmodule( [ Delta1, Delta2 ] );;
IsOne( I );
#! true
#! @EndExample

#! @Chunk Patch

#! @Example
V := Patch( row, [ H1[1], H2[1] ], [ H1[2], H2[2] ] );
#! <A 3 x 3 matrix over an external ring>
EntriesOfHomalgMatrix( V );
#! [ 1, 1/8*x^8*y+1/2*x^5*y-3/4*x^3*y-y, 
#!   -1/16*x^13*y-1/4*x^10*y+1/2*x^8*y+x^5*y-3/4*x^3*y-y, 0, 
#!   1/2*x^10*y^2-1/4*x^10*y+2*x^7*y^2-x^7*y-2*x^5*y^2+3/2*x^5*y+2*x^2*y-\
#! 2*y+1, 
#!   -1/4*x^15*y^2+1/8*x^15*y-x^12*y^2+1/2*x^12*y+3/2*x^10*y^2-x^10*y+2*x\
#! ^7*y^2-2*x^7*y-2*x^5*y^2+3/2*x^5*y+2*x^2*y-2*y, 0, 
#!   -1/2*x^5*y-2*x^2*y+2*y, 1/4*x^10*y+x^7*y-3/2*x^5*y-2*x^2*y+2*y+1 ]
EntriesOfHomalgMatrix( row * V );
#! [ x^2, 1/2, 0 ]
y := RelativeIndeterminatesOfPolynomialRing( R )[1];;
row * V = Value( row, y, Zero( y ) );
#! true
#! @EndExample

Assert( 0, row * V = Value( row, y, Zero( y ) ) );
