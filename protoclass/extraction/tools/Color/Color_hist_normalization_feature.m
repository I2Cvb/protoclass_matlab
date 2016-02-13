function result = Color_hist_normalization_feature(I,N,format,MAP)

% N should be 32
% I =uint8(imread('T02.jpg')); 

if strcmp(format,'RGB') 

        fact=size(I,1)*size(I,2);

        [countr,xr]=imhist(I(:,:,1),N);
        [countg,xg]=imhist(I(:,:,2),N);
        [countb,xb]=imhist(I(:,:,3),N);

        result=cat(2,countg',countb',countr')/fact;

elseif  strcmp(format,'HSV') 
    
        fact=size(I,1)*size(I,2);
        
        I=rgb2hsv(I);

        [countr,xr]=imhist(uint8(255*I(:,:,1)),N);
%         [countg,xg]=imhist(I(:,:,2),N);
        [countb,xb]=imhist(uint8(255*I(:,:,3)),N);

        result=cat(2,countb',countr')/sqrt(fact);
        
elseif  strcmp(format,'LAB') 
        R=I(:,:,1);
        G=I(:,:,2);
        B=I(:,:,3);
        
        [L,a,b] = RGB2Lab(R,G,B);
    
%         % Convert indexed image to true-color (RGB) format
%         RGB = ind2rgb(I,MAP); 
% 
%         % Convert image to L*a*b* color space
%         cform2lab = makecform('srgb2lab');
%         LAB = applycform(RGB, cform2lab); 

        % Scale values to range from 0 to 1
%         L = LAB(:,:,1)/100;     
        fact=size(I,1)*size(I,2);
        
%         L1=255*mat2gray(L);

        [countr,xr]=imhist(uint8(L),N);
%         [countg,xg]=imhist(I(:,:,2),N);
%         [countb,xb]=imhist(I(:,:,3),N);

        result=cat(2,countr')/sqrt(fact);
    
end
