%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Guillaume Lemaitre, Mojdeh Rastgoo 
%%%% UdG - 5-02-14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating a Mask for the dermoscopic lesions, using
%%%% Adaptive thresholding 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [segImg] = pdfBasedSegmentation( rgbImg )

% Data Initialization
cform = makecform('srgb2xyz');

%%% Transfering rgb to XYZ color space    
TransfImg = applycform(im2double(rgbImg), cform);
Img = mat2gray( TransfImg( :, :, 3 ) );
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

