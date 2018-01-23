function [cmatrix, ctype] = noise(h, freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX, CTYPE] = NOISE(H, FREQ) calculates the noise correlation
%   matrix of the RFCKT object at the specified frequencies FREQ. The first
%   input is the handle to the RFCKT object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.AMPLIFIER

%   Copyright 2003-2015 The MathWorks, Inc.

% Get the simdata
simdata = get(h, 'SimData');
if ~isa(simdata, 'rfdata.network')
    set(h, 'SimData', rfdata.network);
    simdata = get(h, 'SimData');
end
if length(simdata.Freq) ~= length(freq) || any(simdata.Freq(:) - freq(:))
    [type, netparameters, z0] = nwa(h, freq);
    if strncmpi(type,'S',1)
        netparameters = s2s(netparameters, z0, simdata.Z0);
    end
    set(simdata, 'Type', type,  'Data', netparameters, 'Freq', freq);
end

% Calculate noise correlation matrix
data = get(h, 'AnalyzedResult');
if isa(data, 'rfdata.data')
    [cmatrix, ctype] = noise(data, freq);
end
if isempty(cmatrix)
    z0 = data.Z0;
    Fmin =  10 .^ (get(h, 'NF')/10);
    Yopt = 1 / z0;
    RN = real(z0)*(Fmin - 1)/4;
    T = 290;
    K = physconst('Boltzmann');
    m = length(freq);
    cmatrix(1,1,1:m) = RN;
    cmatrix(1,2,1:m) = (Fmin-1)/2 - RN .* Yopt;
    cmatrix(2,1,1:m) = (Fmin-1)/2 - RN .* conj(Yopt);
    cmatrix(2,2,1:m) = RN .* abs(Yopt) .* abs(Yopt);
    cmatrix = 2 * T * K * cmatrix;
    ctype = 'ABCD CORRELATION MATRIX';
end