%f = (2:0.25:7)*1e9;
s=20; %scale factor
f = (100:10:1000)*1e6*s;
a = 0.14/s;
w1 = 0.01/s; % is this right?
w2 = 0.12/s;
h1 = 0.02/s;
h2 = 0.04/s;
via_rad = 0.005/s;
eps1 = 1;
eps2 = 2.2;
feed = 0; %1 for probe feed, 0 for diff


ZL = [0 0; 0 0]; 

%ZL = ones(2)*1e6;


Zin = zeros(size(f));

for ii = 1:length(f)
    Zin(ii) = HIS_term_test_case(4, a, w1, w2, h1, h2, via_rad, eps1, eps2, f(ii), feed, ZL, ZL);
    if real(Zin(ii))<0
        sprintf('Check me\n')
    end
end

figure; 
plot(f*1e-6, real(Zin), f*1e-6, imag(Zin))
xlabel('Frequency [MHz]')
ylabel('\Omega')
legend({'R';'X'})
grid on
