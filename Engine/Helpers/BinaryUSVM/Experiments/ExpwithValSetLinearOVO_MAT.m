function [RPred,RPredU,Remp,RempU,Finmodel,Finoutput,FinmodelU,FinoutputU,optparam]=ExpwithValSetLinearOVO_MAT(trndata,valdata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: OVO model selection using separate validations data.
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
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

param.t='linear';

K = max(trndata.y);
classes  = 1:K;
CL = combnk(classes,2);

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
if(isempty(cset));
else,
    param.method='svm';
    Finoutput.train = zeros(length(trndata.y),K);
    Finoutput.test = zeros(length(tstdata.y),K);
    Finoutput.univ = zeros(length(univdata.y),K);
    
    output.train = zeros(length(trndata.y),K,length(cset));
    output.test = zeros(length(valdata.y),K,length(cset));
    output.univ = zeros(length(univdata.y),K,length(cset));
    
    for i=1:size(CL,1)

        trnPos = find(trndata.y==CL(i,1));   
        trnNeg = find(trndata.y==CL(i,2)); 
        trnInd = [trnPos;trnNeg];
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)]; 
        
        index1=0;
        for c = cset
            index1 = index1+1;
            param.c=c;
            [jnk,temp,model,out] =runUsvm(trn,valdata,[],param);

            for n = 1:length(valdata.y)
                if(out.test.projection(n)>=0), output.test(n,CL(i,1),index1) = output.test(n,CL(i,1),index1)+1;
                else output.test(n,CL(i,2),index1) = output.test(n,CL(i,2),index1)+1;     
                end 
            end
        end
    end

    [proj,ytst] = max(output.test,[],2);
    
    index1 = 0;
    Rval = zeros(length(cset),1);
    for c = cset
        index1 = index1+1;
        Rval(index1) = (length(find(ytst(:,:,index1)~=valdata.y)))/length(valdata.y);
    end
    param.c=cset(min(find(Rval==min(Rval))));
    
    
    for i=1:size(CL,1)
        trnPos = find(trndata.y==CL(i,1));   
        trnNeg = find(trndata.y==CL(i,2)); 
        trnInd = [trnPos;trnNeg];
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)];
        
        [jnk,temp,model,out] =runUsvm(trn,tstdata,univdata,param);
        
        Finoutput.class(i).trnproj = out.train.projection';  Finoutput.class(i).trny = trn.y;
        Finoutput.class(i).tstproj = out.test.projection'; 
        
        for n = 1:length(tstdata.y)
            if(out.test.projection(n)>=0), Finoutput.test(n,CL(i,1)) = Finoutput.test(n,CL(i,1))+1;
            else Finoutput.test(n,CL(i,2)) = Finoutput.test(n,CL(i,2))+1;     
            end 
        end
        
        for n = 1:length(trn.y)
            if(out.train.projection(n)>=0), Finoutput.train(trnInd(n),CL(i,1)) = Finoutput.train(trnInd(n),CL(i,1))+1;
            else Finoutput.train(trnInd(n),CL(i,2)) = Finoutput.train(trnInd(n),CL(i,2))+1;     
            end 
        end
        
        for n = 1:length(univdata.y)
            if(out.univ.projection(n)>=0), Finoutput.univ(n,CL(i,1)) = Finoutput.univ(n,CL(i,1))+1;
            else Finoutput.univ(n,CL(i,2)) = Finoutput.univ(n,CL(i,2))+1;     
            end 
        end   
    end
    
    [proj,ytst] = max(Finoutput.test,[],2);
    [proj,ytrn] = max(Finoutput.train,[],2);
    [proj,yuniv] = max(Finoutput.univ,[],2);

    RPred = (length(find(ytst~=tstdata.y)))/length(tstdata.y);
    Remp = (length(find(ytrn~=trndata.y)))/length(trndata.y);
    Finmodel.model = model;
end

% MULTI-USVM
Cset=param.Cset;
if(isempty(Cset));
else,
    param.method = 'usvm';
    Gset = param.Gset;
    FinmodelU = [];
    FinoutputU.train = zeros(length(trndata.y),K);
    FinoutputU.test = zeros(length(tstdata.y),K);
    FinoutputU.univ = zeros(length(univdata.y),K);
    
    outputU.train = zeros(length(trndata.y),K,length(Cset),length(Gset));
    outputU.test = zeros(length(valdata.y),K,length(Cset),length(Gset));
    outputU.univ = zeros(length(univdata.y),K,length(Cset),length(Gset));
    
   
    for i=1:size(CL,1)
        trnPos = find(trndata.y==CL(i,1));   
        trnNeg = find(trndata.y==CL(i,2)); 
        trnInd = [trnPos;trnNeg];
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)]; 

        index1=0;
        for C = Cset
            index1 = index1+1;
            index2 = 0;
            for G = Gset
                index2 = index2+1;
                param.C=C;
                param.G = G;
                [jnk,temp,model,out] =runUsvm(trn,valdata,univdata,param);
                for n = 1:length(valdata.y)
                    if(out.test.projection(n)>=0), outputU.test(n,CL(i,1),index1,index2) = outputU.test(n,CL(i,1),index1,index2)+1;
                    else outputU.test(n,CL(i,2),index1,index2) = outputU.test(n,CL(i,2),index1,index2)+1;     
                    end 
                end
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
    
    for i=1:size(CL,1)
        trnPos = find(trndata.y==CL(i,1));   
        trnNeg = find(trndata.y==CL(i,2)); 
        trnInd = [trnPos;trnNeg];
        trn.X = trndata.X(trnInd,:); trn.y = [ones(length(trnPos),1);-ones(length(trnNeg),1)]; 

        [jnk,temp,model,out] =runUsvm(trn,tstdata,univdata,param);
        
        FinoutputU.class(i).trnproj = out.train.projection';  FinoutputU.class(i).trny = trn.y;
        FinoutputU.class(i).tstproj = out.test.projection';
        
        for n = 1:length(tstdata.y)
            if(out.test.projection(n)>=0), FinoutputU.test(n,CL(i,1)) = FinoutputU.test(n,CL(i,1))+1;
            else FinoutputU.test(n,CL(i,2)) = FinoutputU.test(n,CL(i,2))+1;     
            end 
        end
        
        for n = 1:length(trn.y)
            if(out.train.projection(n)>=0), FinoutputU.train(trnInd(n),CL(i,1)) = FinoutputU.train(trnInd(n),CL(i,1))+1;
            else FinoutputU.train(trnInd(n),CL(i,2)) = FinoutputU.train(trnInd(n),CL(i,2))+1;     
            end 
        end
        
        
        for n = 1:length(univdata.y)
            if(out.univ.projection(n)>=0), FinoutputU.univ(n,CL(i,1)) = FinoutputU.univ(n,CL(i,1))+1;
            else FinoutputU.univ(n,CL(i,2)) = FinoutputU.univ(n,CL(i,2))+1;     
            end 
        end   
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



            