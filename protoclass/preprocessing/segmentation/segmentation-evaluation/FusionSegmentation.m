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

 function [FusionSegImg] = FusionSegmentation( Seg1, Seg2, Seg3, Seg4)
% Seg4 = zeros(size(Seg1)) ; 
% Seg4 (49:end-50 , 49:end-50)  = 1 ;

%% Creating the filters for defining over segmentation and undersegmentation images. 
Filter1 = zeros(size(Seg1)) ; 
Filter2 = zeros(size(Seg1)) ;
Filter3 = zeros(size(Seg1)) ; 
Filter4 = zeros(size(Seg1)) ; 
Filter5 = ones(size(Seg1)); 

% Filter1 corresponds to the higher length
Filter1 (15 : 30 , : ) = 1 ; sumFilter1_2 = sum(Filter1(:)); 
% Filter2 corresponds to the lower length 
Filter2 (end-30: end-15, :) = 1 ;
% Filter3 corresponds to the left width
Filter3 (:,15:30) = 1 ;   sumFilter3_4 = sum(Filter3(:)) ; 
% Filter4 corresponds to the rigth width
Filter4 (:, end-30:end-15) = 1 ; 

% Four segmentation methods, All four segmentation should be checked 
    % Seg1 
    tem1 = Seg1.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    tem2 = Seg1.*Filter2 ; sumtem2 = sum(tem2(:)) ; 
    tem3 = Seg1.*Filter3 ; sumtem3 = sum(tem3(:)) ; 
    tem4 = Seg1.*Filter4 ; sumtem4 = sum(tem4(:)) ; 
    
    if sumtem1 == 0 && sumtem2 ==0 && sumtem3 == 0 && sumtem4 == 0 
         disp('Seg1 is not over segmented');
         F1= 0 ; 
    elseif ((sumtem1 <= sumFilter1_2 ) && (sumtem1 > 0.6*(sumFilter1_2))) || ...
            ((sumtem3 <= sumFilter3_4 ) && (sumtem3 > 0.6*(sumFilter3_4)))
        Seg1 = zeros(size(Seg1)); 
        F1 = 1 ; 
        disp('Seg1 is over segmented')
    elseif ((sumtem4 <= sumFilter3_4 ) && (sumtem4 > 0.4*(sumFilter3_4)))
        Seg1 = zeros(size(Seg1)) ; 
        F1 = 1 ; 
        disp('Seg1 is either over segmented or under segmented, only detects the right border of the image')
    else
        F1 = 0 ; 
    end 
    
    
    % Seg2 
    tem1 = Seg2.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    tem2 = Seg2.*Filter2 ; sumtem2 = sum(tem2(:)) ; 
    tem3 = Seg2.*Filter3 ; sumtem3 = sum(tem3(:)) ; 
    tem4 = Seg2.*Filter4 ; sumtem4 = sum(tem4(:)) ; 
    
    if sumtem1 == 0 && sumtem2 ==0 && sumtem3 == 0 && sumtem4 == 0 
         disp('Seg2 is not over segmented');
         F2 = 0 ; 
    elseif ((sumtem1 <= sumFilter1_2 ) && (sumtem1 >= 0.6*(sumFilter1_2))) || ...
            ((sumtem3 <= sumFilter3_4 ) && (sumtem3 >= 0.6*(sumFilter3_4)))
        Seg2 = zeros(size(Seg2)); 
        F2 = 1 ; 
        disp('Seg2 is over segmented')
    elseif ((sumtem4 <= sumFilter3_4 ) && (sumtem4 >  0.4*(sumFilter3_4)))
        Seg2 = zeros(size(Seg2)) ; 
        F2 = 1 ; 
        disp('Seg2 is either over segmented or under segmented, only detects the right border of the image')
    else 
        F2 = 0 ; 
    end 
    
    
    % Seg3 
    tem1 = Seg3.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    tem2 = Seg3.*Filter2 ; sumtem2 = sum(tem2(:)) ; 
    tem3 = Seg3.*Filter3 ; sumtem3 = sum(tem3(:)) ; 
    tem4 = Seg3.*Filter4 ; sumtem4 = sum(tem4(:)) ; 
    
    if sumtem1 == 0 && sumtem2 ==0 && sumtem3 == 0 && sumtem4 == 0 
         disp('Seg3 is not over segmented');
         F3 = 0 ; 
    elseif ((sumtem1 <=sumFilter1_2 ) && (sumtem1 >  0.6*(sumFilter1_2))) || ...
            ((sumtem3 <= sumFilter3_4 ) && (sumtem3 > 0.6*(sumFilter3_4)))
        Seg3 = zeros(size(Seg3)); 
        F3 = 1 ; 
        disp('Seg3 is over segmented')
    elseif ((sumtem4 < sumFilter3_4 ) && (sumtem4 > 0.4*(sumFilter3_4)))
        Seg3 = zeros(size(Seg3)) ; 
        F3 = 1 ; 
        disp('Seg3 is either over segmented or under segmented, only detects the right border of the image')
    else 
        F3 = 0 ; 
    end 
    
    
    % Seg4 
    tem1 = Seg4.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    tem2 = Seg4.*Filter2 ; sumtem2 = sum(tem2(:)) ; 
    tem3 = Seg4.*Filter3 ; sumtem3 = sum(tem3(:)) ; 
    tem4 = Seg4.*Filter4 ; sumtem4 = sum(tem4(:)) ; 
    
    if sumtem1 == 0 && sumtem2 ==0 && sumtem3 == 0 && sumtem4 == 0 
         disp('Seg4 is not over segmented');
         F4 = 0 ; 
    elseif ((sumtem1 <= sumFilter1_2 ) && (sumtem1 > 0.6*(sumFilter1_2))) || ...
            ((sumtem3 <= sumFilter3_4 ) && (sumtem3 > 0.6*(sumFilter3_4)))
        Seg4 = zeros(size(Seg4)); 
        F4 = 1 ; 
        disp('Seg4 is over segmented')
    elseif ((sumtem4 < sumFilter3_4 ) && (sumtem4 >  0.4*(sumFilter3_4)))
        Seg4 = zeros(size(Seg4)) ; 
        F4 = 1 ; 
        disp('Seg4 is either over segmented or under segmented, only detects the right border of the image')
    else 
        F4 = 0 ; 
    end 
    
    
%% Segmentation Fusion 
TemSeg = logical(Seg1) + logical(Seg2) + logical(Seg3) + logical(Seg4) ; 
FusionSegImg = zeros(size(TemSeg)); 

F = F1 + F2 + F3 + F4 ; 
if F == 0     
    FusionSegImg (TemSeg >= 2) = 1 ; 
    FusionSegImg(TemSeg <= 0) = 0 ; 
elseif F == 1 
    FusionSegImg (TemSeg >= 2) = 1 ; 
    FusionSegImg(TemSeg <= 0) = 0 ; 
elseif F ==2 
    FusionSegImg (TemSeg >= 2) = 1 ; 
    FusionSegImg(TemSeg <= 0) = 0 ; 
elseif F == 3 
    FusionSegImg (TemSeg >= 1) = 1 ; 
    FusionSegImg(TemSeg <= 0) = 0 ;     
end 
