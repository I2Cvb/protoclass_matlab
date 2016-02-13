%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Image Derivatives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Iy, Ix, Mag, gradImg , gradDir] = derivativeImages(in_im, filtery, filterx)
disp('Compute derivative images')
Ix = conv2(in_im,filterx,'same');
Iy = conv2(in_im,filtery,'same');
Mag = sqrt(Ix.^2 + Iy.^2);  
gradImg = Iy + Ix ; 
gradDir = atan2(Iy, Ix); 
disp('Derivative images computed, the magnitude of the gradients are returned')