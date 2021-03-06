function [ feature_mat_vol ] = extract_lbp_volume_p( in_vol, pyr_num_lev, NumNeighbors, Radius, CellSize, Upright )
% EXTRACT_LBP_VOLUME_P Function to extract LBP descriptor from a
% volume using a pyramidal (p) approach
%     [ feature_mat_vol ] = extract_lbp_volume( in_vol,
%     pyr_num_lev, NumNeighbors, Radius, CellSize, Upright ) 
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
%     Upright : bool
%          Rotation invariant flag.
%
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
        if Upright == true
            feat_dim = feat_dim + numCells * ((NumNeighbors * (NumNeighbors ...
                                                              - 1)) + 3);
        else
            feat_dim = feat_dim + numCells * (NumNeighbors + 2);
        end
    end

    % Pre-allocate feature_mat_vol
    feature_mat_vol = zeros( size(in_vol, 3), feat_dim );

    parfor sl = 1 : size(in_vol, 3)
        if ( sl <= size(in_vol, 3) )
            feature_mat_vol(sl, :) = extract_lbp_image( in_vol(:, :, sl), ...
                                                        pyr_num_lev, ...
                                                        NumNeighbors, ...
                                                        Radius, ...
                                                        CellSize, ...
                                                        Upright );
        end
    end    

end

function [ feature_vec_img ] = extract_lbp_image( in_img, pyr_num_lev, NumNeighbors, Radius, CellSize, Upright )

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
        if Upright == true
            feat_dim = [ feat_dim, numCells * ((NumNeighbors * (NumNeighbors ...
                                                              - 1)) + 3) ];
        else
            feat_dim = [ feat_dim, numCells * (NumNeighbors + 2) ];
        end
    end

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
            extractLBPFeatures(im_rsz, 'NumNeighbors', NumNeighbors, ...
                               'Radius', Radius, 'CellSize', CellSize, ...
                               'Upright', Upright);

    end

end


