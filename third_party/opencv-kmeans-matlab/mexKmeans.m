% FUNCTION runs the k-means algorithm on input data
%
%	centers = mexKmeans( data, k, epsilon, nIter, nAttempts );
%
% INPUT :
%	data		- matrix with samples in columns
%	k			- number of clusters
%	epsilon		- stopping criteria (e.g. 0.0001)
%	nIter		- stopping criteria - number of iterations (e.g. 10000)
%	nAttempts	- number of clustering attempts (e.g. 1)
%
% OUTPUT :
%	centers		- cluster center matrix
%