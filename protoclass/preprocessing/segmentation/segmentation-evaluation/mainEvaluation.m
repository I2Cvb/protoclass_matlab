%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: mainEvaluation.m
%%% Description: 
%%% Author: Guillaume Lemaitre - Modjeh Rastgoo 
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
%%%     - vec: vectors with the different statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vec] = mainEvaluation( Seg, GT )

% Compute the Dice's coefficient
dsc = diceCoefficient( Seg, GT );
disp( [ 'Dice coefficient: ', num2str( dsc ) ] );

% Compute the different statistics
[sensitivity, specificity, precision, recall] = statisticsConfMat( Seg, GT );
disp( [ 'Sensitivity: ', num2str( sensitivity ) ] );
disp( [ 'Specificity: ', num2str( specificity ) ] );
disp( [ 'Precision: ', num2str( precision ) ] );
disp( [ 'Recall: ', num2str( recall ) ] );

% Compute the hausdorff distance
[hd] = computeHausdorff( Seg, GT );
disp( [ 'Hausdorff distance: ' , num2str( hd ) ] );

vec = [ dsc, sensitivity, specificity, precision, recall, hd ];
