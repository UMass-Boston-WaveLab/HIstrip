function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.LADDERFILTER

%   Copyright 2004-2007 The MathWorks, Inc.

% Get and check the cascaded CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Get the data
if ~isa(h.SimData, 'rfdata.network')
    set(h, 'SimData', rfdata.network);
end
simdata = get(h, 'SimData');

% Calculate the network parameters
if (nckts == 1)
    ckt = ckts{1};
    [type, netparameters, z0] = nwa(ckt, freq);
else 
    z0 = 50;
    % Calculate the ABCD-parameters
    type = 'ABCD_PARAMETERS';
    ckt = ckts{1};
    [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
    netparameters = convertmatrix(simdata, ckt_params, ckt_type, type,  ...
        ckt_z0);
    [n1,n2,m] = size(netparameters);
    for ii=2:nckts
        ckt = ckts{ii};
        [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
        ckt_params = convertmatrix(simdata, ckt_params, ckt_type, type, ...
            ckt_z0);
        for k=1:m
            netparameters(:,:,k) = netparameters(:,:,k)*ckt_params(:,:,k);
        end
    end
end