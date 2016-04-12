function [edge_vol ] = extract_edge_volume( in_vol, method, varargin)
% EXTRACT_EDGE_VOLUME Function to extract edges from spatial blocks within the images of the
% volume considering different levels of pyramid
%     [ feature_mat_vol ] = extract_edge( in_vol,
%     pyr_num_lev, Method, Threshold) 
%
% Required arguments:
%     in_vol : 3D array
%         Entire volume.
%     Method : string
%         The name of edge detection method {'canny', 'sobel', ....}.
%
% optional arguments : 
%     Threshold: int 
%         default = 0 , if mentioned this value will be used for canny edge
%         detector. 
% Return:
%     feature_vol :  3D array 
%         Entire volume 
%

    % Check if the threshold is specified or not 
    if nargin < 2
      error('extract_edge_volume:NArgInIncorrect', ['The number ' ...
                                'of arguments is incorrect']); 
    end 
    
    % Pre-allocate feature_mat_vol
    edge_vol = zeros( size(in_vol));
    if strcmpi(method, 'canny')
        if nargin ~= 3
            threshold = 0; 
        else 
            threshold = varargin{1}; 
        end
        parfor sl = 1 : size(in_vol, 3)
            if (sl <= size(in_vol, 3))
                edge_vol(sl, :) = extract_canny_image( in_vol(:, :, sl), ...
                                                            threshold) ; 
            end
        end
    else
        error('extract_edge_volume:NotImplemented', ['The method required ' ...
                            'is not implemented']);
    end 

end

function [edge_img ] = extract_canny_image( in_img,threshold)


    % Make the allocation
    edge_img = zeros(size(in_img));  
    
    if threshold == 0 
        edge_img = edge(in_img, 'canny'); 
    else
        edge_img = edge(in_img, 'canny', threshold) ; 
    end 

end


