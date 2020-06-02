function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam,Rval,RvalU,RpredAll,RpredUAll]=ExpwithLOOBoundMUSVMSpan(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: MU-SVM model selection using L.O.O Bound Theorem 4.
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
% Rval = M-SVM Validation Accuracies
% RvalU = MU-SVM Validation Accuracies
% RpredAll = M-SVM Test Accuracies for all model parameters.
% RpredUAll = MU-SVM Test Accuracies for all model parameters.
%--------------------------------------------------------------------------

%INITIALIZE
    RPredU=100;
    RempU=100;
    FinmodelU=struct;
    FinoutputU=[];
    param.t = 'linear';
    
    Rval = zeros(length(param.cset),1);
    RvalU=zeros(length(param.Cset),length(param.Gset));
    RpredAll=zeros(length(param.cset),1);
    RpredUAll=zeros(length(param.Cset),length(param.Gset));
    
% M-SVM
cset=param.cset;
if(isempty(param.cset))
    param.method = 'svm';
    optparam = param;
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
else
    param.method = 'svm';
   
    index1=0;
    for c=cset
        index1=index1+1;
        param.c=c;
        [Rval(index1),RpredAll(index1)] =runSvmMultiClassBound_USVM(trndata,tstdata,univdata,param);
    end
    optparam = param;
    optparam.c=cset(min(find(Rval==min(Rval))));
    
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
end

% MU-SVM
param=optparam;
Cset=(optparam.c)*(param.Cset); % Search for the optimal C* keeping C constant.
Gset=param.Gset;
if(isempty(Cset)|| isempty(Gset))
else
    param.method = 'usvm';
        index2=0;
        for C=Cset
            index2=index2+1;
            index3=0;
            for G=Gset
                index3=index3+1;
                param.C=C;
                param.G=G;     
                
                [RvalU(index2,index3),RpredUAll(index2,index3)] =runSvmMultiClassBound_USVM(trndata,tstdata,univdata,param);
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
            % TAKE THE LARGEST C* and SMALLEST G (model selection). i.e
            % max. contradiction
            if(Rpred(j,k)<=Rpredopt)
                param.C=Cset(j);
                param.G=Gset(k);
                Rpredopt=Rpred(j,k);
            end
        end
    end

end


            