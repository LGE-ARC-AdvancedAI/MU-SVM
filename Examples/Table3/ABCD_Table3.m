function [RPred,optparam,...
    RPred1cv,RPredU1cv,Remp1cv,RempU1cv,optparam1cv,...
    RPred1th2,RPredU1th2,Remp1th2,RempU1th2,Finmodel1th2,Finoutput1th2,FinmodelU1th2,FinoutputU1th2,optparam1th2,RvalU1th2,RpredUAll1th2,...
    RPred1loo,RPredU1loo,Remp1loo,RempU1loo,Finmodel1loo,Finoutput1loo,FinmodelU1loo,FinoutputU1loo,optparam1loo,RvalU1loo,...
    RPred2cv,RPredU2cv,Remp2cv,RempU2cv,optparam2cv,...
    RPred2th2,RPredU2th2,Remp2th2,RempU2th2,Finmodel2th2,Finoutput2th2,FinmodelU2th2,FinoutputU2th2,optparam2th2,RvalU2th2,RpredUAll2th2,...
    RPred2loo,RPredU2loo,Remp2loo,RempU2loo,Finmodel2loo,Finoutput2loo,FinmodelU2loo,FinoutputU2loo,optparam2loo,RvalU2loo,...
    RPred3cv,RPredU3cv,Remp3cv,RempU3cv,optparam3cv,...
    RPred3th2,RPredU3th2,Remp3th2,RempU3th2,Finmodel3th2,Finoutput3th2,FinmodelU3th2,FinoutputU3th2,optparam3th2,RvalU3th2,RpredUAll3th2,...
    RPred3loo,RPredU3loo,Remp3loo,RempU3loo,Finmodel3loo,Finoutput3loo,FinmodelU3loo,FinoutputU3loo,optparam3loo,RvalU3loo,...
    RPred4cv,RPredU4cv,Remp4cv,RempU4cv,optparam4cv,...
    RPred4th2,RPredU4th2,Remp4th2,RempU4th2,Finmodel4th2,Finoutput4th2,FinmodelU4th2,FinoutputU4th2,optparam4th2,RvalU4th2,RpredUAll4th2,...
    RPred4loo,RPredU4loo,Remp4loo,RempU4loo,Finmodel4loo,Finoutput4loo,FinmodelU4loo,FinoutputU4loo,optparam4loo,RvalU4loo,...
    tCV1,tSpan1th2,tloo1,tCV2,tSpan2th2,tloo2,tCV3,tSpan3th2,tloo3,tCV4,tSpan4th2,tloo4] = ABCD_Table3()
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
%     RPred3cv,RPredU3cv,Remp3cv,RempU3cv,optparam3cv,...
%     RPred3th2,RPredU3th2,Remp3th2,RempU3th2,Finmodel3th2,Finoutput3th2,FinmodelU3th2,FinoutputU3th2,optparam3th2,RvalU3th2,RpredUAll3th2,...
%     RPred3loo,RPredU3loo,Remp3loo,RempU3loo,Finmodel3loo,Finoutput3loo,FinmodelU3loo,FinoutputU3loo,optparam3loo,RvalU3loo,...
%     RPred4cv,RPredU4cv,Remp4cv,RempU4cv,optparam4cv,...
%     RPred4th2,RPredU4th2,Remp4th2,RempU4th2,Finmodel4th2,Finoutput4th2,FinmodelU4th2,FinoutputU4th2,optparam4th2,RvalU4th2,RpredUAll4th2,...
%     RPred4loo,RPredU4loo,Remp4loo,RempU4loo,Finmodel4loo,Finoutput4loo,FinmodelU4loo,FinoutputU4loo,optparam4loo,RvalU4loo,...
%     tCV1,tSpan1th2,tloo1,tCV2,tSpan2th2,tloo2,tCV3,tSpan3th2,tloo3,tCV4,tSpan4th2,tloo4] = ABCD_Table3()

% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%-------------------------------------------------------------------------- 


expno = 10;  % No. of experiments.

param.t='rbf';
param.Gset=[0,0.01,0.05,0.1];
param.nfold = 5;
param.gset = 2.^[-7]; % Fixed to the typical parameter.


