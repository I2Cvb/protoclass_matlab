function [f info]=Extract_features_WVhist(im,wname,nb,energyDec,nlevel)
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
RI=0;

    for l=1:nlevel
%         compute wavelet transform of the Image

        [cA,cH,cV,cD]=dwt2(im,wname);
                
        hA=hist(cA(:),nb);
        hA=hA/sum(hA(:));
        
        hH=hist(cH(:),nb);
        hH=hH/sum(hH(:));
        
        hV=hist(cV(:),nb);
        hV=hV/sum(hV(:));
        
        hD=hist(cD(:),nb);
        hD=hD/sum(hD(:));
        
        
%         normal Features
         if RI==0 
             f=[f hA hH hV hD];
         end
         
%          rotarion Invariante features
         
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


info=0;


