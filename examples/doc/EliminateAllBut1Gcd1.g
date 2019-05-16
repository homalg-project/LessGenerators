#! @Chunk Eliminate-If-Obsolete-For-Unimodularity-Columns

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := Q * "x1..5";
#! Q[x1,x2,x3,x4,x5]

row := HomalgMatrix( "[ \
  120*x1^2-96*x1*x2+12*x2^2-96*x1*x3+60*x2*x3+18*x3^2+176*x1*x4\
    -32*x2*x4-108*x3*x4+20*x4^2-128*x1*x5+80*x2*x5+48*x3*x5-144*x4*x5\
    +32*x5^2+40*x1-4*x2+20*x4+15,\
  -48*x1^2+24*x1*x2-12*x2^2+60*x1*x3-24*x2*x3-18*x3^2-32*x1*x4\
    +32*x2*x4+36*x3*x4-20*x4^2+80*x1*x5\-32*x2*x5-48*x3*x5+48*x4*x5\
    -32*x5^2-4*x1-14*x2+22*x4+1,\
  -48*x1^2+60*x1*x2-12*x2^2+36*x1*x3-36*x2*x3-108*x1*x4+36*x2*x4\
    +72*x3*x4-24*x4^2+48*x1*x5-48*x2*x5+96*x4*x5-2,\
  88*x1^2-32*x1*x2+16*x2^2-108*x1*x3+36*x2*x3+36*x3^2+40*x1*x4\
    -40*x2*x4-48*x3*x4+24*x4^2-144*x1*x5+48*x2*x5+96*x3*x5-64*x4*x5\
    +64*x5^2+20*x1+22*x2-30*x4+7,\
  -64*x1^2+80*x1*x2-16*x2^2+48*x1*x3-48*x2*x3-144*x1*x4+48*x2*x4\
    +96*x3*x4-32*x4^2+64*x1*x5-64*x2*x5+128*x4*x5-2\
  ]", 1, 5, R );
#! <A 1 x 5 matrix over an external ring>

EliminateIfColumnObsoleteForUnimodularity( row );
#! [ <An unevaluated 5 x 5 matrix over an external ring>, 
#!   <An unevaluated 5 x 5 matrix over an external ring> ]

n := NrColumns( row );;
Assert( 4, row * l[1] = CertainRows( HomalgIdentityMatrix( n, R ), [ 1 ] ) );
Assert( 4, CertainRows( l[2], [ 1 ] ) = row );

#! @EndExample


#! @Chunk Eliminate-If-Obsolete-For-Unimodularity-Rows

LoadPackage( "LessGenerators" );

#! @Example
Q := HomalgFieldOfRationalsInSingular( );;
R := Q * "x1..5";
#! Q[x1,x2,x3,x4,x5]

col := HomalgMatrix( "[ \
  120*x1^2-96*x1*x2+12*x2^2-96*x1*x3+60*x2*x3+18*x3^2+176*x1*x4\
    -32*x2*x4-108*x3*x4+20*x4^2-128*x1*x5+80*x2*x5+48*x3*x5-144*x4*x5\
    +32*x5^2+40*x1-4*x2+20*x4+15,\
  -48*x1^2+24*x1*x2-12*x2^2+60*x1*x3-24*x2*x3-18*x3^2-32*x1*x4\
    +32*x2*x4+36*x3*x4-20*x4^2+80*x1*x5\-32*x2*x5-48*x3*x5+48*x4*x5\
    -32*x5^2-4*x1-14*x2+22*x4+1,\
  -48*x1^2+60*x1*x2-12*x2^2+36*x1*x3-36*x2*x3-108*x1*x4+36*x2*x4\
    +72*x3*x4-24*x4^2+48*x1*x5-48*x2*x5+96*x4*x5-2,\
  88*x1^2-32*x1*x2+16*x2^2-108*x1*x3+36*x2*x3+36*x3^2+40*x1*x4\
    -40*x2*x4-48*x3*x4+24*x4^2-144*x1*x5+48*x2*x5+96*x3*x5-64*x4*x5\
    +64*x5^2+20*x1+22*x2-30*x4+7,\
  -64*x1^2+80*x1*x2-16*x2^2+48*x1*x3-48*x2*x3-144*x1*x4+48*x2*x4\
    +96*x3*x4-32*x4^2+64*x1*x5-64*x2*x5+128*x4*x5-2\
  ]", 5, 1, R );
#! <A 5 x 1 matrix over an external ring>

l := EliminateIfRowObsoleteForUnimodularity( col );
#! [ <An unevaluated 5 x 5 matrix over an external ring>, 
#!   <An unevaluated 5 x 5 matrix over an external ring> ]

n := NrRows( col );;
Assert( 4, l[1] * col = CertainColumns( HomalgIdentityMatrix( n, R ), [ 1 ] ) );
Assert( 4, CertainColumns( l[2], [ 1 ] ) = col );

#! @EndExample


