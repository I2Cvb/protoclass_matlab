function [Acc, Sensitivity, Specificity, Precision] = Evaluation(Control, LabelTest)

%%%% TPR = Recall , Sensitiviy 
%%%% TNR = specificity 
%%%% Precision

error = sum(Control ~= LabelTest)/length(LabelTest); 
Acc = 1 - error; 
% [CM order] = confusionmat(LabelTest, Control); 
Pos = zeros (size(LabelTest)); 
Neg = zeros(size(LabelTest)); 

Pos (LabelTest == 1) = 1 ; 
Neg (LabelTest == -1) = 1 ; 
D = Control.*LabelTest; 
DPos = D.*Pos; 
DNeg = D.*Neg ; 

TP = sum(DPos == 1); 
TN = sum(DNeg == 1); 

FN = sum(DPos == -1); 
FP = sum(DNeg == -1);

%%% Sensitivity = Recall = TPR = TP/(TP+FN); 
if  TP~= 0 
    Sensitivity = TP /(TP + FN); 
    %%% Precision 
    Precision  = TP / (TP + FP); 
else
    Sensitivity = 0 ; 
    Precision = 0 ; 
end 


%%% Specificity  = TNR 
if TN ~= 0 
    Specificity = TN / (FP + TN); 
else 
    Specificity = 0 ; 
end 



%%% ConfMat 
ConfMat = [TP FP; FN TN]; 
