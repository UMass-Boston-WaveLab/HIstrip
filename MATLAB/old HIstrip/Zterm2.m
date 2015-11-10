%Uses ABCD matrix for MTL line behavior instead of transmission line
%equation for Zin

[a, b, c] = xlsread('E:\kkerby\HIstrip\PECantZin.csv');
freq = a(:,1).';
PECZin = 2*(a(:,3)+j*a(:,2));
[a, b, c] = xlsread('E:\kkerby\HIstrip\HIstripantZin.csv');
HIstripZin = 2*(a(:,3)+j*a(:,2));

a = 0.14;
w1 = 0.01;
h2 = 0.04;
h1= 0.02+h2;
eps1=1;
w2 = 0.12;
eps2=2.2;
via_rad = 0.0015875;


c0 = 3e8;
lambda = c0./(freq*1e6);
beta = 2*pi./lambda;
omega = 2*pi*freq*1e6;
len = 0.47/2;
[Z0, ~, ~, epseff] = microstrip(w1, h1-h2, eps1); %epseff is 1 here
deltal = lengthcorrection(w1, h1-h2, epseff, eps1);
deltal2 = deltal;
expn = round((len+deltal2)/a);
expn = (len+deltal2)/a;


for ii = 1:length(freq)
    [ABCDbot, ZBbot(ii), gambot(ii)] = bottom_unitcell(a, w2, h2, via_rad, eps2, freq(ii)*1e6);
    [ABCD, ~] = multicond_unitcell(a, w1, w2, h1, h2, via_rad, eps1, eps2, freq(ii)*1e6);
    PECZL(ii) = Z0*(PECZin(ii)-j*Z0*tan(beta(ii)*(len+deltal)))/...
        (Z0-j*PECZin(ii)*tan(beta(ii)*(len+deltal)));
    line2 = ABCD^expn;
    Z4 = ABCD4toZ(line2);
    Z2 = [Z4(1,1) Z4(1,3); Z4(3,1) Z4(3,3)];
    ABCD2 = ZtoABCD(Z2);
    A = ABCD2(1,1);
    B = ABCD2(1,2);
    C = ABCD2(2,1);
    D = ABCD2(2,2);
    HIstripZL(ii) = (D*HIstripZin(ii)-B)/(A-C*HIstripZin(ii));
end
HIQ = calcQ(HIstripZL, omega);
PECQ = calcQ(PECZL, omega);

figure
plot(freq, real(PECZL), '-b', freq, imag(PECZL), '--b', freq, real(HIstripZL),'-r', freq, imag(HIstripZL),'--r','linewidth', 3)
xlabel('Frequency [MHz]')
ylabel('Impedance [\Omega]')
legend({'Re(Z_{LPEC})'; 'Im(Z_{LPEC})'; 'Re(Z_{LHI})'; 'Im(Z_{LHI})'})


figure
plot(freq, real(ZBbot), '-b', freq, imag(ZBbot), '--b','linewidth', 3)
xlabel('Frequency [MHz]')
ylabel('Impedance [\Omega]')
legend({'Re(Z_{bot})'; 'Im(Z_{bot})'})

figure
smithchart((PECZL/50-1)./(PECZL/50+1))
legend('PEC')

figure
smithchart((HIstripZL/50-1)./(HIstripZL/50+1))
legstr = ['HIstrip (ABCD), expn = ' num2str(expn)];
legend(legstr)

figure
plot(freq, PECQ, freq, HIQ)
legend({'PEC';'HIStrip'})
title('Antenna Q')
xlabel('Frequency [MHz]');

figure
plot(freq, 10*log10(abs(PECQ)), freq, 10*log10(abs(HIQ)))
legend({'PEC';'HIStrip'})
title('Antenna Q [dB]')
xlabel('Frequency [MHz]');


