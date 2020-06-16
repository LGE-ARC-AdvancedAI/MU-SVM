function [traindata,valid]=Leave_One_Out(data,samp_num)
%-------------------------------------------------------------------
%--- K Fold Cross Validation----------------------------------------
%----------------------------------------------------------------------
%   OUTPUT
%       train:Train data for the fold number
%       validation: Validation data for the fold number
%-------------------------------------------------------------------------
%   INPUT
%       data:       The array of dataset(with the last value as the class labels)
%      
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

data = [data.X,data.y];
indx=1:size(data,1);
[I,trindx]=find(indx~=samp_num);
[I,valindx]=find(indx==samp_num);
traindat=data(trindx,:);
validation=data(valindx,:);

traindata.X = traindat(:,1:end-1);
traindata.y = traindat(:,end);

valid.X = validation(:,1:end-1);
valid.y = validation(:,end);
