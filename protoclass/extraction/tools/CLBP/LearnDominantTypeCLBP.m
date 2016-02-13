%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    disCLBP_(S+M) Version 0.1
%    Authors: Yimo Guo, Guoying Zhao, and Matti Pietikainen
%
%    LearnDominantTypeCLBP(G,R,N,threshold,mapping) extracts
%    dominant pattern sets of image G with radius R and 
%    number of neighboring samples N, with threshold controling
%    the proportion of the dominant patterns will be selected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Dominant_Type_HistS,Dominant_Type_HistM] = LearnDominantTypeCLBP(G,R,N,threshold,mapping)


G = double(G);

[SHist,MHist,CHist] = clbp(double(G),R,N,mapping);
SHist = SHist';
MHist = MHist';

Num_Total_TypeS = size(SHist,1);
Num_Total_TypeM = size(MHist,1);

Type_IDS = 1:Num_Total_TypeS;
Type_IDS = Type_IDS';
Type_IDS = Type_IDS - 1;

Type_IDM = 1:Num_Total_TypeM;
Type_IDM = Type_IDM';
Type_IDM = Type_IDM - 1;

Total_Num_PatternS = sum(SHist);
Total_Num_PatternM = sum(MHist);

Threshold_NumS = floor(Total_Num_PatternS*threshold);
Threshold_NumM = floor(Total_Num_PatternM*threshold);

MS = [Type_IDS, SHist];
MM = [Type_IDM, MHist];

Configed_MS = sortrows(MS, 2);
Configed_MM = sortrows(MM, 2);

Des_MS = flipdim(Configed_MS,1);
Des_MM = flipdim(Configed_MM,1);

%% Find out the Cut Point
for index1 = 1:size(Des_MS,1)
    if(sum(Des_MS(1:index1,2))>=Threshold_NumS)
        cut_indexS = index1;
        break;
    end
end

for index1 = 1:size(Des_MM,1)
    if(sum(Des_MM(1:index1,2))>=Threshold_NumM)
        cut_indexM = index1;
        break;
    end
end

Dominant_Type_HistS = Des_MS(1:cut_indexS,1);
Dominant_Type_HistM = Des_MM(1:cut_indexM,1);
    






