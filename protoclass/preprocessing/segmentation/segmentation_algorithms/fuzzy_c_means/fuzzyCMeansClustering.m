%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: fuzzyCMeansClustering.m
%%% Description: This function allows to perform segmentation using fuzzy 
%%% c-means.
%%% Author: Guillaume Lemaitre - Mojdeh Rastgoo
%%% LE2I - ViCOROB
%%% Date: 3 March 2014
%%% Version: 0.1
%%% Copyright (c) 2014 Guillaume Lemaitre
%%% http://le2i.cnrs.fr/ - http://vicorob.udg.es/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ segImg ] = fuzzyCMeansClustering( rgbImg , colorSpace)

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
    





% Adjust the contrast
I = imadjust( I );


% Apply Fuzzy C-means clustering
data = I( : );
[center,U,obj_fcn] = fcm(data,2);

% Find the cluster
maxU = max(U);
% Map each pixel to the most plausible outcome
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);

% Affect to 1 the largest region
if ( mean( data( index1 ) ) < mean( data( index2 ) ) )
    tmp = index1;
    index1 = index2;
    index2 = tmp;
    clear tmp;
end

% Initilisaton
fcmImage( 1 : length( data ) )=0;       
fcmImage( index1 )= 1;
fcmImage( index2 )= 0;

% Reshapeing the array to a image
imagNew = reshape( fcmImage, size( I, 1 ), size( I, 2 ) );

% Find the largest componenent
[segImg statRegion] = getLargestCc( ~logical( imagNew ), 4, 1);

% Fill holes just in case
segImg = imfill( segImg, 'holes' );
