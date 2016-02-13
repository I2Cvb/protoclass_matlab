%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mojdeh Rastgoo , 28-06-13
%%% Mean and Variance of Img 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If the Mask input is not inserted the whole image is considered 

function [M , V] = MeanVariance(Img, Mask)

Img = im2double(Img); 
[r c d] = size(Img); 
 M = []; V = []; 
if nargin == 1  
    if d == 3 
        R = Img(:,:,1); 
        G = Img(:,:,2); 
        B = Img(:,:,3); 
        meanR = mean(R(:)); varR = var(R(:)); 
        meanB = mean(B(:)); varB = var(B(:)); 
        meanG = mean(G(:)); varG = var(G(:)); 

        meanTot = mean2(Img(:,:)); vraTot = var(Img(:)); 
        M = [M, meanR; meanG; meanB; meanTot]; 
        V = [V; varR; varG; varB; varTot]; 

    elseif d ==1 
        meanTot = mean2(Img); 
        varTot = var(Img(:)); 
        M = [M ; meanTot]; 
        V = [V; varTot]; 

    else 
        disp('Input image not valid'); 
    end
elseif nargin == 2 
    Mask = im2double(Mask);     
    Pixelnum = sum(Mask(:)); 
    if d == 3 
        R = Img(:,:,1); 
        G = Img(:,:,2); 
        B = Img(:,:,3); 
        meanR = sum(sum(R(:))) /Pixelnum; 
        varR = sum(sum(R(R~=0)- meanR))/Pixelnum;
        
        meanB = sum(sum(B(:))) /Pixelnum; 
        varB = sum(sum(B(B~=0)- meanB))/Pixelnum;
        meanG = sum(sum(G(:))) /Pixelnum; 
        varG = sum(sum(G(G~=0)- meanG))/Pixelnum;

        meanTot = sum(sum(Img(:,:)))/ Pixelnum; 
        
        varTot = sum(sum(Img(Mask~=0)- meanTot))/Pixelnum;
        
        M = [M, meanR, meanG, meanB, meanTot]; 
        V = [V, varR, varG, varB, varTot]; 

    elseif d ==1 
        meanTot = sum(Img(:))/Pixelnum; 
        varTot = sum(sum(Img(Mask~=0)- meanTot))/Pixelnum; 
        M = [M ; meanTot]; 
        V = [V; varTot]; 

    else 
        disp('Input image not valid'); 
    end
    
    
end 
   