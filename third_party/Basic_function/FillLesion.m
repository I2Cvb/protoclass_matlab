function ImgFill = FillLesion(Img, Mask)

    Img = im2uint8(Img); 
    ImgFill = Img; 
    temp = Img(:,:,1); 
    temp(Mask==1) = 0 ; 
    ImgFill(:,:,1) = temp; 
    
    temp = Img(:,:,2); 
    temp(Mask==1) = 255 ; 
    ImgFill(:,:,2) = temp; 
    
    temp = Img(:,:,3); 
    temp(Mask==1) = 0 ; 
    ImgFill(:,:,3) = temp; 