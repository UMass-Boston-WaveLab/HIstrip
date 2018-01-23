function z_params = h2z(h_params)
%H2Z Convert hybrid H-parameters to Z-parameters
%   Z_PARAMS = H2Z(H_PARAMS) converts the hybrid H-parameters H_PARAMS
%   into the impedance parameters Z_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. The output
%   Z_PARAMS is a complex 2x2xM array of M 2-port Z-parameters.
%
%   See also Z2H, H2S, H2Y, H2ABCD, S2Z, Y2Z, ABCD2Z

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input H-parameters
CheckNetworkData(h_params, 2, 'H_PARAMS');

% Get the H-parameters
[h11, h12, h21, h22] = deal(h_params(1,1,:), h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:));

% Calculate the Z-parameters
delta = h11 .* h22 - h12 .* h21;
z_params = [delta, h12; -h21, ones(size(h22))] ./ repmat(h22, [2 2 1]);