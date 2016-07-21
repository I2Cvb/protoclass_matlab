% This file is used to add the necessary paths to the Matlab path
addpath(genpath(fullfile(pwd, 'protoclass')));
addpath(genpath(fullfile(pwd, 'third_party')));

rmpath(genpath(fullfile(pwd, 'third_party/prtools')));
% this path should be added when sift is needed to be used 
rmpath(genpath(fullfile(pwd, 'third_party/vlfeat-0.9.20')));