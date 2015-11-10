function [ ] = ppmodes( X, h, f )
%PPMODES Modes of parallel-plate guide if one plate has surface reactance 
    %X. 
epsilon = 8.854e-12;
mu = 1.2566e-6;
omega = 2*pi*f;
beta = sqrt(omega^2*mu*epsilon);
ky = 0:(beta/1000):beta;

TMrel = X*omega*epsilon./tan(ky*h);
TErel = -omega*mu*tan(ky*h)/X;
figure;
plot(ky, TMrel, ky, TErel, ky, ky)
title('High-impedance parallel plate dispersion relation')
legend({'TM relation';'TE relation'; 'k_y'})
ylim([0 max(ky)])





end

