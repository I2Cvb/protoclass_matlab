function [edge_vol ] = extract_edge_volume( in_vol, Method, Threshold)
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
%     Threshold: int 
%         default = 0 , if mentioned this value will be used for canny edge
%         detector. 
% Return:
%     feature_vol :  3D array 
%         Entire volume 
%

    % Check if the threshold is specified or not 
    if nargin <= 2
        Threshold = 0 ;
    elseif nargin == 1 
        if exits ('in_vol')
            Method = 'canny' ; 
        else
            error ('not enough input'); 
        end 
    end 
    
    % Pre-allocate feature_mat_vol
    edge_vol = zeros( size(in_vol));
    if strcmpi(Method, 'canny')
        parfor sl = 1 : size(in_vol, 3)
            if ( sl <= size(in_vol, 3) )
                edge_vol(sl, :) = extract_canny_image( in_vol(:, :, sl), ...
                                                            Threshold) ; 
            end
        end
    elseif strcmpi(Method, 'others')
        disp('under construction'); 
    end 

end

function [edge_img ] = extract_canny_image( in_img,Threshold)


    % Make the allocation
    edge_img = zeros(size(in_img));  
    
    if Threshold ==0 
        edge_img = edge(in_img, 'canny'); 
    else
        edge_img = edge(in_img, 'canny', Threshold) ; 
    end 

end


