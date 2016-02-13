function [bestc,bestg] = computeBestParameter(trainLabel,histogramsTrain, svm_kernel)
% compute best parameters
addpath ../../third_party/libsvm/matlab/
bestcv = 0;
for log2c = -1:1:5
   for log2g = -4.1:1:5
       param = ['-q -t ' num2str(svm_kernel) ' -v 10 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
       cv = libsvmtrain(trainLabel,histogramsTrain,param);
       if (cv>=bestcv),
           bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
       end
  end
end
