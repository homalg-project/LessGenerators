#############################################################################
##
##  Tools.gi                                          LessGenerators package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##                  Vinai Wagh, Indian Institute of Technology Guwahati
##
##  Implementations for tools.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( CauchyBinetColumn,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local c, R, RP, row;
    
    c := NrColumns( M );
    
    R := HomalgRing( M );
    
    if NrRows( M ) + 1 <> c then
        Error( "the input is not an (p-1) x p matrix\n" );
    elif c = 1 then
        return HomalgIdentityMatrix( 1, 1, R );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.CauchyBinetRow) then
        row := RP!.CauchyBinetRow( M );
        return HomalgMatrix( row, c, 1, R );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    row := List( [ 1 .. c ],
                 i -> (-1)^(c + i) * Determinant(
                         CertainColumns( M,
                                 Concatenation(
                                         [ 1 .. i - 1 ],
                                         [ i + 1 .. c ]
                                         )
                                 )
                         )
                 );
    
    return HomalgMatrix( row, c, 1, R );
    
end );

##
InstallMethod( CauchyBinetBaseChange,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return UnionOfColumns( RightInverseLazy( M ), CauchyBinetColumn( M ) );
    
end );

##
InstallMethod( CauchyBinetCompletion,
        "for matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    
    return LeftInverseLazy( CauchyBinetBaseChange( M ) );
    
end );

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
