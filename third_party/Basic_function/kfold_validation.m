%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kfold_validation.m 
%%% Author: Mojdeh Rastgoo
%%% UB - UdG
%%% Version: 1.0
%%% Input: labels, fold, rep
%%% Output: testingIdx, trainingIdx
%%% Note: this function is based on cvpartition thus the percentage of
%%% training and testing set based on the partitions are : 
%%% fold  | training | testing 
%%%----------------------------
%%% 10    |  90%     | 10%
%%% 5     |  80%     | 20%
%%% 4     |  75%     | 25%
%%% 3     |  67%     | 33%
%%% 5     |  50%     | 50% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [trainingIdx, testingIdx] = kfold_validation (labels, fold, rep)

trainingIdx = []; 
testingIdx = []; 
repIdx = 0 ; 
while repIdx <= rep 
    partitions = cvpartition(labels, 'kfold', fold); 
    %%% Check if the size of trainingIdx and testingIdx returned by cvpartition
    %%% is the same for all the samples
    testSize = partitions.TestSize; 
    n = unique(testSize); 
    if length(n) ~= 1 
        testSize = testSize - max(n); 
    end
    testSize = abs(testSize); 

    temp_trainIdx = zeros(length(labels) - max(n), partitions.NumTestSets);
    temp_testIdx = zeros(max(n), partitions.NumTestSets); 
    indexList = 1 : length(labels); 
    %%% Reading the indexes of the paritions 
    for Id  =  1 : partitions.NumTestSets
        trainIdx_cv = indexList(partitions.training(Id) ==1); 
        testIdx_cv = indexList(partitions.test(Id) == 1); 
        if testSize(Id) ~= 0
            temp_trainIdx(:,Id) = trainIdx_cv(1:end-testSize(Id)); 
            temp_testIdx(1:end-testSize(Id),Id) = testIdx_cv; 
            temp_testIdx(end-testSize(Id)+1:end, Id) = trainIdx_cv(end-testSize(Id)+1 : end ); 
        else 
            temp_trainIdx(:,Id) = trainIdx_cv; 
            temp_testIdx(:,Id) = testIdx_cv; 
        end 
        trainingIdx = [trainingIdx,temp_trainIdx(:,Id)]; 
        testingIdx = [testingIdx, temp_testIdx(:,Id)]; 
        %%% updating the repetition index until the demanded iteration is
        %%% achieved
        repIdx = repIdx +1; 
        if repIdx == rep
            return
        end 
    end  
    
end 