function [A]= gabor_feature_calculation(I,stage,orientation,N)

% I =double(imread('T02.jpg')); 
% I = rgb2gray(I);

% Extract_feature_wavelet(I,'haar',1,1,9);
% --------------- generate the Gabor FFT data ---------------------

% stage = 4;
% orientation = 6;
% N = 64;
N=length(I);


if size(I,1)== size(I,2)
    
    
else
    
    I = imresize(I, [N N]);
    
end

freq = [0.05 0.4];
flag = 0;

j = sqrt(-1);

for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor(N,[s n],freq,[stage orientation],flag);
        F = fft2(Gr+j*Gi);
        F(1,1) = 0;
        GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n) = F;
    end;
end;

% -----------------------------------------------------------------

            F = Fea_Gabor_brodatz(I, GW, N, stage, orientation);
            A = [F(:,1); F(:,2)]';



