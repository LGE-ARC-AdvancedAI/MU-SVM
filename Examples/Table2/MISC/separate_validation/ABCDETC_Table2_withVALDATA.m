function [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
    RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
    RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
    RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
    RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
    RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2,...
    RPred3OVA,RPredU3OVA,Remp3OVA,RempU3OVA,Finmodel3OVA,Finoutput3OVA,FinmodelU3OVA,FinoutputU3OVA,optparam3OVA,...
    RPred3OVO,RPredU3OVO,Remp3OVO,RempU3OVO,Finmodel3OVO,Finoutput3OVO,FinmodelU3OVO,FinoutputU3OVO,optparam3OVO,...
    RPred3,RPredU3,Remp3,RempU3,Finmodel3,Finoutput3,FinmodelU3,FinoutputU3,optparam3,...
    RPred4OVA,RPredU4OVA,Remp4OVA,RempU4OVA,Finmodel4OVA,Finoutput4OVA,FinmodelU4OVA,FinoutputU4OVA,optparam4OVA,...
    RPred4OVO,RPredU4OVO,Remp4OVO,RempU4OVO,Finmodel4OVO,Finoutput4OVO,FinmodelU4OVO,FinoutputU4OVO,optparam4OVO,...
    RPred4,RPredU4,Remp4,RempU4,Finmodel4,Finoutput4,FinmodelU4,FinoutputU4,optparam4]=ABCDETC_Table2_withVALDATA()
%--------------------------------------------------------------------------
% DESCRIPTION:
% This example is to reproduce the results in Table 2 for the ABCDETC dataset
% Simply Run the following command in MATLAB's Command Line:-
% [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
%     RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
%     RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
%     RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
%     RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
%     RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2,...
%     RPred3OVA,RPredU3OVA,Remp3OVA,RempU3OVA,Finmodel3OVA,Finoutput3OVA,FinmodelU3OVA,FinoutputU3OVA,optparam3OVA,...
%     RPred3OVO,RPredU3OVO,Remp3OVO,RempU3OVO,Finmodel3OVO,Finoutput3OVO,FinmodelU3OVO,FinoutputU3OVO,optparam3OVO,...
%     RPred3,RPredU3,Remp3,RempU3,Finmodel3,Finoutput3,FinmodelU3,FinoutputU3,optparam3,...
%     RPred4OVA,RPredU4OVA,Remp4OVA,RempU4OVA,Finmodel4OVA,Finoutput4OVA,FinmodelU4OVA,FinoutputU4OVA,optparam4OVA,...
%     RPred4OVO,RPredU4OVO,Remp4OVO,RempU4OVO,Finmodel4OVO,Finoutput4OVO,FinmodelU4OVO,FinoutputU4OVO,optparam4OVO,...
%     RPred4,RPredU4,Remp4,RempU4,Finmodel4,Finoutput4,FinmodelU4,FinoutputU4,optparam4]=ABCDETC_Table2_withVALDATA()
%-------------------------------------------------------------------------- 


expno=10;
param.cset = 10.^[-2:1];
param.gset = 2.^[-7]; % PRE-FIXED TO OPTIMAL PARAMETER
param.Gset=[0,0.01,0.05,0.1];
param.Cset = 0.3;  % n/mL
 

