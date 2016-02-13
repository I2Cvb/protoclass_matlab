% disCLBP_(S+M) Version 0.1
% Authors: Yimo Guo, Guoying Zhao, and Matti Pietikainen

% The implementation is based on lbp code from MVG, Oulu University, Finland
% http://www.ee.oulu.fi/mvg/page/lbp_matlab
%  and CLBP code from the Hong Kong Polytechnic University, Hong Kong
% http://www.comp.polyu.edu.hk/~cslzhang/code/CLBP.rar


% Matlab Script DemoOutexDisCLBP
% This script runs the experiments of DisCLBP (dis(S+M))on the Outex Database for
% test suite TC_00012
% For Images and labels folder please download Outex Database from http://www.outex.oulu.fi, then
% extract Outex_TC_00012 to the "rootpic" folder

% rootdir = 'D:\Databases\Texture_Database\Outex\Outex_TC_00012\';
rootdir = 'P:\serverrun\databases\Outex_TC_00012\';

% Example to run on problem 001 of test suite Outex_TC_00012,
% you may also change the '001' on the following line to '000' to run
% problem 000 of test suite Outex_TC_00012
Problem_STR = '001';
trainfile = strcat(rootdir,Problem_STR,'\','train.txt');

fid = fopen(trainfile);
filename = textscan(fid,'%s');
namelist = filename{1};
Num_Sample = str2num(namelist{1,1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Construct Training Labels
%        and sample list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Labels_Train = [];
SampleList = [];
for index1 = 2:size(namelist,1)
    if(mod(index1,2)~=0)
        Labels_Train = [Labels_Train,str2num(namelist{index1,1})];
    else
        SampleList = [SampleList;namelist{index1,1}];
    end
end

fclose(fid);

%  Patterns of interests are the rotation invariant patterns for texture
%  classification
mapping1 = getmapping(8,'ri');
mapping2 = getmapping(16,'ri');
mapping3 = getmapping(24,'ri');


STotal_Dominant_Type_R1 = [];
STotal_Dominant_Type_R2 = [];
STotal_Dominant_Type_R3 = [];

MTotal_Dominant_Type_R1 = [];
MTotal_Dominant_Type_R2 = [];
MTotal_Dominant_Type_R3 = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  LEARNING PHASE 
%   learn the most discriminantive subset of patterns by considering feature robustness, 
%          feature discriminant power, and feature representation capability 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Conducting Learning Stage...');
%  This parameter controls how many dominant patterns will be selected from
%   each individual image, default is 0.9, means the subset of patterns
%   which can occupy 90% amount all the possible patterns will be selected
Thres_Val = 0.9;
imgpath = strcat(rootdir,'images');


for index2 = 1:size(SampleList,1)
    G = double(imread(strcat(imgpath,'/',SampleList(index2,:))));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    Layer 1: Extract dominant patterns from each image for Feature robustness
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [SDominant_Type_Hist_R1,MDominant_Type_Hist_R1] = LearnDominantTypeCLBP(G,1,8,Thres_Val,mapping1);
    [SDominant_Type_Hist_R2,MDominant_Type_Hist_R2] = LearnDominantTypeCLBP(G,2,16,Thres_Val,mapping2);
    [SDominant_Type_Hist_R3,MDominant_Type_Hist_R3] = LearnDominantTypeCLBP(G,3,24,Thres_Val,mapping3);    
    
    if(mod(index2,20)==1)  %Begin of a class
        SClass_Dominant_ID_List_R1 = SDominant_Type_Hist_R1;
        SClass_Dominant_ID_List_R2 = SDominant_Type_Hist_R2;
        SClass_Dominant_ID_List_R3 = SDominant_Type_Hist_R3;
        MClass_Dominant_ID_List_R1 = MDominant_Type_Hist_R1;
        MClass_Dominant_ID_List_R2 = MDominant_Type_Hist_R2;
        MClass_Dominant_ID_List_R3 = MDominant_Type_Hist_R3;
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %        Layer 2: Calculate class-specific dominant pattern sets 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SClass_Dominant_ID_List_R1 = RemoveDominantOutlier(SClass_Dominant_ID_List_R1,SDominant_Type_Hist_R1);
        SClass_Dominant_ID_List_R2 = RemoveDominantOutlier(SClass_Dominant_ID_List_R2,SDominant_Type_Hist_R2);
        SClass_Dominant_ID_List_R3 = RemoveDominantOutlier(SClass_Dominant_ID_List_R3,SDominant_Type_Hist_R3);
        MClass_Dominant_ID_List_R1 = RemoveDominantOutlier(MClass_Dominant_ID_List_R1,MDominant_Type_Hist_R1);
        MClass_Dominant_ID_List_R2 = RemoveDominantOutlier(MClass_Dominant_ID_List_R2,MDominant_Type_Hist_R2);
        MClass_Dominant_ID_List_R3 = RemoveDominantOutlier(MClass_Dominant_ID_List_R3,MDominant_Type_Hist_R3);

    end
       
    if(mod(index2,20)==0)  %End of a class
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Layer 3: Calculate the global dominant pattern sets of interest
        %                         for the whole database       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(size(STotal_Dominant_Type_R1,1)==0)
            STotal_Dominant_Type_R1 = [STotal_Dominant_Type_R1;SClass_Dominant_ID_List_R1];
            STotal_Dominant_Type_R2 = [STotal_Dominant_Type_R2;SClass_Dominant_ID_List_R2];
            STotal_Dominant_Type_R3 = [STotal_Dominant_Type_R3;SClass_Dominant_ID_List_R3];
            MTotal_Dominant_Type_R1 = [MTotal_Dominant_Type_R1;MClass_Dominant_ID_List_R1];
            MTotal_Dominant_Type_R2 = [MTotal_Dominant_Type_R2;MClass_Dominant_ID_List_R2];
            MTotal_Dominant_Type_R3 = [MTotal_Dominant_Type_R3;MClass_Dominant_ID_List_R3];
        else
            STotal_Dominant_Type_R1 = MergeDominantType(STotal_Dominant_Type_R1,SClass_Dominant_ID_List_R1);
            STotal_Dominant_Type_R2 = MergeDominantType(STotal_Dominant_Type_R2,SClass_Dominant_ID_List_R2);
            STotal_Dominant_Type_R3 = MergeDominantType(STotal_Dominant_Type_R3,SClass_Dominant_ID_List_R3);
            MTotal_Dominant_Type_R1 = MergeDominantType(MTotal_Dominant_Type_R1,MClass_Dominant_ID_List_R1);
            MTotal_Dominant_Type_R2 = MergeDominantType(MTotal_Dominant_Type_R2,MClass_Dominant_ID_List_R2);
            MTotal_Dominant_Type_R3 = MergeDominantType(MTotal_Dominant_Type_R3,MClass_Dominant_ID_List_R3);
        end
    end
        
end   


%%Save the learnt global dominant pattern sets with respect to each scales
%%of interest for both S and M
save('Outex_DominantTypeCLBP', 'STotal_Dominant_Type_R1','STotal_Dominant_Type_R2','STotal_Dominant_Type_R3','MTotal_Dominant_Type_R1','MTotal_Dominant_Type_R2','MTotal_Dominant_Type_R3');

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     TRAINING PHASE
% Extract S+M histogram features from training images based on the global dominant pattern sets
%                           obtained in the learning phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Conducting Training Stage...');
% Load the global dominant pattern sets learnt from the learning phase
load Outex_DominantTypeCLBP;

Sfeature_hist1 = zeros(size(STotal_Dominant_Type_R1,1),1);
Sfeature_hist2 = zeros(size(STotal_Dominant_Type_R2,1),1);
Sfeature_hist3 = zeros(size(STotal_Dominant_Type_R3,1),1);
Mfeature_hist1 = zeros(size(MTotal_Dominant_Type_R1,1),1);
Mfeature_hist2 = zeros(size(MTotal_Dominant_Type_R2,1),1);
Mfeature_hist3 = zeros(size(MTotal_Dominant_Type_R3,1),1);

%imgpath = strcat(rootdir,'images');
global_feature = [];

% Here begins the feature extraction stage
for index2 = 1:size(SampleList,1)
    G = imread(strcat(imgpath,'/',SampleList(index2,:)));
    feature_vector1 = [];     
    
    [L1S,L1M,L1C] = clbp(double(G),1,8,mapping1,'nh');
    L1S = L1S';
    L1M = L1M';    
    
    
    for index7 = 1:size(STotal_Dominant_Type_R1,1)
        Sfeature_hist1(index7,1) = L1S((STotal_Dominant_Type_R1(index7,1)+1),1);
    end         
        
   for index7 = 1:size(MTotal_Dominant_Type_R1,1)
       Mfeature_hist1(index7,1) = L1M((MTotal_Dominant_Type_R1(index7,1)+1),1);
   end    
    
   feature_vector1 = [feature_vector1;Sfeature_hist1;Mfeature_hist1];
   
   
   feature_vector2 = [];       
   [L2S,L2M,L2C] = clbp(double(G),2,16,mapping2,'nh');
   L2S = L2S';
   L2M = L2M';
   
   
   for index8 = 1:size(STotal_Dominant_Type_R2,1)
       Sfeature_hist2(index8,1) = L2S((STotal_Dominant_Type_R2(index8,1)+1),1);
   end    
        
   for index8 = 1:size(MTotal_Dominant_Type_R2,1)
       Mfeature_hist2(index8,1) = L2M((MTotal_Dominant_Type_R2(index8,1)+1),1);
   end  
   
   feature_vector2 = [feature_vector2;Sfeature_hist2;Mfeature_hist2];
   
   
   feature_vector3 = [];       
   [L3S,L3M,L3C] = clbp(double(G),3,24,mapping3,'nh');
   L3S = L3S';
   L3M = L3M';
   
   for index9 = 1:size(STotal_Dominant_Type_R3,1)
       Sfeature_hist3(index9,1) = L3S((STotal_Dominant_Type_R3(index9,1)+1),1);
   end     
        
   for index9 = 1:size(MTotal_Dominant_Type_R3,1)
       Mfeature_hist3(index9,1) = L3M((MTotal_Dominant_Type_R3(index9,1)+1),1);
   end     
   
   feature_vector3 = [feature_vector3;Sfeature_hist3;Mfeature_hist3];
   
   feature_vector = [feature_vector1;feature_vector2;feature_vector3];
   global_feature = [global_feature,feature_vector];
end   %%Finish feature extraction from training set


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Normalization of each dimension of features to [-1,1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Samples = global_feature;

minSamples=min(Samples,[],2);
maxSamples=max(Samples,[],2);
normalize_para_1 = minSamples;
normalize_para_2 = maxSamples;
Samples=((Samples-(minSamples*ones(1,size(Samples,2))))./((maxSamples-minSamples)*ones(1,size(Samples,2)))-0.5)*2;
Samples_Train = Samples;

%%Save the training image features
save('Training_Outex_LCLBP','Labels_Train','Samples_Train','minSamples','maxSamples');

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     TESTING PHASE
% Extract S+M histogram features from testing images based on the global dominant pattern sets
%                           obtained in the learning phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
disp('Conducting Testing Stage...');

testfile = strcat(rootdir,Problem_STR,'/','test.txt');

%testfile = strcat('D:\Temp\Texture Database\Outex\Outex_TC_00001\Outex_TC_00001\000','\','test.txt');
fid = fopen(testfile);
filename = textscan(fid,'%s');
namelist = filename{1};
Num_Sample = str2num(namelist{1,1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Construct Testing Labels
%        and sample list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Labels_Test = [];
SampleList = [];
for index1 = 2:size(namelist,1)
    if(mod(index1,2)~=0)
        Labels_Test = [Labels_Test,str2num(namelist{index1,1})];
    else
        SampleList = [SampleList;namelist{index1,1}];
    end
end

fclose(fid);

% Load the global dominant pattern sets learnt from the learning phase
load Outex_DominantTypeCLBP;

Sfeature_hist1 = zeros(size(STotal_Dominant_Type_R1,1),1);
Sfeature_hist2 = zeros(size(STotal_Dominant_Type_R2,1),1);
Sfeature_hist3 = zeros(size(STotal_Dominant_Type_R3,1),1);
Mfeature_hist1 = zeros(size(MTotal_Dominant_Type_R1,1),1);
Mfeature_hist2 = zeros(size(MTotal_Dominant_Type_R2,1),1);
Mfeature_hist3 = zeros(size(MTotal_Dominant_Type_R3,1),1);

%imgpath = strcat(rootdir,'images');
global_feature = [];

% Here begins the feature extraction stage
for index2 = 1:size(SampleList,1)
    G = imread(strcat(imgpath,'/',SampleList(index2,:)));
    feature_vector1 = [];     
    
    [L1S,L1M,L1C] = clbp(double(G),1,8,mapping1,'nh');
    L1S = L1S';
    L1M = L1M';    
    
    
    for index7 = 1:size(STotal_Dominant_Type_R1,1)
        Sfeature_hist1(index7,1) = L1S((STotal_Dominant_Type_R1(index7,1)+1),1);
    end         
        
   for index7 = 1:size(MTotal_Dominant_Type_R1,1)
       Mfeature_hist1(index7,1) = L1M((MTotal_Dominant_Type_R1(index7,1)+1),1);
   end    
    
   feature_vector1 = [feature_vector1;Sfeature_hist1;Mfeature_hist1];
   
   
   feature_vector2 = [];       
   [L2S,L2M,L2C] = clbp(double(G),2,16,mapping2,'nh');
   L2S = L2S';
   L2M = L2M';
   
   
   for index8 = 1:size(STotal_Dominant_Type_R2,1)
       Sfeature_hist2(index8,1) = L2S((STotal_Dominant_Type_R2(index8,1)+1),1);
   end    
        
   for index8 = 1:size(MTotal_Dominant_Type_R2,1)
       Mfeature_hist2(index8,1) = L2M((MTotal_Dominant_Type_R2(index8,1)+1),1);
   end  
   
   feature_vector2 = [feature_vector2;Sfeature_hist2;Mfeature_hist2];
   
   
   feature_vector3 = [];       
   [L3S,L3M,L3C] = clbp(double(G),3,24,mapping3,'nh');
   L3S = L3S';
   L3M = L3M';
   
   for index9 = 1:size(STotal_Dominant_Type_R3,1)
       Sfeature_hist3(index9,1) = L3S((STotal_Dominant_Type_R3(index9,1)+1),1);
   end     
        
   for index9 = 1:size(MTotal_Dominant_Type_R3,1)
       Mfeature_hist3(index9,1) = L3M((MTotal_Dominant_Type_R3(index9,1)+1),1);
   end     
   
   feature_vector3 = [feature_vector3;Sfeature_hist3;Mfeature_hist3];
   
   feature_vector = [feature_vector1;feature_vector2;feature_vector3];
   global_feature = [global_feature,feature_vector];
end   %%Finish feature extraction from testing set


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Normalization of each dimension of features to [-1,1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load Training_Outex_LCLBP
Samples = global_feature;
Samples=((Samples-(minSamples*ones(1,size(Samples,2))))./((maxSamples-minSamples)*ones(1,size(Samples,2)))-0.5)*2;
Samples_Test = Samples;

%%Save the testing image features
save('Testing_Outex_LCLBP','Labels_Test','Samples_Test');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            CLASSIFICATION STAGE
% Input the features extracted from training and testing set and groundtruth labels
%        to the classifier to compute the classification accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nearest neighbor classifier with L1 distance is adopted
[final_accu,PreLabel] = NNClassifier(Samples_Train,Samples_Test,Labels_Train,Labels_Test);
Classification_Accuracy = final_accu;
Classification_Accuracy

