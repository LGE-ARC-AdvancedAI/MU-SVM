function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam,Rval,RvalU]=ExpwithValSetLinearMUSVM(trndata,valdata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: M-SVM/MU-SVM model selection using separate validation data.
%
% INPUT:
% trndata : The training data structure with fields,
%   trndata.X = The X - features of the training data i.e. (Ntrn x D) data.
%   trndata.y = The class values {1 ... K} of training samples i.e. (Ntrn x 1) vector.
% valdata : The validation data structure with fields,
%   valdata.X = The X - features of the test data i.e. (Ntst x D) data.
%   valdata.y = The class values {1 ... K} of test samples i.e. (Ntrn x 1) vector.
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
% Rval = M-SVM accuracies on the validation data for different model params
% RvalU = MU-SVM's accuracy on the validation data for different model
% parameters.

% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

%INITIALIZE
    RPred=0;
    Remp=0;
    RPredU=0;
    RempU=0;
    Finmodel=struct;
    Finoutput=[];
    FinmodelU=struct;
    FinoutputU=[];
    optparam=struct;
    param.t = 'linear';
    Rval=0;
    RvalU=0;
% DEFINE THE PARAMETERS
cset=param.cset;
if(isempty(cset))
else
    param.method = 'svm';
   
    index1=0;
    for c=cset
        index1=index1+1;
        param.c=c;
        [Rval(index1)] = runUsvmMultiClass(trndata,valdata,univdata,param);  
        fprintf('Running for C = %f \n',param.c);
    end
    
    optparam = param;
    optparam.c=cset(min(find(Rval==min(Rval))));
    [RPred,Remp,Finmodel,Finoutput] =runUsvmMultiClass(trndata,tstdata,univdata,optparam);
end
param=optparam;
Cset=(optparam.c)*(param.Cset); % Search for the optimal C* keeping C constant.
Gset=param.Gset;
if(isempty(Cset)|| isempty(Gset))
else
    %fprintf('........Starting UNIVERSUM SVM(Linear)...........\n');
    param.method = 'usvm';
        index2=0;
        for C=Cset
            index2=index2+1;
            index3=0;
            for G=Gset
                index3=index3+1;
                param.C=C;
                param.G=G;
                [RvalU(index2,index3)] = runUsvmMultiClass(trndata,valdata,univdata,param);
                fprintf('Running for C* = %f and G= %f \n',param.C,param.G);
            end
        end
    optparam.method = 'usvm';
    optparam=getOptimalUParam(RvalU,Cset,Gset,optparam);
    [RPredU,RempU,FinmodelU,FinoutputU] = runUsvmMultiClass(trndata,tstdata,univdata,optparam);
    
end

end

 



function [param]=getOptimalUParam(Rpred,Cset,Gset,param)
% NOTE:- Here Rpred means the Prediction Accuracy
Rpredopt=1;
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


            