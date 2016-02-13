function [ f info ] = FE_WaveletPacket( I,wlt,nlevel,RI )
f=[];
for w=1:numel(wlt)
    wname=wlt{w};
    toDec={I};
%     compute all subimages first
    for l=1:nlevel
%         compute wavelet transform of the Image
            if l==1
                cur=toDec{1};
                [cA,cH,cV,cD]=dwt2(cur,wname);
                toDec=[toDec {cA,cH,cV,cD}];
                eA=energy(cA);eH=energy(cH);eV=energy(cV);eD=energy(cD);
                sA=std(cA(:));sH=std(cH(:));sV=std(cV(:));sD=std(cD(:));

                 if RI==0 
                     f=[f eA eH eV eD sA sH sV sD];
                 elseif RI==1
                     et=eH+eV+eD;
                     ori=sqrt((eH-eV)^2+ (eH-eD)^2+ (eV-eD)^2 )/et;
                     fs=(sH+sV)/2;
                     f=[f et ori fs];
                 end
                toDec(1)=[]; 
            
            else
                newdec={};
                for d=1:numel(toDec)
                    cur=toDec{d};
                    [cA,cH,cV,cD]=dwt2(cur,wname);
                    newdec=[newdec {cA,cH,cV,cD}];
                    eA=energy(cA);eH=energy(cH);eV=energy(cV);eD=energy(cD);
                    sA=std(cA(:));sH=std(cH(:));sV=std(cV(:));sD=std(cD(:));
                    if RI==0 
                        f=[f eA eH eV eD sA sH sV sD];
                    elseif RI==1
                        et=eH+eV+eD;
                        ori=sqrt((eH-eV)^2+ (eH-eD)^2+ (eV-eD)^2 )/et;
                        fs=(sH+sV)/2;
                        f=[f et ori fs];
                    end

                end
                toDec=newdec;
            end
            
                  
            
            
    end
    
end
             
info=0;

 function e=energy(x)
row=size(x,1);
col=size(x,2);
t=x.*x;
e=sum(sum(t));
e=(1/(row*col))*e;
       
   
