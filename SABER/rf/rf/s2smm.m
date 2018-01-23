function varargout = s2smm(s_params,rfflag)
%S2SMM Convert single-ended S-parameters to mixed-mode S-parameters
%   [SDD, SDC, SCD, SCC] = S2SMM(S_PARAMS_EVEN, RFFLAG)
%   converts single-ended S-parameters to mixed-mode form.
%
%   S_PARAMS_EVEN is a complex 2N x 2N x K array of K 2N-port single-ended
%   S-parameter matrices. SDD, SDC, SCD, and SCC are complex N x N x K
%   arrays of K N-port mixed-mode S-parameters.
%
%   S2SMM uses one of 3 definitions of port indices for 2N-port
%   S-parameters, S_PARAMS_EVEN, determined by the value of the RFFLAG
%   argument. The default value of RFFLAG is 1.
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
%   SMM = S2SMM(S_PARAMS_ODD)
%
%   S_PARAMS_ODD is a complex (2N+1) x (2N+1) x K array of K (2N+1) port
%   single-ended S-parameter matrices.
%
%   SMM is an (N+1) x (N+1) x K complex array of mixed mode S-parameters.
%
%   The topology and port ordering of the input network (S_PARAMS_ODD) is:
% 
%       1   2   3   4           2N-1  2N   2N+1
%       |   |   |   |   . . . .   |   |     |    <- 2N+1 single-ended ports
%     __|___|___|___|_____________|___|_____|___ 
%     |                                         |
%     |           [ S_PARAMS_ODD ]              |
%     |_________________________________________|
%
%   To create the output SMM from S_PARAMS_ODD, the single-ended input
%   ports are paired sequentially (port 1 with port 2, port 3 with port 4,
%   etc.), and the last port is left single-ended.  The mixed-mode
%   S-parameters are then calculated and returned in the matrix SMM.
%
%   The topology and port ordering of the output network (SMM) is:
% 
%         1       2                 N            <- N mixed-mode pairs
%         |       |                 |
%         |       |                 |      N+1   <- one single-ended port        
%       |---|   |---|   . . . . . |---|     | 
%     __|___|___|___|_____________|___|_____|___ 
%     |                                         |
%     |                 [ SMM ]                 |
%     |_________________________________________|
% 
%   Reference: T. Granberg, "Handbook of Digital Techniques for High Speed
%   Design", Upper Saddle River, NJ: Prentice Hall, 2004.
%
%   See also SMM2S, S2SDD, S2SDC, S2SCD, S2SCC, SNP2SMP

%   Copyright 2008-2011 The MathWorks, Inc.


narginchk(1,2);

% Check if S-parameter matrix is vector
if isvector(s_params)
    error(message('rf:s2smm:VectorsNotAllowed'));
end

% Check the input S-parameters
[pts, s_params] = CheckNetworkData(s_params, 'N', 'S_PARAMS');

% Determine the size of the (3-D) S-parameter matrix
N = size(s_params,1);

% Determine the mixed-mode matrices according to the output.
% If the number of ports is even, calculate differential & common modes
if ~mod(N,2)
    Ports = [1:2:N-1 2:2:N];

    % Check the specified ordering for S-parameters and reorder if necessary
    if nargin==2
        if rfflag==1
            Ports = [1:2:N-1 2:2:N];
        elseif rfflag==2
            Ports = 1:N;
        elseif rfflag==3
            Ports = [1:N/2 N:-1:N/2+1];
        else
            error(message('rf:s2smm:RfFlagIncorrect'));
        end
    end

    s_params = s_params(Ports,Ports,:);

    % Create the transformation matrix
    M1 = []; 
    M2 = []; 
    for idx = 1:N/2, 
        M1 = blkdiag(M1,[1 -1]); 
        M2 = blkdiag(M2,[1  1]); 
    end
    M = [M1;M2];
    invM = M';

    % Apply the transformation matrix
    smm_params = zeros(N,N,pts);
    for idx = 1:pts
        smm_params(:,:,idx) = M*s_params(:,:,idx)*invM/2;
    end
    
    if nargout > 0
        varargout{1} = smm_params(1:N/2,1:N/2,:);
        if nargout > 1
            varargout{2} = smm_params(1:N/2,N/2+1:N,:);
            if nargout > 2
                varargout{3} = smm_params(N/2+1:N,1:N/2,:);
                if nargout > 3
                    varargout{4} = smm_params(N/2+1:N,N/2+1:N,:);
                    if nargout > 4
                        error(message('rf:s2smm:NumOutArgEvenPortIncorrect'));
                    end
                end
            end
        end
    end

else % If the number of ports is odd, calculate full mixed-mode

    if N==1 
        error(message('rf:s2smm:NoOnePortSparams'))
    end
    
    if nargin ~= 1
        error(message('rf:s2smm:NoSecondArgNeeded'));
    end
    
    if nargout > 1
        error(message('rf:s2smm:NumOutArgOddPortIncorrect'));
    end

    SEport = 1; % hardcoded for future enhancement
    
    Imat = eye(SEport); % for future enhancement of SEport>1
    
    % Create the transformation matrix. 
    M1 = []; 
    M2 = []; 
    for idx = 1:(N-SEport)/2, 
        M1 = blkdiag(M1,[1/sqrt(2) -1/sqrt(2)]); 
        M2 = blkdiag(M2,[1/sqrt(2)  1/sqrt(2)]); 
    end
    M = [M1;M2];
    MM = blkdiag(Imat,M);

    % Apply the transformation matrix
    smm_params = zeros(N,N,pts);
    for idx = 1:pts
        smm_params(:,:,idx) = MM*s_params(:,:,idx)/MM;
    end
    
    % Output only one matrix for odd number ports
    varargout = {smm_params};
end