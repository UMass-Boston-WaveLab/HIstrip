function h_params = g2h(g_params)
%G2H Convert hybrid G-parameters to hybrid H-parameters
%   H_PARAMS = G2H(G_PARAMS) converts the hybrid G-parameters G_PARAMS 
%   into the hybrid H-parameters H_PARAMS. 
%   
%   G_PARAMS is a complex 2x2xM array of M 2-port G-parameters. The output
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. 
%
%   See also H2G, Z2H, H2S, H2Y, H2ABCD, S2Z, Y2Z, ABCD2Z

%   Copyright 2004-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input G-parameters
m = CheckNetworkData(g_params, 2, 'G_PARAMS');

% Allocate memory for the H-parameters
h_params = zeros(size(g_params));

% Calculate the H-parameters
for k = 1:m
    h_params(:,:,k) = inv(g_params(:,:,k));
end