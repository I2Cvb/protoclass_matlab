%clear all; close all;

% Path to the original images
path_org = '/home/mojdeh/Documents/PhD/Coding/Datasets/Vienna_Central_Hospital/M_D_B/';
% Get the content of the original folder
content_list = dir( path_org );

% Create the directory to save the output image
path_seg = '../../images/seg/level-set/';
if ~exist(path_seg, 'dir')
  mkdir(path_seg);
end

% Annotate each file
for file = 4459 : length( content_list )
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( path_org, content_list( file ).name ) );
        if ( strcmp(info.Format, 'jpg') )
            % Open the image
            disp( [ 'Level-set segmentation of image ', content_list( file ).name ] );
            im = im2double( imread( fullfile( path_org, content_list( file ).name ) ) );
            [pathstr,name,ext] = fileparts( fullfile( path_org, content_list( file ).name ) );
            % Segment the image using fuzzy C-means
            [ segImg ] = levelSetSegmentation( im );
            % Save the image
            imwrite( segImg, [ path_seg, name, '_mask', '.png' ], 'png' );
            close all;
        end
    end
end
