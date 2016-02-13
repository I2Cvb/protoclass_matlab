function Im = lin_sRGB_to_nonlin_sRGB ( Im0 )

%Im = double(zeros(size(Im0)));

Im = Im0; 

s = 1.0 / 2.4;

for i=1:size(Im0,1)
    for j = 1:size(Im0,2)
       
        %% R Channel
        if (Im0(i,j,1) < 0) 
            Im0(i,j,1) = 0;
        end
        if (Im0(i,j,1) < 0.0031308) 
            Im(i,j,1) = 12.92 * Im0(i,j,1);
        else
            Im(i,j,1) = 1.055 * Im0(i,j,1)^s - 0.055;
        end
        if(Im(i,j,1) > 1.0019), Im(i,j,1) = 1.0019;
        end
        Im(i,j,1) = 0.5 + 255.0 * Im(i,j,1);                
        
        %% G Channel
        if (Im0(i,j,2) < 0) 
            Im0(i,j,2) = 0;
        end
        if (Im0(i,j,2) < 0.0031308) 
            Im(i,j,2) = 12.92 * Im0(i,j,2);
        else
            Im(i,j,2) = 1.055 * Im0(i,j,2)^s - 0.055;
        end
        if(Im(i,j,2) > 1.0019), Im(i,j,2) = 1.0019;
        end
        Im(i,j,2) = 0.5 + 255.0 * Im(i,j,2); 
        
        %% B Channel
        if (Im0(i,j,3) < 0) 
            Im0(i,j,3) = 0;
        end
        if (Im0(i,j,3) < 0.0031308) 
            Im(i,j,3) = 12.92 * Im0(i,j,3);
        else
            Im(i,j,3) = 1.055 * Im0(i,j,3)^s - 0.055;
        end
        if(Im(i,j,3) > 1.0019), Im(i,j,3) = 1.0019;
        end
        Im(i,j,3) = 0.5 + 255.0 * Im(i,j,3); 
        
    end
end

Im = uint8(Im);