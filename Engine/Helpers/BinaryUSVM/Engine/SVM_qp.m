function [x,obj]=SVM_qp(K,y,rho,L,U)
% Solves the SVM/MU-SVM QP using quadprog
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
 
Aeq = y';
H = diag(y)*K*diag(y);
H = H+1e-10*eye(size(H));   % For ill-conditioned problems
H=(0.5)*(H+H');

% Use this for CVX
% cvx_begin
% cvx_quiet true
%     variable x(N)
%     minimize ((0.5)*(x'*H*x)+c'*x)
%     subject to
%         A*x==0
%         x>=L
%         x<=U
% cvx_end


% QP OPTIMIZATION
options = optimset('Algorithm','Interior-point-convex','Display','off');
x = quadprog(H,-rho,[],[],Aeq,0,L,U,[],options);
obj=((0.5)*(x'*H*x)-rho'*x);

end