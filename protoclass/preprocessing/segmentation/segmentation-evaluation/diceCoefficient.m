%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: diceCoefficient.m
%%% Description: This function allows to compute the Dice's coefficient
%%% between two segmented images
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
%%%     - coef: Dice's coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ coef ] = diceCoefficient( Seg, GT )

% Compute the Dices coefficient
coef = ( 2 .* nnz( and( Seg, GT ) ) ) / ( nnz( Seg ) + nnz( GT ) );

% % Show the overlapping areas between the two images
figure( 1 );
fusedMask = zeros( size( Seg, 1 ), size( Seg, 2 ), 3 );
fusedMask( :, :, 1 ) = or( Seg, GT );
fusedMask( :, :, 2 ) = ~or( ~GT, Seg );
fusedMask( :, :, 3 ) = ~or( ~Seg, GT );
imshow( fusedMask );
