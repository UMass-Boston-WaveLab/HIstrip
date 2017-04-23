f = (100:10:500)*1e6;
a = 0.14;
w1 = 0.05; % is this right?
w2 = 0.12;
h1 = 0.02;
h2 = 0.04;
via_rad = 0.005;
eps1 = 1;
eps2 = 2.2;
feed = 1;

ZL = [0 1e6; 1e6 0];


Zin = zeros(size(f));

for ii = 1:length(f)
    Zin(ii) = HIS_term_test_case(4, a, w1, w2, h1, h2, via_rad, eps1, eps2, f(ii), feed, ZL, ZL);
end

figure; 
plot(f*1e-6, real(Zin), f*1e-6, imag(Zin))

