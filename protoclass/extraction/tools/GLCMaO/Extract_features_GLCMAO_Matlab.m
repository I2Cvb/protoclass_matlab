function [ f ] = Extract_features_GLCMAO_Matlab(Img,d,levelsNum)
% Computes GLCM Features


    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[0 1]);
    ft1= graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    f1=[ ft1.Contrast ft1.Correlation ft1.Energy ft1.Homogeneity];
    
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 1]);
     ft2=graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    f2=[ ft2.Contrast ft2.Correlation ft2.Energy ft2.Homogeneity];
    
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 0]);
     ft3=graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    f3=[ ft3.Contrast ft3.Correlation ft3.Energy ft3.Homogeneity];
    
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', d.*[-1 -1]);
     ft4=graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    f4=[ ft4.Contrast ft4.Correlation ft4.Energy ft4.Homogeneity];
    
    f=mean(f1+f2+f3+f4,1);
    
    
   

end

