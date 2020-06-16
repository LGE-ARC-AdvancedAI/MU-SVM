function [D] = DiameterKernelSpace(K)
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0
H = K;
H = H+1e-10*eye(size(H));   % For ill-conditioned problems
H=(0.5)*(H+H');
N = size(H,1);

g = -diag(K);
H=2*H;
Aeq = ones(1,N);
beq = 1;

% QP OPTIMIZATION
options = optimset('Algorithm','Interior-point-convex','Display','off');
a = quadprog(H,g,[],[],Aeq,beq,zeros(N,1),[],[],options);
obj = (0.5)*a'*H*a + g'*a;
D = 2*sqrt(-obj);

end

