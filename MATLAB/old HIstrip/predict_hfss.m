a = 0.14;
w1 = 0.01;
h2 = 0.04;
h1= 0.02+h2;
eps1=1;
w2 = 0.12;
eps2=2.2;
freq = 100:0.5:500; %in MHz
via_rad = 0.0015875;
Cterm1 = -47e-12;
Cterm2 = 150e-12;
Y11 = 1/172;
% Y11 = 0;

lambda = 3e8./(freq*1e6);
k = 2*pi./lambda;

for ii = 1:length(freq)
    Y21 = j*2*pi*freq(ii)*Cterm1*1e6;
    Y22 = j*2*pi*freq(ii)*Cterm2*1e6;
%     gapcorr = stacked_ustrip_line_seg(w1, w2, h1, h2, eps1, eps2,
%     -(a-w2), freq(ii)*1e6);
    gapcorr = eye(4);
    Yterm = [1 0 0 0; 0 1 0 0; Y21 -Y21 1 0; -Y21 Y21 0 1]*[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 Y22 0 1]*[1 0 0 0; 0 1 0 0; Y11 0 1 0; 0 0 0 1];
    Yterm1 = Yterm*gapcorr;
    Yterm2 = gapcorr*Yterm;

    [ABCD(:,:,ii), ~] = multicond_unitcell(a,w1, w2, h1, h2, via_rad, eps1, eps2, freq(ii)*1e6);
    
    [gamma(ii), Zbloch(ii), ABCD2(:,:,ii)] = predict_nonMTL2(ABCD(:,:,ii), a, freq(ii)*1e6, Yterm1, Yterm2);
    condval(ii) = cond(ABCD(:,:,ii));
    ADmBC(ii) = ABCD2(1,1,ii)*ABCD2(2,2,ii)-ABCD2(2,1,ii)*ABCD2(1,2,ii);
    %I need to look at these components of ABCD^n1, ABCD^n2
    Q(:,:,ii) = Yterm1*ABCD(:,:,ii)^2*Yterm2;
    C22(ii) = Q(4,2,ii);
    C21(ii) = Q(4,1,ii);
    D21(ii) = Q(4,3,ii);
end

figure
scatter( real(gamma)*a, freq, 'r')
hold on
scatter(wrapToPi(imag(gamma)*a), freq, 'b')
plot(k*a,freq,'k', -k*a,freq,'k') 
scatter(-wrapToPi(imag(gamma)*a), freq, 'b')
legend({'\beta a'; '\alpha a'; 'Light Line'})
ylabel('Frequency [MHz]')
xlabel('Unitless')
xlim([-pi pi])

figure
plot( freq, real(Zbloch),'b',freq, imag(Zbloch),'r')
legend({'R';'X'})
title('Bloch Impedance R+jX')
xlabel('Frequency [MHz]')
ylabel('Impedance [\Omega]')
% ylim([-200 1000])

figure
plot(freq,ADmBC)
title('ABCD reciprocity check')
% figure
% plot(freq, squeeze(real(ABCD(4,2,:))),'b', freq,squeeze(imag(ABCD(4,2,:))),'r')
% figure
% plot(freq, squeeze(real(Q(4,2,:))),'c', freq,squeeze(imag(Q(4,2,:))),'m')
% title('C22 for matrices #1 and #2')