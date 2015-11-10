function [  ] = kbfromHOBsparams( HOB_files_mag, HOB_files_phase, d, a)
%KBFROMCSTSPARAMS Summary of this function goes here
%   Detailed explanation goes here
HOB_S11file_mag = HOB_files_mag{1};
HOB_S21file_mag = HOB_files_mag{2};

HOB_S11file_phase = HOB_files_phase{1};
HOB_S21file_phase = HOB_files_phase{2};

[freq, S11mag] = read_HOB_file(HOB_S11file_mag);
[~, S11phase] = read_HOB_file(HOB_S11file_phase);
[~, S21mag] = read_HOB_file(HOB_S21file_mag);
[~, S21phase] = read_HOB_file(HOB_S21file_phase);

Z0 = 50;
gamma = zeros(size(freq));

Smag = [S11mag S21mag S21mag S11mag];
Sphase = [S11phase S21phase S21phase S11phase];

for ii = 1:length(freq)
    S = [Smag(ii,1)*exp(j*Sphase(ii,1)), Smag(ii,2)*exp(j*Sphase(ii,2));
         Smag(ii,3)*exp(j*Sphase(ii,3)), Smag(ii,4)*exp(j*Sphase(ii,4))];
    ABCD = getABCDfromS(S, Z0);
    % from Pozar (periodic structures in filters section):
    gammad(ii) = acosh((ABCD(1,1)+ABCD(2,2))/2);
    Zchar(ii) = sqrt(ABCD(1,2)/ABCD(2,1));
end
imgamma = unwrap(imag(gammad))/d;
k = 2*pi*freq*1e6/(3e8);
figure;
set(gca, 'fontSize', 12)
plot(imgamma*a, k*a,'b','linewidth',2);
hold on
plot(real(gammad*a/d), k*a,'r','linewidth',2);
plot(k*a,k*a,'k','linewidth',2)
plot(-imgamma*a, k*a,'b','linewidth',2);
plot(-real(gammad*a/d), k*a,'r','linewidth',2);
plot(-k*a,k*a,'k','linewidth',2)
ylabel('k_0 * a')
xlabel('\beta * a')
legend({'Phase Constant';'Attenuation Constant';'Light Line'})
xlim([-2*pi 2*pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'ytick', 0:pi/4:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})
set(gca, 'yticklabel', {'0', 'pi/4', 'pi/2', '3pi/4', 'pi', '5pi/4', '3pi/2', '7pi/4', '2pi'})
title('Dispersion Diagram Derived from HOBBIES Simulated S Parameters','fontsize',14)

figure;
set(gca, 'fontSize', 12)
plot(k, real(Zchar),'b', k, imag(Zchar),'r');
xlabel('Free Space Wavenumber (1/m)')
ylabel('Characteristic Impedance [\Omega]')
legend({'Re[Z]';'Im[Z]'})
title('Characteristic Impedance Derived from CST Simulated S Parameters','fontsize',14)

figure;
set(gca, 'fontSize', 12)
plot(freq, real(Zchar),'b', freq, imag(Zchar),'r');
xlabel('Frequency [MHz]')
ylabel('Characteristic Impedance [\Omega]')
legend({'Re[Z]';'Im[Z]'})
title('Characteristic Impedance Derived from CST Simulated S Parameters','fontsize',14)

end

