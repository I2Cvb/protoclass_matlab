%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: statisticsConfMat.m
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

function [sensitivity, specificity, precision, recall] = statisticsConfMat( Seg, GT )

% Compute the confusion matrix between the two images
confMat = confusionmat( GT( : ), Seg( : ), 'order', [255 0] );

% Compute the sensitivity and specificity
sensitivity = confMat( 1, 1 ) / ( confMat( 1, 1 ) + confMat( 1, 2 ) );
specificity = confMat( 2, 2 ) / ( confMat( 2, 2 ) + confMat( 2, 1 ) );
precision = confMat( 1, 1 ) / ( confMat( 1, 1 ) + confMat( 2, 1 ) );
recall = confMat( 2, 2 ) / ( confMat( 2, 2 ) + confMat( 1, 2 ) );
