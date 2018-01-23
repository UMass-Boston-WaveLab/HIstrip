function t_params = s2t(s_params)
%S2T Convert S-parameters to T-parameters
%   T_PARAMS = S2T(S_PARAMS) converts the scattering parameters S_PARAMS
%   into the chain scattering parameters T_PARAMS. 
%   
%   S_PARAMS is a complex 2x2xM array of M 2-port S-parameters. The output
%   T_PARAMS is a complex 2x2xM array of M 2-port T-parameters. The
%   definitions of the S-parameters and T-parameters are
%   
%       [b(1) b(2)]' = [S_PARAMS] * [a(1) a(2)]'
%
%       [a(1) b(1)]' = [T_PARAMS] * [b(2) a(2)]'
%
%   Where, a(i) is the normalized incident wave at the i-th port, and b(i)
%   is the normalized reflected wave at the i-th port. 
%
%   See also S2ABCD, S2Y, S2Z, S2H, T2S

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,1);

% Check the input S-parameters
CheckNetworkData(s_params, 2, 'S_PARAMS');

% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the T-parameters
delta = (s11.*s22-s12.*s21);
t_params = [1./s21, -s22./s21; s11./s21, -delta./s21];