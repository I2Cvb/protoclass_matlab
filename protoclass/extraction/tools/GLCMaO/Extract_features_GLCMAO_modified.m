function [ f ] = Extract_features_GLCMAO_modified(Img,d,levelsNum)
% Computes GLCM Features


    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[0 1]);
    ft=GLCM_Features2(glcm);
    f1=[ ft.asm ft.dissi ft.mean ft.var ft.sosvh ft.savgh ft.svarh ft.dvarh];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 1]);
     ft=GLCM_Features2(glcm);
    f2=[ ft.asm ft.dissi ft.mean ft.var ft.sosvh ft.savgh ft.svarh ft.dvarh];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 0]);
     ft=GLCM_Features2(glcm);
    f3=[ ft.asm ft.dissi ft.mean ft.var ft.sosvh ft.savgh ft.svarh ft.dvarh];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 -1]);
     ft=GLCM_Features2(glcm);
    f4=[ ft.asm ft.dissi ft.mean ft.var ft.sosvh ft.savgh ft.svarh ft.dvarh];
    
    f=mean(f1+f2+f3+f4,1);
    
    
   

end

