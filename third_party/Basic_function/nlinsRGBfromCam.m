function  [LinsRGB, nonlin_sRGB] = nlinsRGBfromCam(InputImg0, Cam_spec)

%%%% Cam_spec should not be inverse!!! the result are similar to what you
%%%% Cam_spec =  [0.6071 -0.0747 -0.0856;-0.7653 1.5365 0.2441; -0.2025 0.2553 0.7315];
%%%% can get with the dcraw!!! 

    
%     Im = InputImg0;
%   
%     [Min, Max] = MinMaxLim(InputImg0);
%     lim = stretchlim(InputImg0, 0.005);
%     
%     for i = 1 : size(InputImg0, 1)
%         for j = 1 : size(InputImg0, 2)
%             for d = 1 : 3
%                 if InputImg0(i,j,d)<= lim(1,d)
%                     InputImg0(i,j,d) = 0;
%                 elseif InputImg0(i,j,d) >= lim(2,d)
%                     InputImg0(i,j,d) = lim(2,d)- lim(1,d);
%                 end 
%                 
%             end 
%             
%         end 
%     end 


    if nargin < 2
        InputImg = InputImg0; 
    else 
        InputImg = InputImg0; 
        inv_cam_spec = inv(Cam_spec); 
        InputImg(:,:,1) = (inv_cam_spec(1,1).*InputImg0(:,:,1) + inv_cam_spec(1,2).*InputImg0(:,:,2) +inv_cam_spec(1,3).*InputImg0(:,:,3)); 
        InputImg(:,:,2) = (inv_cam_spec(2,1).*InputImg0(:,:,1) + inv_cam_spec(2,2).*InputImg0(:,:,2) +inv_cam_spec(2,3).*InputImg0(:,:,3)); 
        InputImg(:,:,3) = (inv_cam_spec(3,1).*InputImg0(:,:,1) + inv_cam_spec(3,2).*InputImg0(:,:,2) +inv_cam_spec(3,3).*InputImg0(:,:,3)); 
    
    end 

 LinsRGB= XYZ_lin_sRGB ( InputImg); 
    for i = 1 : size(InputImg, 1)
        for j = 1 : size(InputImg, 2)
           for d = 1 : 3 
                
            if LinsRGB(i,j,d)< 0
                LinsRGB(i,j,d) = 0;
            end 
           end 
        end 
    end 
    
  
 nonlin_sRGB = lin_sRGB_to_nonlin_sRGB ( LinsRGB); 
    
    

 
