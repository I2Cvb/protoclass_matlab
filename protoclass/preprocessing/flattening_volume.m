function [ baseline_vol, warped_vol ] = flattening_volume( in_vol, method, varargin )
% FLATTENING_VOLUME Function to flatten a 3D volume.
%     out_vol = flattening_volume( in_vol, method ) flattens the
%     volume using the method given.
%
% Required arguments:
%     in_vol: 3D array
%         Entire volume.
%
%     method: string
%         Method used to flatten. Can be any of: 'srinivasan-2014',
%         'liu-2011'.
%
% 'srinivasan-2014' method:
%     No arguments to be specified.
%
% 'liu-2011' method:
%     thresh_method: string, optional (default='static')
%         The thresholding method to apply. Can be either:
%         - 'static': static thresholding using thres_val.
%         - 'otsu': threh_val will be determined using otsu.
%
%     gpu_enable: boolean, optional (default=false)
%         Either to run some processing using the GPU.
%
%     thres_val: float, optional (default=.2)
%         Value used to threshold each image. Can be overwritten if
%         ostu is used. The value should be between 0 and 1.
%
%     median_sz: vector of 2 int, optional (default=[5 5])
%         The kernel size used for median filtering.
%
%     se_op: strel, optional (default=(disk, 5))
%         The kernel used in the opening operation.
%
%     se_cl: strel, optional (default=(disk, 35))
%         The kernel used in the closing operation.
%
% Return:
%     out_vol: 3D array
%         Flattened volume.
%
   % Check that the input is a volume
    if size(size(in_vol)) ~= 3
        error('flattening_volume:InputMustBe3D', ['The input matrix should be a volume.']);
    end

    if strcmp(method, 'srinivasan-2014')
        % Check that the number of arguments is correct
        if nargin ~= 2
            error('flattening_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']);
        end
        % Call the appropriate function
        [ baseline_vol, warped_vol ] = flattening_volume_srinivasan_2014( ...
            in_vol );
    elseif strcmp(method, 'liu-2011')
        % Check that at least 2 arguments are given and less than 8
        if nargin < 2 || nargin > 8
            error('flattening_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']);
        elseif nargin == 2
            thres_method = 'static';
            gpu_enable = false;
            thres_val = .2;
            median_sz = [5 5];
            se_op = strel('disk', 5);
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 3
            thres_method = varargin{1};
            gpu_enable = false;
            thres_val = .2;
            median_sz = [5 5];
            se_op = strel('disk', 5);
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 4
            thres_method = varargin{1};
            gpu_enable = varargin{2};
            thres_val = .2;
            median_sz = [5 5];
            se_op = strel('disk', 5);
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 5
            thres_method = varargin{1};
            gpu_enable = varargin{2};
            thres_val = varargin{3};
            median_sz = [5 5];
            se_op = strel('disk', 5);
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 6
            thres_method = varargin{1};
            gpu_enable = varargin{2};
            thres_val = varargin{3};
            median_sz = varargin{4};
            se_op = strel('disk', 5);
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 7
            thres_method = varargin{1};
            gpu_enable = varargin{2};
            thres_val = varargin{3};
            median_sz = varargin{4};
            se_op = varargin{5};
            se_cl = strel('disk', 35);
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        elseif nargin == 8
            thres_method = varargin{1};
            gpu_enable = varargin{2};
            thres_val = varargin{3};
            median_sz = varargin{4};
            se_op = varargin{5};
            se_cl = varargin{6};
            % Call the appropriate function
            [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( ...
                in_vol, thres_method, gpu_enable, thres_val, median_sz, ...
                se_op, se_cl );
        end
    else
        error('flattening_volume:NotImplemented', ['The method required ' ...
                            'is not implemented']);
    end
end


function [ baseline_vol, warped_vol ] = flattening_volume_srinivasan_2014( in_vol )

    % We will make a parallel processing
    % Pre-allocate the volume
    warped_vol = zeros( size(in_vol) );
    baseline_vol = zeros( size(in_vol, 3) );
    parfor sl = 1 : size(in_vol, 3)
        if sl <= size(in_vol, 3)
            [ baseline_vol(sl), warped_vol(:, :, sl) ] = flattening_image_srinivasan_2014( in_vol(:, :, sl) );
        end
    end

end


function [ baseline_y, warped_img ] = flattening_image_srinivasan_2014( in_img )

    % Find the indexes of the first maximum
    [~, idx_max_1] = max( in_img );
    % Temporary put to zeros the first maximum
    sec_im = in_img;
    sec_img(idx_max_1, :) = 0;
    % Find the indexes of the second maximum
    [~, idx_max_2] = max( sec_im );
    % Take the maximum index by column which mean the lowest
    % boundary of the convex hull
    idx = max([idx_max_1; idx_max_2]);
    
    % Compute the best polynom of second degree using RANSAC
    deg_poly = 2;
    min_num = 5;
    iter_num = 1000;
    dist_max = 20;
    poly_f = ransac( 1:size(in_img,2), idx, deg_poly, min_num, iter_num, dist_max );
    point_poly = round( polyval( poly_f, 1:size(in_img,2) ) );

    % Find the minum of the baselin to realign everything
    baseline_y = max(point_poly);

    warped_img = zeros(size(in_img));

    for col_idx = 1:size(in_img, 2)
        % Compute the distance to apply the rolling
        dist_roll = round( baseline_y - point_poly(col_idx) );
        
        % Assign the new column to the warped image
        warped_img(:, col_idx) = circshift( in_img(:, col_idx), ...
                                            dist_roll );
    end    

end


function [ baseline_vol, warped_vol ] = flattening_volume_liu_2011( in_vol, thres_method, gpu_enable, thres_val, median_sz, se_op, se_cl )

    % We need to have uint8 volume for this technique
    if ~isa(in_vol, 'uint8')
        % Convert the data if possible
        if min(in_vol(:)) >= 0 && max((in_vol(:) <= 1))
            in_vol = uint8(in_vol * 256);
        elseif min(in_vol(:)) >= 0 && max((in_vol(:) <= 255))
            in_vol = uint8(in_vol);
        else
            error('flattening_volume_liu_2011:WrongDataType', ['The ' ...
                                'type of data is unknown.']);
        end
    end

    % We will make a parallel processing
    % Pre-allocate the volume
    warped_vol = zeros( size(in_vol) );
    baseline_vol = zeros( size(in_vol, 3) );
    if gpu_enable
        for sl = 1 : size(in_vol, 3)
            if sl <= size(in_vol, 3)
                [ baseline_vol(sl), warped_vol(:, :, sl) ] = ...
                    flattening_image_liu_2011( in_vol(:, :, sl), ...
                                               thres_method, gpu_enable, ...
                                               thres_val, median_sz, ...
                                               se_op, se_cl );
            end
        end
    else
        for sl = 1 : size(in_vol, 3)
            if sl <= size(in_vol, 3)
                [ baseline_vol(sl), warped_vol(:, :, sl) ] = ...
                    flattening_image_liu_2011( in_vol(:, :, sl), ...
                                               thres_method, gpu_enable, ...
                                               thres_val, median_sz, ...
                                               se_op, se_cl );
            end
        end
    end

    % Convert back the data as double
    warped_vol = double(warped_vol) / double(max(warped_vol(:)));

end


function [ baseline_y, warped_img ] = flattening_image_liu_2011( in_img, thres_method, gpu_enable, thres_val, median_sz, se_op, se_cl )

    % Check which technique to apply for thresholding
    if strcmp(thres_method, 'otsu')
        thres_val = graythresh(in_img);
        bw_img = im2bw(in_img, thres_val);
    elseif strcmp(thres_method, 'static')
        bw_img = im2bw(in_img, thres_val);
    else
        error('flattening_image_liu_2011:UnknownMethod', ['The ' ...
                            'thresholding method is unknwon.']);
    end

    % Check if we have to transfer the data to the GPU
    if gpu_enable
        bw_img = gpuArray(bw_img);
    end

    % Apply the median filter to the image
    med_img = medfilt2(bw_img, median_sz);

    % Apply closing
    close_img = imclose(med_img, se_cl);
    % Apply opening
    open_img = imopen(med_img, se_op);

    if gpu_enable
        open_img = gather(open_img);
    end

    % Compute second degree polynomial
    [I J] = find(open_img > 0);
    p = polyfit(J, I, 2);
    point_poly = round( polyval(p, 1:size(open_img, 2)) );

    % Find the minum of the baselin to realign everything
    baseline_y = max(point_poly);

    warped_img = zeros(size(in_img));

    for col_idx = 1:size(in_img, 2)
        % Compute the distance to apply the rolling
        dist_roll = round( baseline_y - point_poly(col_idx) );
        
        % Assign the new column to the warped image
        warped_img(:, col_idx) = circshift( in_img(:, col_idx), ...
                                            dist_roll );
    end    

end