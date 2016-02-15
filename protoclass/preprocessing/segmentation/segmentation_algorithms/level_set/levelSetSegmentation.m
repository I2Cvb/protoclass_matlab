%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: levelSetSegmentation.m
%%% Description: This function allows to perform segmentation using fuzzy 
%%% c-means.
%%% Author: Guillaume Lemaitre - Mojdeh Rastgoo
%%% LE2I - ViCOROB
%%% Date: 3 March 2014
%%% Version: 0.1
%%% Copyright (c) 2014 Guillaume Lemaitre
%%% http://le2i.cnrs.fr/ - http://vicorob.udg.es/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ segImg ] = levelSetSegmentation( rgbImg, colorSpace )

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
I = mat2gray( imadjust( I ) ).*255;

% Size of the image
[row, col] = size(I); 

% Parameter of the level set
A=255; % Maximum intensity
nu=0.001*A^2; % coefficient of arc length term
sigma = 4; % scale parameter that specifies the size of the neighborhood
iter_outer=70; 
iter_inner=20;   % inner iteration for level set evolution
timestep=.1;
mu=1;  % coefficient for distance regularization term (regularize the level set function)
c0=2;

% Initialize level set function
initialLSF = c0*ones(size(I));
% The lesion is usually in the middle of the picture
initialLSF (floor(row/2)-100:floor(row/2)+100 , floor(col/2)-150:floor(col/2)+150) = -c0; 
u=initialLSF;

epsilon=1;
b=ones(size(I));  %%% initialize bias field

% Smooth the image to not stuck to the gradient so much
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
%KI=conv2(I,K,'same');
KONE=conv2(ones(size(I)),K,'same');

% Level-set iteration
for n=1:iter_outer
    [u, b, ~]= lse_bfe(u,I, b, K,KONE, nu,timestep,mu,epsilon, iter_inner); 
    disp([ 'Iteration #', num2str( n ), '/', num2str( iter_outer ) ] );
end

% Threshold the final results
segImg = u ; 
segImg(u>=0.5) = 0; 
segImg(u<0.5) = 1;

% Find the largest component and fill holes

%%% Find the largest componenent
[segImg, ~] = getLargestCc( logical( segImg ), 4, 1);
%%% Fill holes just in case
segImg = imfill( segImg, 'holes' );
