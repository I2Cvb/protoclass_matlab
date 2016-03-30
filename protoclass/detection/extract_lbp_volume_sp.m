function [ feature_mat_vol ] = extract_lbp_volume_sp( in_vol, pyr_num_lev, NumNeighbors, Radius, CellSize,MODE )
% EXTRACT_LBP_VOLUME_SP Function to extract LBP descriptor from a
% volume using a pyramidal and spatial blocks within a pyramids (SP) approach
%     [ feature_mat_vol ] = extract_lbp_volume_sp( in_vol,
%     pyr_num_lev, NumNeighbors, Radius, CellSize, Mapping, MODE ) 
%
% Required arguments:
%     in_vol : 3D array
%         Entire volume.
%
%     pyr_num_lev : int
%         The number of level in the pyramid.
%
%     NumNeighbors : int
%         Number of neighbors.
%
%     Radius : int
%         Radius of circular pattern to select neighbors.
%
%     CellSize : vector
%          Cell size.
%   
%     MODE: string 
%          histogram ('h') , normalized histogram ('nh') 
%
%     Mapping: string
%          Basic LBP : 'none', uniform: 'u2', rotation-invariant = 'ri',
%          uniform-rotation-invariant = 'riu2'
% Return:
%     feature_mat_vol : 2D array 
%         Feature matrix
%


    % Check the number of level in the pyramid is meaningful
    if pyr_num_lev < 0
        error('extract_lbp_volume:IncorrectNumPyr', ['The level in ' ...
                            'the pyramid cannot be 0 or less.']);
    end 
    % Compute the size of the descriptor
    feat_dim = 0;
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( [ size(in_vol, 1) size(in_vol, 2) ] / factor );

        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize));
        
        % Using uniform mapping 
        if strcmpi(Mapping , 'u2') == 1
            feat_dim = feat_dim + numCells * ((NumNeighbors * (NumNeighbors ...
                                                              - 1)) + 3);
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(Mapping , 'riu2') == 1
            feat_dim = feat_dim + numCells * (NumNeighbors + 2);
        
        % Using rotation-invariant mapping 
        elseif strcmpi(Mapping , 'ri') == 1
            % The number of features for rotation invariant only are not defined mathematically. 
            if NumNeighbors == 8 
                feat_dim = feat_dim + 36 ; 
            elseif NumNeighbors == 16
                feat_dim = feat_dim + 4116; 
            elseif NumNeighbors == 24 
                % Not complete yet !! 
                feat_dim = feat_dim ; 
            end 
        
        % No mapping is used 
        elseif strcmpi(Mapping , 'none') == 1 
            feat_dim = feat_dim + numCells*(2^NumNeighbors); 
        end
    end

    % Pre-allocate feature_mat_vol
    feature_mat_vol = zeros( size(in_vol, 3), feat_dim );

    for sl = 1 : size(in_vol, 3)
        if ( sl <= size(in_vol, 3) )
            feature_mat_vol(sl, :) = extract_lbp_image_sp( in_vol(:, :, sl), ...
                                                        pyr_num_lev, ...
                                                        NumNeighbors, ...
                                                        Radius, ...
                                                        CellSize, ...
                                                        MODE, Mapping, feat_dim);
        end
    end    

end

function [ feature_vec_img ] = extract_lbp_image_sp( in_img, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, Mapping )

    % Compute the size of the descriptor to make pre-allocation to
    % speed-up
    feat_dim = [];
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( size(in_img) / factor );
       
        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize));

        % Using uniform mapping 
        if strcmpi(Mapping , 'u2') == 1
            feat_dim = feat_dim + numCells * ((NumNeighbors * (NumNeighbors ...
                                                              - 1)) + 3);
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(Mapping , 'riu2') == 1
            feat_dim = feat_dim + numCells * (NumNeighbors + 2);
        
        % Using rotation-invariant mapping 
        elseif strcmpi(Mapping , 'ri') == 1
            % The number of features for rotation invariant only are not defined mathematically. 
            if NumNeighbors == 8 
                feat_dim = feat_dim + 36 ; 
            elseif NumNeighbors == 16
                feat_dim = feat_dim + 4116; 
            elseif NumNeighbors == 24 
                % Not complete yet !! 
                feat_dim = feat_dim ; 
            end 
        
        % No mapping is used 
        elseif strcmpi(Mapping , 'none') == 1 
            feat_dim = feat_dim + numCells*(2^NumNeighbors); 
        end
    end
%%% Up to here 
    % Make the allocation
    feature_vec_img = zeros( 1, sum(feat_dim) );
    cum_feat_dim = [ 0 cumsum( feat_dim ) ];

    for lev = 1:pyr_num_lev
        % Downsize if necessary
        im_rsz = in_img;
        if ( lev > 1 )
            for rsz = 1:lev-1
                im_rsz = impyramid(im_rsz, 'reduce');
            end
        end
        % Compute the LBP feature
        feature_vec_img( cum_feat_dim(lev) + 1 : cum_feat_dim(lev + 1) ) = ...
            lbp(im_rsz, 'NumNeighbors', NumNeighbors, ...
                               'Radius', Radius, 'CellSize', CellSize, ...
                               'Upright', Upright);

    end

end


