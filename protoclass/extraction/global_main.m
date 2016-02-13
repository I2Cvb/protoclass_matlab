%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% feature extraction main function ---> global_main.m
%%% Author: Mojdeh Rastgoo
%%% UB-UdG 
%%% Verison: 1.0 
%%% This version is only applicable for extracting global features not
%%% local features 
%%% However Sift features can be used for local features
%%% Examples : 
%%%    LBP_feature(i,:) = ExtractFeatures(Img,'LBP', 'Mask', Mask); 
%%%    CLBP_feature(i,:) = ExtractFeatures(Img, 'CLBP', 'Mask', Mask); 
%%%    GLCMaO_feature(i,:) = ExtractFeatures(Img, 'GLCMaO', 'Mask', Mask); 
%%%    GLCMaD_feature(i,:) = ExtractFeatures(Img,'GLCMaD','Mask', Mask, 'theta', 45, 'num_levels', 32); 
%%%    Hog_feature(i,:) = ExtractFeatures(Img,'HoG', 'Mask', Mask, 'cellSize', 11);
%%%    sift_feature = ExtractFeatures(Img, 'sift'); 
%%%    color_feature(i,:) = ExtractFeatures(Img, 'Color1', 'Mask', Mask, 'nbins' , 30); 
%%%    color_features2(i,:) = ExtractFeatures(Img, 'Color2', 'Mask', Mask);
%%%    wavelet_features = ExtractFeatures(Img, 'wavelet', 'option2', 'WAL' , 'RI', 0, 'nlevel', 3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Initialization 

    %%%% This is specific to PH2 dataset 
    ImgPath = '/home/mojdeh/Documents/PhD/Coding/Datasets/PH2Dataset/'; 
    resultPath = '/home/mojdeh/Documents/PhD/Coding/Matlab_codes/Classification/M_D_B_PH2/'; 
    name1 = 'PH2_Dataset_images';
    name2 = '_Dermoscopic_Image'; 
    name3 = '_lesion';
    load(fullfile(ImgPath, 'PH2_DataInformation.mat')); 

    data = Data_Sorted; 

    for i = 1 : length(BinaryLabels)
        currFile = Idx_label(i) ; 

        Img = imread(fullfile(ImgPath, name1, cell2mat(data(currFile,1)) ,[cell2mat(data(currFile,1)) name2], ...
            [cell2mat(data(currFile,1)) '.bmp']));
        Mask = imread(fullfile(ImgPath, name1, cell2mat(data(currFile,1)) ,[cell2mat(data(currFile,1)) name3],...
            [cell2mat(data(currFile,1)) '_lesion.bmp']));

        LBP_feature(i,:) = ExtractFeatures_global(Img,'LBP', 'Mask', Mask); 
        CLBP_feature(i,:) = ExtractFeatures_global(Img, 'CLBP', 'Mask', Mask); 
        GLCMaO_feature(i,:) = ExtractFeatures_global(Img, 'GLCMaO', 'Mask', Mask); 
        GLCMaD_feature(i,:) = ExtractFeatures_global(Img,'GLCMaD','Mask', Mask, 'theta', 45, 'num_levels', 32); 
        Hog_feature(i,:) = ExtractFeatures_global(Img,'HoG', 'Mask', Mask, 'cellSize', 11);
        sift_feature = ExtractFeatures_global(Img, 'sift'); 
        color_feature(i,:) = ExtractFeatures_global(Img, 'Color1', 'Mask', Mask, 'nbins' , 30); 
        color_features2(i,:) = ExtractFeatures_global(Img, 'Color2', 'Mask', Mask);
         wavelet_features = ExtractFeatures_global(Img, 'wavelet', 'option2', 'WAL' , 'RI', 0, 'nlevel', 3);

    end 


