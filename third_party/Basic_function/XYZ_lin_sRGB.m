function Im = XYZ_lin_sRGB ( Im0 )


XYZ_to_sRGB = [ 3.2404542 -1.5371385 -0.4985314;
               -0.9692660  1.8760108  0.0415560;
                0.0556434 -0.2040259  1.0572252];
            
            
% Im0 = im2double(Im0);        
% Im = double(zeros(size(Im0)));  
Im = Im0; 

Im(:, :, 1) = XYZ_to_sRGB(1,1) .* Im0(:,:,1) + XYZ_to_sRGB(1,2) .* Im0(:,:,2) + XYZ_to_sRGB(1,3) .* Im0(:,:,3);
Im(:, :, 2) = XYZ_to_sRGB(2,1) .* Im0(:,:,1) + XYZ_to_sRGB(2,2) .* Im0(:,:,2) + XYZ_to_sRGB(2,3) .* Im0(:,:,3);
Im(:, :, 3) = XYZ_to_sRGB(3,1) .* Im0(:,:,1) + XYZ_to_sRGB(3,2) .* Im0(:,:,2) + XYZ_to_sRGB(3,3) .* Im0(:,:,3);

%parfor i = 1:3
%   
%   Im(:, :, i) = XYZ_to_sRGB(i,1) .* Im0(:,:,1) + XYZ_to_sRGB(i,2) .* Im0(:,:,2) + XYZ_to_sRGB(i,3) .* Im0(:,:,3); 
%    
%end