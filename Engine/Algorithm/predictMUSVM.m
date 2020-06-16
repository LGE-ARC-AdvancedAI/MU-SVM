function [R,yest] = predictMUSVM(y,f,J)
%--------------------------------------------------------------------------
% DESCRIPTION: The predicted labels from the multiclass scores and the
% equivalent balanced error rate.
% INPUT: 
%   y = True labels. {1 ... J}
%   f = Flattened predicted scores.
%   J = No. of classes.
% OUTPUT:
%   R = balanced test error
%   yest =  sample's predicted class. 
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

yest=zeros(size(y,1),1);
for i=1:length(y)
    tmp = f((i-1)*J+1:i*J);
    [jnk,yest(i)] = max(tmp);
end

err = length(find(yest~=y));
R = err/length(y);
end