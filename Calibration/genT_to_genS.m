% Function accepts T-parameters and converts them into
% a 2x2 S-parameter matrix composed of smaller sub-matrices. 
% Matlab has a built in function that does this, but it defines the 
% T-parameters differently from how we are defining them in the multimode
% TRL procedure. See Appendix A of "Multimode TRL Calibration Techniques
% for Characterization of Differential Devices" by Wojnowsky et al for
% the equations.

function [S11, S12, S21, S22, S] = genT_to_genS(T11, T12, T21, T22, T,...
    depth, sub_size)


S11 = zeros(sub_size,sub_size,depth);
S12 = zeros(sub_size,sub_size,depth);
S21 = zeros(sub_size,sub_size,depth);
S22 = zeros(sub_size,sub_size,depth);
X = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    X(:,:,ii) = inv(T22(:,:,ii));
end

for ii = 1:depth
    S11(:,:,ii) = T12(:,:,ii)*X(:,:,ii);
    S12(:,:,ii) = T11(:,:,ii) - T12(:,:,ii)*X(:,:,ii)*T21(:,:,ii);
    S21 = X;
    S22(:,:,ii) = -X(:,:,ii)*T21(:,:,ii);
end

S = [S11 S12; S21 S22];
end