function s_params = abcd2s(abcd_params, z0)
%ABCD2S Convert ABCD-parameters to S-parameters
%   S_PARAMS = ABCD2S(ABCD_PARAMS, Z0) converts the ABCD-parameters
%   ABCD_PARAMS into the scattering parameters S_PARAMS.
%   
%   ABCD_PARAMS is a complex 2Nx2NxM array of M 2N-port ABCD-parameters. Z0
%   is the reference impedance, the default is 50 ohms. The output S_PARAMS
%   is a complex 2Nx2NxM array of M 2N-port S-parameters.
% 
%   See also S2ABCD, ABCD2Y, ABCD2Z, ABCD2H, Y2S, Z2S, H2S

%   Copyright 2003-2011 The MathWorks, Inc.

narginchk(1,2);

% Check the input ABCD-parameters
[freq, abcd_params] = CheckNetworkData(abcd_params, '2N', 'ABCD_PARAMS');

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,freq);
else
    z0 = CheckZ(z0, freq, 'Z0');
end

% Check the dimension
siz = size(abcd_params);
m = siz(1)/2; %2N/2 dimension

% Allocate memory for the S-parameters
s_params = zeros(siz);

% Choose the optimal math depending on the size of the network parameter
if siz(1) == 2
    % Get the ABCD-parameters
    [a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:) ./ z0, ...
        abcd_params(2,1,:) .* z0, abcd_params(2,2,:));
    
    % Calculate the S-parameters
    delta = a+b+c+d;
    s_params = [(a+b-c-d), 2*(a.*d-b.*c); 2*ones(size(b)), (-a+b-c+d)] ./ ...
        repmat(delta, [2 2 1]);
    
else
    I = eye(m);
    for k = 1:freq
        % Get the ABCD-parameters
        A = abcd_params(1:m,1:m,k);
        B = abcd_params(1:m,(m+1):(2*m),k);
        C = abcd_params((m+1):(2*m),1:m,k);
        D = abcd_params((m+1):(2*m),(m+1):(2*m),k);
        
        BB = B/(z0(k)*I);
        CC = C*(z0(k)*I);
        
        denom = A + BB + CC + D;
        
        % Calculate the S-parameters
        S12 = ((A-BB-CC+D)-(A+BB-CC-D)/(A+BB+CC+D)*(A-BB+CC-D))/2;
        s_params(:,:,k) = [(A + BB - CC - D)/denom, S12; ...
            2*I/denom, denom\(-A + BB - CC + D)];
    end
end