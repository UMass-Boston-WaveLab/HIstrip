function s_params_mp = snp2smp(s_params_np,varargin)
%SNP2SMP convert and reorder N-port S-parameters to M-port S-parameters
%   S_PARAMS_MP = SNP2SMP(S_PARAMS_NP, Z0, N2M_INDEX, ZT) converts the
%   single-ended N-port S-parameters, S_PARAMS_NP, into the single-ended
%   M-port S-parameters, S_PARAMS_MP. S_PARAMS_NP is a complex NxNxK array
%   of K N-port S-parameters, and S_PARAMS_MP is a complex MxMxK
%   array of K M-port S-parameters, where K is typically the
%   number of frequency points. Z0 is the reference impedance of
%   S_PARAMS_NP and S_PARAMS_MP. The default is 50 ohms. You specify how
%   the original N ports map to the ports for the M-port S-parameters using
%   N2M_INDEX. M must be less than or equal to N. If M is less than N,
%   the N-M ports that are not listed in N2M_INDEX are terminated with
%   the impedances that are specified by ZT.
%   
%   SM_OBJ = SNP2SMP(SN_OBJ,N2M_INDEX,ZT) does the same calculation
%   described above, where SN_OBJ and SM_OBJ are sparameters objects.  The
%   values used for S_PARAMS_NP and Z0 are the "Parameters" and "Impedance"
%   fields of SN_OBJ.
% 
%   N2M_INDEX is a vector of length M specifying how the ports of the
%   N-port S-parameters map to the ports of the M-port S-parameters.
%   N2M_INDEX(i) is the index of the port from S_PARAMS_NP that is
%   converted to the i-th port of S_PARAMS_MP. The default value of
%   N2M_INDEX is [1, 2]. This means M is 2 and the first two ports of the
%   N-port S-parameters become the ports of the 2-port S-parameters. Other
%   ports are terminated with the impedances that are specified by ZT.
%  
%   ZT is the termination impedance of the ports that are not listed in
%   N2M_INDEX. By default, ZT is the same as Z0. If ZT is a scalar, all N-M
%   ports that are not listed by N2M_INDEX are terminated by the same
%   impedance ZT. If ZT is a vector of length K, then ZT(i) is the
%   impedance used to terminate all N-M ports of the i-th frequency point
%   that are not listed in N2M_INDEX. If ZT is a cell array of length N,
%   then ZT{j} is the impedance used to terminate the j-th port of the
%   N-port S-parameters. Impedances related to the ports listed in
%   N2M_INDEX are ignored. Each ZT{j} can be a scalar or a vector of length
%   K.
% 
%   % EXAMPLE 1: Convert 3-port S-parameters to 3-port by swapping port
%   %            index from [1 2 3] to [2 3 1]:
%       ckt = read(rfckt.passive, 'default.s3p');
%       s3p = ckt.NetworkData.Data;
%       Z0 = ckt.NetworkData.Z0;
%       s3p_new = snp2smp(s3p, Z0, [2 3 1]);
% 
%   % EXAMPLE 2: Convert 3-port S-parameters to 2-port S-parameters by
%   %            terminating port-3
%       s2p = snp2smp(s3p, Z0, [1 2], Z0);
%       % or simply using the defaults of N2M_INDEX and ZT:
%       s2p = snp2smp(s3p, Z0);
% 
%   % EXAMPLE 3: Convert 16-port S-parameters to 4-port S-parameters by
%   %            choosing ports 1, 16, 2 and 15 as the first, second, third
%   %            and fourth port, and terminate other 12 ports by Z0
%       ckt = read(rfckt.passive, 'default.s16p');
%       s16p = ckt.NetworkData.Data;
%       Z0 = ckt.NetworkData.Z0;
%       s4p = snp2smp(s16p, Z0, [1 16 2 15], Z0);
% 
%   % EXAMPLE 4: Convert 16-port S-parameters to 4-port S-parameters by
%   %            choosing ports 1, 16, 2 and 15 as the first, second, third
%   %            and fourth port, and terminate port-4 by 100 ohms, and
%   %            other 11 ports by 50 ohms
%       ckt = read(rfckt.passive, 'default.s16p');
%       s16p = ckt.NetworkData.Data;
%       Z0 = ckt.NetworkData.Z0;
%       ZT = {};
%       ZT(1:16) = {50};	
%       ZT{4} = 100;
%       s4p = snp2smp(s16p, Z0, [1 16 2 15], ZT)
%   %   Note that termination impedances ZT{1}, ZT{2}, ZT{15} and ZT{16}
%   %   are specified as 50 ohms, but not used by SNP2SMP. 
%
%   See also S2TF, POWERGAIN, S2S, RATIONALFIT

