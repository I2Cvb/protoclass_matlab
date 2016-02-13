function [Image] = contrastAdjust(Img1)

Image = Img1; 
R = double(Image(:,:,1)); 
G = double(Image(:,:,2)); 
B = double(Image(:,:,3)); 

R = R(:);
G = G(:);
B = B(:);

[HR, Rx] = hist(R,0:max(max(R)));
[HG, Gx] = hist(G,0:max(max(G)));
[HB, Bx] = hist(B,0:max(max(B)));

cumHR = cumsum(HR);
cumHG = cumsum(HG);
cumHB = cumsum(HB);

% Compute threshold
thr = 0.99;

thrR = cumHR(end).*thr;
thrG = cumHG(end).*thr;
thrB = cumHB(end).*thr;

% Find the corresponding raw value in the histogram
valImgR = find(cumHR>thrR);
valImgR = valImgR(1);
valImgG = find(cumHG>thrG);
valImgG = valImgG(1);
valImgB = find(cumHB>thrB);
valImgB = valImgB(1);

% Work on the image
indR = find(R > valImgR);
R(indR) = valImgR;
indG = find(G > valImgG);
G(indG) = valImgG;
indB = find(B > valImgB);
B(indB) = valImgB;

% Reshape
R = reshape(R, size(Image(:,:,1)));
G = reshape(G, size(Image(:,:,2)));
B = reshape(B, size(Image(:,:,3)));


Image(:,:,1) = (R);
Image(:,:,2) = (G);
Image(:,:,3) = (B);