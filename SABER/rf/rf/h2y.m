function y_params = h2y(h_params)
%H2Y Convert hybrid H-parameters to Y-parameters
%   Y_PARAMS = H2Y(H_PARAMS) converts the hybrid H-parameters H_PARAMS
%   into the admittance parameters Y_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. The output
%   Y_PARAMS is a complex 2x2xM array of M 2-port Y-parameters.
%
%   See also Z2H, H2S, H2Y, H2ABCD, S2Z, Y2Z, ABCD2Z

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input H-parameters
CheckNetworkData(h_params, 2, 'H_PARAMS');

% Get the H-parameters
[h11, h12, h21, h22] = deal(h_params(1,1,:), h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:));

% Calculate the Y-parameters
delta = h11 .* h22 - h12 .* h21;
y_params = [ones(size(h11)), -h12; h21, delta] ./ repmat(h11, [2 2 1]);