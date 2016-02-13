% Get the path to the original image
folder_name = uigetdir();

% Check all the jpg file to annotate one by one
content_list = dir(folder_name);

% Create a folder where to store the jpg image
if ~exist('gt', 'dir')
  mkdir('gt');
end

% Annotate each file
for file = 1 : length( content_list )
    % Exclude the directories
    if ( content_list( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( folder_name, content_list( file ).name ) );
        if ( strcmp(info.Format, 'jpg') )
            % Open the image
            im = imread( fullfile( folder_name, content_list( file ).name ) );
            [pathstr,name,ext] = fileparts( fullfile( folder_name, content_list( file ).name ) );
            imshow( im );
            set(gcf,'units','normalized','outerposition',[0 0 1 1])
            % Now this is time to get make the ground truth
            ann = imfreehand(gca);
            % Get the contour position
            contour_pos = ann.getPosition;
            % Create the mask image
            mask_im = poly2mask( contour_pos( :, 1 ), contour_pos( :, 2 ), size( im, 1 ), size( im, 2 ) );
            % Save the image
            imwrite( mask_im, [ folder_name, '/gt/', name, '_mask', '.jpg' ], 'jpg' );
            close all;
        end
    end
end