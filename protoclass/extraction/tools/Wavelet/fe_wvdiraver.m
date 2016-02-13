function [ f ] = fe_wvdiraver( I,wlt,RI,energyDec,nlevel )
%FE_WVDIRAVER Summary of this function goes here
%   Detailed explanation goes here
[f k] =Extract_feature_wavelet(I,wlt,RI,energyDec,nlevel);
F0=zeros(6,numel(f));
F0(1,:)=f;
kk=2;
for a=15:15:90
Ir=imrotate(I,a);
[f k] =Extract_feature_wavelet(Ir,wlt,RI,energyDec,nlevel);
% figure; imshow(cI);
F0(kk,:)=f;
kk=kk+1;
% f =Extract_feature_wavelet(cI,{'haar'},1,0,1);
% Fir=[Fir;f];

end
f=sum(F0,1)/size(F0,1);

end
