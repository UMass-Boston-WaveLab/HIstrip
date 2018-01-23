function [cmatrix,ctype] = noise(h,freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX,CTYPE] = NOISE(H,FREQ) calculates the noise correlation matrix
%   of the RFCKT object at the specified frequencies FREQ. The first input
%   is the handle to the RFCKT object, the second input is a vector for the
%   specified freqencies.
%
%   See also RFCKT.PASSIVE

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(2,2)

cmatrix = [];
ctype = '';
% Get the simdata
simdata = get(h,'SimData');
if ~isa(simdata,'rfdata.network')
    set(h,'SimData',rfdata.network)
    simdata = get(h,'SimData');
end
if length(simdata.Freq) ~= length(freq) || any(simdata.Freq(:) - freq(:))
    [type,netparameters,z0] = nwa(h,freq);
    if strncmpi(type,'S',1)
        netparameters = s2s(netparameters,z0,simdata.Z0);
    end
    set(simdata,'Type',type,'Data',netparameters,'Freq',freq);
end

% Calculate noise correlation matrix
T = 290;
K = physconst('Boltzmann');
np = h.nPort;
nfreq = length(freq);
netobj = h.NetworkData;
if isa(netobj,'rfdata.network')
    if np == 2
        if strncmpi(netobj.Type,'S',1)
            s = netobj.Data;
            if all(s(1,1,:) == 0) && all(s(1,2,:) == 1) && ...
                    all(s(2,1,:) == 1) && all(s(2,2,:) == 0)
                cmatrix = zeros(np,np,nfreq);
                ctype = 'ABCD CORRELATION MATRIX';
            end
        elseif strncmpi(netobj.Type,'ABCD',4)
            abcd = netobj.Data;
            if all(abcd(1,1,:) == 1) && all(abcd(1,2,:) == 0) && ...
                    all(abcd(2,1,:) == 0) && all(abcd(2,2,:) == 1)
                cmatrix = zeros(np,np,nfreq);
                ctype = 'ABCD CORRELATION MATRIX';
            else
                if all(abcd(2,1,:) == 0)
                    y = convertmatrix(simdata,simdata.Data, ...
                        simdata.Type,'Y-PARAMETERS',simdata.Z0);
                    if all(all(all(isfinite(y))))
                        cmatrix = T*K*rf.internal.makeHermitian(y);
                        ctype = 'Y CORRELATION MATRIX';
                    else
                        cmatrix = zeros(np,np,nfreq);
                        ctype = 'ABCD CORRELATION MATRIX';
                    end
                end
            end
        end
    end
    if isempty(cmatrix)
        if np >= 2
            numports = size(simdata.Data,1);
            I = eye(numports);
            is_S = strncmpi(simdata.Type,'S',1);
            ycond = ones(1,nfreq);
            if is_S
                zcond = ones(1,nfreq);
                for ii = 1:nfreq
                    zcond(ii) = rcond(I - simdata.Data(:,:,ii));
                end
                if all(zcond > eps)
                    z = convertmatrix(simdata,simdata.Data, ...
                        simdata.Type,'Z-PARAMETERS',simdata.Z0);
                    if all(all(all(isfinite(z))))
                        cmatrix = T*K*rf.internal.makeHermitian(z);
                        ctype = 'Z CORRELATION MATRIX';
                    end
                else
                    for ii = 1:nfreq
                        ycond(ii) = rcond(I + simdata.Data(:,:,ii));
                    end
                end
            end
            % Still go to Y if the source data is not S OR if ycond is OK
            if (~is_S) || (isempty(cmatrix) && all(ycond > eps))
                y = convertmatrix(simdata,simdata.Data, ...
                    simdata.Type,'Y-PARAMETERS',simdata.Z0);
                if all(all(all(isfinite(y))))
                    cmatrix = T*K*rf.internal.makeHermitian(y);
                    ctype = 'Y CORRELATION MATRIX';
                end
            end
        end
    end
end
if isempty(cmatrix)
    cmatrix = zeros(np,np,nfreq);
    ctype = 'ABCD CORRELATION MATRIX';
end