% Function accepts a 4x4 matrix of S-parameters and converts them into
% a 4x4 matrix of T-parameters composed of smaller 2x2 matrices. 
% Matlab has a built in function that does this, but it defines the 
% T-parameters differently from how we are defining them in the multimode
% TRL procedure. See Appendix A of "Multimode TRL Calibration Techniques
% for Characterization of Differential Devices" by Wojnowsky et al for
% the equations.

function [T11, T12, T21, T22, T] = S_to_T(S11, S12, S21, S22, S)
[k,l,m] = size(S);
T11 = zeros(2,2,m);
T12 = zeros(2,2,m);
T21 = zeros(2,2,m);
T22 = zeros(2,2,m);
X = zeros(2,2,m);
for ii = 1:m
    X(:,:,ii) = inv(S21(:,:,ii));
end
for ii = 1:m
    T11(:,:,ii) = S12(:,:,ii) - S11(:,:,ii)*X(:,:,ii)*S22(:,:,ii);
    T12(:,:,ii) = S11(:,:,ii)*X(:,:,ii);
    T21(:,:,ii) = -X(:,:,ii)*S22(:,:,ii);
    T22 = X;
end
T = [T11 T12; T21 T22];
end

    

