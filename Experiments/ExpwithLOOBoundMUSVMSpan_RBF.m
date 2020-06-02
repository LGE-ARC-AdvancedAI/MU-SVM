function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam,Rval,RvalU,RpredAll,RpredUAll]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: MU-SVM model selection using L.O.O Bound Theorem 4 for RBF
% Kernel.
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
%   param.gset = Range of M-SVM's kernel parameter.
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
    param.t = 'rbf';
    
    Rval = zeros(length(param.cset),length(param.gset));
    RpredAll=zeros(length(param.cset),length(param.gset));
    
% SVM
if(isempty(param.cset) || isempty(param.gset))
    param.method = 'svm';
    optparam = param;
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
else
    param.method = 'svm';
    Rval=zeros(length(param.cset),length(param.gset));
    gset = param.gset;    
    cset=param.cset;
    
    for i=1:length(cset)      
            Rvaltmp1 = zeros(1,length(gset));
            RpredAlltmp1 = zeros(1,length(gset));
            paramtmp=param;
            for j=1:length(gset) 
                paramtmp.c=cset(i);
                paramtmp.g=gset(j);     
                fprintf('Running for C = %f and g= %f \n',paramtmp.c,paramtmp.g);
                [Rvaltmp1(j),RpredAlltmp1(j)] =runSvmMultiClassBound_USVM(trndata,valdata,univdata,paramtmp);
            end
            Rvaltmp(i,:) = Rvaltmp1;  
            RpredAlltmp(i,:) = RpredAlltmp1;  
    end 
    Rval = Rval + Rvaltmp;
    RpredAll = RpredAll + RpredAlltmp;
    optparam = param;
    optparam=getOptimalParam(Rval,cset,gset,optparam);
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam); 
    
end

% MU-SVM
param=optparam;
Cset=(optparam.c)*(param.Cset); % Search for the optimal C* keeping C constant.
Gset=param.Gset;
RvalU = zeros(length(param.Cset),length(param.Gset));   
RpredUAll=zeros(length(param.Cset),length(param.Gset));  
if(isempty(Cset)|| isempty(Gset))
else
    param.method = 'usvm';
        
        for i=1:length(Gset)      
        RvalUtmp1 = zeros(1,length(Cset));
        RpredUtmp1= zeros(1,length(Cset));
        paramtmp=param;
        for j=1:length(Cset) 
            paramtmp.C=Cset(j);
            paramtmp.G=Gset(i);     
            fprintf('Running for C* = %f and G= %f \n',paramtmp.C,paramtmp.G);
            [RvalUtmp1(j),RpredUtmp1(j)] = runSvmMultiClassBound_USVM(trndata,tstdata,univdata,paramtmp);
        end
        RvalUtmp(i,:) = RvalUtmp1;
        RpredUtmp(i,:) = RpredUtmp1;
        end  
    RvalU=RvalU+RvalUtmp'; 
    RpredUAll=RpredUAll+RpredUtmp';
    optparam.method = 'usvm';
    optparam=getOptimalUParam(RvalU,Cset,Gset,optparam);
    [RPredU,RempU,FinmodelU,FinoutputU] = runUsvmMultiClass(trndata,tstdata,univdata,optparam);
    
end

end

function [param]=getOptimalParam(Rpred,cset,gset,param)
% NOTE:- Model selection for M-SVM. Here Rpred means the error
Rpredopt=1;
    for j=size(Rpred,1):-1:1
        for k=size(Rpred,2):-1:1
            % LETS TAKE THE SMALLEST c and g(model selection)
            if(Rpred(j,k)<=Rpredopt)
                param.c=cset(j);
                param.g=gset(k);
                Rpredopt=Rpred(j,k);
            end
        end
    end
end

function [param]=getOptimalUParam(Rpred,Cset,Gset,param)
% NOTE:- Model Selection for MU-SVM. Here Rpred means the error
Rpredopt=1;
    for j=1:size(Rpred,1)%:-1:1
        for k=size(Rpred,2):-1:1
            % Take THE  LARGEST C* and SMALLEST G(model selection)
            if(Rpred(j,k)<=Rpredopt)
                param.C=Cset(j);
                param.G=Gset(k);
                Rpredopt=Rpred(j,k);
            end
        end
    end

end


            