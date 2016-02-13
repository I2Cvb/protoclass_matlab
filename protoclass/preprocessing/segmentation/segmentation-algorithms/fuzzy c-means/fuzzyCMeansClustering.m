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

function [ segImg ] = fuzzyCMeansClustering( rgbIm )

% Convert in XYZ colorspace
I = rgb2xyz( rgbIm );

% Select only the Z channel
I = I( :, :, 3 );

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
