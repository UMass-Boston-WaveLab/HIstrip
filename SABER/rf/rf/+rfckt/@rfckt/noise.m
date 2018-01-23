function [cmatrix,ctype] = noise(h,freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX,CTYPE] = NOISE(H,FREQ) calculates the noise correlation
%   matrix of the RFCKT object at the specified frequencies FREQ. The first
%   input is the handle to the RFCKT object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(2,2)

cmatrix = [];
ctype = '';
% Get the simdata
simdata = get(h,'SimData');
if ~isa(simdata,'rfdata.network')
    set(h,'SimData',rfdata.network);
    simdata = get(h,'SimData');
    [type,netparameters,z0] = nwa(h,freq);
    if strncmpi(type,'S',1)
        netparameters = s2s(netparameters,z0,simdata.Z0);
    end
    set(simdata,'Type',type,'Data',netparameters,'Freq',freq);
end
if length(simdata.Freq) ~= length(freq) || any(simdata.Freq(:) - freq(:))
    [type,netparameters,z0] = nwa(h,freq);
    if strncmpi(type,'S',1)
        netparameters = s2s(netparameters,z0,simdata.Z0);
    end
    set(simdata,'Type',type,'Data',netparameters,'Freq',freq);
end

% Calculate noise correlation matrix
data = get(h,'AnalyzedResult');
if isa(data,'rfdata.data')
    [cmatrix,ctype] = noise(data,freq);
end
T = 290;
K = physconst('Boltzmann');
nfreq = length(freq);
if isempty(cmatrix)
    if strncmpi(simdata.Type,'S',1)
        s = simdata.Data;
        if all(s(1,1,:) ==0) && all(s(1,2,:) ==1) && ...
                all(s(2,1,:) ==1) && all(s(2,2,:) ==0)
            cmatrix = zeros(2,2,nfreq);
            ctype = 'ABCD CORRELATION MATRIX';
        end
    elseif strncmpi(simdata.Type,'ABCD',4)
        abcd = simdata.Data;
        if all(abcd(1,1,:) ==1) && all(abcd(1,2,:) ==0) && ...
                all(abcd(2,1,:) ==0) && all(abcd(2,2,:) ==1)
            cmatrix = zeros(2,2,nfreq);
            ctype = 'ABCD CORRELATION MATRIX';
        else
            c = abcd(2,1,:);
            if all(c == 0)
                y = convertmatrix(simdata,simdata.Data, ...
                    simdata.Type,'Y-PARAMETERS',simdata.Z0);
                if all(all(isfinite(y)))
                    cmatrix = T*K*rf.internal.makeHermitian(y);
                    ctype = 'Y CORRELATION MATRIX';
                else
                    cmatrix = zeros(2,2,nfreq);
                    ctype = 'ABCD CORRELATION MATRIX';
                end
            end
        end
    elseif strncmpi(simdata.Type,'Z',1)
        z = simdata.Data;
        if all(all(all(isfinite(z))))
            cmatrix = T*K*rf.internal.makeHermitian(z);
            ctype = 'Z CORRELATION MATRIX';
        end
    elseif strncmpi(simdata.Type,'Y',1)
        y = simdata.Data;
        if all(all(isfinite(y)))
            cmatrix = T*K*rf.internal.makeHermitian(y);
            ctype = 'Y CORRELATION MATRIX';
        end
    end
end
if isempty(cmatrix)
    z = convertmatrix(simdata,simdata.Data,simdata.Type, ...
        'Z-PARAMETERS',simdata.Z0);
    if all(all(all(isfinite(z))))
        cmatrix = T*K*rf.internal.makeHermitian(z);
        ctype = 'Z CORRELATION MATRIX';
    else
        y = convertmatrix(simdata,simdata.Data,simdata.Type, ...
            'Y-PARAMETERS',simdata.Z0);
        if all(all(isfinite(y)))
            cmatrix = T*K*rf.internal.makeHermitian(y);
            ctype = 'Y CORRELATION MATRIX';
        else
            cmatrix = zeros(2,2,nfreq);
            ctype = 'ABCD CORRELATION MATRIX';
        end
    end
end