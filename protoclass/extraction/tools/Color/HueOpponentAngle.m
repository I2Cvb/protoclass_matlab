%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mojdeh Rastgoo , UdG , 12-08-13
%%%% Version 1 
%%%% Color hue and opponent angle histogram 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FV = HueOpponentAngle(Img,  nbins, Mask)
    Img  = Min_Max_normalization(im2double(Img)); 
   % Img  = Img (10:end-10, 10:end-10, :);
    
    R = Img(:,:,1); G = Img(:,:,2) ; B = Img(:,:,3); 
    
    Hue = (sqrt(6).*(R-G))./(sqrt(2).*(R+G-2.*B)); 
    Hue = removenan(Hue); 
    Hue = removeinf(Hue); 
    
    sobelx = [1 2 1; 0 0 0; -1 -2 -1];
    sobely = sobelx';
    filterx = sobelx;  
    filtery = sobely; 
    
    [Ry, Rx , RgradMag, RgradImg, RgradDir] = derivativeImages(R, filterx, filtery); 
    [Gy, Gx , GgradMag, GgradImg, GgradDir] = derivativeImages(G, filterx, filtery); 
    [By, Bx , BgradMag, BgradImg, BgradDir] = derivativeImages(B, filterx, filtery); 
    
    Aongx = (sqrt(6).*(Rx-Gx))./(sqrt(2).*(Rx+Gx-2.*Bx));
    Aongy =  (sqrt(6).*(Ry-Gy))./(sqrt(2).*(Ry+Gy-2.*By));
    Aongx = removenan(Aongx); 
    Aongx = removeinf(Aongx); 
    
    if nargin <=2 
        
        [HueCounts, x] = imhist(Hue, nbins); 
        [AongxCounts, x] = imhist(Aongx, nbins); 
        
        FV = []; 
        FV = [FV, HueCounts, AongxCounts]; 
        
    
    elseif nargin <=3
       % Mask = Mask(10:end-10, 10:end-10);
        Hue  = Hue.*Mask; 
        Aongx  = Aongx.*Mask; 
        
        [HueCounts, x] = imhist(Hue, nbins); 
        [AongxCounts, x] = imhist(Aongx, nbins); 
        
        HueCounts(1) = 0 ; AongxCounts(1) =  0 ; 
       
        FV = []; 
        FV = [FV, HueCounts(:), AongxCounts(:)]; 
        
    
    
    end 
    
    