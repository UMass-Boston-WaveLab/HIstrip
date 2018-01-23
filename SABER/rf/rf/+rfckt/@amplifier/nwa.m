function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.AMPLIFIER

%   Copyright 2003-2007 The MathWorks, Inc.

% Check if an analysis is needed
if ~(h.DoAnalysis)
    data = getdata(h);
    if isa(data, 'rfdata.data') &&                                      ...
            (length(freq) == length(data.Freq)) && ~any(freq-data.Freq)
        type = 'S_PARAMETERS';
        netparameters = get(data, 'S_Parameters');
        z0 = get(data, 'Z0');
        return;
    end
end

% Update the property
data = get(h, 'AnalyzedResult');
set(data, 'IntpType', get(h, 'IntpType'));

% Calculate network parametters
[type, netparameters, z0] = nwa(data, freq);