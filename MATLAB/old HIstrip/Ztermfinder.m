[a, b, c] = xlsread('E:\kkerby\HIstrip\PECantZin.csv');
freq = a(:,1);
PECZin = 2*(a(:,2)+j*a(:,3));
[a, b, c] = xlsread('E:\kkerby\HIstrip\HIstripantZin.csv');
HIstripZin = 2*(a(:,2)+j*a(:,3));

w = 0.01;
h=0.02;
c0 = 3e8;
lambda = c0./(freq*1e6);
beta = 2*pi./lambda;
len = 0.47/2;
deltal = lengthcorrection(0.01, 0.02, 1, 1);
deltal2 = deltal;
[Z0, ~, ~, epseff] = microstrip(w, h, 1); %epseff is 1 here

for ii = 1:length(freq)
    PECZL(ii) = Z0*(PECZin(ii)-j*Z0*tan(beta(ii)*(len+deltal)))/...
        (Z0-j*PECZin(ii)*tan(beta(ii)*(len+deltal)));
    HIstripZL(ii) = Z0*(HIstripZin(ii)-j*Z0*tan(beta(ii)*(len+deltal2)))/...
        (Z0-j*HIstripZin(ii)*tan(beta(ii)*(len+deltal2)));
end
figure
plot(freq, real(PECZL), '-b', freq, imag(PECZL), '--b', freq, real(HIstripZL),'-r', freq, imag(HIstripZL),'--r','linewidth', 3)
xlabel('Frequency [MHz]')
ylabel('Impedance [\Omega]')
legend({'Re(Z_{LPEC})'; 'Im(Z_{LPEC})'; 'Re(Z_{LHI})'; 'Im(Z_{LHI})'})

figure
smithchart((PECZL/50-1)./(PECZL/50+1))
legend('PEC')
figure
smithchart((HIstripZL/50-1)./(HIstripZL/50+1))
legend('HIstrip')