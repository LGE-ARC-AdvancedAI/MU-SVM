function [Rpred,Remp,model,output] =runUsvm(trndata,tstdata,univdata,param)
%--------------------------------------------------------------------------
% This solves the SVM/U-SVM problem. Compare the results with U-SVM package
% https://github.com/fabiansinz/UniverSVM
%--------------------------------------------------------------------------

model=[];
output=[];

switch (param.method)
    
    % STANDARD SVM 
    case 'svm'
        % DATA and PARAMETERS
        X=trndata.X; y=trndata.y; n=size(X,1);  
        rho=ones(n,1); 
        L=zeros(n,1);U=(param.c)*ones(n,1);
    
    % STANDARD U-SVM
    case 'usvm'
        % DATA and PARAMETERS
        X=[trndata.X;univdata.X;univdata.X]; y=[trndata.y;ones(size(univdata.X,1),1); -ones(size(univdata.X,1),1)]; 
        n=size(trndata.X,1); m=size(univdata.X,1); N=n+2*m;  

        rho=[ones(n,1);-(param.G)*ones(2*m,1)]; 
        C_hat=[(param.c)*ones(n,1);(param.C)*ones(2*m,1)];
        
        L=zeros(N,1);U=C_hat;           
end

% COMPUTE KERNEL
switch(param.t)
    case 'linear';model.options.ker='polyhomog';model.options.arg=1;
    case 'rbf', model.options.ker='gaussian'; model.options.arg=1/sqrt(2*param.g);
    case 'poly',model.options.ker='poly';model.options.arg=param.d;        
end

    % INITIALIZE OPTIMIZATION PARAMETERS
    K=svmkernel(X,model.options.ker,model.options.arg);
    [a,obj]=SVM_qp(K,y,rho,L,U);
    [model]=calculateb(a,L,U,K,y,rho,model); % Update b, alpha

    model.sv.X=X(model.indsv,:);
    model.sv.y=y(model.indsv);
    model.alphaall=a;
    model.alpha=a(model.indsv);

   % COMPUTE PROJECTIONS
    Ktrain=svmkernel(trndata.X,model.options.ker,model.options.arg,model.sv.X);  
    output.train.projection=Ktrain*((model.alpha).*(model.sv.y))+model.bias;     

    Ktest=svmkernel(tstdata.X,model.options.ker,model.options.arg,model.sv.X);  
    output.test.projection=Ktest*((model.alpha).*(model.sv.y))+model.bias;
    if(~isempty(univdata))
        Kuniv=svmkernel(univdata.X,model.options.ker,model.options.arg,model.sv.X); 
        output.univ.projection=Kuniv*((model.alpha).*(model.sv.y))+model.bias;
    end

    Rpred = length(find(tstdata.y~=sign(output.test.projection)))/length(tstdata.y);                    
    Remp = length(find(trndata.y~=sign(output.train.projection)))/length(trndata.y);
