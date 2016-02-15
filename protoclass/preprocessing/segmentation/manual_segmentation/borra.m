dirAns = dir('images');
imNames = dirAns( ~[dirAns(:).isdir] );

if ~isdir('images/GT')
    mkdir('images/GT');
end

for imIdx = 1:length(imNames);
    
    try
        I = imread(['images/' imNames(imIdx).name]);
    catch
        I = dicomread(['images/' imNames(imIdx).name]);
    end
    
    if size(I,3)==1
        I = repmat(I,[1 1 3]);
    end
    
    namePoints = strfind(imNames(imIdx).name,'.');
    lastPointName = namePoints(end);
    dirAns = dir(['images/GT/' imNames(imIdx).name(1:lastPointName-1) '*'])
    
    imshow(I); hold on;
    for i=1:length(dirAns)
        contour(imread(['images/GT/' dirAns(i).name]),.5,'r');
    end
    hold off;
end