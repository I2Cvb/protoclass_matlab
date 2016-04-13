function [ feature_mat_vol, pyr_info, feat_desc_dim ] = extract_lbp_volume_mssp( in_vol, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, mapping )
% EXTRACT_LBP_VOLUME_MSSP Function to extract LBP descriptor from a
% volume using a pyramidal and spatial blocks within a pyramids (SP) approach
% MSSP method in comparison to SP method extract spatial blocks from the
% image and also from the intersections of the blocks
%     [ feature_mat_vol ] = extract_lbp_volume_mssp( in_vol,
%     pyr_num_lev, NumNeighbors, Radius, CellSize, mapping, MODE ) 
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
% 
%     pyr_info : 2D array, [nx3] 
%         n the number of pyramids , [startingIdx, endingIdx, Pyramidlevel]
%         First and last index in the feature_mat_vol(sl,:) that correspond
%         to the cells extracted from each level of pyramid
% 
%     feat_desc_dim : 1D 
%         Dimension of the lbp feature descriptor (ex. 59 for rotation invariant and uniform lbp)
%


    % Check the number of level in the pyramid is meaningful
    if pyr_num_lev < 0
        error('extract_lbp_volume_mssp:IncorrectNumPyr', ['The level in ' ...
                            'the pyramid cannot be 0 or less.']);
    end 
    % Compute the size of the descriptor
    feat_dim = 0;
    strIdx = 0 ; 
    endIdx = 0 ; 
    pyr_info = []; 
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( [ size(in_vol, 1) size(in_vol, 2) ] / factor );

        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize)) + prod((floor(im_sz./CellSize) -1));

        
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

        strIdx = endIdx +1 ;
        endIdx = endIdx + numCells*feat_desc_dim;
        pyr_info = [pyr_info ; [strIdx, endIdx, lev+1, numCells]];


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
                                                        MODE, mapping);
        end
    end    

end

function [ feature_vec_img ] = extract_lbp_image_mssp( in_img, pyr_num_lev, NumNeighbors, Radius, CellSize, MODE, mapping )

    % Compute the size of the descriptor to make pre-allocation to
    % speed-up
    feat_dim = 0;
    for lev = 0:pyr_num_lev - 1
        % Compute the factor of reduction to apply on the size of
        % the image
        factor = 2 ^ lev;
        im_sz = ceil( size(in_img) / factor );
       
        % Compute the number of cell
        numCells = prod(floor(im_sz ./ CellSize)) + prod(floor(im_sz./CellSize) - 1);
        
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
                feat_dim = feat_dim + numCells * feat_desc_dim; 
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
            Map = 0;
        end
    end
    
    % Make the allocation
    feature_vec_img = [];
     
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
        %feature_vec_lev = zeros(1, numCells * feat_desc_dim); 
        feature_vec_lev = [] ; 
        
        % Extracting the spatial blockes based on cellsize  
        % bloclproc is not used because it returns all the blocks even the
        % partial blocks smaller than the specified size on the border         

        %%% ---- Indexes for spatial non-overlapping blocks  
        % Starting indexes of cells in y
   
        ystrIdx_nol_sb = 1: CellSize(1,2) : size(im_rsz,2); 
        if rem(size(im_rsz, 2), CellSize(1,2)) ~= 0 
            ystrIdx_nol_sb(end) = []; 
        end
        
        % Ending indexes for cells in y
        yendIdx_nol_sb = CellSize(1,2): CellSize(1,2): size(im_rsz, 2); 
        
        % Starting indexes for cells in x
        xstrIdx_nol_sb = 1: CellSize(1,1): size(im_rsz, 1); 
        if rem(size(im_rsz, 1), CellSize(1,1)) ~= 0 
            xstrIdx_nol_sb(end) = []; 
        end 
        % Ending indexes for cells in x 
        xendIdx_nol_sb = CellSize(1,1): CellSize(1,1) : size(im_rsz, 1); 
  
        % non-overlapping
        [X_nol, Y_nol] = meshgrid(1: length(xendIdx_nol_sb), 1: length(yendIdx_nol_sb)); 
        X_nol = X_nol(:); Y_nol = Y_nol(:); 
    
        for sbId = 1 : length(X_nol)
            im_rsz_sb = im_rsz(xstrIdx_nol_sb(X_nol(sbId)): xendIdx_nol_sb(X_nol(sbId)), ystrIdx_nol_sb(Y_nol(sbId)): yendIdx_nol_sb(Y_nol(sbId))); 
            
            % Compute the LBP feature
            tem = lbp(im_rsz_sb, Radius, NumNeighbors, Map, MODE);
            feature_vec_lev = [feature_vec_lev, tem]; 
        end  

       
        % In case of a large CellSize there wont be intersections and
        % therefore no overlapping window
        if prod((floor(size(im_rsz) ./ CellSize))-1) ~= 0 
        
            %%% ---- Indexes for over-lapping blocks
            % StartingIdx y 
            ystrIdx_ol_sb = ystrIdx_nol_sb(1:end-1) + floor(CellSize(1,2)/2); 
            % EndingIdx y 
            yendIdx_ol_sb = yendIdx_nol_sb(1:end-1) + floor(CellSize(1,2)/2); 
        
            % StartingIdx x
            xstrIdx_ol_sb = xstrIdx_nol_sb(1:end-1) + floor(CellSize(1,1)/2); 
            % EndingIdx x 
            xendIdx_ol_sb = xendIdx_nol_sb(1:end-1) + floor(CellSize(1,1))/2; 
  
            % overlapping 
            [X_ol, Y_ol] = meshgrid(1: length(xendIdx_ol_sb), 1: length(yendIdx_ol_sb)); 
            X_ol = X_ol(:); Y_ol = Y_ol(:); 
       
            for sbId = 1 : length(X_ol)
                im_rsz_sb = im_rsz(xstrIdx_ol_sb(X_ol(sbId)): xendIdx_ol_sb(X_ol(sbId)), ystrIdx_ol_sb(Y_ol(sbId)): yendIdx_ol_sb(Y_ol(sbId))); 
            
                % Compute the LBP feature
                tem = lbp(im_rsz_sb,  Radius, NumNeighbors, Map, MODE);
                feature_vec_lev = [feature_vec_lev, tem]; 
            end          
        
        end 
         
        feature_vec_img = [feature_vec_img, feature_vec_lev];        
         
    end

end


