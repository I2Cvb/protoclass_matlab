%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% min_max normalization in each channel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [normalizedImg] = Min_Max_normalization(Img)

[row, col, depth] = size(Img); 
normalizedImg = zeros(size(Img)); 

if depth == 1
   normalizedImg= (Img- min(Img(:)))./(max(Img(:))- min(Img(:))); 
    
   
elseif depth == 3
    RImg = Img(:,:,1); 
    GImg = Img(:,:,2); 
    BImg = Img(:,:,3); 
    
    RImg = (RImg - min(RImg(:)))./ (max(RImg(:))- min(RImg(:))); 
    GImg = (GImg - min(GImg(:)))./ (max(GImg(:))- min(GImg(:))); 
    BImg = (BImg - min(BImg(:)))./ (max(BImg(:))- min(BImg(:))); 
    
    normalizedImg(:,:,1) = RImg; 
    normalizedImg(:,:,2) = GImg; 
    normalizedImg(:,:,3) = BImg; 
    
else 
    disp('Wrong input'); 
end 
    