function s_params = t2s(t_params)
%T2S Convert T-parameters to S-parameters
%   S_PARAMS = T2S(T_PARAMS) converts the chain scattering parameters
%   T_PARAMS into the scattering parameters S_PARAMS. 
% 
%   S_PARAMS is a complex 2x2xM array of M 2-port S-parameters. The output
%   T_PARAMS is a complex 2x2xM array of M 2-port T-parameters. The
%   definitions of the T-parameters and S-parameters are
%
%       [a(1) b(1)]' = [T_PARAMS] * [b(2) a(2)]'
%   
%       [b(1) b(2)]' = [S_PARAMS] * [a(1) a(2)]'
%
%   Where, a(i) is the normalized incident wave at the i-th port, and b(i)
%   is the normalized reflected wave at the i-th port. 
%
%   See also ABCD2S, Y2S, Z2S, H2S, S2T

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input T-parameters
CheckNetworkData(t_params, 2, 'T_PARAMS');

% Get the T-parameters 
[t11, t12, t21, t22] = deal(t_params(1,1,:), t_params(1,2,:), ...
    t_params(2,1,:), t_params(2,2,:));

% Calculate the S-parameters
delta = t11.*t22-t21.*t12;
s_params = [t21./t11, delta./t11; 1./t11, -t12./t11];