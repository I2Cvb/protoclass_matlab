%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mojdeh Rastgoo , 13-08-13
%%%% FeatureExtraction_Wavelet 
%%%% This function provides the choice between wavelet analysis, either on
%%%% the approximation or details and wavelet packets 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUT:
% I     : Image rgb 
% if I is gray Image , the coloroption should be set to 'g'
% wname = wavelet name ; 
% RI = determines if we combine features or not , RI = 0 ==> 4
% decomposition (CA, eH, eV, eD) will be analysed 
% RI = 1 ==> eH, eV, eD will be combined in 
% Ori  = sqrt((eV-eH)^2 + (eV-eD)^2 + (eD-eH)^2)/(eH+eV+eD); 
% RI = 2 ==> FV = [eH, eV, eD, Ori]
% option = Low Decomposition; wavelet Packets {'WAL','WAH', 'WP'} respectively 
% coloroption = either gray scale analysis, or rgb analysis , or rgbl
% analysis {'g' 'rgb' 'rgbl'}
% nlevel = number of decompositions 

% OUTPUT :
% FV : feature vector containing all features coputed and normalized


function FV =ExtractFeatures_wavelet(I,wname,RI,option,coloroption, nlevel)
% for each wavelet in do
      
    if coloroption == 'g' 
        FV=[];
        im = I ; 
        if  strcmp( 'WA' , option(1:end-1))
            for l=1:nlevel
                [cA,cH,cV,cD]=dwt2(im,wname);
                if l==1 
                    mA=measureFV(cA);
                end
                mH = measureFV(cH); mV = measureFV(cV); mD = measureFV(cD);                                 
                f = ChekingOption (RI, mA, mH, mV, mD); 
                FV  = [FV f]; 
                 % decompose the submage with higher energy
                if strcmp('H', option(end))
                     eA=energy(cA); eH = energy(cH); eV = energy(cV); eD = energy(cD); 
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
            %%% Total Length of Feature Vector = 8*4*nlevel + 8
            FV =[FV mA];
            
        elseif strcmp(option , 'WP')
            
            FV = waveletPacketFeature (nlevel, im , wname, RI); 
        
        end 
        
    elseif strcmp(coloroption ,'rgb')
        R = mat2gray(I(:,:,1)); 
        G = mat2gray(I(:,:,2)); 
        B = mat2gray(I(:,:,3)); 
        
        FV.R = waveletPacketFeature (nlevel, R , wname, RI); 
        FV.G = waveletPacketFeature (nlevel, G , wname, RI); 
        FV.B = waveletPacketFeature (nlevel, B , wname, RI); 
            
            
        
        
    elseif strcmp(coloroption , 'rgbl')
        
        R = mat2gray(I(:,:,1)); 
        G = mat2gray(I(:,:,2)); 
        B = mat2gray(I(:,:,3)); 
        L = (0.29.*R) + (0.59.*G) + (0.11.*B); 
        
        FV.R = waveletPacketFeature (nlevel, R , wname, RI); 
        FV.G = waveletPacketFeature (nlevel, G , wname, RI); 
        FV.B = waveletPacketFeature (nlevel, B , wname, RI); 
        FV.L = waveletPacketFeature (nlevel, L , wname, RI); 
        
    end
    
    
    function  F = waveletPacketFeature (nlevels, Img , wname, RI)
        F = []; 
            T = wpdec2(Img,0,wname); 
            [T,cA, cH, cV, cD] = wpsplt(T,0); 
            mA = measureFV(cA); mH = measureFV(cH); 
            mV = measureFV(cV); mD = measureFV(cD); 
            f  = ChekingOption (RI, mA, mH, mV, mD) ; 
            [RmA RmH RmV RmD] = measureRm(mA, mH, mV, mD); 
            [RfA RfH RfV RfD] = measureRf(mA, mH, mV, mD); 
            F = [F f RmA RmH RmV RmD RfA RfH RfV RfD]; 
            j = 1 ; 
            currIdx = 1 ; 
            lastIdx = 0 ; 
            for l = 1 : nlevels-1   
                Nodes  = currIdx : 4^l + lastIdx;   
                for i = 1 : length(Nodes)
                    [T, cA, cH, cV, cD] = wpsplt(T,Nodes(i)); 
                    mA = measureFV(cA); mH = measureFV(cH); 
                    mV = measureFV(cV); mD = measureFV(cD); 
                    f  = ChekingOption (RI, mA, mH, mV, mD) ; 
                    [RmA RmH RmV RmD] = measureRm(mA, mH, mV, mD); 
                    [RfA RfH RfV RfD] = measureRf(mA, mH, mV, mD); 
                    F = [F f RmA RmH RmV RmD RfA RfH RfV RfD];
                    j = j+1 ; 
                end 
                currIdx = Nodes(end)+1;    
                lastIdx = Nodes(end); 
                
            end 
          

    
    function [RmA RmH RmV RmD] = measureRm(mA, mH, mV, mD)
        tem = []; 
        tem = [tem; mA; mH; mV; mD]; 
        RmA  = mA./max(tem); 
        RmH  = mH./max(tem); 
        RmV  = mV./max(tem); 
        RmD  = mD./max(tem); 
        
    function [RfA RfH RfV RfD] = measureRf(mA, mH, mV, mD)
        tem = mA + mH + mV +mD ; 
        RfA = mA./tem; 
        RfH = mH./tem; 
        RfV = mV./tem; 
        RfD = mD./tem; 
            
        
        


function f = ChekingOption (RI, mA, mH, mV, mD)
f = []; 
             % RI = 0 ; 
                
             if RI==0 
                     f =[f mA mH mV mD];
             end
             % RI == 1 
             if RI==1
                mt=mH+mV+mD;
                ori=sqrt((mH-mV).^2+ (mH-mD).^2+ (mV-mD).^2 )./mt;
                f =[f mt ori];
             end
             % Both Rotation invariant and variant features
             if RI==2
                mt=mH+mV+mD;
                ori=sqrt((mH-mV).^2+ (mH-mD).^2+ (mV-mD).^2 )./mt;
                f=[f mH mV mD mt ori];
             end
    
    
function  e=energy(x)
row=size(x,1);
col=size(x,2);
t=x.*x;
e=sum(sum(t));
e=(1/(row*col))*e;


function m = measureFV(x)
    row = size(x,1); 
    col = size(x,2);
    N = row*col; 
    m = zeros(1,8); 
    % Energy 
    m(1) = sum(sum(x.^2))/N;
    
    % Mean
    m(2) = sum(sum(x))/N; 
    
    % Standard deviation 
    m(3) = sum(sum(x-m(2)))/N; 
    
    %Average Energy 
    m(4) = sum(sum(abs(x)))/N; 
    
    % Skewness
    m(5) = sum(sum(((x-m(2))./m(3)).^3))/N; 
    
    % Kurtosis 
    m(6) = sum(sum(((x-m(2))./m(3)).^4))/N;
    
    % Norm 
    m(7) = max(sqrt(eig(x*x'))); 
    
    % Entropy 
    m(8) = sum(sum((x.^2).*log((x.^2))))/N; 