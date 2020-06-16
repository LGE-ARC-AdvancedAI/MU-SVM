function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam,Rval,RvalU]=ExpwithLOOLinearMUSVM(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: M-SVM/MU-SVM model selection using L.O.O using
% Linear Kernel.
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
% Rval = M-SVM l.o.o accuracies for different model params
% RvalU = MU-SVM's l.o.o accuracy for different model params

% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

    RPred=100;
    Remp=100;
    RPredU=100;
    RempU=100;
    Finmodel=struct;
    Finoutput=[];
    FinmodelU=struct;
    FinoutputU=[];
    optparam=struct;
    param.t = 'linear';
    param.method='svm';
    
    RvalU=zeros(length(param.Cset),length(param.Gset));
    param.nfold=size(trndata.X,1);
    if(isempty(param.cset))
        Rval = 0;
        param.method = 'svm';
        optparam = param;
        [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
    else
        cset = param.cset;
        for i=1:length(cset)
            c_i = cset(i);
            for l=1:param.nfold

            [learndata,validata]=Leave_One_Out(trndata,l);

            paramtmp=param;
            paramtmp.c=c_i;

            [Rvaltmp(l)] = runUsvmMultiClass(learndata,validata,univdata,paramtmp);
            end
            Rval(i)=sum(Rvaltmp)/(param.nfold);
            fprintf('Finished Running for C = %f \n',cset(i));
        end
        optparam = param;
        optparam.c=cset(min(find(Rval==min(Rval))));

        [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
    end
    
    param=optparam;
    Cset=(optparam.c)*(param.Cset); % Search for the optimal C* keeping C constant.
    Gset=param.Gset;
    if(isempty(Cset)|| isempty(Gset));
    else
        param.method = 'usvm';
        for i=1:length(Cset)            
            for j=1:length(Gset) 
                C_i = Cset(i); G_j= Gset(j);
                for l=1:param.nfold
                    [learndata,validata]=Leave_One_Out(trndata,l);
                    paramtmp1=param;
                    paramtmp1.C = C_i;
                    paramtmp1.G = G_j;    
                    [RvalUtmp(l)] = runUsvmMultiClass(learndata,validata,univdata,paramtmp1);
                end
                RvalU(i,j)=sum(RvalUtmp)/(param.nfold);
                fprintf('Finished Running for C* = %f, G = %f \n',C_i,G_j);                
            end
        end  
    optparam.method = 'usvm';
    optparam=getOptimalUParam(RvalU,Cset,Gset,optparam);
    [RPredU,RempU,FinmodelU,FinoutputU] = runUsvmMultiClass(trndata,tstdata,univdata,optparam);
    end
end

function [param]=getOptimalUParam(Rpred,Cset,Gset,param)
% NOTE:- Here Rpred means the error
Rpredopt=1;
    for j=1:size(Rpred,1)%:-1:1
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





           