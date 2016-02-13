%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mojdeh Rastgoo 
%%% sparatingfile
%%% Separating the data according to the percentage, mentioned by the user 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TrainingIdx , TestingIdx] = separationFile(Data, percentage) 


    % percentage indicates the training indexes 

    datacpy = Data; 
    
    %classes = unique(Data(3:end, 3)); 
    datalength = length(Data); 
    classes = unique(Data); 
    [class1IDX, class1] = find(Data == classes(1)) ; 
    [class2IDX, class2]= find(Data == classes(2)); 
    
    spilitPercentageClass1 = (percentage/100)*sum(class1); 
    spilitPercentageClass2 = (percentage/100)*sum(class2); 
    randomIndexClass1 = randi(sum(class1), [spilitPercentageClass1,1]); 
    randomIndexClass2 = randi(sum(class2), [spilitPercentageClass2,1]); 
    dClass1 = spilitPercentageClass1 - length(unique(randomIndexClass1));
    dClass2 = spilitPercentageClass2 - length(unique(randomIndexClass2)); 
    
    randomIndexClass1 = unique(randomIndexClass1); 
    randomIndexClass2 = unique(randomIndexClass2); 
    
   
    TrainingClass1Idx = []; 
    TrainingClass2Idx = []; 
    TrainingClass1Idx = [TrainingClass1Idx ; randomIndexClass1]; 
    TrainingClass2Idx = [TrainingClass2Idx ; randomIndexClass2]; 
    
    
       j = 1 ; 
   
    while j <= dClass1
       v = randi(sum(class1), [1,1]); 
       f = find(TrainingClass1Idx == v); 
       if isempty(f)
          TrainingClass1Idx = [TrainingClass1Idx; v]; 
          j = j+1; 
       end 
   
    end 
    
    
       j = 1 ; 
   
    while j <= dClass2
       v = randi(sum(class2), [1,1]); 
       f = find(TrainingClass2Idx == v); 
       if isempty(f)
          TrainingClass2Idx = [TrainingClass2Idx; v]; 
          j = j+1; 
       end 
   
    end 
    
    TrainingIdx = zeros (length(class1IDX (TrainingClass1Idx)) + length(class2IDX(TrainingClass2Idx)),1); 
    TrainingIdx (1:length(class1IDX (TrainingClass1Idx))) =  class1IDX (TrainingClass1Idx)'; 
    TrainingIdx (length(class1IDX (TrainingClass1Idx)) + 1 : end) = class2IDX(TrainingClass2Idx)'; 

   t = zeros(datalength,1); 
   t (TrainingIdx) = 1; 
   TestingIdx = find(t == 0); 
   %TestingIdx = TestingIdx+2; 
   %TrainingIdx = TrainingIdx+2; 
    
    
    
%     %datalength = length(Data)-2; 
%     datalength = length(Data); 
%     spilitPercentage = (percentage/100)*datalength; 
%     randomIndex = randi(datalength, [spilitPercentage,1]); 
%     d = spilitPercentage - length(unique(randomIndex)); 
%     randomIndex = unique(randomIndex) ; 
% 
%     TrainingIdx = []; 
%     Indextem = []; 
%     TrainingIdx = [TrainingIdx; randomIndex];

%    j = 1 ; 
%    
%    while j <= d 
%        v = randi(datalength, [1,1]); 
%        f = find(TrainingIdx == v); 
%        if isempty(f)
%           TrainingIdx = [TrainingIdx; v]; 
%           j = j+1; 
%        end 
%    
%    end 
%    

   
   

   
%    datacpy(TrainingIdx,4) = {0};
%    
%    for i = 1 : datalength+2
%        temp = cell2mat(Data(i,3));
%        if (strcmpi(temp, 'Malignant'))
%            datacpy(i,3) = {1}; 
%        elseif (strcmpi(temp, 'Dysplastic'))
%            datacpy(i,3) = {2};
%        elseif (strcmpi(temp, 'Dysplastic'))
%            datacpy(i,3) = {2};
%        end    
%    end 
%    
%   
   
   
   



