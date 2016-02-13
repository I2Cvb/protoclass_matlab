%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Indication minimum and maximum of each channels in RGB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [Min, Max] = MinMaxLim(Img)
[row, col, depth] = size(Img); 

if depth == 1
  Min = min(Img(:)); 
  Max = max(Img(:));    
   
elseif depth == 3
    RImg = Img(:,:,1); 
    GImg = Img(:,:,2); 
    BImg = Img(:,:,3); 
    
    Min = [ min(RImg(:)); min(GImg(:)); min(BImg(:))]; 
    Max = [ max(RImg(:)); max(GImg(:)); max(BImg(:))]; 
   
    
else 
    disp('Wrong input'); 
end 
    