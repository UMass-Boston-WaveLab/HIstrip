function sdd_params = s2sdd(s_params, rfflag)
%S2SDD Convert 2N-port S-parameters to differential N-port S-parameters Sdd
%   SDD_PARAMS = S2SDD(S_PARAMS, RFFLAG) coverts single-ended 2N-port
%   S-parameters to differential-mode N-port S-parameters. 
%
%   S_PARAMS is a complex 2Nx2NxM array of M 2N-port single-ended
%   S-parameters. The output SDD_PARAMS is a complex NxNxM array of M
%   N-port differential-mode S-parameters.
%
%   S2SDD uses one of 3 definitions of port indices for 2N-port
%   S-parameters, S_PARAMS, determined by the value of the RFFLAG argument.
%   The default value of RFFLAG is 1.
% 
%   The general topology of the network is:
% 
%        1|     2|                N-1|     N|    <- N mixed-mode pairs
%         |      |                   |      |          
%       |---|  |---|   . . . . .   |---|  |---|  <- 2N single-ended ports
%     __|___|__|___|_______________|___|__|___|__    from S_PARAMS_EVEN
%     |                                         | (order defined by RFFLAG)
%     |           [ 2N-port network ]           |
%     |_________________________________________|
% 
%     RFFLAG = 1: Odd-numbered ports are followed by even-numbered ports:
%     1, 3, 5, ... , 2N-4, 2N-2, 2N.
%
%     RFFLAG = 2: Ports are paired in ascending order: (1,2),...,(2N-1,2N).
%
%     RFFLAG = 3: Half of the ports are in ascending order followed by the
%     remaining ports in descending order: 1,2,...,N,2N,2N-1,...,N+1.
%
%   Reference: W. Fan, A. C. W. Lu, L. L. Wai and B. K. Lok "Mixed-Mode
%   S-Parameter Characterization of Differential Structures" Electronic
%   Packaging Technology Conference, pp533-537, 2003 
%      
%   See also S2SCC, S2SDC, S2SCD, SMM2S, S2SMM

%   Copyright 2005-2010 The MathWorks, Inc.

narginchk(1,2);

% Check the input S-parameters
CheckNetworkData(s_params, '2N', 'S_PARAMS');

% Get and check the rfflag
if nargin == 1
    rfflag = 1;
end

[sdd_params] = s2smm(s_params, rfflag);
