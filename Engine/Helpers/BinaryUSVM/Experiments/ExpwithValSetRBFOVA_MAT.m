function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam]=ExpwithValSetRBFOVA_MAT(trndata,valdata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: OVA model selection using separate validation data for RBF
% Kernel
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
%   param.gset = Range of M-SVM's kernel parameters.
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
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

param.t='rbf';


K = max(trndata.y);


RPred = Inf;
Remp = Inf;
RPredU = Inf;
RempU = Inf;
Finmodel=[];
Finoutput=[];
FinmodelU=[];
FinoutputU=[];


% MULTI-SVM PART
cset=param.cset;
gset = param.gset;
if(isempty(cset));
else
    param.method='svm';
    Finoutput.train = zeros(length(trndata.y),K);
    Finoutput.test = zeros(length(tstdata.y),K);
    Finoutput.univ = [];

    for j=1:K
        trnPos = find(trndata.y==j);
        trnNeg = find(trndata.y~=j);
        trnInd = [trnPos;trnNeg]; 
        trn.X = [trndata.X(trnInd,:)]; trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

        valPos = find(valdata.y==j);
        valNeg = find(valdata.y~=j);
        valInd = [valPos;valNeg]; 
        val.X = valdata.X(find(valdata.y==j),:); val.y = ones(size(val.X,1),1); val.X = [val.X;valdata.X(find(valdata.y~=j),:)]; val.y = [val.y;-ones(length(find(valdata.y~=j)),1)]; 
        
        index1=0;
        for c = cset 
            index1 = index1+1;
            index2 = 0;
            for g = gset
                index2 = index2+1;
                param.c = c;
                param.g = g;
                [jnk,temp,model,out] =runUsvm(trn,val,univdata,param);
                
                output.test(valInd,j,index1,index2) = out.test.projection';
            end
        end
    end
    
    [proj,ytst] = max(output.test,[],2);
    
    
    Rval = zeros(length(cset),length(gset));
    index1 = 0;
  
    for c = cset 
        index1 = index1+1;
        index2 = 0;
        for g = gset
            index2 = index2+1;
            Rval(index1,index2) = (length(find(ytst(:,:,index1,index2)~=valdata.y)))/length(valdata.y);
        end
    end
    
   [param]=getOptimalParam(Rval,cset,gset,param);

    for j=1:K
        trnPos = find(trndata.y==j);
        trnNeg = find(trndata.y~=j);
        trnInd = [trnPos;trnNeg]; 
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

        tstPos = find(tstdata.y==j);
        tstNeg = find(tstdata.y~=j);
        tstInd = [tstPos;tstNeg]; 
        tst.X = tstdata.X(tstInd,:); tst.y = [ones(length(tstPos),1);-ones(length(tstNeg),1)];

        [jnk,temp,model,out] =runUsvm(trn,tst,univdata,param);
        Finoutput.train(trnInd,j) = out.train.projection'; Finoutput.trny = trn.y;
        Finoutput.test(tstInd,j) = out.test.projection'; Finoutput.tsty = tst.y;
        
        Finoutput.univ(:,j)=out.univ.projection';
    end
    
    [proj,ytst] = max(Finoutput.test,[],2);
    [proj,ytrn] = max(Finoutput.train,[],2);
    [proj,yuniv] = max(Finoutput.univ,[],2);
    
    RPred = (length(find(ytst~=tstdata.y)))/length(tstdata.y);
    Remp = (length(find(ytrn~=trndata.y)))/length(trndata.y);
    Finmodel.model = model;
end
optparam = param;


% MULTI-USVM
Cset=param.Cset;
if(isempty(Cset));
else
    param.method='usvm';
    FinmodelU = [];
    FinoutputU.train = zeros(length(trndata.y),K);
    FinoutputU.test = zeros(length(tstdata.y),K);
    FinoutputU.univ = [];
     
    Gset = param.Gset;
    
    for j=1:K
        trnPos = find(trndata.y==j);
        trnNeg = find(trndata.y~=j);
        trnInd = [trnPos;trnNeg]; 
        trn.X = [trndata.X(trnInd,:)]; trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

        valPos = find(valdata.y==j);
        valNeg = find(valdata.y~=j);
        valInd = [valPos;valNeg]; 
        val.X = valdata.X(find(valdata.y==j),:); val.y = ones(size(val.X,1),1); val.X = [val.X;valdata.X(find(valdata.y~=j),:)]; val.y = [val.y;-ones(length(find(valdata.y~=j)),1)]; 

        tstPos = find(tstdata.y==j);
        tstNeg = find(tstdata.y~=j);
        tstInd = [tstPos;tstNeg]; 
        tst.X = tstdata.X(tstInd,:); tst.y = [ones(length(tstPos),1);-ones(length(tstNeg),1)];
        
        
        index1=0;
        for C = Cset 
            index1 = index1+1;
            index2 = 0;
            for G = Gset
                index2 = index2+1;
                param.C = C;
                param.G = G;
                [jnk,temp,model,out] =runUsvm(trn,val,univdata,param);
                outputU.test(valInd,j,index1,index2) = out.test.projection';
            end
        end
    end
    

    
    [proj,ytst] = max(outputU.test,[],2);
    RvalU = zeros(length(Cset),length(Gset)); 
    
    index1=0;
    for C = Cset 
        index1 = index1+1;
        index2 = 0;
        for G = Gset
            index2 = index2+1;
            RvalU(index1,index2) = (length(find(ytst(:,:,index1,index2)~=valdata.y)))/length(valdata.y);
        end
    end

    param = getOptimalUParam(RvalU,Cset,Gset,param);

    for j=1:K
        trnPos = find(trndata.y==j);
        trnNeg = find(trndata.y~=j);
        trnInd = [trnPos;trnNeg]; 
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

        tstPos = find(tstdata.y==j);
        tstNeg = find(tstdata.y~=j);
        tstInd = [tstPos;tstNeg]; 
        tst.X = tstdata.X(tstInd,:); tst.y = [ones(length(tstPos),1);-ones(length(tstNeg),1)];


        [jnk,temp,model,out] =runUsvm(trn,tst,univdata,param);
        FinoutputU.train(trnInd,j) = out.train.projection';  Finoutput.trny = trn.y;
        FinoutputU.test(tstInd,j) = out.test.projection';  Finoutput.tsty = tst.y;

        FinoutputU.univ(:,j)=out.univ.projection';
    end
    
    [proj,ytst] = max(FinoutputU.test,[],2);
    [proj,ytrn] = max(FinoutputU.train,[],2);
    [proj,yuniv] = max(FinoutputU.univ,[],2);
    
    RPredU = (length(find(ytst~=tstdata.y)))/length(tstdata.y);
    RempU = (length(find(ytrn~=trndata.y)))/length(trndata.y);
    FinmodelU.model = model;
end

optparam = param;

end


function [param]=getOptimalParam(Rpred,cset,gset,param)
% NOTE:- Here Rpred means the error
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
% NOTE:- Here Rpred means the Prediction Error
Rpredopt=Inf;
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






            