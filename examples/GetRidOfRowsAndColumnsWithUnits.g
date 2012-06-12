LoadPackage( "LessGenerators" );

LoadPackage( "Modules" );

Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";

wmat := HomalgMatrix( "[ \
x*z, z*y, z^2, 0, 0, y, \
0, 0, 0, z^2*y-z^2, z^3, x*z, \
0, 0, 0, z*y^2-z*y, z^2*y, x*y, \
0, 0, 0, x*z*y-x*z, x*z^2, x^2, \
x^2*z, x*z*y, x*z^2, 0, 0, x*y, \
-x*y, -y^2, -z*y, x^2*y-y-x^2+1, x^2*z-z, 0, \
x^2*y-x^2, x*y^2-x*y, x*z*y-x*z, -y^3+2*y^2-y, -z*y^2+z*y, 0, \
0, 0, 0, z*y-z, z^2, x^3-y^2 \
]", 8, 6, Qxyz );

rsyz := SyzygiesGeneratorsOfRows( wmat );

isyz := Involution( rsyz );

m := GetRidOfRowsAndColumnsWithUnits( rsyz );

Assert( 0, m = List( Reversed( GetRidOfRowsAndColumnsWithUnits( isyz ) ), Involution ) );

MM := rsyz;
U := m[1];
UI := m[2];
M := m[3];
VI := m[4];
V := m[5];

Assert( 0, GenerateSameColumnModule( U * MM, M ) );
Assert( 0, GenerateSameRowModule( MM * V, M ) );
Assert( 0, IsZero( DecideZeroColumns( UI * M, BasisOfColumnModule( MM ) ) ) );
Assert( 0, IsZero( DecideZeroRows( M * VI, BasisOfRowModule( MM ) ) ) );
