function [ out_vol ] = denoising_volume( in_vol, method, varargin )
% DENOISING_VOLUME Function to denoise a 3D volume.
%     out_vol = denoising_volume( in_vol, method ) denoises the
%     volume using the method given.
%
% Required arguments:
%     in_vol: 3D array
%         Noisy volume.
%
%     method: string
%         Method used to denoise. Can be any of: 'bm3d'
%
% 'bm3d' method:
%     sigma: check the bm3d documentation.
%
% 'nlm' method:
%     kernelratio: int, optional (default 3)
%         Radius of local patch.
%
%     windowratio: int, optional (default 3)
%         Radius of neighbourhood search window.
%
%     filterstrength: float, optional (default 0.05)
%         Strength of the NLMF filtering.
%
%     blocksize : int, optional (default: 150)
%         The image is split in sub-blocks for more efficient memory
%         usage.
%
% Return:
%     out_vol: 3D array
%         Denoised volume.
%

    % Check that the input is a volume
    if size(size(in_vol)) ~= 3
        error('denoising_volume:InputMustBe3D', ['The input matrix ' ...
                            'should be a volume.']);
    end

    if strcmp(method, 'bm3d')
        % Check that you have the right amount of parameters
        if nargin ~= 3
            error('denoising_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']);
        end
        % Get the value of sigma
        sigma = varargin{1};
        % Call the appropriate function
        out_vol = denoising_volume_bm3d( in_vol, sigma );
    elseif strcmp(method, 'nlm')
        % Check the number of arguments
        if (nargin < 2) || (nargin > 6)
            error('denoising_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']);
        elseif nargin == 2
            kernelratio = 3;
            windowratio = 3;
            filterstrength = 0.05;
            blocksize = 150;
            % Call the appropriate function
            out_vol = denoising_volume_nlm( in_vol, kernelratio, windowratio, ...
                                  filterstrength, blocksize);
        elseif nargin == 3
            kernelratio = varargin{1};
            windowratio = 3;
            filterstrength = 0.05;
            blocksize = 150;
            % Call the appropriate function
            out_vol = denoising_volume_nlm( in_vol, kernelratio, windowratio, ...
                                  filterstrength, blocksize);
        elseif nargin == 4
            kernelratio = varargin{1};
            windowratio = varargin{2};
            filterstrength = 0.05;
            blocksize = 150;
            % Call the appropriate function
            out_vol = denoising_volume_nlm( in_vol, kernelratio, windowratio, ...
                                  filterstrength, blocksize);
        elseif nargin == 5
            kernelratio = varargin{1};
            windowratio = varargin{2};
            filterstrength = varargin{3};
            blocksize = 150;
            % Call the appropriate function
            out_vol = denoising_volume_nlm( in_vol, kernelratio, windowratio, ...
                                  filterstrength, blocksize);
        elseif nargin == 6
            kernelratio = varargin{1};
            windowratio = varargin{2};
            filterstrength = varargin{3};
            blocksize = varargin{4};
            % Call the appropriate function
            out_vol = denoising_volume_nlm( in_vol, kernelratio, windowratio, ...
                                  filterstrength, blocksize);
        end
    else
        error('denoising_volume:NotImplemented', ['The method required ' ...
                            'is not implemented']);
    end
end

function [ out_vol ] = denoising_volume_bm3d( in_vol, sigma )

    % Check the input type
    if isfloat( in_vol )
        % Check that the value are between 0. and 1.
        if ( ( max(in_vol(:)) > 1. ) || ( min(in_vol(:)) < 0. ) )
            error('denoising_volume_bm3d:FloatRangeError', ['Volume ' ...
                                'of type float with value out of ' ...
                                'range. Need to scale between 0. and 1.']);
        end
        % Check the value of sigma
        if ( ( sigma > 1. ) || ( sigma < 0. ) )
            error('denoising_volume_bm3d:SigmaNotInRange', ['The ' ...
                                'image data are in the range between ' ...
                                '0.0 and 1.0. sigma need to be in the same range.']);
        else
            % From the BM3D toolbox, sigma need to be scale between
            % 0 and 255
            sigma = 255. * sigma;
        end
    elseif isinteger( in_vol )
        
        % Divide sigma by the maximum value of the image
        sigma = double( sigma );

        % Convert the data to floating number
        in_vol = im2double( in_vol );
    end

    % We will make a parallel processing
    % Pre-allocate the volume
    out_vol = zeros( size(in_vol) );
    parfor sl = 1 : size(in_vol, 3)
        if sl <= size(in_vol, 3)
            out_vol(:, :, sl) = denoising_image_bm3d( in_vol(:, :, sl), sigma );
        end
    end

end

function [ Oimg ] = denoising_image_bm3d( Iimg, sigma )

    % Apply the BM3D filter
    [t, Oimg] = BM3D(1, Iimg, sigma);

end

function [ out_vol ] = denoising_volume_nlm( in_vol, kernelratio, windowratio, filterstrength, blocksize )

    % Check the input type
    if isfloat( in_vol )
        % Check that the value are between 0. and 1.
        if ( ( max(in_vol(:)) > 1. ) || ( min(in_vol(:)) < 0. ) )
            error('denoising_volume_nlm:FloatRangeError', ['Volume ' ...
                                'of type float with value out of ' ...
                                'range. Need to scale between 0. and 1.']);
        end
    elseif isinteger( in_vol )
        
        % Convert the data to floating number
        in_vol = im2double( in_vol );
    end

    % We will make a parallel processing
    % Pre-allocate the volume
    out_vol = zeros( size(in_vol) );
    parfor sl = 1 : size(in_vol, 3)
        if sl <= size(in_vol, 3)
            out_vol(:, :, sl) = denoising_image_nlm( in_vol(:, :, ...
                                                            sl), ...
                                                     kernelratio, ...
                                                     windowratio, ...
                                                     filterstrength, ...
                                                     blocksize );
        end
    end

end

function [ Oimg ] = denoising_image_nlm( Iimg, kernelratio, windowratio, filterstrength, blocksize )

    % Apply the NLM filter
    % Create the optional argument
    options.kernelratio = kernelratio;
    options.windowratio = windowratio;
    options.filterstrength = filterstrength;
    options.blocksize = blocksize;
    Oimg = NLMF(Iimg, options);

end