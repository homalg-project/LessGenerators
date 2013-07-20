##  <#GAPDoc Label="Horrocks">
##  <Example><![CDATA[
##  gap> Q := HomalgFieldOfRationalsInSingular( );;
##  gap> R := ( Q * "x" ) * "y";
##  Q[x][y]
##  gap> row := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );
##  <A 1 x 3 matrix over an external ring>
##  gap> m1 := AMaximalIdealContaining( ZeroLeftSubmodule( BaseRing( R ) ) );;
##  gap> m1 := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m1 ) );;
##  gap> S1 := LocalizeBaseRingAtPrime( R, m1 );
##  ( Q[x]_< x > )[y]
##  gap> row1 := S1 * row;
##  <A 1 x 3 matrix over a fake local ring localized at <[ x ]> ring>
##  gap> Assert( 0, IsRightInvertibleMatrix( row1 ) );
##  gap> H1 := Horrocks( row1, 2 );
##  [ <An unevaluated 3 x 3 matrix over a fake local ring localized at <[ x ]> ring>,
##    <An unevaluated 3 x 3 matrix over a fake local ring localized at <[ x ]> ring> ]
##  gap> EntriesOfHomalgMatrix( H1[1] );
##  [ 1, -y-1/2, (-1/4*x^5+1/2), (4*x^7-4*x^5)/(x^5-2)*y+(-2*x^2+2),
##    (-4*x^7+4*x^5)/(x^5-2)*y^2+(-4*x^2+4)/(x^5-2)*y+(x^2),
##    (-x^7)*y+(1/2*x^7-x^2), (-4*x^2+4)/(x^5-2),
##    (4*x^2-4)/(x^5-2)*y+(2*x^2-2)/(x^5-2), (x^2) ]
##  gap> EntriesOfHomalgMatrix( H1[2] );
##  [ (x^2), y+1/2, (x^5)*y^2+y, 0, 1, (x^5)*y+(-1/2*x^5+1), (4*x^2-4)/(x^5-2), 0, 1 ]

##  ]]></Example>
##  <#/GAPDoc>


LoadPackage( "LessGenerators" );

Q := HomalgFieldOfRationalsInSingular( );

R := ( Q * "x" ) * "y";

AssignGeneratorVariables( R );

row := HomalgMatrix( "[ x^2, y+1/2, x^5*y^2+y ]", 1, 3, R );

Assert( 0, IsRightInvertibleMatrix( row ) );

m1 := AMaximalIdealContaining( ZeroLeftSubmodule( BaseRing( R ) ) );

m1 := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m1 ) );

S1 := LocalizeBaseRingAtPrime( R, m1 );

row1 := S1 * row;

Assert( 0, IsRightInvertibleMatrix( row1 ) );
                                                                                                 
H1 := Horrocks( row1, 2 );

Delta1 := Denominator( H1[1] ) / BaseRing( R );

m2 := AMaximalIdealContaining( LeftSubmodule( [ Delta1 ] ) );

m2 := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( m2 ) );

S2 := LocalizeBaseRingAtPrime( R, m2 );

Assert( 0, IsIdenticalObj( AssociatedComputationRing( S1 ), AssociatedComputationRing( S2 ) ) );

row2 := S2 * row;

Assert( 0, IsRightInvertibleMatrix( row2 ) );
                                                                                                 
H2 := Horrocks( row2, 2 );

V := Patch( row, [ H1[1], H2[1] ], [ H1[2], H2[2] ] );

Assert( 0, ForAll( EntriesOfHomalgMatrix( row * V ), e -> Degree( e ) < 1 ) );