for i=1:expno
    
    disp("Experiment "+i);
    
    param.cset = 10.^[-4:3];
    
    % LOAD THE DATA
    [trndata,valdata,tstdata,univ1]=abcdetcdataMULTI([53:56],150,50,50,[1:25],20);  % Digits '0' - '3' Training, Lowercase Letters 'a' - 'z' as Universum. 
    [jnk,jnk,jnk,univ2]=abcdetcdataMULTI([1],1,1,1,[28:52],20);                     % Upper Case Letters 'A' - 'Z' as Universum 
    [jnk,jnk,jnk,univ3]=abcdetcdataMULTI([1],1,1,1,[63:77],32);                     % Special Characters as Universum 
    [univ4]=generateRA(trndata,[],500);                                             % Random Averaging.

    univ1.y = -2*ones(size(univ1.X,1),1);
    univ2.y = -2*ones(size(univ2.X,1),1);
    univ3.y = -2*ones(size(univ3.X,1),1);
    univ4.y = -2*ones(size(univ4.X,1),1);
    
    
    % GET THE OPTIMAL M-SVM MODEL.
    param.Cset = [];
    [RPred(i),jnk1,jnk2,jnk3,jnk4,jnk5,jnk6,jnk7,optparam]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ1,param);
     param.c= optparam.c; 
     param.g = optparam.g;
     param.cset = [];
     param.gset = [];
     param.Cset = [0.1];
     disp('finished M-SVM model Selection');
    
    
    
    
    disp('Running Universum (Lowercase)');
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
     
     
    
    
    disp('Running Universum (Uppercase)');
    t = cputime;
    [RPred2cv(i),RPredU2cv(i),Remp2cv(i),RempU2cv(i),Finmodel2cv,Finoutput2cv,FinmodelU2cv,FinoutputU2cv,optparam2cv(i) ]=ExpwithCVRBFMUSVM(trndata,tstdata,univ2,param);
    tCV2(i) = cputime-t;
    disp('Finished CV');

    t = cputime;
    [RPred2th2(i),RPredU2th2(i),Remp2th2(i),RempU2th2(i),Finmodel2th2(i),Finoutput2th2(i),FinmodelU2th2(i),FinoutputU2th2(i),optparam2th2(i),jnk,RvalU2th2(i,:),jnk,RpredUAll2th2(i,:)]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univ2,param);
    tSpan2th2(i) = cputime-t;
    disp('Finished Span Theorem 4');
   
    t = cputime;
    [RPred2loo(i),RPredU2loo(i),Remp2loo(i),RempU2loo(i),Finmodel2loo(i),Finoutput2loo(i),FinmodelU2loo(i),FinoutputU2loo(i),optparam2loo(i),jnk,RvalU2loo(i,:)]=ExpwithLOORBFMUSVM(trndata,tstdata,univ2,param);
    tloo2(i) = cputime-t;
    disp('Finished LOO');
    
    
    
    disp('Running Universum (Special Characters)');
    
    t = cputime;
    [RPred3cv(i),RPredU3cv(i),Remp3cv(i),RempU3cv(i),Finmodel3cv,Finoutput3cv,FinmodelU3cv,FinoutputU3cv,optparam3cv(i) ]=ExpwithCVRBFMUSVM(trndata,tstdata,univ3,param);
    tCV3(i) = cputime-t;
    disp('Finished CV');
    
    t = cputime;
    [RPred3th2(i),RPredU3th2(i),Remp3th2(i),RempU3th2(i),Finmodel3th2(i),Finoutput3th2(i),FinmodelU3th2(i),FinoutputU3th2(i),optparam3th2(i),jnk,RvalU3th2(i,:),jnk,RpredUAll3th2(i,:)]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univ3,param);
    tSpan3th2(i) = cputime-t;
    disp('Finished Span Theorem 4');
     
    t = cputime;
    [RPred3loo(i),RPredU3loo(i),Remp3loo(i),RempU3loo(i),Finmodel3loo(i),Finoutput3loo(i),FinmodelU3loo(i),FinoutputU3loo(i),optparam3loo(i),jnk,RvalU3loo(i,:)]=ExpwithLOORBFMUSVM(trndata,tstdata,univ3,param);
    tloo3(i) = cputime-t;
    disp('Finished LOO');
     
     
    
    
    disp('Running Universum (RA)');
    t = cputime;
    [RPred4cv(i),RPredU4cv(i),Remp4cv(i),RempU4cv(i),Finmodel4cv,Finoutput4cv,FinmodelU4cv,FinoutputU4cv,optparam4cv(i) ]=ExpwithCVRBFMUSVM(trndata,tstdata,univ4,param);
    tCV4(i) = cputime-t;
    disp('Finished CV');

    t = cputime;
    [RPred4th2(i),RPredU4th2(i),Remp4th2(i),RempU4th2(i),Finmodel4th2(i),Finoutput4th2(i),FinmodelU4th2(i),FinoutputU4th2(i),optparam4th2(i),jnk,RvalU4th2(i,:),jnk,RpredUAll4th2(i,:)]=ExpwithLOOBoundMUSVMSpan_RBF(trndata,tstdata,univ4,param);
    tSpan4th2(i) = cputime-t;
    disp('Finished Span Theorem 4');
   
    t = cputime;
    [RPred4loo(i),RPredU4loo(i),Remp4loo(i),RempU4loo(i),Finmodel4loo(i),Finoutput4loo(i),FinmodelU4loo(i),FinoutputU4loo(i),optparam4loo(i),jnk,RvalU4loo(i,:)]=ExpwithLOORBFMUSVM(trndata,tstdata,univ4,param);
    tloo4(i) = cputime-t;
    disp('Finished LOO');
    
       
end
%save results_SPAN_ABCD_G2
end