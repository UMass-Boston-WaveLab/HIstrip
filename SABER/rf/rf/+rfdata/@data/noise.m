function [cmatrix, ctype] = noise(h, freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX, CTYPE] = NOISE(H, FREQ) calculates the noise correlation
%   matrix of the RFCKT object at the specified frequencies FREQ. The first
%   input is the handle to the RFDATA.DATA object, the second input is a
%   vector for the specified freqencies.
%
%   See also RFDATA.DATA

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(2,2)

cmatrix = [];
ctype = '';
% Get the parameters
sparams = get(h, 'S_Parameters');
if isempty(sparams) || (numel(h.Freq) ~= numel(freq)) || (any(h.Freq(:) - freq(:)))
    [type, sparams, own_z0] = nwa(h, freq);
    % Update the properties
    if strncmpi(type,'S',1)
        sparams = s2s(sparams, own_z0, h.z0);
    else
        sparams = convertmatrix(h, sparams, type, 'S_PARAMETERS', h.z0);
    end
    % Update the properties of RFDATA.DATA object
    set(h, 'S_Parameters', sparams, 'Freq', freq);
end

T = 290;
K = physconst('Boltzmann');
refobj = getreference(h);
if hasnoisereference(h)
    % Noise was specified by an rfdata.noise object
    noisedata = get(refobj, 'NoiseData');
    % Calculate noise correlation matrix
    z0 = noisedata.Z0;
    Fmin = 10.^(interpolate(h, noisedata.Freq, noisedata.FMIN, freq)/10);
    gammaopt = interpolate(h, noisedata.Freq, noisedata.GAMMAOPT, freq);
    Yopt = (1-gammaopt) ./ (1+gammaopt) / z0;
    rn = interpolate(h, noisedata.Freq, noisedata.RN, freq);
    RN = rn * z0;
    cmatrix(1,1,:) = RN;
    cmatrix(1,2,:) = (Fmin-1)/2 - RN .* conj(Yopt);
    cmatrix(2,1,:) = (Fmin-1)/2 - RN .* Yopt;
    cmatrix(2,2,:) = RN .* abs(Yopt) .* abs(Yopt);
    cmatrix = 2 * T * K * cmatrix;
    ctype = 'ABCD CORRELATION MATRIX';
elseif hasnfreference(h)
    % Noise was specified by an rfdata.nf object
    % Note that this should mirror the code block in rfckt.amplifier/noise
    nfdata = get(refobj,'NFData');
    % Calculate noise correlation matrix
    z0 = nfdata.Z0; % Must be scalar for rfdata.nf object
    Fmin = 10.^(interpolate(h, nfdata.Freq, nfdata.Data, freq)/10);
    RN = real(z0)*(Fmin - 1)/4;
    Yopt = 1 / z0;
    m = numel(freq);
    cmatrix(1,1,1:m) = RN;
    cmatrix(1,2,1:m) = (Fmin-1)/2 - RN .* conj(Yopt);
    cmatrix(2,1,1:m) = (Fmin-1)/2 - RN .* Yopt;
    cmatrix(2,2,1:m) = RN .* abs(Yopt) .* abs(Yopt);
    cmatrix = 2 * T * K * cmatrix;
    ctype = 'ABCD CORRELATION MATRIX';
end
