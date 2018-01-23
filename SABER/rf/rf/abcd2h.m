function h_params = abcd2h(abcd_params)
%ABCD2H Convert ABCD-parameters to hybrid H-parameters  
%   H_PARAMS = ABCD2H(ABCD_PARAMS) converts the ABCD-parameters ABCD_PARAMS
%   into the hybrid H-parameters H_PARAMS.
%   
%   ABCD_PARAMS is a complex 2x2xM array of M 2-port ABCD-parameters. The
%   output H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. 
% 
%   See also H2ABCD, ABCD2S, ABCD2Y, ABCD2Z, S2H, Y2H, Z2H

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input ABCD-parameters
CheckNetworkData(abcd_params, 2, 'ABCD_PARAMS');

% Get the ABCD-parameters
[a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:), ...
    abcd_params(2,1,:), abcd_params(2,2,:));

% Calculate the H-parameters
delta = a .* d - b .* c;
h_params = [b, delta; -ones(size(b)), c] ./ repmat(d, [2 2 1]);