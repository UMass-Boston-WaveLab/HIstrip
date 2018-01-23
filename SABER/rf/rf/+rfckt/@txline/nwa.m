function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.TXLINE

%   Copyright 2003-2007 The MathWorks, Inc.

% Allocate memory for netparameters
nport = get(h, 'nPort');
netparameters  = zeros(nport,nport,length(freq));
z0 = get(h, 'Z0');
if length(z0) ~= 1
    z0 = interpolate(h, h.Freq, z0, freq, h.IntpType);
    z0 = z0(:);
end

switch upper(h.get('StubMode'))
    % transmission line is not a stub
    case 'NOTASTUB'
        e_negkl = calckl(h, freq);
        e_kl = 1./e_negkl;
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = (e_kl + e_negkl)./2;
        netparameters(1,2,:) = (e_kl - e_negkl).*z0./2;
        netparameters(2,1,:) = (e_kl - e_negkl)./z0./2;
        netparameters(2,2,:) = (e_kl + e_negkl)./2;
        % transmission line is a series stub
    case 'SERIES'
        Z_in = calczin(h, freq);
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = 1;
        netparameters(1,2,:) = Z_in;
        netparameters(2,1,:) = 0;
        netparameters(2,2,:) = 1;
        % transmission line is a shunt stub
    case 'SHUNT'
        Z_in = calczin(h, freq);
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = 1;
        netparameters(1,2,:) = 0;
        netparameters(2,1,:) = 1./Z_in;
        netparameters(2,2,:) = 1;
end