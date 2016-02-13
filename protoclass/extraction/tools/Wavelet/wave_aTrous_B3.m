function [FNscales,Wplanes]=wave_aTrous_B3(input_image,Nscales)

% mpb 12-abril-2007
% Fa la descomposicio d'una imatge en Nscales plans de wavelet utilitzant
% l'algoritme "A trous", i fent servir un filtre concret (B3 spline, de
% moment).

% Sortida: FN --> Imatge residual
% W --> Conjunt de Nscales imatges (plans wavelet)

F0=input_image;
[Kd,Ld]=size(F0);
F=ones(Kd,Ld,Nscales);
Wplanes=F;

% Definicio del filtre:
h_b3=[1 4 6 4 1; 4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1];
h_b3=(1/256)*h_b3;
[S_h_b3,S_h_b3]=size(h_b3);
shift=(S_h_b3+1)/2;

% Convolucio i calcul dels plans

% Inicialitzacio del cicle:
  F(:,:,1)=imfilter(F0,h_b3);
  Wplanes(:,:,1)=F0-F(:,:,1);
% Seguents iteracions:
if Nscales > 1
unv=2;
for i = 2 : Nscales
  scal_fact=2^(i-1);
  S_H=S_h_b3 + (S_h_b3 - 1)*(scal_fact - 1);
  unv=unv+(S_H-1)/2;
  disp('i='); disp(i); disp('Size H= '); disp(S_H); disp('unvalid border pixels= '); disp(unv);
  H=zeros(S_H,S_H);
  k=(S_H+1)/2;
  for n= 1 : S_h_b3
      for m= 1 : S_h_b3
          H(k+scal_fact*(n-shift),k+scal_fact*(m-shift))=h_b3(n,m);
      end
  end
  
  F(:,:,i)=imfilter(F(:,:,i-1),H);
  Wplanes(:,:,i)=F(:,:,i-1)-F(:,:,i);
end 
end

% "imatge residual"
FNscales=F(:,:,Nscales);