function [segImg] = pdfBasedSegmentation2( rgbImg )

% Data Initialization
cform = makecform('srgb2xyz');

%%% Transfering rgb to XYZ color space    
TransfImg = applycform(im2double(rgbImg), cform);
Img = Min_Max_normalization(TransfImg (:,:,3)) ; 
Img = Img (15:end-14, 15:end-14);

% Core Code   

%%% Adaptive thresholding based on the local minima 
[counts, x] = imhist(Img); 
% Smoothing the histogram curve 
[x2, counts2] = smoothLine(x, counts, 0.2); 
% Detecting the minimum and maximums 
[maxtab, mintab] = peakdet(counts2, 200);   

[maxV, idx] = max(maxtab(:,2));  
mintabcpy= []; 
for i = 1 : size(mintab,1)
    if (mintab(i,2)>100) && x2(mintab(i,1)) < x2(maxtab(idx,1)) && x2(mintab(i,1)) < 0.4 && x2(mintab(i,1)) > 0.05
        mintabcpy = [mintabcpy; mintab(i,:)]; 
    end 
end

if isempty(mintabcpy)
    Th = 0.2; 
else             
    [Values , Idxlis] = sort(mintabcpy(:,2), 'ascend');        
    Th = x2(mintabcpy(Idxlis(1), 1)); 
end 
        
Mask = (Img <  Th);

% Find the largest componenent
[segImg, ~] = getLargestCc( logical( Mask ), 4, 1);

% Fill holes just in case
segImg = imfill( segImg, 'holes' );

% Add a pad that we previously removed
segImg = padarray(segImg, [14 14], 'both');
