function abcd_params = z2abcd(z_params)
%Z2ABCD Convert Z-parameters to ABCD-parameters
%   ABCD_PARAMS = Z2ABCD(Z_PARAMS) converts the impedance parameters
%   Z_PARAMS into the ABCD-parameters ABCD_PARAMS. 
%   
%   Z_PARAMS is a complex 2Nx2NxM array of M 2N-port Z-parameters. The
%   output ABCD_PARAMS is a complex 2Nx2NxM array of M 2N-port
%   ABCD-parameters.
%
%   See also ABCD2Z, Z2S, Z2Y, Z2H, S2ABCD, Y2ABCD, H2ABCD

%   Copyright 2003-2011 The MathWorks, Inc.

narginchk(1,1);

% Check the input Z-parameters
[freq, z_params] = CheckNetworkData(z_params, '2N', 'Z_PARAMS');

% Check the dimension
siz = size(z_params); 
m = siz(1)/2; %2N/2 dimension

% Allocate memory for the ABCD-parameters
abcd_params = zeros(siz);

% Choose the optimal math depending on the size of the network parameter
if siz(1) == 2
    % Get the Z-parameters
    [z11, z12, z21, z22] = deal(z_params(1,1,:), z_params(1,2,:), ...
        z_params(2,1,:), z_params(2,2,:));
    
    % Calculate the ABCD-parameters
    delta = z11 .* z22 - z12 .* z21;
    abcd_params = [z11, delta; ones(size(z21)), z22] ./ repmat(z21, [2 2 1]);
    
else
    I = eye(m);
    for k = 1:freq
        % Get the Z-parameters
        z11 = z_params(1:m,1:m,k);
        z12 = z_params(1:m,(m+1):(2*m),k);
        z21 = z_params((m+1):(2*m),1:m,k);
        z22 = z_params((m+1):(2*m),(m+1):(2*m),k);
        
        % Calculate the ABCD-parameters
        abcd_params(:,:,k) = [z11/z21, z11/z21*z22-z12 ; I/z21, z21\z22];
    end
end