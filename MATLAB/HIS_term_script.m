%f = (2:0.25:7)*1e9;
s=20; %scale factor
n=4; % number of unit cells in model
f = (100:2.5:400)*1e6*s;
a = 0.14/s;
w1 = 0.01/s; % is this right?
w2 = 0.12/s;
h2 = 0.04/s;
h1 = 0.02/s+h2; %h1 is defined from the ground plane!!
via_rad = 0.005/s;
eps1 = 2.2;
eps2 = 2.2;
feed = 0; %1 for probe feed, 0 for diff



L1 = viaL(h1-h2, via_rad);
L2 = viaL(h2, via_rad);

loadIndMat = [L1 0; 0 0]+L2*ones(2,2);

ZL = zeros(2,2);


Zin = zeros(size(f));

for ii = 1:length(f)
    ZL = j*2*pi*f(ii)*loadIndMat;
    
    Zin(ii) = HIS_term_test_case(n, a, w1, w2, h1, h2, via_rad, eps1, eps2, f(ii), feed, ZL, ZL);
    if real(Zin(ii))<0
        sprintf('Check me\n')
    end
end

figure; 
plot(f*1e-6, real(Zin), f*1e-6, imag(Zin),'linewidth',2)
xlabel('Frequency [MHz]')
ylabel('\Omega')
legend({'R';'X'})
grid on
set(gca,'fontsize',14)
ylim([-4000 10000])
xlim([2000 7000])
