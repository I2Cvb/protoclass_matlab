%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% segmentation.m
%%% Author: Mojdeh Rastgoo
%%% UB-UdG
%%% Version: 1.0
%%% Two class segmentation og objects within the scence using either
%%% level_set, fuzzy_kmeans, or probablity density districution (pdf-based)
%%% Note: The pdf-based function is specially prepared for melanoma lesions and it should be adjusted depending the application
%%% ---------------------------------------------------
%%% Parameters: 
%%% Img       | image to be segmented 
%%% segId     | 'fcm' (fuzzy-c-mean); 'ls' (level-set); 'pdf' (pdf-based)
%%% colorSpace|  intersted colorSpace (deafult 'z') 
%%%           | possible channels : 'gray', 'x', 'y', 'z', 'r', 'g', 'b',
%%%           | 'l' (from La*b*), 'h', 's' , 'v'
%%%           |
%%% save_path | 'name_of_the_file'; according to the chosen segmentation
%%%           | algorithms results will be saved in different folders
%%% Note : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function segImg = segmentation (Img, segId, varargin)
addpath ../../../third_party/Basic_function/

input.colorSpace = 'z'; 
input.save_path = []; 
input = parseargs(input,varargin{:});

Img = im2double(Img); 

    if (strncmpi('fcm', segId, 3) == 1)
        addpath segmentation-algorithms/fuzzy-c-means/ 
        resPath = 'segmentation_algorithms/fuzzy_c_means/results' ; 
         [ segImg ] = fuzzyCMeansClustering( Img, input.colorSpace);
        
        
    elseif (strncmpi('ls', segId, 2) == 1)
        addpath segmentation-algorithms/level-set/ 
        resPath = 'segmentation_algorithms/level_set/results' ; 
         [ segImg ] = levelSetSegmentation( Img, input.colorSpace );
        
    elseif (strncmpi('pdf', segId, 2) == 1)
        addpath segmentation-algorithms/pdf-based/ 
        resPath = 'segmentation_algorithms/pdf_based/results' ; 
         [ segImg ] = pdfBasedSegmentation( Img, input.colorSpace);
        
    end
    
    
    if (isempty(input.save_path) ~= 0 )
        imwrite(segImg, fullfile(resPath, [input.savepath '.png']) , 'png'); 
        
    end 
    
