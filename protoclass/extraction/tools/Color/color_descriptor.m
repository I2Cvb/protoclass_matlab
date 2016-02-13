function result=color_descriptor(Im,no_of_bins,reshape_size,patch_size)

% clear all
% close all
% 
% no_of_bins=36;
% reshape_size=80;
% [Im Map]= imread('T31.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Im1=double(imresize(Im, [reshape_size reshape_size]));
% patch_size=10;
method=4;

row_patch=floor(size(Im1,1)/patch_size);
col_patch=floor(size(Im1,2)/patch_size);

no_patch=1;

for k1=1:row_patch
    for k2=1:col_patch
        
    pr=Im1((k1-1)*patch_size+1:k1*patch_size,(k2-1)*patch_size+1:k2*patch_size,1);
    patches_R(:,no_patch)=reshape(pr,patch_size*patch_size,1);
    
    pg=Im1((k1-1)*patch_size+1:k1*patch_size,(k2-1)*patch_size+1:k2*patch_size,2);
    patches_G(:,no_patch)=reshape(pg,patch_size*patch_size,1);
    
    pb=Im1((k1-1)*patch_size+1:k1*patch_size,(k2-1)*patch_size+1:k2*patch_size,3);
    patches_B(:,no_patch)=reshape(pb,patch_size*patch_size,1);        
        
    no_patch=no_patch+1;
    
    end
end

if method == 1 
    
    result=Color_hist_normalization_feature(Im1,64,'RGB',MAP);

elseif method ==2
    
    result=Color_hist_normalization_feature(Im1,64,'HSV',MAP);

elseif method ==3

    result=Color_hist_normalization_feature(Im1,64,'LAB',MAP);

elseif method ==4
    
[out2]=HueDescriptor(patches_R,patches_G,patches_B,no_of_bins,2,1, patch_size);
if k1 ==1 && k2 == 1 
    res2=sum(out2,2)/1;
end


[out3]=OpponentDescriptor(patches_R,patches_G,patches_B,no_of_bins,2,1, patch_size);
if k1 ==1 && k2 == 1 
    res3=sum(out3,2)/1;
end


result=[res2;res3]';
% result=res3';
end
