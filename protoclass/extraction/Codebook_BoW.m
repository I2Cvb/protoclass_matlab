%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Codebook_BoW.m 
%%% Author: Mojdeh Rastgoo
%%% UB-UdG
%%% Version: 1.0
%%% The code is highly inspired from vl_feat bow approach 
%%% url : http://www.vlfeat.org/applications/apps.html
%%% Note : This function is intended to use with the structure elemenets 
%%% ---------------------------------------------------
%%% Parameters: 
%%% save_path       | indicate the file you want to save your data -->  example: 'home/data/FV_LBP_BoW.mat'; 
%%% featureSet      | if you are interested to save the high-level features for all the features and not separately for training and testing data, mention your featureSet 
%%% initialization  | 'plusplus' or  'randsel', initialization of vl_kmeans
%%% algorithm       |  'lloyd', 'elkan', 'ann.lloyd', possible choices of algorithm for vl_kmeans
%%% distance        | 'l2' or 'l1'
%%% NumRepetitions  | number of times requested to restart the kmeans 
%%% iter            | Maximum number of iterations 
%%% quantizer       | 'kdtree' or 'vq'
%%% Note : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [model, train_descr, test_descr] = Codebook_BoW (trainSet, testSet, Words , varargin)

addpath ../../third_party/vlfeat-0.9.16/toolbox/
vl_setup


input.featureSet = []; 
input.save_path = []; 
input.initialization = 'plusplus'; 
input.algorithm = 'elkan'; 
input.iter = 1000; 
input.distance = 'l2'; 
input.NumRepetitions = 1 ; 
input.quantizer = 'kdtree'; 
input = parseargs(input,varargin{:});

model.quantizer = input.quantizer; 
model.vocab = []; 

%%% Concatenating the features in descrs matrix 
descrs = []; 
for id = 1 : length()
    descrs = [descrs; trainSet{id}]; 
end

%%% calculating the vocabluray using vl_kmeans function
descrs = single(descrs') ;
vocab = vl_kmeans(descrs, Words, 'Initialization', input.initialization, 'verbose', ...
    'algorithm', input.algorithm, 'MaxNumIterations', input.iter, ...
    'NumRepetitions', input.NumRepetitions, 'Distance', input.distance) ;
           
model.vocab = vocab; 
           
if strcmp(model.quantizer, 'kdtree')
   model.kdtree = vl_kdtreebuild(vocab) ;
end

%%% High representation of the training and test set in terms of the new
%%% learned dictionary 
if (isempty(input.featureSet) ~= 1)
    featureSet = input.featureSet; 
    FV = []; 
    for id = 1 : length(featureSet)
        iddescr = featureSet{id}; 
        iddescr = iddescr'; 
        hist = getImageDescriptor(model, iddescr); 
        FV = [FV; hist']; 
    end 
    if (isempty(input.save_path) ~= 0 )
        save(input.save_path, 'FV'); 
    end 
    

elseif (isempty(input.featureSet == 1))

    train_descr = []; 
    for id = 1 : length(trainSet)
        iddescr = trainSet{id}; 
        iddescr = iddescr'; 
        hist = getImageDescriptor(model, iddescr); 
        train_descr = [train_descr; hist']; 
    end 
    test_descr = []; 
    for id = 1 : length(testSet)
        iddescr = testSet{id}; 
        iddescr= iddescr'; 
        hist = getImageDescriptor(model, iddescr); 
        test_descr = [test_descr; hist']; 
    end 

    if (isempty(input.save_path) ~= 0 )
        save(input.save_path, 'model', 'train_descr', 'test_descr'); 
    end 
end 
end 


function hist = getImageDescriptor(model, descrs)

    descrs = single (descrs); 
    numWords = size(model.vocab, 2) ;

    % quantize local descriptors into visual words
    switch model.quantizer
      case 'vq'
        [drop, binsa] = min(vl_alldist(model.vocab, descrs), [], 1) ;
      case 'kdtree'
        binsa = double(vl_kdtreequery(model.kdtree, model.vocab, ...
                                      descrs, ...
                                      'MaxComparisons', 50)) 
    end
    hists = zeros(numWords, 1) ;
    hists = vl_binsum(hists, ones(size(binsa)), binsa) ;
    %hists = single(hist / sum(hist)) ;
    hist = hists ;
    hist = hist / sum(hist) ;
end 
 
