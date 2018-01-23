function h_params = s2h(s_params, z0)
%S2H Convert S-parameters to hybrid H-parameters 
%   H_PARAMS = S2H(S_PARAMS, Z0) converts the scattering parameters
%   S_PARAMS into the hybrid H-parameters H_PARAMS. 
%   
%   S_PARAMS is a complex 2x2xM array of M 2-port S-parameters. Z0 is the
%   reference impedance, the default is 50 ohms. The output H_PARAMS is a
%   complex 2x2xM array of M 2-port H-parameters.
%
%   See also H2S, S2Y, S2Z, S2ABCD, Y2H, Z2H, ABCD2H

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,2);

% Check the input S-parameters
m = CheckNetworkData(s_params, 2, 'S_PARAMS');

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,m);
else
    z0 = CheckZ(z0, m, 'Z0');
end

% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the H-parameters
delta = (1-s11).*(1+s22)+s12.*s21;
h_params = [z0.*((1+s11).*(1+s22)-s12.*s21),2*s12; -2*s21, ...
    (((1-s11).*(1-s22)-s12.*s21))./z0] ./ repmat(delta, [2 2 1]);