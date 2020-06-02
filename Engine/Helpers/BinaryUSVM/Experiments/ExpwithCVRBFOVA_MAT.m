function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam]=ExpwithCVRBFOVA_MAT(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: OVA model selection using separate validation data for RBF
% Kernel
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
if(isempty(cset))
     % param.c and param.g has to be provided.
else
    param.method='svm';
    Finoutput.train = zeros(length(trndata.y),K);
    Finoutput.test = zeros(length(tstdata.y),K);
    Finoutput.univ = [];
    Rval = zeros(length(cset),length(gset));
    
    for k = 1:param.nfold
        lrndata.X =[];lrndata.y = [];
        valdata.X = []; valdata.y = [];
        
        % CONSTRUCT THE PARTITIONED LEARN/VAL DATA
        for p = 1:max(trndata.y)

            dat = [trndata.X(find(trndata.y==p),:),trndata.y(find(trndata.y==p),:)];
            fldsze = (param.nfold-1)/(param.nfold); nsize = ceil(fldsze*size(dat,1));
            [traindat,validation]=k_FoldCV_SPLIT_RAND(dat,nsize);

            lrndata.X = [lrndata.X;traindat(:,1:end-1)]; lrndata.y = [lrndata.y;traindat(:,end)]; 
            valdata.X = [valdata.X;validation(:,1:end-1)];  valdata.y = [valdata.y;validation(:,end)];
        end
        
    
        for j=1:K
            trnPos = find(lrndata.y==j);
            trnNeg = find(lrndata.y~=j);
            trnInd = [trnPos;trnNeg]; 
            trn.X = [lrndata.X(trnInd,:)]; trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

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

        index1 = 0;

        for c = cset 
            index1 = index1+1;
            index2 = 0;
            for g = gset
                index2 = index2+1;
                Rval(index1,index2) = Rval(index1,index2)+(length(find(ytst(:,:,index1,index2)~=valdata.y)))/length(valdata.y);
            end
        end
        
    end
    
    Rval = Rval/(param.nfold);
   [param]=getOptimalParam(Rval,cset,gset,param);
end

% Use the optimal parameter for predicting on test data.

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

optparam = param;   % Relay the optimal c and g



% MULTI-USVM

Cset=param.Cset;
if(isempty(Cset))
    % should contain the param.c, param.g. If param.Cset = [] just return.
else
    param.method='usvm';
    FinmodelU = [];
    FinoutputU.train = zeros(length(trndata.y),K);
    FinoutputU.test = zeros(length(tstdata.y),K);
    FinoutputU.univ = []; 
    Gset = param.Gset;
    RvalU = zeros(length(Cset),length(Gset)); 
    
    for k = 1:param.nfold
        
        lrndata.X =[];lrndata.y = [];
        valdata.X = []; valdata.y = [];
        
        % CONSTRUCT THE PARTITIONED LEARN/VAL DATA
        for p = 1:max(trndata.y)

            dat = [trndata.X(find(trndata.y==p),:),trndata.y(find(trndata.y==p),:)];
            fldsze = (param.nfold-1)/(param.nfold); nsize = ceil(fldsze*size(dat,1));
            [traindat,validation]=k_FoldCV_SPLIT_RAND(dat,nsize);

            lrndata.X = [lrndata.X;traindat(:,1:end-1)]; lrndata.y = [lrndata.y;traindat(:,end)]; 
            valdata.X = [valdata.X;validation(:,1:end-1)];  valdata.y = [valdata.y;validation(:,end)];
        end
    
    
        for j=1:K
            trnPos = find(lrndata.y==j);
            trnNeg = find(lrndata.y~=j);
            trnInd = [trnPos;trnNeg]; 
            trn.X = [lrndata.X(trnInd,:)]; trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];

            valPos = find(valdata.y==j);
            valNeg = find(valdata.y~=j);
            valInd = [valPos;valNeg]; 
            val.X = valdata.X(find(valdata.y==j),:); val.y = ones(size(val.X,1),1); val.X = [val.X;valdata.X(find(valdata.y~=j),:)]; val.y = [val.y;-ones(length(find(valdata.y~=j)),1)]; 


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
    
        index1=0;
        for C = Cset 
            index1 = index1+1;
            index2 = 0;
            for G = Gset
                index2 = index2+1;
                RvalU(index1,index2) = (length(find(ytst(:,:,index1,index2)~=valdata.y)))/length(valdata.y);
            end
        end
        
    end
    
    RvalU = RvalU/(param.nfold);
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






            