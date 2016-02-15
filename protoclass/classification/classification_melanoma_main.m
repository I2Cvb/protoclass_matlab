%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% classification_melanoma_main.m
%%% Author : Mojdeh Rastgoo 
%%% UB-UdG 
%%% Version : 1.0 
%%% Two option exists for validation either cross validation or leave one
%%% out the user should specify this option at the begining, otherwise cv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath ../../third_party/Basic_function/
    addpath ../validation/
    addpath ../extraction/

    %%% Initialization
    dataPath = '/home/mojdeh/Documents/PhD/Coding/OrganizedCode/protoclass_matlab/data';
    resultPath = '/home/mojdeh/Documents/Coding/OrganizedCode/protoclass_matlab/protoclass/results/';
    load(fullfile(dataPath, 'PH2_Train_Test_80_20.mat')); 
    Labels = BinaryLabels; 
    
    %%% feature.csv for global features and feature_Patch.csv for local
    %%% features feature_Bow.csv for high-level using bow  and
    %%% feature_scf.csv for high-level using scf.
    
    FeatureLists = csv2cell(fullfile(dataPath, 'feature_Patch.csv'), 'fromfile'); 
    FeatureLists = FeatureLists(2:end); 
    validation.opt = 'CV'; 
    %%% List of features and their combination based on the csv file feature.csv 
%     FIdx = [1 0 0 0 ; 0 2 0 0 ; 0 0 3 0 ; 0 0 0 4 ; 0 0 3 4 ; 1 2 0 0 ; 1 0 3 4 ;...
%         0 2 3 4 ; 1 2 3 4]; 
    FIdx = [1]; 


    for IND = 1 : length(FIdx)

        FVCombined = []; 
        %%% Loading the appropriate data based on the FIdx 
        Index = FIdx(IND,:); 
        NonZeroIndex = find(Index~=0); 
        NonZeroIndex = Index(NonZeroIndex); 
        for PathIdx = 1 : length(NonZeroIndex)
            load(fullfile(dataPath, cell2mat(FeatureLists(NonZeroIndex(PathIdx))))); 
            FV = FV'; 
            display(['Feature:' cell2mat(FeatureLists(NonZeroIndex(PathIdx)))]); 
            FVCombined = [FVCombined, FV]; clear FV ; 
        end
        
        FV = FVCombined;    
        FeatureSize = size(FV, 2);  
        display(['The Features in line .... ' num2str(IND)  'are being analysed']); 
                
        %%% Choice of classifier 
        classifierId = 'rf'; 
        
        %%%  high level representation parameters -------------------------
        %%% This option provide the choice to join the high representation
        %%% with the classification, however if your high-level features
        %%% are saved in advance use 'none' option.
        
        %%% high_level_Id = ['bow', 'scf', 'none']; 
        high_level_Id = 'scf'; 
        
        %%% The parameters for high level representation. 
        dSize = 200; 
        sLevel = 2 ; 
        nWords = 20; 
        %%% ---------------------------------------------------------------

        %%% Classification validation based on validation_opt = 'CV' or 'OvA'
        %%%% Validation_opt = CV 
        
        if strncmpi(validation.opt , 'CV', 2) == 1 
            pred_label = zeros(size(testingIdx)); 
            pred_prob  = zeros(size(testingIdx)); 
            for cv = 5 : size(trainingIdx,2)
                training_data = FV(trainingIdx(:,cv),:); 
                training_label= Labels(trainingIdx(:,cv)); 
                testing_data = FV(testingIdx(:,cv),:); 
                testing_label = Labels(testingIdx(:,cv)); 
                
                if (strncmpi('none', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' was chosen for classification'])
                    
                elseif (strncmpi('bow', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' and ' high_level_Id ' with ' num2str(nWords) ' was chosen for classification'])
                     [Bow_model, training_data, testing_data] = Codebook_BoW (training_data, testing_data, nWords); 
                     
                elseif (strncmpi('scf', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' and ' high_level_Id ' with ' num2str(sLevel) ' and dictionary size of ' num2str(dSize)  ' was chosen for classification'])
                    [params, training_data, testing_data] = Codebook_SCF (training_data, testing_data, 'dSize', 100); 

                end 
                
                %%% Classification
                [pred_label(:,cv) pred_prob(:,cv)] = classification(training_data, training_label, testing_data, testing_label, classifierId , 'ntree', 50,'svm_kernel', 1); 
                [acc(cv), sen(cv), spec(cv), prec(cv)] = Evaluation(testing_label, pred_label(:,cv));
                if (sen(cv) == 0 && prec(cv) == 0) || (spec(cv) == 0) 
                    x(:,cv) = 0 ; y(:,cv) = 1 ; t(:,cv) = 0 ; auc(cv) = 0 ; 
                else 
                    [x(:,cv),y(:,cv),t(:,cv),auc(cv)] = perfcurve(testing_label,pred_label(:,cv),'1');
                end 
            end 
            Acc = mean(acc); Sen = mean(sen); Spec = mean(spec); Prec = mean(prec); 
            AUC = mean(auc); 
            X = mean(x,2); 
            Y = mean(y,2); 
            resultName = 'GiveaName.mat'; 
            save(fullfile(resultPath, resultName), 'Acc', 'Sen', 'Spec', 'Prec', 'AUC', 'X', 'Y'); 

        %%%% Validation_opt = OvA 
        elseif strncmpi (validation.opt , 'OvA', 3) == 1
            IndexList = 1 :1: length(Labels);  
            for Id = 1: length(Labels)
                Index = IndexList ; 
                Index(Id) = []; 
                testing_data = FV(IndexList(Id), :); 
                testing_label = Labels(IndexList(Id));
                training_data = FV(Index,:); 
                training_label = Labels(Index);
                
                
                if (strncmpi('none', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' was chosen for classification'])
                    
                elseif (strncmpi('bow', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' and ' high_level_Id ' with ' num2str(nWords) ' was chosen for classification'])
                     [Bow_model, training_data, testing_data] = Codebook_BoW (training_data, testing_data, nWords); 
                     
                elseif (strncmpi('scf', high_level_Id, 4) == 1)
                    
                    disp ([classifierId ' and ' high_level_Id ' with ' num2str(sLevel) ' and dictionary size of ' num2str(dSize)  ' was chosen for classification'])
                    [params, training_data, testing_data] = Codebook_SCF (training_data, testing_data, 'dSize', 100); 

                end 
                
                
                %%% classification 
                disp ([classifierId 'was chosen for classification'])
                [pred_label(Id) pred_prob(Id)] = classification(training_data, training_label, testing_data, testing_label, classifierId , 'ntree', 50); 

            end 
            disp('One versus all validation is performed')
            [Acc, Sen, Spec, Prec] = Evaluation(Labels, pred_label); 
            resultName = 'GiveaName.mat'; 
            save(fullfile(resultPath, resultName), 'Acc', 'Sen', 'Spec', 'Prec'); 

        end 
    end 

