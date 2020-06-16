function [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
    RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
    RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
    RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
    RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
    RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2]=ISOLET_Table2()
%--------------------------------------------------------------------------
% DESCRIPTION:
% This example is to reproduce the results in Table 2 for the ISOLET dataset
% Simply Run the following command in MATLAB's Command Line:-
% [RPred1OVA,RPredU1OVA,Remp1OVA,RempU1OVA,Finmodel1OVA,Finoutput1OVA,FinmodelU1OVA,FinoutputU1OVA,optparam1OVA,...
%     RPred1OVO,RPredU1OVO,Remp1OVO,RempU1OVO,Finmodel1OVO,Finoutput1OVO,FinmodelU1OVO,FinoutputU1OVO,optparam1OVO,...
%     RPred1,RPredU1,Remp1,RempU1,Finmodel1,Finoutput1,FinmodelU1,FinoutputU1,optparam1,...
%     RPred2OVA,RPredU2OVA,Remp2OVA,RempU2OVA,Finmodel2OVA,Finoutput2OVA,FinmodelU2OVA,FinoutputU2OVA,optparam2OVA,...
%     RPred2OVO,RPredU2OVO,Remp2OVO,RempU2OVO,Finmodel2OVO,Finoutput2OVO,FinmodelU2OVO,FinoutputU2OVO,optparam2OVO,...
%     RPred2,RPredU2,Remp2,RempU2,Finmodel2,Finoutput2,FinmodelU2,FinoutputU2,optparam2]=ISOLET_Table2()

% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
%-------------------------------------------------------------------------- 

expno=10;

param.cset = 2.^[-3:3];
param.Gset=[0,0.01,0.05,0.1];
param.Cset = 0.2;   % n/ML
param.gset = 2.^[-7]; 
param.nfold = 5;

for i=1:expno
    display("Experiment "+i);
    [trndata,valdata,tstdata,univ1]=isoletdata_MULTI([1,2,3,4,5],100,0,[],[6:26],24);  % Others universum
    univ1.y = -2*ones(size(univ1.X,1),1);
    
    [univ2]=generateRA(trndata,[],500);  % RA Universum
    univ2.y = -2*ones(size(univ2.X,1),1);
    
    [RPred1OVA(i),RPredU1OVA(i),Remp1OVA(i),RempU1OVA(i),Finmodel1OVA(i),Finoutput1OVA(i),FinmodelU1OVA(i),FinoutputU1OVA(i),optparam1OVA(i)]=ExpwithCVRBFOVA_MAT(trndata,tstdata,univ1,param);
    [RPred1OVO(i),RPredU1OVO(i),Remp1OVO(i),RempU1OVO(i),Finmodel1OVO(i),Finoutput1OVO(i),FinmodelU1OVO(i),FinoutputU1OVO(i),optparam1OVO(i)]=ExpwithCVRBFOVO_MAT(trndata,tstdata,univ1,param);
    [RPred1(i),RPredU1(i),Remp1(i),RempU1(i),Finmodel1(i),Finoutput1(i),FinmodelU1(i),FinoutputU1(i),optparam1(i)]=ExpwithCVRBFMUSVM(trndata,tstdata,univ1,param);
    
    
    [RPred2OVA(i),RPredU2OVA(i),Remp2OVA(i),RempU2OVA(i),Finmodel2OVA(i),Finoutput2OVA(i),FinmodelU2OVA(i),FinoutputU2OVA(i),optparam2OVA(i)]=ExpwithCVRBFOVA_MAT(trndata,tstdata,univ2,param);
    [RPred2OVO(i),RPredU2OVO(i),Remp2OVO(i),RempU2OVO(i),Finmodel2OVO(i),Finoutput2OVO(i),FinmodelU2OVO(i),FinoutputU2OVO(i),optparam2OVO(i)]=ExpwithCVRBFOVO_MAT(trndata,tstdata,univ2,param);
    [RPred2(i),RPredU2(i),Remp2(i),RempU2(i),Finmodel2(i),Finoutput2(i),FinmodelU2(i),FinoutputU2(i),optparam2(i)]=ExpwithCVRBFMUSVM(trndata,tstdata,univ2,param);
    
end

end