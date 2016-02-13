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
path_seg = '../images/seg/stapleImages/';

%% Evaluation for the different images

% Get the content of the original folder
content_list = dir(path_seg);
% Annotate each file
for file = 1: length( content_list )
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
         info = imfinfo( fullfile(path_seg , content_list( file ).name));
        if ( strcmp(info.Format, 'png') )
            % Current file to evaluate
            filename = content_list( file ).name
            
            filenameOriginal = [filename(1:end-9) '.jpg']; 
%             OriginalImg = im2double( imread( fullfile( path_org, filenameOriginal ) ) );
%             OriginalImg = mat2gray(rgb2gray(OriginalImg)); 
            
           
            % Read the results of the fuzzy segmentation
            staple_seg = im2double(imread( [ path_seg, filename ] ));
                   
            [FusionSegImg] = FusionSegmentationStaple(staple_seg); 
            
%             figure; subplot(211); imshow(FusionSegImg) ; subplot(212); imshow(OriginalImg)
%             close all ; 
            imwrite( FusionSegImg, [ path_seg 'final/' filename], 'png' );


        end
    end
end

