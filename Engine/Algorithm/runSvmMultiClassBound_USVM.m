function [Rloo,Rpred,Remp,model,output] =runSvmMultiClassBound_USVM(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% DESCRIPTION: Interface to run the M-SVM/MU-SVM algorithms and return the 
% Training/Test errors along with the (Theorem 4) bound-based l.o.o validation
% error. It also provides the model and the projection values.
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
%   param.g = gamma kernel paramete for RBF
%   param.d = degree kernel parameter for polynomial kernel.
%   param.c = M-SVM's C parameter.
%   param.C = MU-SVM's C* parameter.
%   param.G = MU-SVM's \Delta parameter.
% OUTPUT:
%   Rloo = L.O.O error using Span Bound (Theorem 4).
%   Rpred = Test Error
%   Remp = Training error. 
%   model = Estimated Model 
%   output = Model's projection values on Train/Test and Universum Data.
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------

Rpred=inf;
Remp=inf;
model=[];
output=[];

switch (param.method)
    % STANDARD M-SVM ALGORITHM
    case 'svm'
        % DATA and PARAMETERS
        X=trndata.X; y=trndata.y; N=size(X,1); 
        J = max(trndata.y);
        
        % COMPUTE KERNEL
        switch(param.t)
            case 'linear';model.options.ker='polyhomog';model.options.arg=1;
            case 'rbf', model.options.ker='gaussian'; model.options.arg=1/sqrt(2*param.g);
            case 'poly',model.options.ker='poly';model.options.arg=param.d;        
        end

        % INITIALIZE OPTIMIZATION PARAMETERS
        K=svmkernel(X,model.options.ker,model.options.arg);
        I = eye(max(trndata.y));
        K = kron(K,I);
        [a]=solveMultiClassUSVMQP(K,y,N,param);
 
        if(~isempty(a))
            % COMPUTE PROJECTIONS
            Ktrain=svmkernel(trndata.X,model.options.ker,model.options.arg,X);  
            Ktrain = kron(Ktrain,I);
            ftrn=Ktrain*a;     

            Ktest=svmkernel(tstdata.X,model.options.ker,model.options.arg,X); 
            Ktest= kron(Ktest,I);
            ftst=Ktest*a;

            Kuniv=svmkernel(univdata.X,model.options.ker,model.options.arg,X); 
            Kuniv = kron(Kuniv,I);
            funiv=Kuniv*a;
            
            [Remp,ytrn] = predictMUSVM(trndata.y,ftrn,J);
            [Rpred,ytst] = predictMUSVM(tstdata.y,ftst,J);
            [jnk,yuniv] = predictMUSVM(ones(size(univdata.X,1),1),funiv,J);
            

            output.train.projections = reshape(ftrn,J,N)';
            output.test.projections = reshape(ftst,J,size(tstdata.X,1))';
            output.univ.projections = reshape(funiv,J,size(univdata.X,1))';
            output.ytrn = ytrn;
            output.ytst = ytst;
            output.yuniv = yuniv;

            model.a=reshape(a,J,N)';
            
            K=svmkernel(X,model.options.ker,model.options.arg);
            
            % ESTIMATE L.O.O 
            [Rloo] = loo_estimateMultiClassBound_USVM(K,y,model.a,param,N,output.train.projections);
        end
        
        
     case 'usvm'
        % MU-SVM ALGORITHM 
        X =[trndata.X]; y=[trndata.y]; N=size(trndata.X,1); 
        J = max(trndata.y);
        for k=1:J
          X = [X;univdata.X];  
          y = [y;k*ones(size(univdata.X,1),1)];
        end
        NM = size(X,1);

        % COMPUTE KERNEL
        switch(param.t)
            case 'linear';model.options.ker='polyhomog';model.options.arg=1;
            case 'rbf', model.options.ker='gaussian'; model.options.arg=1/sqrt(2*param.g);
            case 'poly',model.options.ker='poly';model.options.arg=param.d;        
        end
        
        K = svmkernel(X,model.options.ker,model.options.arg);
        I = eye(max(trndata.y));
        K = kron(K,I);
        [a] = solveMultiClassUSVMQP(K,y,N,param);
        
        if(~isempty(a))
            
            % COMPUTE PROJECTIONS
            Ktrain=svmkernel(trndata.X,model.options.ker,model.options.arg,X);  
            Ktrain = kron(Ktrain,I);
            ftrn=Ktrain*a;     

            Ktest=svmkernel(tstdata.X,model.options.ker,model.options.arg,X); 
            Ktest= kron(Ktest,I);
            ftst=Ktest*a;

            Kuniv=svmkernel(univdata.X,model.options.ker,model.options.arg,X); 
            Kuniv = kron(Kuniv,I);
            funiv=Kuniv*a;
                       
            [Remp,ytrn] = predictMUSVM(trndata.y,ftrn,J);
            [Rpred,ytst] = predictMUSVM(tstdata.y,ftst,J);
            [jnk,yuniv] = predictMUSVM(ones(size(univdata.X,1),1),funiv,J);

            output.train.projections = reshape(ftrn,J,N)';
            output.test.projections = reshape(ftst,J,size(tstdata.X,1))';
            output.univ.projections= reshape(funiv,J,size(univdata.X,1))';
            output.ytrn = ytrn;
            output.ytst = ytst;
            output.yuniv = yuniv;
            model.a=reshape(a,J,NM)';
            
            K=svmkernel(X,model.options.ker,model.options.arg);
            
            % ESTIMATE L.O.O
            [Rloo] = loo_estimateMultiClassBound_USVM(K,y,model.a,param,N,output.train.projections);
           
        end
                
end
