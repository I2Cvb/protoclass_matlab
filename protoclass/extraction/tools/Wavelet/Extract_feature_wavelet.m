function [f info]=Extract_feature_wavelet(I,wlt,RI,energyDec,nlevel)
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

    wname=wlt;
    im=I;
    for l=1:nlevel
%         compute wavelet transform of the Image

        [cA,cH,cV,cD]=dwt2(im,wname);
        if l==1 
            eA=energy(cA);
        end
        eH=energy(cH);eV=energy(cV);eD=energy(cD);
        
%         normal Features
         if RI==0 
             f=[f eH eV eD];
         end
%          rotarion Invariante features
         if RI==1
             et=eH+eV+eD;
             ori=sqrt((eH-eV)^2+ (eH-eD)^2+ (eV-eD)^2 )/et;
             f=[f et ori];
         end
%          Both Rotation invariant and variant features
         if RI==2
             et=eH+eV+eD;
             ori=sqrt((eH-eV)^2+ (eH-eD)^2+ (eV-eD)^2 )/et;
             f=[f(:) eH eV eD et ori];
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
f=[f eA];

info=0;

function e=energy(x)
row=size(x,1);
col=size(x,2);
t=x.*x;
e=sum(sum(t));
e=(1/(row*col))*e;
