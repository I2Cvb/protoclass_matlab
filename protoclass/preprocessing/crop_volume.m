function [ out_vol ] = crop_volume( in_vol, method, varargin )
% CROP_VOLUME Function to crop a 3D volume.
%     out_vol = denoising_volume( in_vol, method ) crop the
%     volume using the given method.
%
% Required arguments:
%     in_vol : 3D array
%         Entire volume.
%
%     method : string
%         Method used to crop the volume. Can be any of: 'srinivasan-2014'
%
% 'srinivisan-2014' method:
%     baseline_vol : int
%         Level of the RPE.
%
%     h_over_rpe : int
%         Height to crop above the RPE.
%
%     h_under_rpe : int
%         Height to crop below the RPE.
%
%     width : int
%         Width to crop. The cropping will take place at the
%         center.
%
% Return:
%     out_vol: 3D array 
%         Cropped volume.
%

    % Check that the input is a volume
    if size(size(in_vol)) ~= 3
        error('crop_volume:InputMustBe3D', ['The input matrix ' ...
                            'should be a volume.']);
    end

    if strcmp(method, 'srinivasan-2014')
        % Check that the number of arguments is correct
        if nargin ~= 6
            error('crop_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']);
        end
        % Get the value of sigma
        baseline_vol = varargin{1};
        h_over_rpe = varargin{2};
        h_under_rpe = varargin{3};
        width = varargin{4};
        % Call the appropriate function
        out_vol = crop_volume_srinivasan_2014( in_vol, baseline_vol, h_over_rpe, h_under_rpe, width );
    else
        error('crop_volume:NotImplemented', ['The method required ' ...
                            'is not implemented']);
    end

end

function [ out_vol ] = crop_volume_srinivasan_2014( in_vol, baseline_vol, h_over_rpe, h_under_rpe, width)

    % We will make a parallel processing
    % Pre-allocate the volume
    % Check what is the width to avoid any inconsistance
    if ( width > ( size(in_vol, 2) - 2 ) )
        out_vol = zeros( h_over_rpe + h_under_rpe + 1, ...
                         size(in_vol, 2), ... 
                         size(in_vol, 3) );
    else
        out_vol = zeros( h_over_rpe + h_under_rpe + 1, ...
                         width + 1, ... 
                         size(in_vol, 3) );
    end

    parfor sl = 1 : size(in_vol, 3)
        if (sl <= size(in_vol, 3) ) || ( sl <= lentgh( baseline_vol ) )
            out_vol(:, :, sl) = crop_image_srinivasan_2014( in_vol(:, :, sl), ...
                                            baseline_vol(sl), ...
                                            h_over_rpe, ...
                                            h_under_rpe, ...
                                            width );
        end
    end    

end

function [ out_img ] = crop_image_srinivasan_2014( in_img, baseline_img, h_over_rpe, h_under_rpe, width)

    % Check that the dimension parameters are meaningful
    if ( h_over_rpe < 0 ) || ( h_under_rpe < 0 ) || ( width < 0 ) || ( width > size(in_img, 2) )
        error('crop_volume:CropSizeWrong', ['The dimension given ' ...
                            'to crop the image are inconsistent.']);
    end
    % Check that the dimension allow a cropping
    if ( ( baseline_img - h_over_rpe ) <= 0 ) || ( ( baseline_img + ...
                                                    h_under_rpe ) > ...
                                                  size(in_img, 1) )
        warning('crop_volume:ModifyCropSize', ['The cropping area will not be based on the baseline ' ...
                 'due to cropping area constraints. Everything will ' ...
                 'go smooth.'])
        if ( baseline_img - h_over_rpe ) <= 0
            h_under_rpe = h_over_rpe - baseline_img + h_under_rpe + ...
                1;
            h_over_rpe = baseline_img - 1;
        elseif ( baseline_img + h_under_rpe ) > size(in_img, 1)
            h_over_rpe = h_over_rpe + h_under_rpe - size(in_img, 1) + baseline_img;
            h_under_rpe = size(in_img, 1) - baseline_img;
        end
    end

    % Crop the image
    % To avoid problem of rounding with the center
    if ( width > ( size(in_img, 2) - 2 ) )
        out_img = in_img( baseline_img - h_over_rpe : ...
                          baseline_img + h_under_rpe, ...
                          : );
    else
        % Compute the center in respect to the width
        center_width = floor( size(in_img, 2) / 2. );
        out_img = in_img( baseline_img - h_over_rpe : ...
                          baseline_img + h_under_rpe, ...
                          center_width - floor(width / 2.) : ...
                          center_width + ceil(width / 2.));
    end

end
