function g_params = h2g(h_params)
%H2G Convert hybrid H-parameters to hybrid G-parameters
%   G_PARAMS = H2G(H_PARAMS) converts the hybrid H-parameters H_PARAMS 
%   into the hybrid G-parameters G_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. The output
%   G_PARAMS is a complex 2x2xM array of M 2-port G-parameters. 
%
%   See also G2H, Z2H, H2S, H2Y, H2ABCD, S2Z, Y2Z, ABCD2Z

%   Copyright 2004-2013 The MathWorks, Inc.

narginchk(1,1);

% Check the input H-parameters
m = CheckNetworkData(h_params, 2, 'H_PARAMS');

% Allocate memory for the G-parameters
g_params = zeros((size(h_params)));

% Calculate the G-parameters
for k = 1:m
    g_params(:,:,k) = inv(h_params(:,:,k));
end