%   Copyright 2007-2015 The MathWorks, Inc.

narginchk(1,4)

if ~isnumeric(s_params_np)
    validateattributes(s_params_np,{'numeric','sparameters'},{}, ...
        'snp2smp','',1)
end
[nfreq,s_params_np] = CheckNetworkData(s_params_np,'N','S_PARAMS');
numports = size(s_params_np,1);
if numports == 1
    error(message('rf:snp2smp:NotForOnePort'))
end

% Parse Z0
if nargin == 1
    z0 = 50*ones(1,1,nfreq);
else
    z0 = CheckZ(varargin{1},nfreq,'Z0');
end

% Parse n2m_index
if nargin < 3
    n2m_index = 1:2;
else
    n2m_index = squeeze(varargin{2});
    validateattributes(n2m_index,{'numeric'}, ...
        {'vector','positive','integer'},'snp2smp','N2M_INDEX')
    if any(n2m_index > numports) || numel(n2m_index) > numports || ...
            numel(n2m_index) ~= numel(unique(n2m_index))
        errstr = sprintf('[%s]',num2str(n2m_index.'));
        if any(n2m_index > numports)
            error(message('rf:snp2smp:WrongPortIndexInput2',errstr,numports,numports))
        elseif numel(n2m_index) > numports
            error(message('rf:snp2smp:WrongPortIndexInput3',errstr,numports,numports))
        elseif numel(n2m_index) ~= numel(unique(n2m_index))
            error(message('rf:snp2smp:WrongPortIndexInput4',errstr))
        end
    end
end

% Parse ztt
% Get and check the termination impedance: ZT
ztt = cell(numports,1);
ztt(1:numports) = {z0};
if nargin == 4
    zt = varargin{3};
    if iscell(zt)
        ncell = numel(zt);
        if ncell ~= numports
            error(message('rf:snp2smp:WrongTerminationInput1',nfreq,numports))
        end
        for ii = 1:ncell
            if ~isempty(zt{ii})
                ztt{ii} = CheckZ(zt{ii},nfreq,'ZT');
            end
        end
    else
        zt = CheckZ(zt,nfreq,'ZT');
        for ii = 1:numports   
            ztt{ii} = zt;   
        end 
    end
end

% Convert n-port S-parameters to m-port S-parameters
mport = numel(n2m_index);

% Do simpleconversion when numports == mport
simpleconversion = true;
if numports ~= mport
    % Otherwise, do simpleconversion when all terminations = z0
    idx = 0;
    while simpleconversion && (idx < numports)
        idx = idx + 1;
        if ~any(idx == n2m_index)
            simpleconversion = all(z0 == ztt{idx});
        end
    end
end

if simpleconversion
    s_params_mp = s_params_np(n2m_index,n2m_index,:);
else
    idx = 0;
    m_idx = n2m_index;
    yterm = zeros(numports,numports,nfreq);
    for ii = 1:numports
        if ~any(ii == n2m_index)
            idx = idx + 1;
            m_idx(mport+idx) = ii;
            zttt = ztt{ii};
            zttt(zttt == 0) = sqrt(eps);
            yterm(ii,ii,:) = 1/zttt;
        end
    end

    y_np = s2y(s_params_np,z0(:)) + yterm;
    y_mp = zeros(mport,mport,nfreq);
    for ii = 1:nfreq
        y_mp(:,:,ii) = y_np(n2m_index,n2m_index,ii) - ...
        y_np(m_idx(1:mport),m_idx((mport+1):numports),ii) / ...
        y_np(m_idx((mport+1):numports),m_idx((mport+1):numports),ii) * ...
        y_np(m_idx((mport+1):numports),m_idx(1:mport),ii);
    end
    s_params_mp = y2s(y_mp,z0(:));
end
