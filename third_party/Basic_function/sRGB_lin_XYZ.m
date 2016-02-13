function Im = sRGB_lin_XYZ ( Im0 )


sRGB_to_XYZ = [0.412453 0.357580 0.180423; 
               0.212671 0.715160 0.072169; 
               0.019334 0.119193 0.950227];
            
            
Im0 = im2double(Im0);        
Im = double(zeros(size(Im0)));   

Im(:, :, 1) = sRGB_to_XYZ(1,1) .* Im0(:,:,1) + sRGB_to_XYZ(1,2) .* Im0(:,:,2) + sRGB_to_XYZ(1,3) .* Im0(:,:,3);
Im(:, :, 2) = sRGB_to_XYZ(2,1) .* Im0(:,:,1) + sRGB_to_XYZ(2,2) .* Im0(:,:,2) + sRGB_to_XYZ(2,3) .* Im0(:,:,3);
Im(:, :, 3) = sRGB_to_XYZ(3,1) .* Im0(:,:,1) + sRGB_to_XYZ(3,2) .* Im0(:,:,2) + sRGB_to_XYZ(3,3) .* Im0(:,:,3);
