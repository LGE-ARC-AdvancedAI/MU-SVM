function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam,Rval,RvalU]=ExpwithCVLinearMUSVM(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: M-SVM/MU-SVM model selection using cross-validation.
%
% INPUT:
% trndata : The training data structure with fields,
%   trndata.X = The X - features of the training data i.e. (Ntrn x D) data.
%   trndata.y = The class values {1 ... K} of training samples i.e. (Ntrn x 1) vector.
% tstdata : The test data structure with fields,
%   tstdata.X = The X - features of the test data i.e. (Ntst x D) data.
%   trndata.y = The class values {1 ... K} of test samples i.e. (Ntrn x 1) vector.
% univdata : The universum samples.
%   univdata.X = The X - features of the universum data i.e. (Nuniv x D) data.
% param : A structure with the following fields
%   param.t = Kernel type: Options 'linear', 'rbf', 'poly'
%   param.method = algorithm type 'svm' or 'usvm'
%   param.cset = Range of M-SVM's C parameters.
%   param.Cset = Range of MU-SVM's C* parameter.
%   param.Gset =  Range of MU-SVM's \Delta parameter.
%   param.nfold = The folds for CV. E.x: 5 = 5-Fold CV, 10 = 10-Fold CV.
%
% OUTPUT:
% RPred = M-SVM Test Accuracy
% RPredU = MU-SVM test Accuracy
% Remp = M-SVM Training Accuracy
% RempU = MU-SVM Training Accuracy
% Finmodel = M-SVM optimal model
% Finoutput = M-SVM predictions on the training/test/univ data using the optimal model.
% FinmodelU = MU-SVM optimal model
% FinoutputU = MU-SVM predictions on the training/test/univ data using the optimal model.
% optparam = optimal parameters selected through model selection.
% Rval = M-SVM cv accuracies for different model params
% RvalU = MU-SVM's cv accuracy for different model params
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

%INITIALIZE
    RPred=0;
    Remp=0;
    Finmodel=struct;
    Finoutput=[];
    RPredU=0;
    RempU=0;
    FinmodelU=struct;
    FinoutputU=[];
    param.t = 'linear';
    Rval=0;
    RvalU=0;
    
% M-SVM
if(isempty(param.cset))
    param.method = 'svm';
    optparam = param;
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
else
    Rval=zeros(length(param.cset),1);
    for k=1:param.nfold
        lrndata.X =[];lrndata.y = [];
        valdata.X = []; valdata.y = [];
        for p = 1:max(trndata.y)

            dat = [trndata.X(find(trndata.y==p),:),trndata.y(find(trndata.y==p),:)];
            fldsze = (param.nfold-1)/(param.nfold); nsize = ceil(fldsze*size(dat,1));
            [traindat,validation]=k_FoldCV_SPLIT_RAND(dat,nsize);

            lrndata.X = [lrndata.X;traindat(:,1:end-1)]; lrndata.y = [lrndata.y;traindat(:,end)]; 
            valdata.X = [valdata.X;validation(:,1:end-1)];  valdata.y = [valdata.y;validation(:,end)];
        end
        val=zeros(length(param.cset),1);
        cset=param.cset;
        param.method = 'svm';
            for i=1:length(cset)
                paramtmp=param;
                paramtmp.c=cset(i);
                fprintf('Running for C = %f \n',paramtmp.c);
                [val(i)] = runUsvmMultiClass(lrndata,valdata,univdata,paramtmp);  
            end
        Rval = Rval + val;
    end

    Rval = Rval/(param.nfold);
    optparam = param;
    optparam.c=cset(min(find(Rval==min(Rval))));

    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
end


% MU-SVM (Using the 2 step approach)
param=optparam;
Cset=(optparam.c)*(param.Cset); % Search for the optimal C* keeping C constant.
Gset=param.Gset;

RvalU = zeros(length(param.Cset),length(param.Gset));    
if(isempty(Cset)|| isempty(Gset));
else
    
for k=1:param.nfold
    lrndata.X =[];lrndata.y = [];
    valdata.X = []; valdata.y = [];
        for p = 1:max(trndata.y)
            dat = [trndata.X(find(trndata.y==p),:),trndata.y(find(trndata.y==p),:)];
            fldsze = (param.nfold-1)/(param.nfold); nsize = ceil(fldsze*size(dat,1));
            [traindat,validation]=k_FoldCV_SPLIT_RAND(dat,nsize);      
            lrndata.X = [lrndata.X;traindat(:,1:end-1)]; lrndata.y = [lrndata.y;traindat(:,end)]; 
            valdata.X = [valdata.X;validation(:,1:end-1)];  valdata.y = [valdata.y;validation(:,end)];
        end

        %fprintf('........Starting UNIVERSUM SVM(Linear)...........\n');
        param.method = 'usvm';
        for i=1:length(Gset)      
            RvalUtmp1 = zeros(1,length(Cset));
            paramtmp=param;
            for j=1:length(Cset) 
                paramtmp.C=Cset(j);
                paramtmp.G=Gset(i);     
                fprintf('Running for C* = %f and G= %f \n',paramtmp.C,paramtmp.G);
                RvalUtmp1(j) = runUsvmMultiClass(lrndata,valdata,univdata,paramtmp);
            end
            RvalUtmp(i,:) = RvalUtmp1;
        end
        RvalU=RvalU+RvalUtmp';
end
RvalU = RvalU/(param.nfold);
optparam.method = 'usvm';
optparam=getOptimalUParam(RvalU,Cset,Gset,optparam);
[RPredU,RempU,FinmodelU,FinoutputU] = runUsvmMultiClass(trndata,tstdata,univdata,optparam);

end

end

 



function [param]=getOptimalUParam(Rpred,Cset,Gset,param)
% NOTE:- Here Rpred means the Prediction Accuracy
Rpredopt=100;
    for j=size(Rpred,1):-1:1
        for k=size(Rpred,2):-1:1
            % LETS TAKE THE SMALLEST C* and G(model selection)
            if(Rpred(j,k)<=Rpredopt)
                param.C=Cset(j);
                param.G=Gset(k);
                Rpredopt=Rpred(j,k);
            end
        end
    end

end


            