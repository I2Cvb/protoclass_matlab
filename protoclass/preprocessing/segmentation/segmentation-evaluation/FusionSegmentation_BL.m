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

 function [FusionSegImg] = FusionSegmentation_BL( Seg1, Seg2, Seg3, Seg4)
% Seg4 = zeros(size(Seg1)) ; 
% Seg4 (49:end-50 , 49:end-50)  = 1 ;

%% Creating the filters for defining over segmentation and undersegmentation images. 
%%% For big lesions, the border of the image is also covered by the lesion,
%%% so the we only discard the images with full image as the lesion 
Filter1 = ones(size(Seg1)) ; 

sumFilter1 = sum(Filter1(:)); 


% Four segmentation methods, All four segmentation should be checked 
    % Seg1 
    tem1 = Seg1.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    
    
    if sumtem1 > 0.75*(sumFilter1) && sumtem1<= sumFilter1
         disp('Seg1 is over segmented')
         F1 = 1 ; 
         Seg1 = zeros(size(Seg1)); 
    else 
        disp('Seg1 is not over segmented')
        F1 = 0 ;     
       
    end 
    
    
    % Seg2 
    tem1 = Seg2.*Filter1 ; sumtem1 = sum(tem1(:)) ; 
    
    if sumtem1 > 0.75*(sumFilter1) && sumtem1<= sumFilter1
         disp('Seg2 is over segmented')
         F2 = 1 ; 
         Seg2 = zeros(size(Seg2)); 
    else 
        disp('Seg2 is not over segmented')
        F2 = 0 ;     
       
    end 
    
    
    % Seg3 
    tem1 = Seg3.*Filter1 ; sumtem1 = sum(tem1(:)) ; 

    
    
    if sumtem1 > 0.75*(sumFilter1) && sumtem1<= sumFilter1
         disp('Seg3 is over segmented')
         Seg3 = zeros(size(Seg3)); 
         F3 = 1 ; 
    else 
        disp('Seg3 is not over segmented')
        F3 = 0 ;     
       
    end 
    
    % Seg4 
    tem1 = Seg4.*Filter1 ; sumtem1 = sum(tem1(:)) ; 

    
    if sumtem1 > 0.75*(sumFilter1) && sumtem1<= sumFilter1
         disp('Seg4 is over segmented')
         Seg4 =zeros(size(Seg4)); 
         F4 = 1 ; 
    else 
        disp('Seg4 is not over segmented')
        F4 = 0 ;     
       
    end 
    
    
%% Segmentation Fusion 
TemSeg = logical(Seg1) + logical(Seg2) + logical(Seg3) + logical(Seg4) ; 
FusionSegImg = zeros(size(TemSeg)); 

% F = F1 + F2 + F3 + F4 ; 
% if F == 0     
    FusionSegImg (TemSeg >= 2) = 1 ; 
    FusionSegImg(TemSeg <= 0) = 0 ; 
% elseif F == 1 
%     FusionSegImg (TemSeg >= 2) = 1 ; 
%     FusionSegImg(TemSeg <= 0) = 0 ; 
% elseif F ==2 
%     FusionSegImg (TemSeg >= 2) = 1 ; 
%     FusionSegImg(TemSeg <= 0) = 0 ; 
% elseif F == 3 
%     FusionSegImg (TemSeg >= 1) = 1 ; 
%     FusionSegImg(TemSeg <= 0) = 0 ;     
% end 
