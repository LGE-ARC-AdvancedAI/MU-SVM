function [S] = SpanMultiFastUSVM(KSV,aSV,Nsv1T,Nsv1U,Nsv2T,Nsv2U,J)

    
    KSV1 = KSV(1:(Nsv1T+Nsv1U),1:(Nsv1T+Nsv1U));
    SV1 = size(KSV1,1);
    
    S = zeros(Nsv1T+Nsv2T,1);
    K = kron(KSV1,eye(J));
    K = K+1e-10*eye(size(K));   % For ill-conditioned problems
    K=(0.5)*(K+K');

    A = eye(SV1);
    B = ones(1,J);
    Aeq = kron(A,B);

    H = [K Aeq';Aeq zeros(SV1,SV1)]; %O(L^3)
    %H = H + 1e-8*eye(size(H));
    try
        %invH = pinv(H);
        H_hat = H + 1e-8*eye(size(H));
        invH = inv(H_hat);
    catch 
        try 
            %H = H + 1e-8*eye(size(H));
            invH = pinv(H);
        catch, 
            display("Cannot compute Inverse!");
            return;
        end
    end
    
    
    for t=1:Nsv1T % Type SV1 (training)
        st = (t-1)*J +1;
        ed = t*J;
        invHtt = invH(st:ed,st:ed);
        invHtt = pinv(invHtt);  % Try to avoid this.
        S(t)=aSV(t,:)*invHtt*aSV(t,:)';
    end
    
    for t = Nsv1T+1:Nsv1T+Nsv2T % Type SV2 (training) 
        Ktt = kron(KSV(t+Nsv1U,t+Nsv1U),eye(J));
        kt = KSV(1:Nsv1T+Nsv1U,t+Nsv1U);
        Kt = [kron(kt',eye(J)), zeros(J,Nsv1T+Nsv1U)]';
        S(t) = aSV(t+Nsv1U,:)*(Ktt - Kt'*invH*Kt)*aSV(t+Nsv1U,:)';
    end
S = abs(S);    

end