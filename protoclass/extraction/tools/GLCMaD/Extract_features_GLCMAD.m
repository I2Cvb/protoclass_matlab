function [ f ] = Extract_features_GLCMAD( Img,theta,levelsNum )
% Computes GLCM Features

switch theta
    case 0
     tt=[0 1];
    case 45
        tt=[-1 1];
    case 90
        tt=[-1 0];
    case 135
        tt=[-1 -1];
end
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', tt);
    ft=GLCM_Features1(glcm);
    f1=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', 3.*tt);
     ft=GLCM_Features1(glcm);
    f2=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', 5.*tt);
     ft=GLCM_Features1(glcm);
    f3=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    glcm = graycomatrix(Img, 'NumLevels', levelsNum, 'GrayLimits', [0 255], 'Offset', 7.*tt);
     ft=GLCM_Features1(glcm);
    f4=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    
    f=mean(f1+f2+f3+f4,1);
    
    
   

end

