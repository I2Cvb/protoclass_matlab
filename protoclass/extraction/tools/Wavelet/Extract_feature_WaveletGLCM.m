function [ f ]=Extract_feature_WaveletGLCM(I,wlt,dist,GL,RI,energyDec,nlevel)

% INPUT:
% I : Image in Gray Scale
% wlt : cell containing the name of wavelets to be used waveforms={'haar' 'db1' 'sym' 'ciof'}
% RI:   determines if feature computed should be Rotation invariaant(RI=1)
        % or not (RI=0) or RI=2 for both features
% energyDec: determines if the decomposition is done in normal (wayenergyDec=0) or the
        % sub image with highest energy is decomposed further(energyDec=1)
% nlevel: number of levels to which the composition is done


% OUTPUT :
% f : feature vector containing all features coputed and normalized
% info : contains the infromation applied for extracting the feature and
% the version

% for each wavelet in do
f=[];
for w=1:numel(wlt)
    wname=wlt{w};
    im=I;
    for l=1:nlevel
%         compute wavelet transform of the Image
        
        [cA,cH,cV,cD]=dwt2(im,wname);
        if l==1 
             cA=cA(1:end,1:size(cA,1));
            ft=GLCM_Features1( cA);
            fA=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
        end
        
        cH=cH(1:end,1:size(cH,1));
         ft=GLCM_Features1(cH);
    fH=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    
    cV=cH(1:end,1:size(cV,1));
     ft=GLCM_Features1(cV);
    fV=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
    
    cD=cH(1:end,1:size(cV,1));
     ft=GLCM_Features1(cD);
    fD=[ ft.autoc ft.contr ft.corrm ft.corrp ft.cprom  ft.cshad ft.dissi ...
        ft.energ ft.entro ft.homom ft.homop ft.maxpr ft.sosvh ft.savgh ... 
        ft.svarh ft.senth ft.dvarh ft.denth ft.inf1h ft.inf2h ft.indnc...
        ft.idmnc];
        
%         fH= Extact_features_GLCM( cH,dist,GL);
%         fV=Extact_features_GLCM( cV,dist,GL);
%         fD=Extact_features_GLCM( cD,dist,GL);
        
       if RI==0
        f=[f fH fV fD];
       end
       if RI==1
           RIf=fH+fV+fD;
            ori=(sqrt((fH-fV).^2+ (fH-fD).^2+ (fV-fD).^2 ))./RIf;
            f=[f RIf ori];
       end
%          decompose the submage with higher energy
         if energyDec==1
             eA=energy(cA);
             en= [eA eH eV eD];
             ind=find(en==max(en));
         if ind==1
             im=cA;
         elseif ind==2 
             im=cH;
         elseif ind==3
             im=cV;
         elseif ind==4 
             im=cD;
         end
         else
            im=cA;
         end
    end
f=[f fA];
end


