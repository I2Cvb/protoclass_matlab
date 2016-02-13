%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mojdeh Rastgoo , UdG, 6-08-13
%%%% Variance Function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Var_Mod  = Var_Mod(Img, mean, N)

Img1 = Img-mean; 
Imgsq = Img1.^2 ; 

Var_Mod = (1/N)*(sum(sum(Imgsq))); 

