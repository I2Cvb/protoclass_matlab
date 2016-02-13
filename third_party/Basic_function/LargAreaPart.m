%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Selecting the biggest segmentated area from Mask 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MaskOut = LargAreaPart(Mask)
    ILabel = bwlabel(Mask,8);
    stat = regionprops(ILabel,'Centroid','Area','PixelIdxList');
    [maxValue,index] = max([stat.Area]);
    MaskOut = zeros(size(Mask)); 
    MaskOut(stat(index).PixelIdxList)=1;