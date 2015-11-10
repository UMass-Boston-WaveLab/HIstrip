function [  ] = kbfromCSTsparams( CST_file_mag, CST_file_phase, d, a)
%KBFROMCSTSPARAMS Summary of this function goes here
%   Detailed explanation goes here
[freq, Smag] = read_CST_file(CST_file_mag);
[~, Sphase] = read_CST_file(CST_file_phase);

Z0 = 50;
gamma = zeros(size(freq));

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
legend({'Phase Const.';'Attenuation Const.';'Light Line'},'location','southeast')
xlim([-2*pi 2*pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'ytick', 0:pi/4:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})
set(gca, 'yticklabel', {'0', 'pi/4', 'pi/2', '3pi/4', 'pi', '5pi/4', '3pi/2', '7pi/4', '2pi'})
title('Dispersion Diagram Derived from CST Simulated S Parameters','fontsize',14)

figure;
set(gca, 'fontSize', 12)
plot(imgamma*a, freq,'b','linewidth',2);
hold on
plot(real(gammad*a/d), freq,'r','linewidth',2);
plot(k*a,freq,'k','linewidth',2)
plot(-imgamma*a, freq,'b','linewidth',2);
plot(-real(gammad*a/d),freq,'r','linewidth',2);
plot(-k*a,freq,'k','linewidth',2)
ylabel('Frequency [MHz]')
xlabel('\beta * a')
legend({'Phase Const.';'Attenuation Const.';'Light Line'},'location','southeast')
xlim([-2*pi 2*pi])
set(gca, 'xtick', -2*pi:pi/2:2*pi)
set(gca, 'xticklabel', {'-2pi', '-3pi/2', '-pi', '-pi/2', '0', 'pi/2', 'pi', '3pi/2', '2pi'})
title('Dispersion Diagram Derived from CST Simulated S Parameters','fontsize',14)



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

function [freq, out] = read_CST_file(filename)
fid = fopen(filename);
ii = 1;
test = fgetl(fid);
if ~isempty(strfind(test,'dB'))
    units = 'dB';
elseif ~isempty(strfind(test,'deg'))
    units = 'deg';
else
    units = '';
end
while test ~=-1
    fgetl(fid);
    temp = textscan(fid, '%f %f');
    out(:,ii) = temp{2};
    freq = temp{1};
    if strcmp(units,'dB')
        out(:,ii) = 10.^(out(:,ii)/10);
    elseif strcmp(units,'deg')
        out(:,ii) = out(:,ii)*pi/180;
    end
    clear temp;
    test = fgetl(fid);
    ii = ii+1;
end
end

function [ABCD] = getABCDfromS(S,Z0)
A = ((1+S(1,1))*(1-S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));
B = Z0*((1+S(1,1))*(1+S(2,2))-S(1,2)*S(2,1))/(2*S(2,1));
C = ((1-S(1,1))*(1-S(2,2))-S(1,2)*S(2,1))/(2*S(2,1)*Z0);
D = ((1-S(1,1))*(1+S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));

ABCD = [A B; C D];

end

