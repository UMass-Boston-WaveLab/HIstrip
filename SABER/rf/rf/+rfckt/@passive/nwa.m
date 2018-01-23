function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.PASSIVE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the RFDATA.DATA object 
data = get(h, 'AnalyzedResult');
set(data, 'IntpType', get(h, 'IntpType'));

% Calculate network parametters
[type, netparameters, z0] = nwa(data, freq);