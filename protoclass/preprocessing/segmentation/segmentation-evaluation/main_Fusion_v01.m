%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: main.m
%%% Description: 
%%% Author: Guillaume Lemaitre - Mojdeh Rastgoo 
%%% LE2I - ViCOROB
%%% Date: 10 February 2014
%%% Version: 0.1
%%% Copyright (c) 2014 Guillaume Lemaitre
%%% http://le2i.cnrs.fr/ - http://vicorob.udg.es/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Organizing the images, 
addpath ../../../Basic_function/
path_csv = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/Clin_Diag_2.csv' ; 
path_org = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/M_D_B/';
Data = csv2cell(path_csv, 'fromfile') ; 

path_image = '../images/original/' ; 

%% Paths
path_seg = '../images/seg/';

%% Evaluation for the different images

% Get the content of the original folder
content_list = dir( [ path_seg, 'fuzzy_c_mean/'] );
% Annotate each file
for file = 1: length( content_list )
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
         info = imfinfo( fullfile( [ path_seg, 'fuzzy_c_mean/'], content_list( file ).name ) );
        if ( strcmp(info.Format, 'png') )
            % Current file to evaluate
            filename = content_list( file ).name
            
            filenameOriginal = [filename(1:end-9) '.jpg']; 
            OriginalImg = im2double( imread( fullfile( path_org, filenameOriginal ) ) );
            OriginalImg = mat2gray(rgb2gray(OriginalImg)); 
            
           
            % Read the results of the fuzzy segmentation
            fuzzy_seg = imread( [ path_seg, 'fuzzy_c_mean/', filename ] );
            
            % Read the results of the level-set segmentation
            levelset_seg = imread( [ path_seg, 'level_set/', filename ] );

            % Read the results of pdf segmentation1
            pdf_seg = imread( [ path_seg, 'pdf_based/', filename ] );
            
            % Read the results of the pdf segmentation2
            pdf_seg2 = imread( [ path_seg, 'pdf_based2/', filename ] );
            
            [FusionSegImg] = FusionSegmentation( fuzzy_seg, levelset_seg, pdf_seg, pdf_seg2); 
            
            figure; subplot(321); imshow(FusionSegImg) ; subplot(322); imshow(OriginalImg)
            subplot(323) ; imshow(fuzzy_seg) ; subplot(324) ; imshow(levelset_seg); 
            subplot(325); imshow(pdf_seg) ; subplot(326) ; imshow(pdf_seg2); 
%             pause; 
            close all ; 
            imwrite( FusionSegImg, [ path_seg 'final/' filename], 'png' );


        end
    end
end

