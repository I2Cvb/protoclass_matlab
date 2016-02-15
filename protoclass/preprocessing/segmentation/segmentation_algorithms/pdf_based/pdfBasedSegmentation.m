%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Guillaume Lemaitre, Mojdeh Rastgoo 
%%%% UdG - 5-02-14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating a Mask for the dermoscopic lesions, using
%%%% Adaptive thresholding 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [segImg] = pdfBasedSegmentation( rgbImg , colorSpace)

 addpath ../../../../../third_party/Basic_function/
 
 

%%% Checking the requested color space 
 if (strncmpi('gray', colorSpace, 4) == 1)
     I = mat2gray(rgb2gray(rgbImg)); 
 elseif (strncmpi('x', colorSpace, 1) == 1) || (strncmpi('y', colorSpace, 1) == 1) ||...
        (strncmpi('z', colorSpace, 1) == 1)
    % Convert in XYZ colorspace
    I = rgb2xyz( rgbImg );
    if (strncmpi('x', colorSpace, 1) == 1)
        I = I(:,:,1); 
    elseif (strncmpi('y', colorSpace, 1) == 1)
        I = I(:,:,2); 
    elseif (strncmpi('z', colorSpace, 1) == 1)
        I = I(:,:,3); 
    end
    
elseif (strncmpi('r', colorSpace, 1) == 1) || (strncmpi('g', colorSpace, 1) == 1) ||...
        (strncmpi('b', colorSpace, 1) == 1)
    % using rgb space of original image 

    if (strncmpi('r', colorSpace, 1) == 1)
        I = rgbImg(:,:,1); 
    elseif (strncmpi('g', colorSpace, 1) == 1)
        I = rgbImg(:,:,2); 
    elseif (strncmpi('b', colorSpace, 1) == 1)
        I = rgbImg(:,:,3); 
    end
    
elseif (strncmpi('l', colorSpace, 1) == 1)
    % La*b* color space 
    I = colorspace ('Lab', rgbImg); 
    I = I(:,:,1); 
    
elseif (strncmpi('h', colorSpace, 1) == 1) || (strncmpi('s', colorSpace, 1) == 1) ||...
        (strncmpi('v', colorSpace, 1) == 1)
    % HSV color space 
    I = colorspace ('HSV',rgbImg ); 
    
    if (strncmpi('h', colorSpace, 1) == 1)
        I = I(:,:,1); 
    elseif (strncmpi('s', colorSpace, 1) == 1)
        I = I(:,:,2); 
    elseif (strncmpi('v', colorSpace, 1) == 1)
        I = I(:,:,3); 
    end
    
end 
    
 

Img = mat2gray(I);
%Img = Min_Max_normalization(TransfImg (:,:,3)) ; 
Img = Img (15:end-14, 15:end-14);

% Core Code   

%%% Adaptive thresholding based on the local minima 
[counts, x] = imhist(Img); 
% Smoothing the histogram curve 
[x2, counts2] = smoothLine(x, counts, 0.2); 
% Detecting the minimum and maximums 
[maxtab, mintab] = peakdet(counts2, 200);   

if isempty(mintab)
       Th = 0.2; 
else 
    mintabcpy = mintab ; 
    dum = x2(mintab(:,1)) ; 
    mintabcpy(dum> 0.5) = 0  ; 
    mintabcpy(dum < 0.5) = 1 ; 
    d = mintabcpy == 0 ; 
    d = d (:,1) ; 
    mintab(d==0,: ) = [];             
    [Values , Idxlis] = sort(mintab(:,2), 'ascend');  
    if ~isempty(Idxlis)
        Th = x2(mintab(Idxlis(1), 1)); 
    elseif isempty(Idxlis)
        Th = 0.2; 
    end 
 end 

Mask = (Img <  Th);

% Find the largest componenent
[segImg, ~] = getLargestCc( logical( Mask ), 4, 1);

% Fill holes just in case
segImg = imfill( segImg, 'holes' );

% Add a pad that we previously removed
segImg = padarray(segImg, [14 14], 'both');

