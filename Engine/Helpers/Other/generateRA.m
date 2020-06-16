function [univdata]=generateRA(trndata,weights,usize)
%--------------------------------------------------------------------------
% DESCRIPTION: Generate RA samples from the training data. If no weights
% specified we use equiprobable.
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

J= max(trndata.y);
univdata.X = zeros(usize,size(trndata.X,2));

if(isempty(weights)),
    weights = ones(J,1);
else,
    if(length(weights)~=J),  weights = ones(J,1);
    end
end


for j=1:J
    
    dataX = trndata.X(trndata.y==j,:);
    ind = randi(size(dataX,1),usize,1);
    univdata.X = univdata.X + weights(j)*dataX(ind,:);
    
end

univdata.X = (univdata.X)/sum(weights); 