function [ ] = tlinekbdiag2( f, Lr, Cr, eps, Z1, Cp, a )
%TLINEKBDIAG2 Implements a more complicated circuit model for EBG-backed
%microstrip (see work notebook Feb. 4 2013) - I thinkt he math is a little
%wrong
% Z1 and eps1 refer to the top layer (above EBG patches)
% Z2 and eps2 refer to the layer between EBG patches & ground
c = 3e8;
k = 2*pi*f/c;
omega = 2*pi*f;
figure;
plot(-k*a,k*a,'r')
hold on




set(gca, 'fontSize', 12)
for ii = 1:length(k)
    TL = [cos(k(ii)*sqrt(eps)*a/2) j*Z1*sin(k(ii)*sqrt(eps)*a/2);...
        j*(1/Z1)*sin(k(ii)*sqrt(eps)*a/2) cos(k(ii)*sqrt(eps)*a/2)];
    Y = 2*j*omega(ii)*Cp*(1-omega(ii)^2*Cr*Lr)/(1-omega(ii)^2*(Cr+Cp)*Lr);
    ABCD = TL*[1 0; Y 1]*TL;
    beta(ii) = acosh((ABCD(1,1)+ABCD(2,2))/2)/j/a;
end

indices = abs(imag(beta))>0;

plot(-beta(~indices)*a, k(~indices)*a,'b','Linewidth',2,'linestyle','--','linestyle','--')
plot(-imag(beta(indices))*a, k(indices)*a, 'm','Linewidth',2,'linestyle','--')
plot(k*a,k*a,'r')
plot(beta(~indices)*a, k(~indices)*a,'b','Linewidth',2,'linestyle','--')

plot(imag(beta(indices))*a, k(indices)*a, 'm','Linewidth',2,'linestyle','--')
legend({'Light Line'; 'Fundamental Modes'; 'Stopband Attenuation'},'location','southoutside')


title('k-\beta Diagram for Transmission Line with Periodic Series Tank Loading','FontSize',14)
ylabel('k * a')
xlabel('\beta * a')
xlim([-pi pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'ytick', 0:pi/4:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})
set(gca, 'yticklabel', {'0', 'pi/4', 'pi/2', '3pi/4', 'pi', '5pi/4', '3pi/2', '7pi/4', '2pi'})


figure;
plot(-k*a,f*1e-9,'r')
hold on

set(gca, 'fontSize', 12)

plot(-beta(~indices)*a, f(~indices)*1e-9,'b','Linewidth',2,'linestyle','--','linestyle','--')
plot(-imag(beta(indices))*a, f(indices)*1e-9, 'm','Linewidth',2,'linestyle','--')
plot(k*a,f*1e-9,'r')
plot(beta(~indices)*a, f(~indices)*1e-9,'b','Linewidth',2,'linestyle','--')

plot(imag(beta(indices))*a, f(indices)*1e-9, 'm','Linewidth',2,'linestyle','--')
legend({'Light Line'; 'Fundamental Mode'; 'Stopband Attenuation'},'location','southoutside')


title('k-\beta Diagram for Transmission Line with Periodic Series Tank Loading','FontSize',14)
ylabel('Frequency [MHz]')
xlabel('\beta * a')
xlim([-pi pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})

end

