%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Color Features 
%%% Mojdeh Rastgo , UDG , 6-08-13
%%% Version 01 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FV = clrFeatures(Img, Mask)

        %Img = Min_Max_normalization(im2double(Img)); 
        %Img = Img(10:end-10, 10:end-10,:); 
 
        
        R = Img(:,:,1); 
        G = Img(:,:,2); 
        B = Img(:,:,3); 

        % LAB color space
         L = sqrt((R.^2) +(G.^2)+(B.^2)); 
         AA = acos(B./L); 
         AA = removenan(AA); 
         AB = acos(R./L.*sin(AA)); 
         AB = removenan(AB); 
        % HSV color space
         HSVImg = rgb2hsv(Img); 
         
         cform  = makecform('srgb2lab'); 
         LabImg = applycform(Img, cform); 
        

        % Img = Img.*255; 
        
    if nargin ==1


    %%% Mean and Variance of different color set 
        % RGB color spcae
        Rmean = mean2(R); 
        Gmean = mean2(G); 
        Bmean = mean2(B); 
        Rvariance = var(var(R)); 
        Gvariance = var(var(G)); 
        Bvariance = var(var(B)); 

        Hmean = mean2(HSVImg(:,:,1)); 
        Hvariance = var(var(HSVImg(:,:,1))); 
        Smean = mean2(HSVImg(:,:,2)); 
        Svariance = var(var(HSVImg(:,:,2))); 
        Vmean = mean2(HSVImg(:,:,3)); 
        Vvariance = var(var(HSVImg(:,:,3))); 

         Lmean = mean2(L); 
         meanA = mean2(AA); 
         meanB = mean2(AB); 
         Lvariance = var(var(L)) ; 
         varianceA = var(var(AA)); 
         varianceB = var(var(AB)); 

         L2mean = mean2(LabImg(:,:,1)); 
         amean = mean2(LabImg(:,:,2)); 
         bmean = mean2(LabImg(:,:,3)); 
         L2variance  = var(var(LabImg(:,:,1))); 
         avariance = var(var(LabImg(:,:,2))); 
         bvariance = var(var(LabImg(:,:,3))); 



    else 
         %Mask = Mask(10:end-10, 10:end-10); 
         Mask = im2double(Mask);
         Img = Img.*repmat(Mask , [1 1 3]); 
         
         R = R.*Mask; 
         B = B.*Mask; 
         G = G.*Mask;        
         
         Npixels = sum(sum(Mask)) ; 
         Rmean = sum(sum(R))./Npixels; 
         Gmean = sum(sum(G))./Npixels; 
         Bmean = sum(sum(B))./Npixels; 
         Rvariance = Var_Mod(R, Rmean, Npixels) ; 
         Gvariance = Var_Mod(G, Gmean, Npixels) ; 
         Bvariance = Var_Mod(B, Rmean, Npixels) ; 
         
         HSVImg = HSVImg.* repmat(Mask , [1 1 3]); 
         Hmean = sum(sum(HSVImg(:,:,1)))./Npixels; 
         Smean = sum(sum(HSVImg(:,:,2)))./Npixels; 
         Vmean = sum(sum(HSVImg(:,:,3)))./Npixels; 
         Hvariance = Var_Mod(HSVImg(:,:,1), Hmean, Npixels) ; 
         Svariance = Var_Mod(HSVImg(:,:,2), Smean, Npixels) ; 
         Vvariance = Var_Mod(HSVImg(:,:,3), Vmean, Npixels) ;
         
         L = L.*Mask; 
         AA = AA.*Mask; 
         AB = AB.*Mask; 
         
         Lmean = sum(sum(L))./Npixels; 
         meanA = sum(sum(AA))./Npixels; 
         meanB = sum(sum(AB))./Npixels; 
         
         Lvariance = Var_Mod(L, Lmean, Npixels); 
         varianceA  = Var_Mod(AA, meanA, Npixels); 
         varianceB = Var_Mod(AB, meanB, Npixels); 
         
         
         LabImg = LabImg.*repmat(Mask, [1 1 3]); 
         L2mean = sum(sum(LabImg(:,:,1)))./Npixels; 
         amean = sum(sum(LabImg(:,:,2)))./Npixels; 
         bmean = sum(sum(LabImg(:,:,3)))./Npixels; 
         L2variance = Var_Mod(LabImg(:,:,1), L2mean, Npixels); 
         avariance = Var_Mod(LabImg(:,:,2), amean, Npixels); 
         bvariance = Var_Mod(LabImg(:,:,3), bmean, Npixels); 
         
         
    end 
         ft = struct('Rmean', Rmean, 'Rvariance', Rvariance, 'Gmean',Gmean, 'Gvariance' , Gvariance, ...
             'Bmean', Bmean , 'Bvariance', Bvariance, 'Hmean', Hmean, 'Hvariance', Hvariance, 'Smean', Smean, ...
             'Svariance', Svariance, 'Vmean', Vmean, 'Vvariance', Vvariance, 'Lmean', L2mean, 'Lvariance', L2variance ,...
             'meanA', amean, 'varianceA', avariance, 'meanB', bmean, 'varianceB', bvariance);  
        
         FV = zeros(18,1); 
         FV(:,1) = [Rmean; Rvariance; Gmean; Gvariance; Bmean; Bvariance; Hmean; Hvariance; Smean; Svariance; Vmean;...
             Vvariance; Lmean; Lvariance; meanA; varianceA; meanB; varianceB ]; 
     
     
    