function [model,ind1,ind2]=calculateb(a,L,U,K,y,rho,model)
% Calculate the bias parameter of SVM/U-SVM.
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0

tolL = 1e-6;
tolU = 1e-6;
% Type 1 SVs
ind1=find(a>L+tolL & a<U-tolU);
% Type 2 SVs
ind2=find(a>=U-tolU);

bias=[];
if(~isempty(ind1))
    bias=rho(ind1).*y(ind1)-K(ind1,[ind1;ind2])*(a([ind1;ind2]).*y([ind1;ind2]));
end

if(isempty(bias))
    fprintf('Cannot Compute Bias\n');
    bias=(max(y([ind1;ind2]))+min(y([ind1;ind2])))/2;
else
    bias=mean(bias);
end
model.bias = bias;
model.indsv = [ind1;ind2];


