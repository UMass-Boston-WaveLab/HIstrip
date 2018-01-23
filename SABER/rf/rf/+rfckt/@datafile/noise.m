function [cmatrix,ctype] = noise(h,freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX,CTYPE] = NOISE(H,FREQ) calculates the noise correlation
%   matrix of the RFCKT object at the specified frequencies FREQ. The first
%   input is the handle to the RFCKT object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.DATAFILE

%   Copyright 2003-2015 The MathWorks, Inc.

cmatrix = [];
ctype = '';
% Get the simdata
simdata = get(h,'SimData');
if ~isa(simdata,'rfdata.network')
    set(h,'SimData',rfdata.network);
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
data = get(h,'AnalyzedResult');
np = h.nPort;
nfreq = length(freq);
if isa(data,'rfdata.data')
    [cmatrix,ctype] = noise(data,freq);
    if isempty(cmatrix)
        refobj = getreference(data);
        if hasnetworkreference(data)
            netobj = refobj.NetworkData;
            if (np == 2)
                if strncmpi(netobj.Type,'S',1)
                    s = netobj.Data;
                    if all(s(1,1,:) == 0) && all(s(1,2,:) == 1) && ...
                            all(s(2,1,:) == 1) && all(s(2,2,:) == 0)
                        cmatrix = zeros(np,np,nfreq);
                        ctype = 'ABCD CORRELATION MATRIX';
                    end
                elseif strncmpi(netobj.Type,'ABCD',4)
                    abcd = netobj.Data;
                    if all(abcd(1,1,:) == 1) && ...
                            all(abcd(1,2,:) == 0) && ...
                            all(abcd(2,1,:) == 0) && ...
                            all(abcd(2,2,:) == 1)
                        cmatrix = zeros(np,np,nfreq);
                        ctype = 'ABCD CORRELATION MATRIX';
                    else
                        c = abcd(2,1,:);
                        if all(c == 0)
                            T = 290;
                            K = physconst('Boltzmann');
                            y = convertmatrix(simdata,simdata.Data, ...
                                simdata.Type,'Y-PARAMETERS',simdata.Z0);
                            if all(all(isfinite(y)))
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
                s = extract(netobj,'S_PARAMETERS',50);
                if (np > 2) || ((np == 2) && ispassive(s))
                    T = 290;
                    K = physconst('Boltzmann');
                    z = convertmatrix(simdata,simdata.Data, ...
                        simdata.Type,'Z-PARAMETERS',simdata.Z0);
                    if all(all(all(isfinite(z))))
                        cmatrix = T*K*rf.internal.makeHermitian(z);
                        ctype = 'Z CORRELATION MATRIX';
                    else
                        y = convertmatrix(simdata,simdata.Data, ...
                            simdata.Type,'Y-PARAMETERS',simdata.Z0);
                        if all(all(isfinite(y)))
                            cmatrix = T*K*rf.internal.makeHermitian(y);
                            ctype = 'Y CORRELATION MATRIX';
                        end
                    end
                end
            end
        end
    end
end
if isempty(cmatrix)
    cmatrix = zeros(np,np,nfreq);
    ctype = 'ABCD CORRELATION MATRIX';
end