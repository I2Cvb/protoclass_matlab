%clear all; close all;

% Path to the original images
path_org = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/M_D_B/';
path_result = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/M_D_B/seg/';
% Get the content of the original folder
content_list = dir( path_org );

% Create the directory to save the output image
path_seg = '../images/seg/final/';
if ~exist(path_seg, 'dir')
  mkdir(path_seg);
end

% Annotate each file
for file = 1: length( content_list )-1
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( path_org, content_list( file ).name ) );
        if ( strcmp(info.Format, 'jpg') )
            % Open the image
            filename  = content_list( file ).name  
            filename2 = [filename(1:end-4) '-mask.png']; 
            Img = imread(fullfile(path_seg, filename2)) ; 
           
            imwrite( Img, [path_result, filename2], 'png');
            close all;
        end
    end
end
