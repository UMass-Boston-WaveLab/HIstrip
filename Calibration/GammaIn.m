% Converts the reflect standard gammaL to gammaIn seen at the input of the
% device. Used to test the reflect standards. 
%
% Source: "Multimode TRL Calibration Technique for Characterization of
% Differential Devices," IEEE Microwave Theory, Vol. 60, No. 7, July 2012;
% equations on page 2242.
%
% Inputs: 
%    - Measured/simulated S-Parameters for reflect standard
%    - S parameters for the access lines (using the raw through data for 
%      now?
% Outputs:
%    - GammaIn matrix. 

function [gammaIn] = GammaIn(S11, S12, S21, S22, gammaL)

% Grab the lengths of the matrices
[~,~, depth1] = size(S11);
[~,~, depth2] = size(gammaL);

% Check lengths for equality
if depth1 ~= depth2
    ME = MException('Matrices must be the same size!');
    throw(ME)
end

% Preallocate matrices
gammaIn = zeros(2, 2, depth2);
ID = eye(2);

% Perform s-parameter conversion
for ii = 1:depth2
    gammaIn(:,:,ii) = S11(:,:,ii) + S12(:,:,ii)*gammaL(:,:,ii) * ...
        inv(ID - (S22(:,:,ii)*gammaL(:,:,ii))) * S21(:,:,ii);
end
