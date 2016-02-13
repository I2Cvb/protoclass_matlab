%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mojdeh Rastgoo, 12-08-13, UdG 
%%% Texture Features Based on Maglogiannis work 
%%% Features, Dissimilarity, Angular Second Moments, Mean and Standard
%%% deviation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FV = GLCMTextureFeatures (Img, Mask)

    Img = Min_Max_normalization(im2double(Img)); 
    GrayImg = mat2gray(rgb2gray(Img)); 
    GrayImg = GrayImg(10:end-10, 10:end-10);  
    GrayImg = GrayImg.*255; 
    [Xmesh, Ymesh] = meshgrid(1:size(GrayImg,2) , 1: size(GrayImg,1)); 
    NumLevel = 32 ; 
    Distance = 3; 
    [glcm1, SI1] = graycomatrix(GrayImg,'NumLevels', NumLevel , 'GrayLimits', [0 255], 'Offset', Distance.*[0 1]); 
    [glcm2, SI2] = graycomatrix(GrayImg,'NumLevels', NumLevel , 'GrayLimits', [0 255], 'Offset', Distance.*[-1 1]); 
    [glcm3, SI3] = graycomatrix(GrayImg,'NumLevels', NumLevel , 'GrayLimits', [0 255], 'Offset', Distance.*[-1 0]); 
    [glcm4, SI4] = graycomatrix(GrayImg,'NumLevels', NumLevel , 'GrayLimits', [0 255], 'Offset', Distance.*[-1 -1]); 
    
    if nargin <=1 
    %%% Dissimilarity 
   
    X_Y_mesh = abs(Xmesh-Ymesh); 
    Dissi1 = sum(sum(SI1.*X_Y_mesh)); 
    Dissi2 = sum(sum(SI2.*X_Y_mesh)); 
    Dissi3 = sum(sum(SI3.*X_Y_mesh)); 
    Dissi4 = sum(sum(SI4.*X_Y_mesh));
    FV.Dissimilarity = Dissi1 + Dissi2 + Dissi3 + Dissi4 ; 
        
    %%% Angular Second Moment 
    ASM1 = sum(sum(Xmesh.*(SI1.^2))); 
    ASM2 = sum(sum(Xmesh.*(SI2.^2))); 
    ASM3 = sum(sum(Xmesh.*(SI3.^2))); 
    ASM4 = sum(sum(Xmesh.*(SI4.^2))); 
    
    FV.ASM = ASM1 + ASM2 + ASM3 + ASM4 ; 
    
    %%% Mean 
    mean1i = sum(sum(Xmesh.*SI1)); 
    mean2i = sum(sum(Xmesh.*SI2)); 
    mean3i = sum(sum(Xmesh.*SI3)); 
    mean4i = sum(sum(Xmesh.*SI4)); 
    
    FV.meani= mean1i + mean2i + mean3i + mean4i ; 
    
    mean1j = sum(sum(Ymesh.*SI1)); 
    mean2j = sum(sum(Ymesh.*SI2)); 
    mean3j = sum(sum(Ymesh.*SI3)); 
    mean4j = sum(sum(Ymesh.*SI4)); 
    
    FV.meanj= mean1j + mean2j + mean3j + mean4j ; 
    
    
    %%% Standard deviation 
    std1i = sqrt(sum(sum(SI1.*((Xmesh-mean1i).^2)))); 
    std2i = sqrt(sum(sum(SI2.*((Xmesh-mean2i).^2)))); 
    std3i = sqrt(sum(sum(SI3.*((Xmesh-mean3i).^2)))); 
    std4i = sqrt(sum(sum(SI4.*((Xmesh-mean4i).^2)))); 
    
    FV.stdi= std1i + std2i + std3i + std4i ; 
    
    std1j = sqrt(sum(sum(SI1.*((Ymesh-mean1j).^2)))); 
    std2j = sqrt(sum(sum(SI2.*((Ymesh-mean2j).^2)))); 
    std3j = sqrt(sum(sum(SI3.*((Ymesh-mean3j).^2))));  
    std4j = sqrt(sum(sum(SI4.*((Ymesh-mean4j).^2)))); 
    
    FV.stdj= std1j + std2j + std3j + std4j ; 
    
    elseif nargin==2 
    
    Mask = Mask(10:end-10, 10:end-10); 
    Mask = im2double(Mask); 
    X_Y_mesh = abs(Xmesh-Ymesh); 
    X_Y_mesh  = X_Y_mesh.*Mask; 
    Xmesh = Xmesh.*Mask; 
    Ymesh = Ymesh.*Mask; 
    
    Dissi1 = sum(sum(SI1.*X_Y_mesh)); 
    Dissi2 = sum(sum(SI2.*X_Y_mesh)); 
    Dissi3 = sum(sum(SI3.*X_Y_mesh)); 
    Dissi4 = sum(sum(SI4.*X_Y_mesh));
    
    FV.Dissimilarity = Dissi1 + Dissi2 + Dissi3 + Dissi4 ; 
        
    %%% Angular Second Moment 
    ASM1 = sum(sum(Xmesh.*(SI1.^2))); 
    ASM2 = sum(sum(Xmesh.*(SI2.^2))); 
    ASM3 = sum(sum(Xmesh.*(SI3.^2))); 
    ASM4 = sum(sum(Xmesh.*(SI4.^2))); 
    
    FV.ASM = ASM1 + ASM2 + ASM3 + ASM4 ; 
    
    %%% Mean 
    mean1i = sum(sum(Xmesh.*SI1)); 
    mean2i = sum(sum(Xmesh.*SI2)); 
    mean3i = sum(sum(Xmesh.*SI3)); 
    mean4i = sum(sum(Xmesh.*SI4)); 
    
    FV.meani= mean1i + mean2i + mean3i + mean4i ; 
    
    mean1j = sum(sum(Ymesh.*SI1)); 
    mean2j = sum(sum(Ymesh.*SI2)); 
    mean3j = sum(sum(Ymesh.*SI3)); 
    mean4j = sum(sum(Ymesh.*SI4)); 
    
    FV.meanj= mean1j + mean2j + mean3j + mean4j ; 
    
    
    %%% Standard deviation 
    mean1i = mean1i.*Mask; 
    mean2i = mean2i.*Mask; 
    mean3i = mean3i.*Mask; 
    mean4i = mean4i.*Mask; 
    
    mean1j = mean1j.*Mask; 
    mean2j = mean2j.*Mask; 
    mean3j = mean3j.*Mask; 
    mean4j = mean4j.*Mask; 
    
    std1i = sqrt(sum(sum(SI1.*((Xmesh-mean1i).^2)))); 
    std2i = sqrt(sum(sum(SI2.*((Xmesh-mean2i).^2)))); 
    std3i = sqrt(sum(sum(SI3.*((Xmesh-mean3i).^2)))); 
    std4i = sqrt(sum(sum(SI4.*((Xmesh-mean4i).^2)))); 
    
    FV.stdi= std1i + std2i + std3i + std4i ; 
    
    std1j = sqrt(sum(sum(SI1.*((Ymesh-mean1j).^2)))); 
    std2j = sqrt(sum(sum(SI2.*((Ymesh-mean2j).^2)))); 
    std3j = sqrt(sum(sum(SI3.*((Ymesh-mean3j).^2))));  
    std4j = sqrt(sum(sum(SI4.*((Ymesh-mean4j).^2)))); 
    
    FV.stdj= std1j + std2j + std3j + std4j ; 
        
    end 
    

        