function [] = MTL_basic_stackedustrip(w1, h1, w2, h2, eps1, eps2, freq)
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*freq;

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[~, C2G, L22,~] = microstrip(w2, h2, eps2);
[~, ~, L11, ~] = microstrip(w1, h1, eps1); %just to test the self-inductance calc...


C = [C12, -C12; -C12, C2G+C12];

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); %I'm using microstrip per-unit-length capacitance values here
[~, C2G0, ~,~] = microstrip(w2, h2, 2);

C0 = [C120, -C120; -C120, C2G0+C120];
L = inv(C0)*mu0*eps0;

for ii = 1:length(freq)
    ZY = j*omega(ii)*L*j*omega(ii)*C;
    Gam = sqrtm(ZY);
    Zw(:,:,ii) = Gam\(j*omega(ii)*L); %terminal-based characteristic impedance matrix
    Zin1(ii) = prll(Zw(1,1,ii),(Zw(1,2,ii)+Zw(2,2,ii)));
    Zin2(ii) = prll(Zw(2,2,ii), (Zw(1,2,ii)+Zw(1,1,ii)));
end
figure
plot(freq*1e-6,real(Zin1), freq*1e-6, imag(Zin1))
title('Port 1')
figure
plot(freq*1e-6,real(Zin2), freq*1e-6, imag(Zin2))
title('Port 2')

figure
plot(freq*1e-6,squeeze(real(Zw(1,1,:))), freq*1e-6, squeeze(real(Zw(1,2,:))), freq*1e-6,squeeze(real(Zw(2,2,:))))
title('Multiconductor Characteristic Impedance')
legend({'Z11';'Z12';'Z22'})

save('ustripcalcZ', 'Zw','freq')