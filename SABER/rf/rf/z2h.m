function h_params = z2h(z_params)
%Z2H Convert Z-parameters to hybrid H-parameters
%   H_PARAMS = Z2H(Z_PARAMS) converts the impedance parameters Z_PARAMS 
%   into the hybrid H-parameters H_PARAMS. 
%   
%   Z_PARAMS is a complex 2x2xM array of M 2-port Z-parameters. The output
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters.
%
%   See also H2Z, Z2S, Z2Y, Z2ABCD, S2H, Y2H, ABCD2H

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input Z-parameters
CheckNetworkData(z_params, 2, 'Z_PARAMS');

% Get the Z-parameters
[z11, z12, z21, z22] = deal(z_params(1,1,:), z_params(1,2,:), ...
    z_params(2,1,:), z_params(2,2,:));

% Calculate the H-parameters
delta = z11 .* z22 - z12 .* z21;
h_params = [delta, z12; -z21, ones(size(z22))] ./ repmat(z22, [2 2 1]);