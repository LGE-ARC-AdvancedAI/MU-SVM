function [trndata,valdata,tstdata,univdata]=abcdetcdataMULTI(trid,ntrn,nval,ntst,uid,nuniv)
%--------------------------------------------------------------------------
%AUTHOR: SAUPTIK DHAR
%DESCRIPTION:
%This interface will be used to preprocess the abcdetc data of the NEC labs
%INPUT:-
%   class1:- 1-78 (a-z,A-Z,0-9) The class number for class1.
%   class2:- 1-78 (a-z,A-Z,0-9) The class number for class2.
%   nsamptr1:- Number of training samples for class1.
%   nsamptr2:- Number of training samples for class2.
%   nsampval1:-Number of Validation samples for class1.
%   nsampval2:-Number of Validation samples for class2.
%   uclass:-    0= Random Averaging
%               1= all the other lower case.
%               2= all the uppercase letters.
%               3= all the digits and characters.
%   nsampu= Number of Universum samples.
% 1:26 - All other lower case
% 27:52 - All uppercase
% 
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

load abcddata;  % Please see the README.txt doc in this forlder to see how to get this data.
trndata.X=[]; trndata.y=[];
valdata.X=[]; valdata.y=[];
tstdata.X=[]; tstdata.y=[];
univdata.X=[]; 
lab=0;
for i = trid
    lab=lab+1;
    datX = data.class(i).data;
    [M] = size(datX,1);
    ind = randperm(M);
    [trnind] = ind(1:ntrn);
    [valind] = ind(ntrn+1:ntrn+nval);
    [tstind] = ind(ntrn+nval+1:ntrn+nval+ntst);
    
    trndata.X=[trndata.X;datX(trnind,:)]; trndata.y=[trndata.y;lab*ones(ntrn,1)];
    valdata.X=[valdata.X;datX(valind,:)]; valdata.y=[valdata.y;lab*ones(nval,1)];
    tstdata.X=[tstdata.X;datX(tstind,:)]; tstdata.y=[tstdata.y;lab*ones(ntst,1)];
end

for i=uid
    datX = data.class(i).data;
    [M] = size(datX,1);
    ind = randperm(M);
    [uind] = ind(1:nuniv);
    univdata.X=[univdata.X;datX(uind,:)]; 
end


end


