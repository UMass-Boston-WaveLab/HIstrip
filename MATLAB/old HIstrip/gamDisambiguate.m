function [gamma] = gamDisambiguate(gam1, gam2, n1, n2,a);

amb1 = gam1+j*(0:(2*pi/n1):(2*pi*0.9999999999))/a;
amb2 = gam2+j*(0:(2*pi/n2):(2*pi*0.9999999999))/a;

if abs(imag(gam2-gam1))>2*pi/a %make sure they're on the same branch
    gam1 = gam1+j*2*pi/a*floor(imag(gam2-gam1)/(2*pi/a));
end

opt1 = kron(amb1, ones(size(amb2)));
opt2 = kron(ones(size(amb1)), amb2);

[~,index] = min(abs(imag(opt1-opt2)));

%if they're not precisely equal, we average them
gamma = (opt1(index)+opt2(index))/2;