for i=1:expno
    
    display("Experiment "+i);
    [trndata,valdata,tstdata,univ1]=abcdetcdataMULTI([53:56],150,50,50,[1:25],20); % Training '0' - '3', Universum 'lowercase'
    [jnk,jnk,jnk,univ2]=abcdetcdataMULTI([1],1,1,1,[28:52],20); % Universum 'Uppercase'
    [jnk,jnk,jnk,univ3]=abcdetcdataMULTI([1],1,1,1,[63:77],32); % Universum 'Special Characters'
    [univ4]=generateRA(trndata,[],500); % Universum 'RA'
    
    
     univ1.y = -2*ones(size(univ1.X,1),1);
     univ2.y = -2*ones(size(univ2.X,1),1);
     univ3.y = -2*ones(size(univ3.X,1),1);
     univ4.y = -2*ones(size(univ4.X,1),1);
     
    [RPred1OVA(i),RPredU1OVA(i),Remp1OVA(i),RempU1OVA(i),Finmodel1OVA(i),Finoutput1OVA(i),FinmodelU1OVA(i),FinoutputU1OVA(i),optparam1OVA(i)]=ExpwithValSetRBFOVA_MAT(trndata,valdata,tstdata,univ1,param);
    [RPred1OVO(i),RPredU1OVO(i),Remp1OVO(i),RempU1OVO(i),Finmodel1OVO(i),Finoutput1OVO(i),FinmodelU1OVO(i),FinoutputU1OVO(i),optparam1OVO(i)]=ExpwithValSetRBFOVO_MAT(trndata,valdata,tstdata,univ1,param);
    [RPred1(i),RPredU1(i),Remp1(i),RempU1(i),Finmodel1(i),Finoutput1(i),FinmodelU1(i),FinoutputU1(i),optparam1(i)]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ1,param);
   
    
    [RPred2OVA(i),RPredU2OVA(i),Remp2OVA(i),RempU2OVA(i),Finmodel2OVA(i),Finoutput2OVA(i),FinmodelU2OVA(i),FinoutputU2OVA(i),optparam2OVA(i)]=ExpwithValSetRBFOVA_MAT(trndata,valdata,tstdata,univ2,param);
    [RPred2OVO(i),RPredU2OVO(i),Remp2OVO(i),RempU2OVO(i),Finmodel2OVO(i),Finoutput2OVO(i),FinmodelU2OVO(i),FinoutputU2OVO(i),optparam2OVO(i)]=ExpwithValSetRBFOVO_MAT(trndata,valdata,tstdata,univ2,param);
    [RPred2(i),RPredU2(i),Remp2(i),RempU2(i),Finmodel2(i),Finoutput2(i),FinmodelU2(i),FinoutputU2(i),optparam2(i)]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ2,param);
    
    
    [RPred3OVA(i),RPredU3OVA(i),Remp3OVA(i),RempU3OVA(i),Finmodel3OVA(i),Finoutput3OVA(i),FinmodelU3OVA(i),FinoutputU3OVA(i),optparam3OVA(i)]=ExpwithValSetRBFOVA_MAT(trndata,valdata,tstdata,univ3,param);
    [RPred3OVO(i),RPredU3OVO(i),Remp3OVO(i),RempU3OVO(i),Finmodel3OVO(i),Finoutput3OVO(i),FinmodelU3OVO(i),FinoutputU3OVO(i),optparam3OVO(i)]=ExpwithValSetRBFOVO_MAT(trndata,valdata,tstdata,univ3,param);
    [RPred3(i),RPredU3(i),Remp3(i),RempU3(i),Finmodel3(i),Finoutput3(i),FinmodelU3(i),FinoutputU3(i),optparam3(i)]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ3,param);
    
    
    [RPred4OVA(i),RPredU4OVA(i),Remp4OVA(i),RempU4OVA(i),Finmodel4OVA(i),Finoutput4OVA(i),FinmodelU4OVA(i),FinoutputU4OVA(i),optparam4OVA(i)]=ExpwithValSetRBFOVA_MAT(trndata,valdata,tstdata,univ4,param);
    [RPred4OVO(i),RPredU4OVO(i),Remp4OVO(i),RempU4OVO(i),Finmodel4OVO(i),Finoutput4OVO(i),FinmodelU4OVO(i),FinoutputU4OVO(i),optparam4OVO(i)]=ExpwithValSetRBFOVO_MAT(trndata,valdata,tstdata,univ4,param);
    [RPred4(i),RPredU4(i),Remp4(i),RempU4(i),Finmodel4(i),Finoutput4(i),FinmodelU4(i),FinoutputU4(i),optparam4(i)]=ExpwithValSetRBFMUSVM(trndata,valdata,tstdata,univ4,param);
    
end

end