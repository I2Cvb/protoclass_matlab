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

function [ segImg ] = levelSetSegmentation( rgbIm )

% Convert in XYZ colorspace
I = rgb2xyz( rgbIm );

% Select only the Z channel
I = I( :, :, 3 );

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
