function [ feature_mat_vol, Pyr_indexes, feat_desc_dim ] = extract_lbp_volume_sp( in_vol, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, mapping )
% EXTRACT_LBP_VOLUME_SP Function to extract LBP descriptor from a
% volume using a pyramidal and spatial blocks within a pyramids (SP) approach
%     [ feature_mat_vol ] = extract_lbp_volume_sp( in_vol,
%     pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, mapping ) 
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
%     mapping: string
%          Basic LBP : 'none', uniform: 'u2', rotation-invariant = 'ri',
%          uniform-rotation-invariant = 'riu2'
% Return:
%     feature_mat_vol : 2D array 
%         Feature matrix
%     feat_desc_dim : int 
%         Dimension of the lbp feature descriptor (ex. 59 for riu2)
%     Pyr_indexes : 2D array , [nx3]
%         n the number of pyramids , [startingIdx, endingIdx, Pyramidlevel]
%         First and last index in the feature_mat_vol(sl,:) that correspond
%         to the cells extracted from each level of pyramid


    % Check the number of level in the pyramid is meaningful
    if pyr_num_lev < 0
        error('extract_lbp_volume_sp:IncorrectNumPyr', ['The level in ' ...
                            'the pyramid cannot be 0 or less.']);
    end 
    % Compute the size of the descriptor
    feat_dim = 0;
    strIdx = 0 ; 
    endIdx = 0 ; 
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( [ size(in_vol, 1) size(in_vol, 2) ] / factor );

        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize));
        
        strIdx = endIdx +1 ; 
        endIdx = endIdx + numCells; 
        Pyr_indexes = [strIdx, endIdx, lev]; 
        
        
        % Using uniform mapping 
        if strcmpi(mapping , 'u2') 
            feat_desc_dim = ((NumNeighbors * (NumNeighbors - 1)) + 3); 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(mapping , 'riu2') 
            feat_desc_dim = NumNeighbors + 2; 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            
        % Using rotation-invariant mapping 
        elseif strcmpi(mapping , 'ri')
            % The number of features for rotation invariant only are not defined mathematically. 
            if NumNeighbors == 8 
                feat_desc_dim = 36; 
                feat_dim = feat_dim + numCells * feat_desc_dim ; 
            elseif NumNeighbors == 16
                feat_desc_dim = 4116 ; 
                feat_dim = feat_dim + numCells * feat_desc_dim; 
            elseif NumNeighbors == 24 
                feat_desc_dim = 699252; 
                feat_dim = feat_dim + numCells * feat_desc_dim ; 
            end 
        
        % No mapping is used 
        elseif strcmpi(mapping , 'none') == 1 
            feat_desc_dim = 2^NumNeighbors; 
            feat_dim = feat_dim + numCells * feat_desc_dim; 
        end
        
        
    end

    % Pre-allocate feature_mat_vol
    feature_mat_vol = zeros( size(in_vol, 3), feat_dim );

    parfor sl = 1 : size(in_vol, 3)
        if ( sl <= size(in_vol, 3) )
            feature_mat_vol(sl, :) = extract_lbp_image_sp( in_vol(:, :, sl), ...
                                                        pyr_num_lev, ...
                                                        NumNeighbors, ...
                                                        Radius, ...
                                                        CellSize, ...
                                                        MODE, mapping);
        end
    end    

end

function [ feature_vec_img ] = extract_lbp_image_sp( in_img, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, mapping )

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
        if strcmpi(mapping , 'u2') 
            feat_desc_dim = ((NumNeighbors * (NumNeighbors - 1)) + 3); 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            % Loading the appropriate map
            load(['Map_'  num2str(NumNeighbors) '_' mapping '.mat']); 
            
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(mapping , 'riu2') 
            feat_desc_dim = NumNeighbors + 2; 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            % Loading the appropriate map
            load(['Map_' num2str(NumNeighbors) '_' mapping '.mat'])
        
        % Using rotation-invariant mapping 
        elseif strcmpi(mapping , 'ri') 
            % The number of features for rotation invariant only are not defined mathematically. 
            if NumNeighbors == 8 
                feat_desc_dim = 36; 
                feat_dim = feat_dim + numCells * feat_desc_dim ; 
            elseif NumNeighbors == 16
                feat_desc_dim = 4116 ; 
                feat_dim = feat_dim + numCells * feat_desc_dim ; 
            elseif NumNeighbors == 24 
                feat_desc_dim = 699252; 
                feat_dim = feat_dim + numCells * feat_desc_dim ; 
            end 
            % Loading the appropriate mapping
            load(['Map_' num2str(NumNeighbors) '_' mapping '.mat']); 
        
        % No mapping is used 
        elseif strcmpi(mapping , 'none') 
            feat_desc_dim = 2^NumNeighbors; 
            feat_dim = feat_dim + numCells * feat_desc_dim; 
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
        % Total number of cells in the image 
        numCells = prod(floor(size(im_rsz) ./ CellSize));
        % Make the allocation 
        feature_vec_img_lev = zeros(1, numCells * feat_desc_dim); 
       
        % Extracting the spatial blockes based on cellsize  
        % bloclproc is not used because it returns all the blocks even the
        % partial blocks smaller than the specified size on the border 
        
        % Starting indexes of cells in y  
        ystrIdx = 1: CellSize(1,2) : size(im_rsz,2); 
        if rem(size(im_rsz, 2), CellSize) ~= 0 
            ystrIdx(end) = []; 
        end 
        % Ending indexes for cells in y 
        yendIdx = CellSize(1,2): CellSize(1,2): size(im_rsz, 2); 
        
        % Starting indexes for cells in x
        xstrIdx = 1: CellSize(1,1): size(im_rsz, 1); 
        if rem(size(im_rsz, 1), CellSize(1,1)) ~= 0 
            xstrIdx(end) = []; 
        end 
        % Ending indexes for cells in x 
        xendIdx = CellSize(1,1): CellSize(1,1) : size(im_rsz, 1); 
        
        % Creating a meshgird 
        [X, Y] = meshgrid(1: length(xendIdx), 1: length(yendIdx)); 
        X = X(:); Y = Y(:); 
        
        for sbId = 1 : length(X)
            im_rsz_sb = im_rsz(xstrIdx(X(sbId)): xendIdx(X(sbId)), ystrIdx(Y(sbId)): yendIdx(Y(sbId))); 
            
            % Compute the LBP feature
            feature_vec_img_lev(((sbId-1)*feat_desc_dim)+1 : sbId * feat_desc_dim)  = lbp(im_rsz_sb, Radius, NumNeighbors, Map, MODE );
        end  
        feature_vec_img( cum_feat_dim(lev) + 1 : cum_feat_dim(lev + 1) )  = feature_vec_img_lev; 
        
    end

end


