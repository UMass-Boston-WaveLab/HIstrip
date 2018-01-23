function abcd_params = y2abcd(y_params)
%Y2ABCD Convert Y-parameters to ABCD-parameters
%   ABCD_PARAMS = Y2ABCD(Y_PARAMS) converts the admittance parameters
%   Y_PARAMS into the ABCD-parameters ABCD_PARAMS. 
%   
%   Y_PARAMS is a complex 2Nx2NxM array of M 2N-port Y-parameters. The
%   output ABCD_PARAMS is a complex 2Nx2NxM array of M 2N-port
%   ABCD-parameters.
%
%   See also ABCD2Y, Y2S, Y2Z, Y2H, S2ABCD, Z2ABCD, H2ABCD

%   Copyright 2003-2011 The MathWorks, Inc.

narginchk(1,1);

% Check the input Y-parameters
[freq, y_params] = CheckNetworkData(y_params, '2N', 'Y_PARAMS');

% Check the dimension
siz = size(y_params);
m = siz(1)/2; %2N/2 dimension

% Allocate memory for the ABCD-parameters
abcd_params = zeros(siz);

% Choose the optimal math depending on the size of the network parameter
if siz(1) == 2
    % Get the Y-parameters
    [y11, y12, y21, y22] = deal(y_params(1,1,:), y_params(1,2,:), ...
        y_params(2,1,:), y_params(2,2,:));
    
    % Calculate the ABCD-parameters
    delta = y11 .* y22 - y12 .* y21;
    abcd_params = [-y22, -ones(size(y12)); -delta, -y11] ./ repmat(y21, [2 2 1]);
    
else
    I = eye(m);
    for k = 1:freq
        % Get the Y-parameters
        y11 = y_params(1:m,1:m,k);
        y12 = y_params(1:m,(m+1):(2*m),k);
        y21 = y_params((m+1):(2*m),1:m,k);
        y22 = y_params((m+1):(2*m),(m+1):(2*m),k);
        
        % Calculate the ABCD-parameters
        abcd_params(:,:,k) = [-y21\y22, -I/y21 ; y12-y11/y21*y22, -y11/y21];
    end
end