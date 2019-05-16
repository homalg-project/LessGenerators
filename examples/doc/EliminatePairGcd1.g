#! @Chunk Eliminate-Unimodular-Pair-Position-Per-Row

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := Q * "x1..5";
#! Q[x1,x2,x3,x4,x5]

row := HomalgMatrix( "[ \
           4*x1+4*x2-8*x3-8*x4-4*x5+17, 4*x1+4*x2-8*x3-8*x4-4*x5+12, \
           -8*x1-8*x2+16*x3+16*x4+8*x5-27, -8*x1-8*x2+16*x3+16*x4+8*x5-28,\
           -4*x1-4*x2+8*x3+8*x4+4*x5-16 \
           ]", 1, 5, R );
#! <A 1 x 5 matrix over an external ring>

l := EliminateUnimodularPairPositionPerRow( row );
#! [ <An unevaluated 5 x 5 matrix over an external ring>, 
#!   <An unevaluated 5 x 5 matrix over an external ring> ]

n := NrColumns( row );;
Assert( 4, row * l[1] = CertainRows( HomalgIdentityMatrix( n, R ), [ 1 ] ) );
Assert( 4, CertainRows( l[2], [ 1 ] ) = row );

#! @EndExample


#! @Chunk Eliminate-Unimodular-Pair-Position-Per-Column

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := Q * "x1..5";
#! Q[x1,x2,x3,x4,x5]

col := HomalgMatrix( "[ \
           4*x1+4*x2-8*x3-8*x4-4*x5+17, 4*x1+4*x2-8*x3-8*x4-4*x5+12, \
           -8*x1-8*x2+16*x3+16*x4+8*x5-27, -8*x1-8*x2+16*x3+16*x4+8*x5-28,\
           -4*x1-4*x2+8*x3+8*x4+4*x5-16 \
           ]", 5, 1, R );
#! <A 5 x 1 matrix over an external ring>

l := EliminateUnimodularPairPositionPerColumn( col );
#! [ <An unevaluated 5 x 5 matrix over an external ring>, 
#!   <An unevaluated 5 x 5 matrix over an external ring> ]

n := NrRows( col );;
Assert( 4, l[1] * col = CertainColumns( HomalgIdentityMatrix( n, R ), [ 1 ] ) );
Assert( 4, CertainColumns( l[2], [ 1 ] ) = col );

#! @EndExample


