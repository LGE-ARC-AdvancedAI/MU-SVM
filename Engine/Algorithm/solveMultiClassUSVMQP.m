function [a]=solveMultiClassUSVMQP(K,y,N,param)
%--------------------------------------------------------------------------
% DESCRIPTION: This solves the M-SVM/MU-SVM QP using MATLAB's quadprog
% library. For details using other toolboxes like,
% 1. CVX : http://cvxr.com/cvx/ 
% 2. MSVMpack:  https://homepages.loria.fr/FLauer/MSVMpack/MSVMpack.html
% contact the authors.
%--------------------------------------------------------------------------

J =max(y);
L = size(K,1)/J;

% CONSTRUCT g,U
g = [];
U =[];
for i=1:N
    temp1 = ones(J,1);
    temp1(y(i))=0;
    g=[g;temp1];
    
    temp2 = zeros(J,1);
    temp2(y(i))=param.c;
    U = [U;temp2];
end

M=L-N;

if(M~=0)
    for i=N+1:N+M
        temp1 = -(param.G)*ones(J,1);
        temp1(y(i))=0;
        g=[g;temp1];

        temp2 = zeros(J,1);
        temp2(y(i))=param.C;
        U = [U;temp2];
    end
end

H = K;
H = H+1e-10*eye(size(H));   % For ill-conditioned problems
H=(0.5)*(H+H');

A = eye(L);
B = ones(1,J);
Aeq = kron(A,B);
beq = zeros(L,1);

% QP OPTIMIZATION
options = optimset('Algorithm','Interior-point-convex','Display','off');
a = quadprog(H,g,[],[],Aeq,beq,[],U,[],options);

end