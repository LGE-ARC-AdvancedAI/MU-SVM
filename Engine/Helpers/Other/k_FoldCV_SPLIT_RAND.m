function [traindat,validation]=k_FoldCV_SPLIT_RAND(data,nsize)
%-------------------------------------------------------------------
%--- K Fold Cross Validation----------------------------------------
%----------------------------------------------------------------------
%   OUTPUT
%       train:Train data for the fold number
%       validation: Validation data for the fold number
%-------------------------------------------------------------------------
%   INPUT
%       data:       The array of dataset(with the last value as the class labels)
%       k_fold:     Number of Folds
%       fold_num: The fold number
%--------------------------------------------------------------------------

n_samples=size(data,1);
ind = randperm(n_samples);

traindat=data(ind(1:nsize),:);
validation=data(ind(nsize+1:end),:);    