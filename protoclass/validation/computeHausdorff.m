%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: computeHausdorff.m
%%% Description: Allow to compute the Hausdorff distance.
%%% Author: Guillaume Lemaitre - Mojdeh Rastgoo 
%%% LE2I - ViCOROB
%%% Date: 10 February 2014
%%% Version: 0.1
%%% Copyright (c) 2014 Guillaume Lemaitre
%%% http://le2i.cnrs.fr/ - http://vicorob.udg.es/
%%% -----------------------------------------------------------------------
%%% Input arguments:
%%%     - Seg: Binary segmented image.
%%%     - GT: Binary segmented image.
%%% -----------------------------------------------------------------------
%%% Output arguments:
%%%     - hd: Hausdorff distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hd] = computeHausdorff( Seg, GT )

% Find the contours of the lesions
contourSeg = edge( Seg );
contourGT = edge( GT );

% Recover the coordinates of the non-zero values
indexContourSeg = find( contourSeg );
P = zeros( length( indexContourSeg ), 2 );
for ind = 1 : length( indexContourSeg )
    [ P( ind, 1 ), P( ind, 2 ) ] = ind2sub( [ size( Seg, 1 ), size( Seg, 2 ) ], indexContourSeg( ind ) );
end
indexContourGT = find( contourGT );
Q = zeros( length( indexContourGT ), 2 );
for ind = 1 : length( indexContourGT )
    [ Q( ind, 1 ), Q( ind, 2 ) ] = ind2sub( [ size( GT, 1 ), size( GT, 2 ) ], indexContourGT( ind ) );
end

% Compute the Hausedorff distance
[hd] = HausdorffDist( P, Q );
