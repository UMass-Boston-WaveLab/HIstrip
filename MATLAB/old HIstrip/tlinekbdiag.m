function [ ] = tlinekbdiag( f, L, C, a )
%TLINEK-BDIAG Summary of this function goes here
%   Detailed explanation goes here
c = 3e8;
k = 2*pi*f/c;
eps = 1;
if ~ischar(L) && ~ischar(C)
    xnorm = prll(j*2*pi*f*L, 1./(j*2*pi*f*C));
elseif ~ischar(C) 
    xnorm = 1./(j*2*pi*f*C);
elseif ~ischar(L)
    xnorm = j*2*pi*f*L;
else
    xnorm = 0*f;
end
Z1 = 50;
figure;
plot(-k*a,k*a,'r')
% epsilonr = (2.2+1)/2;
epsilonr = 1;
hold on

for jj = 1:length(xnorm)
    TL = [cos(k(jj)*sqrt(eps)*a/2) j*Z1*sin(k(jj)*sqrt(eps)*a/2);...
        j*(1/Z1)*sin(k(jj)*sqrt(eps)*a/2) cos(k(jj)*sqrt(eps)*a/2)];
    ABCD = TL*[1 xnorm(jj); 0 1]*TL;
    
    set(gca, 'fontSize', 12)
    gamma(jj) = acosh((ABCD(1,1)+ABCD(2,2))/2)/a;
  
    beta(jj) = imag(gamma(jj));
    alpha(jj) = real(gamma(jj));
    Zbloch(jj) = Zbloch_from_ABCD(ABCD);
end
figure;
plot(k*a, real(Zbloch), k*a, imag(Zbloch))
title('Bloch Impedance for Transmission Line with Periodic Series Tank Loading','FontSize',14)


figure;
indices = imag(gamma)~=0;
plot(beta(indices)*a, k(indices)*a,'b','Linewidth',2,'linestyle','--','linestyle','--')
plot(beta(indices)*a+2*pi, k(indices)*a, 'k','Linewidth',2,'linestyle','--')
plot(-alpha*a, k*a, 'm','Linewidth',2,'linestyle','--')
plot(k*a,k*a,'r')
plot(-beta(indices)*a, k(indices)*a,'b','Linewidth',2,'linestyle','--')
plot(-beta(indices)*a+2*pi, k(indices)*a, 'k','Linewidth',2,'linestyle','--')
plot(beta(indices)*a-2*pi, k(indices)*a, 'k','Linewidth',2,'linestyle','--')
plot(-beta(indices)*a-2*pi, k(indices)*a, 'k','Linewidth',2,'linestyle','--')

plot(alpha*a, k*a, 'm','Linewidth',2,'linestyle','--')
legend({'Light Line'; 'Fundamental Modes'; 'Spatial Harmonics'; 'Stopband Attenuation'},'location','southoutside')

title('k-\beta Diagram for Transmission Line with Periodic Series Tank Loading','FontSize',14)
ylabel('k * a')
xlabel('\beta * a')
xlim([-1.5*pi 1.5*pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'ytick', 0:pi/4:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})
set(gca, 'yticklabel', {'0', 'pi/4', 'pi/2', '3pi/4', 'pi', '5pi/4', '3pi/2', '7pi/4', '2pi'})


figure;
plot(-k*a,f*1e-9,'r')
hold on
for jj = 1:size(xnorm,1)
    
    test = abs(cos(sqrt(epsilonr)*k*a)-xnorm(jj,:)./(2*sin(sqrt(epsilonr)*k*a)));
    for ii = 1:length(k)
        beta(ii) = acos(test(ii))/a;
    end
    indices = imag(beta)>0;
    set(gca, 'fontSize', 12)

    plot(-beta(~indices)*a, f(~indices)*1e-9,'b','Linewidth',2,'linestyle','--','linestyle','--')
    plot(beta(~indices)*a+pi, f(~indices)*1e-9, 'k','Linewidth',2,'linestyle','--')
    plot(-imag(beta(indices))*a, f(indices)*1e-9, 'm','Linewidth',2,'linestyle','--')
    plot(k*a,f*1e-9,'r')
    plot(beta(~indices)*a, f(~indices)*1e-9,'b','Linewidth',2,'linestyle','--')
    plot(-beta(~indices)*a+pi, f(~indices)*1e-9, 'k','Linewidth',2,'linestyle','--')
    plot(beta(~indices)*a-pi, f(~indices)*1e-9, 'k','Linewidth',2,'linestyle','--')
    plot(-beta(~indices)*a-pi, f(~indices)*1e-9, 'k','Linewidth',2,'linestyle','--')

    plot(imag(beta(indices))*a, f(indices)*1e-9, 'm','Linewidth',2,'linestyle','--')
    legend({'Light Line'; 'Fundamental Modes'; 'Spatial Harmonics'; 'Stopband Attenuation'},'location','southoutside')
end

title('k-\beta Diagram for Transmission Line with Periodic Series Tank Loading','FontSize',14)
ylabel('Frequency [GHz]')
xlabel('\beta * a')
xlim([-1.5*pi 1.5*pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})

end

