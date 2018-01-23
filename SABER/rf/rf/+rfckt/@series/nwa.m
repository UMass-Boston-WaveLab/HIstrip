function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.SERIES

%   Copyright 2003-2007 The MathWorks, Inc.

% Get and check the CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Calculate the network parameters
if (nckts == 1)
    ckt = ckts{1};
    [type, netparameters, z0] = nwa(ckt, freq);
else 
    data = rfdata.data;
    z0 = get(data, 'Z0');
    % Calculate the Z-parameters
    type = 'Z_PARAMETERS';
    ckt = ckts{1};
    [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
    netparameters = convertmatrix(data, ckt_params, ckt_type, type,     ...
        ckt_z0);
    for ii=2:nckts
        ckt = ckts{ii};
        [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
        ckt_params = convertmatrix(data, ckt_params, ckt_type, type,    ...
            ckt_z0);
        netparameters = netparameters + ckt_params;
    end
end