#############################################################################
##
##  LessGenerators.gi           LessGenerators package       Mohamed Barakat
##                                                            Anna Fabianska
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for LessGenerators.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

#InstallValue( LESS_GENERATORS,
#        rec(
#            
#            )
#);

####################################
#
# global functions and operations:
#
####################################

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList, IsList ],
        
  function( M, unclean_rows, unclean_columns )
    local lr, j, i, r, f, h;
    
    lr := Length( unclean_rows );
    
    for j in unclean_columns do
        for i in [ 1 .. lr ] do
            r := ShallowCopy( unclean_rows );
            Remove( r, i );
            f := CertainRows( CertainColumns( M, [ j  ] ), r );
            h := LeftInverse( f );
            if Eval( h ) <> fail then
                ## i = the position of the obsolete row
                ## j = the position of the column where all the entries but the i-th row generate 1
                ## r = the number of rows in the j-th column that generate 1
                ## h = the left inverse of r-rows of the j-th column
                return [ i, j, r, h ];
            fi;
        od;
    od;
    
    return fail;
    
end );

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return GetAllButOneGcd1ColumnPosition( M, [ 1 .. NrRows( M ) ], [ 1 .. NrColumns( M ) ] );
    
end );

##
InstallMethod( GetAllButOneGcd1ColumnPosition,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    return fail;
    
end );
