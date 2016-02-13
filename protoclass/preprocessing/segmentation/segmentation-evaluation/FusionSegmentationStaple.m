%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: FusionSegmentation.m
%%% Description: 
%%% Author:  Modjeh Rastgoo 
%%% LE2I - ViCOROB
%%% Date: 10 February 2014
%%% Version: 0.1
%%% -----------------------------------------------------------------------
%%% Input arguments:
%%%     - Seg1, Seg2, Seg3 : Binary segmented images.
%%%     
%%% -----------------------------------------------------------------------
%%% Output arguments:
%%%     - FusionSegImg: Fusion of the segmented images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function [FusionImg] = FusionSegmentationStaple( SegImg)

 FusionImg = zeros(size(SegImg)) ; 
 FusionImg(SegImg >= 0.8) = 1 ; 
 
