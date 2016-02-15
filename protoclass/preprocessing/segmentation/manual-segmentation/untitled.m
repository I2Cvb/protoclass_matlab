Lists = dir('*.jpg'); 

for i = 1 : length(Lists)
     I = imread(Lists(i).name); 
     I = im2double(I);
     Imgname = Lists(i).name; 
     Imgname = Imgname(1:end-4); 
     imwrite(I, [Imgname '.png'] ,'png'); 
    
end 
