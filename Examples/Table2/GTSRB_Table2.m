function [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
    RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
    RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
    RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
    RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
    RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2,...
    RPred3OVA,RPredU3OVA,Remp3OVA,RempU3OVA,Finmodel3OVA,Finoutput3OVA,FinmodelU3OVA,FinoutputU3OVA,optparam3OVA,...
    RPred3OVO,RPredU3OVO,Remp3OVO,RempU3OVO,Finmodel3OVO,Finoutput3OVO,FinmodelU3OVO,FinoutputU3OVO,optparam3OVO,...
    RPred3,RPredU3,Remp3,RempU3,Finmodel3,Finoutput3,FinmodelU3,FinoutputU3,optparam3]=GTSRB_Table2()
%--------------------------------------------------------------------------
% DESCRIPTION:
% This example is to reproduce the results in Table 2 for the GTSRB dataset
% Simply Run the following command in MATLAB's Command Line:-
% [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
%     RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
%     RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
%     RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
%     RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
%     RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2,...
%     RPred3OVA,RPredU3OVA,Remp3OVA,RempU3OVA,Finmodel3OVA,Finoutput3OVA,FinmodelU3OVA,FinoutputU3OVA,optparam3OVA,...
%     RPred3OVO,RPredU3OVO,Remp3OVO,RempU3OVO,Finmodel3OVO,Finoutput3OVO,FinmodelU3OVO,FinoutputU3OVO,optparam3OVO,...
%     RPred3,RPredU3,Remp3,RempU3,Finmodel3,Finoutput3,FinmodelU3,FinoutputU3,optparam3]=GTSRB_Table2()
%-------------------------------------------------------------------------- 

expno = 10;

param.cset = 2.^[-3:3];
param.Gset=[0,0.01,0.05,0.1];
param.Cset = 0.2; % n/mL
param.nfold = 5;

for i=1:expno
    disp("Experiment "+i);
    
    
    % Load the data
    [trndata,valdata,tstdata,univ1]=GTSRBMulti(100,0,500,[30,70,80],500,[4]);   
    univ1.y = -2*ones(size(univ1.X,1),1);
    
    
    [jnk,jnk,jnk,univ2]=GTSRBMulti(1,1,1,[30,70,80],25,[1:20]);
    univ2.y = -2*ones(size(univ2.X,1),1);
    
    
    [univ3]=generateRA(trndata,[],500); 
    univ3.y = -2*ones(size(univ3.X,1),1);
    
    
    [RPred1OVA(i),RPredU1OVA(i),Remp1OVA(i),RempU1OVA(i),Finmodel1OVA(i),Finoutput1OVA(i),FinmodelU1OVA(i),FinoutputU1OVA(i),optparam1OVA(i)]=ExpwithCVLinearOVA_MAT(trndata,tstdata,univ1,param);
    [RPred1OVO(i),RPredU1OVO(i),Remp1OVO(i),RempU1OVO(i),Finmodel1OVO(i),Finoutput1OVO(i),FinmodelU1OVO(i),FinoutputU1OVO(i),optparam1OVO(i)]=ExpwithCVLinearOVO_MAT(trndata,tstdata,univ1,param);
    [RPred1(i),RPredU1(i),Remp1(i),RempU1(i),Finmodel1(i),Finoutput1(i),FinmodelU1(i),FinoutputU1(i),optparam1(i)]=ExpwithCVLinearMUSVM(trndata,tstdata,univ1,param);
    
    
    [RPred2OVA(i),RPredU2OVA(i),Remp2OVA(i),RempU2OVA(i),Finmodel2OVA(i),Finoutput2OVA(i),FinmodelU2OVA(i),FinoutputU2OVA(i),optparam2OVA(i)]=ExpwithCVLinearOVA_MAT(trndata,tstdata,univ2,param);
    [RPred2OVO(i),RPredU2OVO(i),Remp2OVO(i),RempU2OVO(i),Finmodel2OVO(i),Finoutput2OVO(i),FinmodelU2OVO(i),FinoutputU2OVO(i),optparam2OVO(i)]=ExpwithCVLinearOVO_MAT(trndata,tstdata,univ2,param);
    [RPred2(i),RPredU2(i),Remp2(i),RempU2(i),Finmodel2(i),Finoutput2(i),FinmodelU2(i),FinoutputU2(i),optparam2(i)]=ExpwithCVLinearMUSVM(trndata,tstdata,univ2,param);
    
    
    [RPred3OVA(i),RPredU3OVA(i),Remp3OVA(i),RempU3OVA(i),Finmodel3OVA(i),Finoutput3OVA(i),FinmodelU3OVA(i),FinoutputU3OVA(i),optparam3OVA(i)]=ExpwithCVLinearOVA_MAT(trndata,tstdata,univ3,param);
    [RPred3OVO(i),RPredU3OVO(i),Remp3OVO(i),RempU3OVO(i),Finmodel3OVO(i),Finoutput3OVO(i),FinmodelU3OVO(i),FinoutputU3OVO(i),optparam3OVO(i)]=ExpwithCVLinearOVO_MAT(trndata,tstdata,univ3,param);
    [RPred3(i),RPredU3(i),Remp3(i),RempU3(i),Finmodel3(i),Finoutput3(i),FinmodelU3(i),FinoutputU3(i),optparam3(i)]=ExpwithCVLinearMUSVM(trndata,tstdata,univ3,param);
end

end