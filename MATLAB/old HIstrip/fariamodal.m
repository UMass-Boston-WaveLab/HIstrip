function [zf, zb, Zterm0, gamma, ABCDmodal, T0, Tl] = fariamodal(ABCD, a)
    A = ABCD(1:2,1:2);
    B = ABCD(1:2, 3:4);
    C = ABCD(3:4, 1:2);
    D = ABCD(3:4,3:4);
    [T0, ~] = eig(B*C.');
    [Tl, ~] = eig(B.'*C);
    W0 = inv(T0).';
    Wl = inv(Tl).';
    %now, these matrices should all be diagonal
    Ahat = T0\A*Tl;
    Bhat = T0\B*Wl;
    Chat = W0\C*Tl;
    Dhat = W0\D*Wl;
    ABCDmodal = [Ahat Bhat; Chat Dhat];
    %there are 3 conductors, so there should be 2 modes
    for jj = 1:2
        gamma(jj)= acosh((Ahat(jj,jj)+Dhat(jj,jj))/2)/a;  %this will always choose + real part
        %forward-propagating waves have e^-gamma*z
        yf(jj) = (exp(gamma(jj)*a)-Ahat(jj,jj))/Bhat(jj,jj); 
        yb(jj)=(-exp(-gamma(jj)*a)+Ahat(jj,jj))/Bhat(jj,jj);
    end
    if any(real(gamma)<0)
        error('Gamma error');
    end
    %Terminal 1 is used as an input port, and terminal 2 is left open (no current into terminal 2, any voltage is allowed).
    %So what you see at Port 1 (as connected in the model) is Z11
    zf = 1./yf;
    zb = 1./yb;
    Zterm0 = T0*diag(zf.')/W0;
end