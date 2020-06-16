function [RPred,optparam,...
    RPred1cv,RPredU1cv,Remp1cv,RempU1cv,optparam1cv,...
    RPred1th2,RPredU1th2,Remp1th2,RempU1th2,Finmodel1th2,Finoutput1th2,FinmodelU1th2,FinoutputU1th2,optparam1th2,RvalU1th2,RpredUAll1th2,...
    RPred1loo,RPredU1loo,Remp1loo,RempU1loo,Finmodel1loo,Finoutput1loo,FinmodelU1loo,FinoutputU1loo,optparam1loo,RvalU1loo,...
    RPred2cv,RPredU2cv,Remp2cv,RempU2cv,optparam2cv,...
    RPred2th2,RPredU2th2,Remp2th2,RempU2th2,Finmodel2th2,Finoutput2th2,FinmodelU2th2,FinoutputU2th2,optparam2th2,RvalU2th2,RpredUAll2th2,...
    RPred2loo,RPredU2loo,Remp2loo,RempU2loo,Finmodel2loo,Finoutput2loo,FinmodelU2loo,FinoutputU2loo,optparam2loo,RvalU2loo,...
    tCV1,tSpan1th2,tloo1,tCV2,tSpan2th2,tloo2]=ISOLET_Table3()
%--------------------------------------------------------------------------
% DESCRIPTION:
% This example is to reproduce the results in Table 3 for the GTSRB dataset
% Simply Run the following command in MATLAB's Command Line:-
% [RPred,optparam,...
%     RPred1cv,RPredU1cv,Remp1cv,RempU1cv,optparam1cv,...
%     RPred1th2,RPredU1th2,Remp1th2,RempU1th2,Finmodel1th2,Finoutput1th2,FinmodelU1th2,FinoutputU1th2,optparam1th2,RvalU1th2,RpredUAll1th2,...
%     RPred1loo,RPredU1loo,Remp1loo,RempU1loo,Finmodel1loo,Finoutput1loo,FinmodelU1loo,FinoutputU1loo,optparam1loo,RvalU1loo,...
%     RPred2cv,RPredU2cv,Remp2cv,RempU2cv,optparam2cv,...
%     RPred2th2,RPredU2th2,Remp2th2,RempU2th2,Finmodel2th2,Finoutput2th2,FinmodelU2th2,FinoutputU2th2,optparam2th2,RvalU2th2,RpredUAll2th2,...
%     RPred2loo,RPredU2loo,Remp2loo,RempU2loo,Finmodel2loo,Finoutput2loo,FinmodelU2loo,FinoutputU2loo,optparam2loo,RvalU2loo,...
%     tCV1,tSpan1th2,tloo1,tCV2,tSpan2th2,tloo2]=ISOLET_Table3()

% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%--------------------------------------------------------------------------


expno = 2;

param.t='rbf';
param.Gset=[0,0.01,0.05,0.1];
param.nfold =5;
param.gset = 2.^[-7]; % Fixed to the typical parameter.


for i=1:expno
    
    disp("Experiment "+i);
    param.cset = 10.^[-3:3];
    [trndata,valdata,tstdata,univ1]=isoletdata_MULTI([1,2,3,4,5],100,100,100,[6:26],40);  % Spoken Letters 'a' - 'e' as Training, and all other letters 'f' - 'z' as Universum. 
    [univ2]=generateRA(trndata,[],1000);                                                  % Random averaging universum.
    
    univ1.y = -2*ones(size(univ1.X,1),1);
    univ2.y = -2*ones(size(univ2.X,1),1);

    
    % GET THE OPTIMAL M-SVM MODEL.
    param.Cset = [];
    [RPred(i),jnk1,jnk2,jnk3,jnk4,jnk5,jnk6,jnk7,optparam]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ1,param);
     param.c= optparam.c; 
     param.g = optparam.g;
     param.cset = [];
     param.gset = [];
     param.Cset = [0.1];
    disp('finished ValSet');
    
    
    disp('Running Universum (Others)');
    t = cputime;
    [RPred1cv(i),RPredU1cv(i),Remp1cv(i),RempU1cv(i),Finmodel1cv,Finoutput1cv,FinmodelU1cv,FinoutputU1cv,optparam1cv(i)]=ExpwithCVRBFMUSVM(trndata,tstdata,univ1,param);
    tCV1(i) = cputime-t;
    disp('Finished CV');
  
    t = cputime;
    [RPred1th2(i),RPredU1th2(i),Remp1th2(i),RempU1th2(i),Finmodel1th2(i),Finoutput1th2(i),FinmodelU1th2(i),FinoutputU1th2(i),optparam1th2(i),jnk,RvalU1th2(i,:),jnk,RpredUAll1th2(i,:)]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univ1,param);
    tSpan1th2(i) = cputime-t;
    disp('Finished Span Theorem 4');
     
    t = cputime;
    [RPred1loo(i),RPredU1loo(i),Remp1loo(i),RempU1loo(i),Finmodel1loo(i),Finoutput1loo(i),FinmodelU1loo(i),FinoutputU1loo(i),optparam1loo(i),jnk,RvalU1loo(i,:)]=ExpwithLOORBFMUSVM(trndata,tstdata,univ1,param);
    tloo1(i) = cputime-t;
    disp('Finished LOO');
     
     
    
    
    disp('Running Universum (RA)');
    t = cputime;
    [RPred2cv(i),RPredU2cv(i),Remp2cv(i),RempU2cv(i),Finmodel2cv,Finoutput2cv,FinmodelU2cv,FinoutputU2cv,optparam2cv(i)]=ExpwithCVRBFMUSVM(trndata,tstdata,univ2,param);
    tCV2(i) = cputime-t;
    disp('finished CV');

    t = cputime;
    [RPred2th2(i),RPredU2th2(i),Remp2th2(i),RempU2th2(i),Finmodel2th2(i),Finoutput2th2(i),FinmodelU2th2(i),FinoutputU2th2(i),optparam2th2(i),jnk,RvalU2th2(i,:),jnk,RpredUAll2th2(i,:)]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univ2,param);
    tSpan2th2(i) = cputime-t;
    disp('Finished Span Theorem 4');
   
    t = cputime;
    [RPred2loo(i),RPredU2loo(i),Remp2loo(i),RempU2loo(i),Finmodel2loo(i),Finoutput2loo(i),FinmodelU2loo(i),FinoutputU2loo(i),optparam2loo(i),jnk,RvalU2loo(i,:)]=ExpwithLOORBFMUSVM(trndata,tstdata,univ2,param);
    tloo2(i) = cputime-t;
    disp('Finished LOO');
     
       
end
%save results_SPAN_ISOLET_G
end