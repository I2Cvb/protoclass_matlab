%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ExtractFeatures.m 
%%% Author: Mojdeh Rastgoo 
%%% Version: 1.0
%%% UB-UdG 
%%% This function is able to extract different set of features on a 
%%% mono-channel image
%%% Using the FeatureId the following features can be selected 
%%% Accordingly the default parameters of each feature can be set 
%%% ---------------------------------------------------
%%% FeatureId  | Params  
%%% ---------- |----------------------------------------
%%% LBP        | maps (samples (default = 16) [8,16,24], option(default = riu) [ri, riu])
%%% CLBP       | maps (samples (default = 16) [8,16,24], option(default = riu) [ri, riu])
%%% Gabor      | orientation (default=6), scale (default = 4) 
%%% GLCMaO     | distance (default = 5), num_levels (default = 16) options:[8,16,32]
%%% GLCMaD     | theta (default = 45) options:[0 45 90 135], num_levels (default = 16) options:[8,16,32]
%%% HoG        | cellSize (default = 9)
%%% Sift       | vl_sift parameters 
%%% DSift      | vl_dsift parameters 
%%% Wavelet    | wname (default = 'db9'), option2 (default = 'WP'), nlevel(default = 4), RI (default = 0), coloroption (default = 'g')
%%% Color1     | nbins (default = 42)
%%% Color2     | nbins (default = 42) , PSize = size of patches for
%%% opponent angle 
%%%            |
%%% -------------------------------------------------------
%%% Note : 
%%% Color1 : is Color statistcis such a mean and variance in
%%% different RGB, HSV and LAB and the color histogram in RGB
%%% Color2 : is the histogram of angle and hue of opponent color space 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function feature_vector = ExtractFeatures_global(Img, FeatureId, varargin)

    %%% Setting the necessary directories -------------------------------------
    %%% The function operates within the protoclass-matlab folder 
    addpath ../../third_party/Basic_function

    %%% Parameters initialization 

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
    input.PSize = 20; 
    input = parseargs(input,varargin{:});


    %%%------------------------------------------------------------------------
    Img = im2double (Img); 
    grayImg = mat2gray(rgb2gray(Img)); 


    if (isempty(input.Mask) ~= 1)
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
        disp ('The features are extracted from the entire image without considering segmentation')
        %%% if Mask image is not provided:
        ImgGray = grayImg; 
        ImgColor = Img; 
        Mask = ones(size(ImgGray)); 

    end 


    if (strncmpi('LBP', FeatureId, 3) == 1)
        %%% Checking the input values 
        if input.samples == 16 
            radius = 2 ; 
        elseif input.samples == 24
            radius = 3 ; 
        elseif input.samples == 8
            radius = 1 ; 
        end 
        disp(['LBP features with sampling number of ' num2str(input.samples) 'and option of' input.option1 ' are being extracted'])
        addpath tools/LBP/
        %%% Loading the look up map 
        load(['tools/LBP/maps/' 'Map_' num2str(input.samples) '_' input.option1 '.mat']); 
        feature_vector = lbp(ImgGray,radius,input.samples,Map,'nh');
        disp('...done.')


    elseif (strncmpi('CLBP', FeatureId, 4) == 1)
        if input.samples == 16 
            radius = 2 ; 
        elseif input.samples == 24
            radius = 3 ; 
        elseif input.samples == 8
            radius = 1 ; 
        end 
        disp(['CLBP features with sampling number of ' num2str(input.samples) 'and option of' input.option1 ' are being extracted ...'])
        addpath tools/CLBP/
        %%% Loading the look up map 
        load(['tools/CLBP/maps/' 'Map_' num2str(input.samples) '_' input.option1 '.mat']); 
        feature_vector = clbp(ImgGray,radius,input.samples,Map,'nh');
        disp('...done.')

    elseif (strncmpi('GLCMaO', FeatureId, 6) == 1)
        disp(['GLCMaO features with distance of ' num2str(input.distance) 'and gray-levels of' num2str(input.num_levels) ' are being extracted'])
        addpath tools/GLCMaO/
        feature_vector =  Extract_features_GLCMAO(ImgGray.*255,input.distance, input.num_levels); 
        disp('... done.')



    elseif (strncmpi('GLCMaD', FeatureId, 6) == 1)
        disp(['GLCMaO features with distance of ' num2str(input.distance) 'and gray-levels of' num2str(input.num_levels) ' are being extracted'])
        addpath tools/GLCMaD/
        feature_vector =  Extract_features_GLCMAD(ImgGray.*255,input.theta, input.num_levels); 
        disp('... done.')


    elseif (strncmpi('Gabor', FeatureId, 5) == 1)
        disp(['Gabor filter features with ' num2str(input.scale) 'scale and ' num2str(input.orientation) ' orientations are being detected'])
        addpath tools/GaborFilter/
        feature_vector = gabor_feature_calculation(ImgGray,input.scale,input.orientation,size(ImgGray,1)); 
        disp('... done.')


    elseif (strncmpi('HoG', FeatureId, 3) == 1)
        disp(['HoG features using ' num2str(input.cellSize) ' as cell-size are being detected'])
        addpath ../../third_party/vlfeat-0.9.16/toolbox/
        vl_setup
        TempGray = vl_hog(im2single(ImgGray),input.cellSize, 'verbose');
        [counts, ~] = imhist(TempGray(:)');
        counts = counts./sum(counts); 
        feature_vector = counts'; 


    elseif (strncmpi('Sift', FeatureId, 4) == 1)
        disp('Sift features are extracted')
        addpath ../../third_party/vlfeat-0.9.16/toolbox/
        vl_setup
        [Centers, Descriptor] = vl_sift(single(ImgGray)); 
        feature_vector = Descriptor; 
        disp('... done.')


    % elseif (strncmpi('DSift', FeatureId, 5) == 1)
    %     disp('Sift features are extracted')
    %     addpath ../../third_party/vlfeat-0.9.16/toolbox/
    %     vl_setup
    %     [Centers, TempDescriptor] = vl_dsift(single(ImgGray));
    %     [counts, ~] = imhist(TempDescriptor(:)); 
    %     feature_vector = Descriptor; 
    %     disp('... done.')

    elseif (strncmpi('Color1', FeatureId, 6) == 1)
        disp(['Color statistics features are extracted, histogram is made using ' num2str(input.nbins) ' bins'])
        addpath tools/Color/ 
        temp1 = clrFeatures(ImgColor, Mask); 
        feature_vector (1:length(temp1)) =  temp1'; 
        [temp2, HistCube, HistVec] = clrHistFeatures (ImgColor, Mask, input.nbins); 
        feature_vector(length(temp1)+1:length(temp1)+(1*input.nbins)) = temp2(1,:)./sum(temp2(1,:)); 
        feature_vector(length(temp1)+(1*input.nbins)+1:length(temp1)+(2*input.nbins)) = temp2(2,:)./sum(temp2(2,:)); 
        feature_vector(length(temp1)+(2*input.nbins)+1:length(temp1)+(3*input.nbins)) = temp2(3,:)./sum(temp2(3,:));


    elseif (strncmpi('Color2', FeatureId, 6) == 1)
        disp(['Angle and Hue histogram of opponent color space are extracted, histogram is made using ' num2str(input.nbins) ' bins'])
        addpath tools/Color/
        [row, col, d] = size(ImgColor); 
        minDim = min(row, col); 
        remind = rem(minDim, 20); 
        ResizeSize = minDim - remind; 
        
        feature_vector = color_descriptor(ImgColor,input.nbins,ResizeSize, input.PSize);


    elseif (strncmpi('wavelet', FeatureId, 7) == 1)
        addpath tools/Wavelet/
        disp(['Wavelet features are extracted with specified parameters - option: ' input.option2 ' color-option: ' input.coloroption ...
            ' levels: ' num2str(input.nlevel) ' RI: ' num2str(input.RI) ' wavelet: ' input.wname])
        feature_vector = ExtractFeatures_wavelet(ImgGray,input.wname, input.RI, input.option2, input.coloroption, input.nlevel); 
        disp('... done.')
    end 





