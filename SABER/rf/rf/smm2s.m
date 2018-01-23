function s_params = smm2s(sdd_params, sdc_params, scd_params, scc_params, rfflag)
%SMM2S Convert four N-port mixed-mode S-parameters to 2N-port single-ended S-parameters
%   S_PARAMS = SMM2S(SDD_PARAMS, SDC_PARAMS, SCD_PARAMS, SCC_PARAMS, RFFLAG)
%   converts mixed-mode S-parameters to single-ended form.  
%
%   SDD_PARAMS, SDC_PARAMS, SCD_PARAMS, and SCC_PARAMS are complex NxNxM
%   arrays of M N-port mixed-mode S-parameters. The output S_PARAMS is a
%   complex 2Nx2NxM array of M 2N-port single-ended S-parameters.  
%
%   SMM2S uses one of 3 definitions of port indices for 2N-port
%   S-parameters, S_PARAMS, determined by the value of the RFFLAG argument.
%   The default value of RFFLAG is 1.
%
%   The general topology of the network is:
% 
%        1|     2|                N-1|     N|    <- N mixed-mode pairs
%         |      |                   |      |          
%       |---|  |---|   . . . . .   |---|  |---|  <- 2N single-ended ports
%     __|___|__|___|_______________|___|__|___|__ (order defined by RFFLAG)
%     |                                         |
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
%   Reference: T. Granberg, "Handbook of Digital Techniques for High Speed
%   Design", Upper Saddle River, NJ: Prentice Hall, 2004.
%
%   See also S2SMM, S2SDD, S2SDC, S2SCD, S2SCC, SNP2SMP

%   Copyright 2008-2011 The MathWorks, Inc.


narginchk(4,5);

% Check the format of mixed-mode parameters
checksizesmm(sdd_params,'SDD_PARAMS');
checksizesmm(sdc_params,'SDC_PARAMS');
checksizesmm(scd_params,'SCD_PARAMS');
checksizesmm(scc_params,'SCC_PARAMS');

% Check the input S-parameters
[pts, sdd_params] = CheckNetworkData(sdd_params, 'N', 'SDD_PARAMS');
[~, sdc_params] = CheckNetworkData(sdc_params, 'N', 'SDC_PARAMS');
[~, scd_params] = CheckNetworkData(scd_params, 'N', 'SCD_PARAMS');
[~, scc_params] = CheckNetworkData(scc_params, 'N', 'SCC_PARAMS');
if any(size(sdd_params) ~= size(sdc_params)) || any(size(sdd_params) ...
        ~= size(scd_params)) || any(size(sdd_params) ~= size(scc_params))  
    error(message('rf:smm2s:InputMatrixesNotMatching'));
end

smm_params = [sdd_params,sdc_params;scd_params,scc_params];
N = size(smm_params,1);
Ports = [1:2:N-1 2:2:N];

% Check the specified ordering for S-parameters and reorder if necessary
if nargin==5
    if rfflag==1
        Ports = [1:2:N-1 2:2:N];
    elseif rfflag==2
        Ports = 1:N;
    elseif rfflag==3
        Ports = [1:N/2 N:-1:N/2+1];
    else
        error(message('rf:smm2s:RfFlagIncorrect'));
    end
end

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
s_params = zeros(N,N,pts);
for idx = 1:pts
    s_params(:,:,idx) = invM*smm_params(:,:,idx)*M/2;
end

[~, redrO] = sort(Ports); 
s_params = s_params(redrO,redrO,:);

function checksizesmm(mm_params,desc)
% This subfunction checks and error out if the mixed-mode parameters are vectors
if numel(mm_params)>1 && isvector(mm_params)
    error(message('rf:smm2s:WrongMixedModeFormat',desc));
end