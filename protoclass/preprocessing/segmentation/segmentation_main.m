%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% segmentation_main.m
%%% Author: Mojdeh Rastgoo
%%% UB-UdG
%%% Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Segmentation 


%%% Initialization and indication of datapath
% Path to the original images
path_org = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/M_D_B/';
% Get the content of the original folder
content_list = dir( path_org );

%%% indication of segmentation id 
segId  = 'ls'; 

% Annotate each file
for file = 1:length( content_list )-1
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( path_org, content_list( file ).name ) );
        if ( strcmp(info.Format, 'jpg') )
            % Open the image
            disp( [segId  ' segmentation of image ', content_list( file ).name ] );
            im = im2double( imread( fullfile( path_org, content_list( file ).name ) ) );
            [pathstr,name,ext] = fileparts( fullfile( path_org, content_list( file ).name ) );
            segImg = segmentation (im, segId, 'save_path', [name '-mask']); 

        end
    end
end



%% Evaluation 
addpath ../../validation
%%% Initialization and indication of datapaths
path_gt = 'gt/';
path_seg = 'segmentation_algorithms/'; 

%%% This is an example fo evaluation of segmentation provided by three
%%% algorithm 


% Get the content of the original folder
content_list = dir(path_gt);



% Annotate each file
for file = 1 : length( content_list )
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( path_gt, content_list( file ).name ) );
        if ( strcmp(info.Format, 'png') )
            % Current file to evaluate
            filename = content_list( file ).name;
            
            % reading GT 
            GT_img = imread(fullfile(path_gt, filename)); 
            % reading the fcm results 
            fuzzy_seg = imread(fullfile(path_seg, 'fuzzy_c_means/results', filename)); 
            % reading the ls results 
            LS_seg = imread(fullfile(path_seg, 'level_set/results', filename)); 
            % reading the pdf-based results 
            pdf_seg = imread(fullfile(path_seg, 'pdf_based/results', filename)); 
            
            

            % Make the evaluation for this image
            disp( [ 'Evaluation of ', filename, ' - Fuzzy C-Means vs. GT' ] );
            fuzzy_stat = segmentation_evaluation( fuzzy_seg, GT_img );
            pause;
            disp( [ 'Evaluation of ', filename, ' - Level Set vs. GT' ] );
            LS_stat= segmentation_evaluation( fuzzy_seg, GT_img );
            pause;
            disp( [ 'Evaluation of ', filename, ' - pdf-based vs. GT' ] );
            pdf_based_stat= segmentation_evaluation( fuzzy_seg, GT_img );
            pause;
      
        end
    end
end
