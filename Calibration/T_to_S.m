% Function accepts a 4x4 matrix of T-parameters and converts them into
% a 4x4 matrix of S-parameters composed of smaller 2x2 matrices. 
% Matlab has a built in function that does this, but it defines the 
% T-parameters differently from how we are defining them in the multimode
% TRL procedure. See Appendix A of "Multimode TRL Calibration Techniques
% for Characterization of Differential Devices" by Wojnowsky et al for
% the equations.

function [S11, S12, S21, S22, S] = T_to_S(T11, T12, T21, T22, T)
[k,l,m] = size(T);
S11 = zeros(2,2,m);
S12 = zeros(2,2,m);
S21 = zeros(2,2,m);
S22 = zeros(2,2,m);
X = zeros(2,2,m);
for ii = 1:m
    X(:,:,ii) = inv(T22(:,:,ii));
end
for ii = 1:m
    S11(:,:,ii) = T12(:,:,ii)*X(:,:,ii);
    S12(:,:,ii) = T11(:,:,ii) - T12(:,:,ii)*X(:,:,ii)*T21(:,:,ii);
    S21 = X;
    S22(:,:,ii) = -X(:,:,ii)*T21(:,:,ii);
end
S = [S11 S12; S21 S22];
end
