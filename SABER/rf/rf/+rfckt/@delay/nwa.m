function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT/DELLAY

%   Copyright 2004-2007 The MathWorks, Inc.

% Allocate memory for netparameters
nport = get(h, 'nPort');
netparameters  = zeros(nport,nport,length(freq));

e_negkl = calckl(h, freq);
e_kl = 1./e_negkl;
% Calculate network parametters
z0 = get(h, 'Z0');
type = 'ABCD_PARAMETERS';
netparameters(1,1,:) = (e_kl + e_negkl)./2;
netparameters(1,2,:) = (e_kl - e_negkl).*z0./2;
netparameters(2,1,:) = (e_kl - e_negkl)./z0./2;
netparameters(2,2,:) = (e_kl + e_negkl)./2;