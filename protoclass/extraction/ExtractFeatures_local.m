%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% feature extraction main function ---> ExtractFeatures_BoW.m
%%% Author: Mojdeh Rastgoo
%%% UB-UdG 
%%% Verison: 1.0 
%%% This version is only applicable for extracting features from patches of 2D image
%%% on gray scale images 
%%% Examples : 
%%% LBP        | maps (samples (default = 16) [8,16,24], option(default = riu) [ri, riu])
%%% CLBP       | maps (samples (default = 16) [8,16,24], option(default = riu) [ri, riu])
%%% Gabor      | orientation (default=6), scale (default = 4) 
%%% GLCMaO     | distance (default = 5), num_levels (default = 16) options:[8,16,32]
%%% GLCMaD     | theta (default = 45) options:[0 45 90 135], num_levels (default = 16) options:[8,16,32]
%%% HoG        | cellSize (default = 9)
%%% Sift       | vl_sift parameters , sift_scale and orientation for a sift
%%%            | descriptor placed in the center on the patch
%%% Wavelet    | wname (default = 'db9'), option2 (default = 'WP'), nlevel(default = 4), RI (default = 0), coloroption (default = 'g')
%%% Color1     | nbins (default = 42)
%%% Color2     | nbins (default = 42) , PSize = size of patches for opponent angle 
%%%            |
%%% -------------------------------------------------------
%%% Note : 
%%% Color1 : is Color statistcis such a mean and variance in
%%% different RGB, HSV and LAB and the color histogram in RGB
%%% Color2 : is the histogram of angle and hue of opponent color space 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   function feature_matrix = ExtractFeatures_local(Img, FeatureId, varargin)
    
    %%% Setting the necessary directories -------------------------------------
    %%% The function operates within the protoclass-matlab folder 
    addpath ../../third_party/Basic_function

    %%% Parameters initialization 
    input.patchSize = 16; 
    input.Mask = [] ; 
    input.samples = 16 ; 
    input.radius = 2; 
    input.option1 = 'riu'; 
    input.distance = 5; 
    input.num_levels = 16;
    input.theta = 45; 
    input.scale = 4 ; 
    input.orientation = 6; 
    input.cellSize = 9 ; 
    input.wname = 'db9'; 
    input.option2 = 'WP'; 
    input.nlevel = 4; 
    input.RI = 0; 
    input.coloroption = 'g'; 
    input.nbins = 42 ; 
    input.sift_scale = 1 ;% input.patchSize/20 ; 
    input = parseargs(input,varargin{:});
    
    
    
    %%%------------------------------------------------------------------------
    Img = im2double (Img); 
    [w, h, d] = size(Img); 
    if d ~= 1 
        grayImg = mat2gray(rgb2gray(Img)); 
    else 
        grayImg = Img; 
    end

    if (isempty(input.Mask) ~= 1)
       
        %%% Bounding the image to its mask by considering the longest axis of
        %%% the mask
        Mask = input.Mask; 
        disp ('The features are extracted from the rectangle bounded to the segmented lesion')
        %%% If Mask imge is provided: 
        BWImg = im2bw(Mask); 
        B_tem = regionprops(BWImg, 'BoundingBox');
        B_dim = zeros(4,1);
        Area_tem = regionprops(BWImg , 'Area'); 
        clear tem; 
        for  j = 1 : length(Area_tem)
            tem(j) = Area_tem(j).Area; 
        end
        [~, Id] = max(tem); 
        if size(B_tem,1) > 1
           B_dim(1,1) = B_tem(Id).BoundingBox(1); 
           B_dim(2,1) = B_tem(Id).BoundingBox(2); 
           B_dim(3,1) = B_tem(Id).BoundingBox(3); 
           B_dim(4,1) = B_tem(Id).BoundingBox(4); 
        elseif size(B_tem,1) == 1
           B_dim(1,1) = B_tem.BoundingBox(1); 
           B_dim(2,1) = B_tem.BoundingBox(2); 
           B_dim(3,1) = B_tem.BoundingBox(3); 
           B_dim(4,1) = B_tem.BoundingBox(4); 
        end 

        B_x = [ceil(B_dim(2)) fix(B_dim(2) + B_dim(4))]; 
        B_y = [ceil(B_dim(1)) fix(B_dim(1) + B_dim(3))];
        ImgGray = grayImg(B_x(1):B_x(2) , B_y(1):B_y(2), :); 
        ImgColor = Img(B_x(1):B_x(2) , B_y(1):B_y(2), :); 
        Mask = BWImg(B_x(1):B_x(2) , B_y(1):B_y(2));  


    elseif (isempty(input.Mask) == 1)
        
        %%% Considerig the full image 
        disp ('The features are extracted from the entire image without considering segmentation')
        %%% if Mask image is not provided:
        ImgGray = grayImg; 
        ImgColor = Img; 

    end 
    feature_matrix = []; 
    PSize = input.patchSize; 
    
     if (strncmpi('LBP', FeatureId, 3) == 1)
        %%% Checking the input values 
        %%% Indicating the overlap and cellsize bigger than the defined
        %%% patchSize is necessary for LBP in order to consider all the
        %%% pixels in the defined patch size in the calculated LBP
        %%% descriptor
        if input.samples == 8 
            radius = 1 ;  
            overlap = 1 ; 
            PSize = PSize + 2*overlap ;
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
        elseif input.samples == 16
            radius = 2 ; 
            overlap = 2 ; 
            PSize = PSize + 2*overlap; 
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
            
        elseif input.samples == 24
            radius = 3 ; 
            overlap = 3 ;
            PSize = PSize + 2*overlap;
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
        end
        
        ystrIdx = 1 : input.patchSize : size(ImgGray, 2);
        if rem(size(ImgGray, 2), input.patchSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  input.patchSize : input.patchSize : size(ImgGray, 2);
        yendIdx(2:end) = yendIdx(2:end)+(2*overlap);
        yendIdx(1) = PSize; 
    
        
        xstrIdx =  1 : input.patchSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , input.patchSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = input.patchSize : input.patchSize : size(ImgGray, 1);
        xendIdx(2:end) = xendIdx(2:end)+(2*overlap);
        xendIdx(1) = PSize; 
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        ImgGray = ImgGrayPad; 
   
        
        
        disp(['LBP features with sampling number of ' num2str(input.samples) 'and option of' input.option1 ' are being extracted'])
        %addpath tools/LBP/
        %%% Loading the look up map 
        load(['Map_' num2str(input.samples) '_' input.option1 '.mat']); 
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            feature_patch = lbp(Patch,radius,input.samples,Map,'nh');
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('...done.')
 
    elseif (strncmpi('CLBP', FeatureId, 4) == 1)

        if input.samples == 8 
            radius = 1 ;  
            overlap = 1 ; 
            PSize = PSize + 2*overlap ;
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
        elseif input.samples == 16
            radius = 2 ; 
            overlap = 2 ; 
            PSize = PSize + 2*overlap; 
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
            
        elseif input.samples == 24
            radius = 3 ; 
            overlap = 3 ;
            PSize = PSize + 2*overlap;
            ImgGrayPad = padarray(ImgGray, [overlap overlap], 'replicate'); %%% Paddarray the image accordingly
        end
        
        ystrIdx = 1 : input.patchSize : size(ImgGray, 2);
        if rem(size(ImgGray, 2), input.patchSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  input.patchSize : input.patchSize : size(ImgGray, 2);
        yendIdx(2:end) = yendIdx(2:end)+(2*overlap);
        yendIdx(1) = PSize; 
        
        xstrIdx =  1 : input.patchSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , input.patchSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = input.patchSize : input.patchSize : size(ImgGray, 1);
        xendIdx(2:end) = xendIdx(2:end)+(2*overlap);
        xendIdx(1) = PSize; 
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        ImgGray = ImgGrayPad; 
        
        
        disp(['CLBP features with sampling number of ' num2str(input.samples) 'and option of' input.option1 ' are being extracted ...'])
        %addpath tools/CLBP/
        %%% Loading the look up map 
        load(['Map_' num2str(input.samples) '_' input.option1 '.mat']); 
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            feature_patch = clbp(Patch,radius,input.samples,Map,'nh');
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('...done.')


    elseif (strncmpi('GLCMaO', FeatureId, 6) == 1)
        disp(['GLCMaO features with distance of ' num2str(input.distance) 'and gray-levels of' num2str(input.num_levels) ' are being extracted'])
        addpath tools/GLCMaO/
       
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            feature_patch = Extract_features_GLCMAO(Patch.*255,input.distance, input.num_levels); 
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('... done.')



    elseif (strncmpi('GLCMaD', FeatureId, 6) == 1)
        disp(['GLCMaO features with distance of ' num2str(input.distance) 'and gray-levels of' num2str(input.num_levels) ' are being extracted'])
        addpath tools/GLCMaD/
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            feature_patch = Extract_features_GLCMAD(Patch.*255,input.theta, input.num_levels); 
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('... done.')
        
    elseif (strncmpi('Gabor', FeatureId, 5) == 1)
        disp(['Gabor filter features with ' num2str(input.scale) 'scale and ' num2str(input.orientation) ' orientations are being detected'])
        %addpath tools/GaborFilter/
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            feature_patch = gabor_feature_calculation(Patch,input.scale,input.orientation,size(ImgGray,1));  
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('... done.')
        
        
 

    elseif (strncmpi('HoG', FeatureId, 3) == 1)
        disp(['HoG features using ' num2str(input.cellSize) ' as cell-size are being detected'])
        %addpath ../../third_party/vlfeat-0.9.16/toolbox/
        addpath ../../third_party/vlfeat-0.9.20/toolbox/
        
        vl_setup
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId))); 
            TempGray = vl_hog(im2single(Patch),input.cellSize, 'verbose');
            [counts, ~] = imhist(TempGray(:)');
            counts = counts./sum(counts); 
            feature_patch = counts'; 
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('... done.')

    elseif (strncmpi('Sift', FeatureId, 3) == 1)
        disp('Sift features are extracted')
        
        %addpath ../../third_party/vlfeat-0.9.20/toolbox/
        vl_setup
        
        if PSize < 16                %%% indicating that the limit size of the window  
            disp('The patch size for Sift can not be smaller than 16 pixels.')
            return
        end 
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X)
            clear Patch feature_patch 
		    Patch = single(ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId)))); 
            fc = [ceil(PSize/2); ceil(PSize/2); input.sift_scale; 0]; 
            [Centers, feature_patch] = vl_sift(single(Patch), 'frames', fc, 'orientations'); 
            feature_matrix = [feature_matrix; feature_patch']; 
        end 
        disp('... done.')

    elseif (strncmpi('Color1', FeatureId, 6) == 1)
        disp(['Color statistics features are extracted, histogram is made using ' num2str(input.nbins) ' bins'])
        %addpath tools/Color/ 
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgColor (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId)), :); 
            Patch_mask = ones([PSize, PSize]); 
            temp1 = clrFeatures(Patch, Patch_mask); 
            feature_patch (1:length(temp1)) =  temp1'; 
            [temp2, HistCube, HistVec] = clrHistFeatures (Patch, Patch_mask, input.nbins); 
            feature_patch(length(temp1)+1:length(temp1)+(1*input.nbins)) = temp2(1,:)./sum(temp2(1,:)); 
            feature_patch(length(temp1)+(1*input.nbins)+1:length(temp1)+(2*input.nbins)) = temp2(2,:)./sum(temp2(2,:)); 
            feature_patch(length(temp1)+(2*input.nbins)+1:length(temp1)+(3*input.nbins)) = temp2(3,:)./sum(temp2(3,:));
            feature_matrix = [feature_matrix; feature_patch]; 

        end
        disp('... done.')


    elseif (strncmpi('Color2', FeatureId, 3) == 1)
        disp(['Angle and Hue histogram of opponent color space are extracted, histogram is made using ' num2str(input.nbins) ' bins'])
        %addpath tools/Color/
        
                
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgColor (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId)), :);
            [row, col, d] = size(Patch); 
            minDim = min(row, col); 
            remind = rem(minDim, PSize); 
            ResizeSize = minDim - remind; 
            feature_patch = color_descriptor(Patch,input.nbins,ResizeSize, PSize);
            feature_matrix = [feature_matrix; feature_patch]; 
        end 
        disp('... done.')


    elseif (strncmpi('wavelet', FeatureId, 7) == 1)
        
        %addpath tools/Wavelet/

        disp('Attention the size of this descriptor depending on the user option might be too large !! ')
        disp(['Wavelet features are extracted with specified parameters - option: ' input.option2 ' color-option: ' input.coloroption ...
            ' levels: ' num2str(input.nlevel) ' RI: ' num2str(input.RI) ' wavelet: ' input.wname])
        
        %%% Divding the image into patches 
        ystrIdx = 1 : PSize  : size(ImgGray, 2);
        if rem(size(ImgGray, 2), PSize) ~= 0
            ystrIdx(end) = [];
        end
        yendIdx =  PSize : PSize : size(ImgGray, 2);
        
        xstrIdx =  1 : PSize : size(ImgGray, 1);
        if rem(size(ImgGray, 1) , PSize) ~= 0
            xstrIdx(end) = [];
        end
        xendIdx = PSize : PSize : size(ImgGray, 1);
        
        [X, Y] = meshgrid(1: length(xendIdx), 1:length(yendIdx));
        X = X(:) ; Y = Y(:);
        
        for pId = 1 : length(X) %%% Main loop for extracting the patches from the image 
            clear Patch feature_patch 
		    Patch = ImgGray (xstrIdx(X(pId)) : xendIdx(X(pId)), ystrIdx(Y(pId)) : yendIdx(Y(pId)));
            feature_patch = ExtractFeatures_wavelet(Patch,input.wname, input.RI, input.option2, input.coloroption, input.nlevel); 
            feature_matrix = [feature_matrix; feature_patch]; 
        end
        
        
        disp('... done.')
    end 
    
  


