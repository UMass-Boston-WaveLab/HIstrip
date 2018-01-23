function s_params_passive = makepassive(s_params)
%MAKEPASSIVE Make N-port S-parameters passive 
%   S_PARAMS_PASSIVE = MAKEPASSIVE(S_PARAMS) alters non-passive N-port
%   S-parameters to make them passive. MAKEPASSIVE will error if the
%   singular values at a frequency are too large.
%   
%   S_PARAMS is either a complex NxNxK array of K N-port S-parameters, or
%   an sparameters object.  It is assumed that S_PARAMS is referenced to a
%   real, positive impedance (Z0).
%
%   % EXAMPLE:
%   % Read a Touchstone data file
%   S = sparameters('measured.s2p');
%   % Check the passivity of the S-parameters
%   passivevar = ispassive(S)
%   % Make the data passive
%   S_new = makepassive(S);
%   % Check the passivity again
%   passivevar = ispassive(S_new)
%
%   See also ISPASSIVE, SVD, sparameters
 
%   Copyright 2009-2015 The MathWorks, Inc.
 
narginchk(1,1)

% Check the input S-parameters
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'makepassive','S-Parameters',1)
end
[nfreq,s_params] = CheckNetworkData(s_params,'N','S_PARAMS');

% Set the default
s_params_passive = s_params;
threshold = 1-1000*eps;

% Enforce the passivity 
for jj = 1:nfreq
    % Check the passivity of data
    result = ispassive(s_params_passive(:,:,jj));
    idx = 0;   
    % Enforce the passivity if necessary
    while result == false && idx < 10
        [U,zigma,V] = svd(s_params_passive(:,:,jj));
        nzigma = length(zigma);
        upsilon = eye(nzigma);
        psi = eye(nzigma);
        for ii = 1:nzigma
            if zigma(ii,ii) <= threshold
                upsilon(ii,ii) = 0;
                psi(ii,ii) = 0;
            else
                upsilon(ii,ii) = 1;
                psi(ii,ii) = threshold;
            end
        end
        % Find the violation of data
        zigma_viol = zigma*upsilon-psi;
        s_viol = U*zigma_viol*V';
        % Compensate the data
        s_params_passive(:,:,jj) = s_params_passive(:,:,jj)-s_viol;
        idx = idx + 1;
        result = ispassive(s_params_passive(:,:,jj));
    end
    % Issue an error message if the passivity can not be enforced
    if result == false
        error(message('rf:makepassive:FailToEnforcePassivity'))
    end
end
