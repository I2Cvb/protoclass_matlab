%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Codebook_BoW.m 
%%% Author: Mojdeh Rastgoo
%%% UB-UdG
%%% Version: 1.0
%%% The sparsity of the code is provided by Desire Sidibe 
%%% Note : This function is intended to use with the structure elemenets 
%%% ---------------------------------------------------
%%% Parameters: 
%%% save_path       | indicate the file you want to save your data -->  example: 'home/data/FV_LBP_BoW.mat'; 
%%% featureSet      | if you are interested to save the high-level features for all the features and not separately for training and testing data, mention your featureSet 
%%% slevel          | sparisty level (default = 4 ); example [2,4,8]
%%% dSize           | dictionary size (default = 200); 
%%% PoolingType     | pooling type (default = 'max') ['max', 'avg', 'mss', 'abs']
%%% iternum         | number of the times ksvd is performed (default = 10)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params, train_descr, test_descr] = Codebook_SCF (trainSet, testSet, varargin)


% Add the path to the k-svd toolbox
addpath ../../third_party/ksvdbox13;
addpath ../../third_party/ompbox10;
addpath ../../third_party/Basic_function/
addpath ../../third_party/vlfeat-0.9.16/toolbox/
vl_setup


input.featureSet = []; 
input.save_path = []; 
input.sLevel = 4 ; 
input.dSize = 100; 
input.PoolingType = 'max ' ;            % 'max','avg', 'mss', 'abs'
input.iternum = 10;                     % number of ksvd iterations to perform 

input = parseargs(input,varargin{:});

%%% Learning the Dictionary 
            
    disp('Dictionary learning...');
    disp('-----------------------'); 
    disp(['Dict size ' num2str(input.dSize)]);
    disp('-----------------------');    
    params.dictsize = input.dSize;             % Parameters for KSVD algorithm
    
    disp('-----------------------');
    disp(['Sparsity level ' num2str(input.sLevel)]);
    disp('-----------------------');    
    params.Tdata = input.sLevel;               % Parameters for KSVD algorithm
    disp('ksvd algorithm');
    params_data = []; 
    params_data = trainSet; 
    params.data = vl_colsubset(cat(1, params_data{:}),10e4); 
    params.data = params.data'; 
    [D, A] = ksvd(params, 'VERBOSE', '');
    params.dictionary = D ; 
    
    disp('---> Done !');
          
    disp('-----------------------'); 
    disp('Organise the features sets');
    disp('-----------------------');
    
    
    if (isempty(input.featureSet) ~= 1)
        featureSet = input.featureSet; 
        FV = []; 
        for t = 1 : length(featureSet)
          % sparse coding using the learned dictionary
          params.data = cell2mat(featureSet(t));
          params.data = params.data'; 
          alpha = omp(D'*params.data, D'*D, params.Tdata);
          if (strncmpi('max', input.PoolingType, 3) == 1)
                z = max( abs(alpha), [], 2); % max pooling
          elseif (strncmpi('mss', input.PoolingType, 3) == 1)
                z = sqrt(mean(alpha.^2, 2)); % mean squared statistics
          elseif (strncmpi('avg', input.PoolingType, 3) == 1)
                z = mean(alpha, 2);          % average statistic
          elseif (strncmpi('abs', input.PoolingType, 3) == 1)
                z = mean(abs(alpha), 2);     % mean absolute value
          end
          FV = [FV; z'];
        end
        if (isempty(input.save_path) ~= 0 )
            save(input.save_path, 'FV'); 
        end 
    elseif (isempty(input.featureSet) == 1)
    
        % training data
        disp('Training voxels');
        disp('-----------------------');
        train_descr = []; 
        % sparse code each training image
        for t = 1:length(trainSet)
          % sparse coding using the learned dictionary
          params.data = cell2mat(trainSet(t));
          params.data = params.data'; 
          alpha = omp(D'*params.data, D'*D, params.Tdata);
    
          if (strncmpi('max', input.PoolingType, 3) == 1)
                z = max( abs(alpha), [], 2); % max pooling
          elseif (strncmpi('mss', input.PoolingType, 3) == 1)
                z = sqrt(mean(alpha.^2, 2)); % mean squared statistics
          elseif (strncmpi('avg', input.PoolingType, 3) == 1)
                z = mean(alpha, 2);          % average statistic
          elseif (strncmpi('abs', input.PoolingType, 3) == 1)
                z = mean(abs(alpha), 2);     % mean absolute value
          end
          train_descr = [train_descr; z'];
        end

        % testing data
        disp('testing images');
        disp('-----------------------');
        test_descr = [];
        for t=1:length(testSet)
          % sparse coding using the learned dictionary
          params.data = cell2mat(testSet(t));
          params.data = params.data'; 
          alpha = omp(D'*params.data, D'*D, params.Tdata);
      
           if (strncmpi('max', input.PoolingType, 3) == 1)
                z = max( abs(alpha), [], 2); % max pooling
           elseif (strncmpi('mss', input.PoolingType, 3) == 1)
                z = sqrt(mean(alpha.^2, 2)); % mean squared statistics
           elseif (strncmpi('avg', input.PoolingType, 3) == 1)
                z = mean(alpha, 2);          % average statistic
           elseif (strncmpi('abs', input.PoolingType, 3) == 1)
                z = mean(abs(alpha), 2);     % mean absolute value
          end
          test_descr = [test_descr; z'];
        end

        disp('---> Done !');
    end 