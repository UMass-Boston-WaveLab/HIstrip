function abcd_params = h2abcd(h_params)
%H2ABCD Convert hybrid H-parameters to ABCD-parameters
%   ABCD_PARAMS = H2ABCD(H_PARAMS) converts the hybrid H-parameters
%   H_PARAMS into the ABCD-parameters ABCD_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. The output
%   ABCD_PARAMS is a complex 2x2xM array of M 2-port ABCD-parameters.
%
%   See also ABCD2H, H2S, H2Y, H2Z, S2ABCD, Y2ABCD, Z2ABCD

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1)

% Check the input H-parameters
CheckNetworkData(h_params, 2, 'H_PARAMS');

% Get the H-parameters
[h11, h12, h21, h22] = deal(h_params(1,1,:), h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:));

% Calculate the ABCD-parameters
delta = h11 .* h22 - h12 .* h21;
abcd_params = [-delta, -h11; -h22, -ones(size(h22))] ./ repmat(h21, [2 2 1]);