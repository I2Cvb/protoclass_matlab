%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Classification.m 
%%% Author: Mojdeh Rastgoo
%%% UB-UdG
%%% Version: 1.0
%%% ---------------------------------------------------
%%% Classifier | Params  
%%% ---------- |----------------------------------------
%%% RF         | ntree (default = 100), mtry (default = floor(sqrt(size(training_data,2)))) , extra.option 
%%% SVM        | svm_kernel: (0,1,2) 
%%% GB         | GB.shrinkageFactor(default = 0.1) , GB.loss (default = exploss), GB.sunsamplingFactor (default = 0.6), GB.iterations (default = 1000), 
%%%              GB.treedepth (default = 4), GB.randSeed (default = rand().*1000)
%%% knn        | k(default = 3)
%%% lda        | 
%%% -------------------------------------------------------
%%% Note : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [pred_label, pred_prob] = classification(training_data,training_label ,testing_data, testing_label, classifierId, varargin)

    addpath ../../third_party/Basic_function/

    %%% Parameters initialization 
    input.validation_data = []; 
    input.validation_label = []; 
    %%%% input.svm_kernel [linear , RBF, polynomial] = [0, 1, 2]; 
    input.svm_kernel = 1 ; 
    %%%% input.GB_loss = ['exploss', 'squaredloss']; 
    input.GB.loss = 'exploss' ; 
    input.GB.randSeed = uint32(rand()*1000); 
    input.GB.shrinkageFactor = 0.1; 
    input.GB.subsamplingFactor = 0.6;
    input.GB.iterations = 1000; 
    input.GB.maxTreeDepth = uint32(2) ; 
    input.ntree = 100; 
    %%%% default value: input.RF_mtry =  floor(sqrt(size(X,2))) D=number of features in X
    input.RF_mtry = floor(sqrt(size(training_data,2))); 
    %%%% extra options can be added by the user accoding to the extra_option of
    %%%% the RF classifier 
    input.k = 3 ; 
    input = parseargs(input,varargin{:});

    %--------------------------------------------------------------------------

    if (strncmpi('RF', classifierId, 2) == 1)
        addpath ../../third_party/RF_Class_C/
        %%% Training        
        classifier  = classRF_train(training_data, training_label,input.ntree); 
        %%% Test
        [pred_label, Votes ] = classRF_predict(testing_data, classifier);
        [Val, col] = max(Votes, [],2); 
        Val (col ==1 ) = -1*Val(col==1); 
        Val= Val/input.ntree; 
        %%% Val or probability prediction has positive and negative sign
        %%% indicating the probabality twards different classes
        %%% To have the probabailiy of positive class only 
        Val(Val<0) = 1 + Val(Val< 0); 
        pred_prob= Val;   

    elseif (strncmpi('SVM', classifierId, 3) == 1)
       addpath ../../third_party/libsvm/matlab/
      
       %%% Training        
       [bestc, bestg] = computeBestParameter(double(training_label), double(training_data), input.svm_kernel); 
       param = ['-t ' num2str(input.svm_kernel) ' -c ' num2str(bestc) ' -g '  num2str(bestg) ' -b 1' ];
       addpath ../../third_party/libsvm/matlab/
       classifier = libsvmtrain(double(training_label),double(training_data), param); 

       %%% Test
       [pred_label, ~, pred_prob ] = libsvmpredict(double(testing_label), double(testing_data), classifier, '-b 1');  
       pred_prob = pred_prob(:,2); 
       

    elseif (strncmpi('GB', classifierId, 2) == 1)
        addpath ../../third_party/Gradient-Boosting/build
        %%% Training
        optsGradient = input.GB ; 
        classifier = SQBMatrixTrain(single(training_data), training_label, uint32(optsGradient.iterations), optsGradient);
        %%% Test
        %%% Note that the output of the model SQBMatrixPredict is the score
        %%% returned by the prediction model 
        pred_prob = SQBMatrixPredict(classifier , single(testing_data));
        pred_label= sign( pred_prob);  

    elseif (strncmpi('LDA', classifierId, 3) == 1)
        addpath ../../third_party/prtools/prtools/
        %%% Training  
        training_labelCP = training_label; 
        training_labelCP(training_label == -1) = 0 ; 
        TrainData = prdataset(training_data, training_labelCP); 
        classifier = fisherc(TrainData); 
        %%% Test
        TestData = prdataset(testing_data); 
        classifier_map = TestData*classifier; 
        pred_label = labeld(classifier_map); 
        [Val, col] = max(classifier_map.data, [],2); 
        Val (col ==1 ) = -1*Val(col==1); 
        pred_prob = Val;  
        pred_label(pred_label == 0) = -1; 

    elseif (strncmpi('KNN', classifierId, 3) == 1)
        addpath ../../third_party/prtools/prtools/
        %%% Training  
        training_labelCP = training_label; 
        training_labelCP(training_label == -1) = 0 ; 
        TrainData = prdataset(training_data, training_labelCP); 
        classifier = knnc(TrainData, input.k); 
        %%% Test
        TestData = prdataset(testing_data); 
        classifier_map = TestData*classifier; 
        pred_label = labeld(classifier_map); 
        pred_label(pred_label == 0) = -1 ; 
        [Val, col] = max(classifier_map.data, [],2); 
        Val (col ==1 ) = -1*Val(col==1); 
        pred_prob = Val;   
        pred_label(pred_label == 0) = -1 ; 

    end 

    
