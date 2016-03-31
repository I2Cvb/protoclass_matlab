function [ feature_mat_vol ] = extract_lbp_volume_mssp( in_vol, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, Mapping )
% EXTRACT_LBP_VOLUME_MSSP Function to extract LBP descriptor from a
% volume using a pyramidal and spatial blocks within a pyramids (SP) approach
% MSSP method in comparison to SP method extract spatial blocks from the
% image and also from the intersections of the blocks
%     [ feature_mat_vol ] = extract_lbp_volume_mssp( in_vol,
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
        numCells = prod(floor(im_sz ./ CellSize)) + prod((floor(im_sz./CellSize) -1));
        
        % Using uniform mapping 
        if strcmpi(Mapping , 'u2') 
            feat_dim = feat_dim + numCells * ((NumNeighbors * (NumNeighbors ...
                                                              - 1)) + 3);
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(Mapping , 'riu2') 
            feat_dim = feat_dim + numCells * (NumNeighbors + 2);
        
        % Using rotation-invariant mapping 
        elseif strcmpi(Mapping , 'ri')
            % The number of features for rotation invariant only are not defined mathematically. 
            if NumNeighbors == 8 
                feat_dim = feat_dim + numCells *  36 ; 
            elseif NumNeighbors == 16
                feat_dim = feat_dim + numCells * 4116; 
            elseif NumNeighbors == 24 
                feat_dim = feat_dim + numCells * 699252; 
            end 
        
        % No mapping is used 
        elseif strcmpi(Mapping , 'none') == 1 
            feat_dim = feat_dim + numCells*(2^NumNeighbors); 
        end
    end

    % Pre-allocate feature_mat_vol
    feature_mat_vol = zeros( size(in_vol, 3), feat_dim );

    parfor sl = 1 : size(in_vol, 3)
        if ( sl <= size(in_vol, 3) )
            feature_mat_vol(sl, :) = extract_lbp_image_mssp( in_vol(:, :, sl), ...
                                                        pyr_num_lev, ...
                                                        NumNeighbors, ...
                                                        Radius, ...
                                                        CellSize, ...
                                                        MODE, Mapping);
        end
    end    

end

function [ feature_vec_img ] = extract_lbp_image_mssp( in_img, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, Mapping )

    % Compute the size of the descriptor to make pre-allocation to
    % speed-up
    feat_dim = [];
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( size(in_img) / factor );
       
        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize)) + prod((floor(im_sz./CellSize) - 1));

        % Using uniform mapping 
        if strcmpi(Mapping , 'u2') 
            feat_desc_dim = ((NumNeighbors * (NumNeighbors - 1)) + 3); 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            % Loading the appropriate map
            load(['Map_'  num2str(NumNeighbors) '_' Mapping '.mat']); 
            
        % Using uniform and rotation-invariant mapping 
        elseif strcmpi(Mapping , 'riu2') 
            feat_desc_dim = NumNeighbors + 2; 
            feat_dim = feat_dim + numCells * feat_desc_dim;
            % Loading the appropriate map
            load(['Map_' num2str(NumNeighbors) '_' Mapping '.mat'])
        
        % Using rotation-invariant mapping 
        elseif strcmpi(Mapping , 'ri') 
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
            % Loading the appropriate mapping
            load(['Map_' num2str(NumNeighbors) '_' Mapping '.mat']); 
        
        % No mapping is used 
        elseif strcmpi(Mapping , 'none') 
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
        numCells = prod(floor(size(im_rsz) ./ CellSize)) + prod((floor(size(im_rsz) ./ CellSize))-1);
        
        % Make the allocation 
        feature_vec_img_lev = zeros(1, numCells * feat_desc_dim); 
       
        % Extracting the spatial blockes based on cellsize  
        % bloclproc is not used because it returns all the blocks even the
        % partial blocks smaller than the specified size on the border 
        
        %%% ---- Indexes for spatial non-overlapping blocks  
        % Starting indexes of cells in y
        ystrIdx = []; 
        yendIdx = []; 
        ystrIdx_nol_sb = 1: CellSize(1,2) : size(im_rsz,2); 
        if rem(size(im_rsz, 2), CellSize(1,2)) ~= 0 
            ystrIdx_nol_sb(end) = []; 
        end
        ystrIdx = [ystrIdx , ystrIdx_nol_sb];
        
        % Ending indexes for cells in y
        yendIdx_nol_sb = CellSize(1,2): CellSize(1,2): size(im_rsz, 2); 
        yendIdx= [yendIdx, yendIdx_nol_sb]; 
        
        % Starting indexes for cells in x
        xstrIdx = []; 
        xendIdx = []; 
        xstrIdx_nol_sb = 1: CellSize(1,1): size(im_rsz, 1); 
        if rem(size(im_rsz, 1), CellSize(1,1)) ~= 0 
            xstrIdx_nol_sb(end) = []; 
        end 
        xstrIdx = [xstrIdx, xstrIdx_nol_sb]; 
        % Ending indexes for cells in x 
        xendIdx_nol_sb = CellSize(1,1): CellSize(1,1) : size(im_rsz, 1); 
        xendIdx = [xendIdx, xendIdx_nol_sb]; 

        % In case of a large CellSize there wont be intersections and
        % therefore no overlapping window
        if prod((floor(size(im_rsz) ./ CellSize))-1) ~= 0 
        
        %%% ---- Indexes for over-lapping blocks
        % StartingIdx y 
        ystrIdx_ol_sb = ystrIdx_nol_sb(1:end-1) + floor(CellSize(1,2)/2); 
        ystrIdx = [ystrIdx, ystrIdx_ol_sb]; 
        % EndingIdx y 
        yendIdx_ol_sb = yendIdx_nol_sb(1:end-1) + floor(CellSize(1,2)/2); 
        yendIdx = [yendIdx, yendIdx_ol_sb]; 
        
        % StartingIdx x
        xstrIdx_ol_sb = xstrIdx_nol_sb(1:end-1) + floor(CellSize(1,1)/2); 
        xstrIdx = [xstrIdx, xstrIdx_ol_sb]; 
        % EndingIdx x 
        xendIdx_ol_sb = xendIdx_nol_sb(1:end-1) + floor(CellSize(1,1))/2; 
        xendIdx = [xendIdx, xendIdx_ol_sb]; 
        end 
        
        % Creating a meshgird 
        [X, Y] = meshgrid(1: length(xendIdx), 1: length(yendIdx)); 
        X = X(:); Y = Y(:); 
        
        for sbId = 1 : length(X)
            im_rsz_sb = im_rsz(xstrIdx(X(sbId)): xendIdx(X(sbId)), ystrIdx(X(sbId)): yendIdx(X(sbId))); 
            
            % Compute the LBP feature
            feature_vec_img_lev(((sbId-1)*feat_desc_dim)+1 : sbId * feat_desc_dim )  = lbp(im_rsz_sb,  Radius,  NumNeighbors, Map,MODE );
        end  
        
        feature_vec_img( cum_feat_dim(lev) + 1 : cum_feat_dim(lev + 1) )  = feature_vec_img_lev; 
        
    end

end

