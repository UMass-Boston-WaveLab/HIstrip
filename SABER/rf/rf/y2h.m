function h_params = y2h(y_params)
%Y2H Convert Y-parameters to hybrid H-parameters
%   H_PARAMS = Y2H(Y_PARAMS) converts the admittance parameters Y_PARAMS 
%   into the hybrid H-parameters H_PARAMS. 
%   
%   Y_PARAMS is a complex 2x2xM array of M 2-port Y-parameters. The output
%   H_PARAMS is a complex 2x2xM array of M 2-port H-parameters. 
%
%   See also H2Y, Y2S, Y2Z, Y2ABCD, S2H, Z2H, ABCD2H

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input Y-parameters
CheckNetworkData(y_params, 2, 'Y_PARAMS');

% Get the Y-parameters
[y11, y12, y21, y22] = deal(y_params(1,1,:), y_params(1,2,:), ...
    y_params(2,1,:), y_params(2,2,:));

% Calculate the H-parameters
delta = y11 .* y22 - y12 .* y21;
h_params = [ones(size(y11)), -y12; y21, delta] ./ repmat(y11, [2 2 1]);