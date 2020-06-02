function [Rloo] = loo_estimateMultiClassBound_USVM(K,y,a,param,N,ftrn)
% Description: This code computes the L.O.O estimates using Theorem 4 in 
% the paper " Multiclass Learning from Contradictions"
% INPUT:
% K  :=  Training + Universum samples (Kernel)
% X  :=  Training + Universum samples
% y  := Training + Universum
% a  := Lagrange multipliers for all samples
% N  := No. of training smaples
% OUTPUT:
% Rloo := The l.o.o error estimate.
%------------------------------------------

Rloo = N; 
eps = 1e-4;
c = param.c;
if(~isempty(param.C))
    C = param.C;
else,
    C = 0;
end

%--------------------------------------------------------------------------
% Construct the Limits
%--------------------------------------------------------------------------
J =max(y);


%--------------------------------------------------------------------------
% Compute the Bounds
%--------------------------------------------------------------------------

indSV1T = [];
indSV2T = [];
indSV1U=[];
indSV2U=[]; 

for i=1:size(a,1)
    if(i<=N)
        if( a(i,y(i)) > eps )
            if( a(i,y(i)) < ( c - eps ))
                indSV1T = [indSV1T;i];
            else
                indSV2T = [indSV2T;i];
            end
        end
    else
        if( a(i,y(i)) > eps )
            if( a(i,y(i)) < ( C - eps ))
                indSV1U = [indSV1U;i];
            else
                indSV2U = [indSV2U;i];
            end
        end
    end
end

Nsv1T = length(indSV1T);
Nsv1U = length(indSV1U);
Nsv2T = length(indSV2T);
Nsv2U = length(indSV2U);

SVs = [indSV1T;indSV1U;indSV2T;indSV2U];

if(~isempty([indSV1T;indSV2T;]))
    % TYPE 1
    aSV = a(SVs,:);
    KSV = K(SVs,SVs);
    ysv = y(SVs);
    [S] = SpanMultiFastUSVM(KSV,aSV,Nsv1T,Nsv1U,Nsv2T,Nsv2U,J);
    thresh = sum(ftrn.*a(1:N,:),2);
    Rloo = length(find(S-thresh([indSV1T;indSV2T])>0));
end

Rloo = (1/N)* Rloo ;
end

