function test_mssp
in_img = ones(500, 1000); 
blocks = mssp( in_img, 3, [40,40]);
figure; imshow(blocks{1}); figure; imshow(blocks{2}); figure; imshow(blocks{3}); 
blocks = mssp( in_img, 3, [70,70]);
figure; imshow(blocks{1}); figure; imshow(blocks{2}); figure; imshow(blocks{3}); 
blocks = mssp( in_img, 3, [100,100]);
figure; imshow(blocks{1}); figure; imshow(blocks{2}); figure; imshow(blocks{3}); 
end 



function [ img_blocks ] = mssp( in_img, pyr_num_lev, CellSize)
% TEST_MSSP Function to test the spacial block extraction form a given
% image 
%
% Required arguments:
%     in_im : 2D array
%         Entire volume.
%
%     pyr_num_lev : int
%         The number of level in the pyramid.
%
%     CellSize : vector
%          Cell size.
%   
% Return:
%     im_block : structure 
%        each element contains a vision of pyramid level with its
%        subsblocks

    % Check the number of level in the pyramid is meaningful
    if pyr_num_lev < 0
        error('mssp:IncorrectNumPyr', ['The level in ' ...
                            'the pyramid cannot be 0 or less.']);
    end 
 
    % Compute the size of the descriptor to make pre-allocation to
    % speed-up
   

    % Make the allocation
%     feature_vec_img = zeros( 1, sum(feat_dim) );  
%     cum_feat_dim = [ 0 cumsum( feat_dim ) ];

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
        
        % Creating a meshgird  with non-overlapping blocks 
        [X, Y] = meshgrid(1: length(xendIdx_nol_sb), 1: length(yendIdx_nol_sb)); 
        X = X(:); Y = Y(:); 
        rectangle_Info = []; 
        for sbId = 1 : length(X)
            im_rsz_sb = im_rsz(floor(xstrIdx_nol_sb(X(sbId))): floor(xendIdx_nol_sb(X(sbId))), floor(ystrIdx_nol_sb(Y(sbId))): floor(yendIdx_nol_sb(Y(sbId)))); 
            rectangle_Info = [rectangle_Info; ystrIdx_nol_sb(Y(sbId)), xstrIdx_nol_sb(X(sbId)), CellSize]; 
        end  
        
        RGB = insertShape( im_rsz, 'Rectangle', rectangle_Info, 'LineWidth', 2) ; 
        
        if prod((floor(size(im_rsz) ./ CellSize))-1) ~= 0 
            % Creating a meshgird  with overlapping blocks 
            clear X Y 
            [X, Y] = meshgrid(1: length(xendIdx_ol_sb), 1: length(yendIdx_ol_sb)); 
            X = X(:); Y = Y(:); 
            rectangle_Info = []; 
            for sbId = 1 : length(X)
                im_rsz_sb = im_rsz(floor(xstrIdx_ol_sb(X(sbId))): floor(xendIdx_ol_sb(X(sbId))), floor(ystrIdx_ol_sb(Y(sbId))): floor(yendIdx_ol_sb(Y(sbId)))); 
                rectangle_Info = [rectangle_Info; ystrIdx_ol_sb(Y(sbId)), xstrIdx_ol_sb(X(sbId)), CellSize]; 
            end  

            RGB = insertShape( RGB, 'Rectangle', rectangle_Info, 'LineWidth', 2, 'Color', 'red') ; 
        end 
        
        
        
        img_blocks{lev} = RGB; 
        clear RGB; 
       
        
    end
end 


