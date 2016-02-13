function [Acc, Sensitivity, Specificity, Precision] = EvaluationMultiClass( LabelTest, Control)

%%%% TPR = Recall , Sensitiviy 
%%%% TNR = specificity 
%%%% Precision
%%% In case of melanoma Label = 3 , order = 3 is melanoma, 

[ConfMat , order] = confusionmat(LabelTest, Control) ; 

for i = 1 : length(order)
   [Cols, Rows] = meshgrid (1:length(order), 1:length(order)); 
   Rows(i,:) = 0 ; 
   Cols(i,:) = 0 ; 
   order2 = order ; 
   order2(order(i)) = []; 
   
   TP(i).tp = ConfMat(i,i) ; 
   Sensitivity(i).SE = ConfMat(i,i)/ sum(ConfMat(i,:)); 
   
   FN(i).fn = 0 ; 
   for j = 1 : length(order2)
    FN(i).FN = FN(i).fn + ConfMat(i,order(j));    
   end 
   
   [m,n] = find(Cols == i) ; 
   FP(i).fp = 0 ; 
   for j = 1 : length(m)
       FP(i).fp = FP(i).np + ConfMat(m(j),n(j)); 
       Cols(m(j), n(j)) = 0 ; 
       Rows(m(j), n(j)) = 0 ; 
   end
   
   [m,n] = find(Cols ~=0) ; 
   TN(i).tn = 0 ; 
   for j = 1 : length(m)
       TN(i).tn = TN(i).tn + ConfMat(m(j),n(j)); 
       Cols(m(j), n(j)) = 0 ; 
       Rows(m(j), n(j)) = 0 ; 
   end
   
   
   Specificity(i).SP = TN(i).tn/(TN(i).tn+FP(i).fp); 
   
   Acc(i).acc = (TP(i).tp + TN(i).tn)/(TP(i).tp+TN(i).tn+FP(i).fp+FN(i).fn); 
   
   Precision(i).Pre = TP(i).tp/(TP(i).tp+FP(i).tp); 

end 
