function s_params = h2s(h_params, z0)
%H2S Convert hybrid H-parameters to S-parameters 
%   S_PARAMS = H2S(H_PARAMS, Z0) converts the hybrid H-parameters H_PARAMS
%   into the scattering parameters S_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. Z0 is the
%   reference impedance, the default is 50 ohms. The output S_PARAMS is a
%   complex 2x2xM array of M 2-port S-parameters.
%
%   See also S2H, H2Y, H2Z, H2ABCD, Y2S, Z2S, ABCD2S

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,2);

% Check the input H-parameters
m = CheckNetworkData(h_params, 2, 'H_PARAMS');

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,m);
else
    z0 = CheckZ(z0, m, 'Z0');
end

% Get the H-parameters 
[h11, h12, h21, h22] = deal(h_params(1,1,:)./z0, h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:).*z0);

% Calculate the S-parameters
delta = (h11+1).*(h22+1)-h12.*h21;
s_params = [((h11-1).*(h22+1)-h12.*h21), 2*h12; -2*h21, ...
    ((1+h11).*(1-h22)+h12.*h21)] ./ repmat(delta, [2 2 1]);