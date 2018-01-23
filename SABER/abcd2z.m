function z_params = abcd2z(abcd_params)
%ABCD2Z Convert ABCD-parameters to Z-parameters
%   Z_PARAMS = ABCD2Z(ABCD_PARAMS) converts the ABCD-parameters ABCD_PARAMS
%   into the impedance parameters Z_PARAMS. 
%   
%   ABCD_PARAMS is a complex 2Nx2NxM array of M 2N-port ABCD-parameters.
%   The output Z_PARAMS is a complex 2Nx2NxM array of M 2N-port
%   Z-parameters.
% 
%   See also Z2ABCD, ABCD2S, ABCD2Y, ABCD2H, S2Z, Y2Z, H2Y

%   Copyright 2003-2011 The MathWorks, Inc.

narginchk(1,1);

% Check the input ABCD-parameters
[freq, abcd_params] = CheckNetworkData(abcd_params, '2N', 'ABCD_PARAMS');

% Check the dimension
siz = size(abcd_params);
m = siz(1)/2; %2N/2 dimension

% Allocate memory for the Z-parameters
z_params = zeros(siz);

% Choose the optimal math depending on the size of the network parameter
if siz(1) == 2
    % Get the ABCD-parameters
    [a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:), ...
        abcd_params(2,1,:), abcd_params(2,2,:));
    
    % Calculate the Z-parameters
    delta = a.*d - b.*c;
    z_params = [a, delta; ones(size(b)), d] ./ repmat(c, [2 2 1]);
    
else
    I = eye(m);
    for k = 1:freq
        % Get the ABCD-parameters
        A = abcd_params(1:m,1:m,k);
        B = abcd_params(1:m,(m+1):(2*m),k);
        C = abcd_params((m+1):(2*m),1:m,k);
        D = abcd_params((m+1):(2*m),(m+1):(2*m),k);
        
        % Calculate the Z-parameters
        z_params(:,:,k) = [A/C, A/C*D-B ; I/C, C\D];
    end
end