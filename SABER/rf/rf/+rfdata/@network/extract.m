function [outmatrix, freq] = extract(h, outtype, z0)
%EXTRACT Extract the specified network parameters.
%   [OUTMATRIX, FREQ] = EXTRACT(H, OUTTYPE, Z0) extracts the network
%   parameters specified by OUTTYPE.
%
%   OUTTYPE: 'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%            'Z_PARAMETERS', 'H_PARAMETERS', 'G_PARAMETERS', 'T_PARAMETERS'
%   Z0: Reference impedance is optional and for S-Parameters only, the
%   default is 50 ohms.
%
%   See also RFDATA.NETWORK

%   Copyright 2003-2007 The MathWorks, Inc.

narginchk(2,3);

% Get Network Parameters
params = get(h, 'Data');

% Check the network parameters
if isempty(params)
     error(message('rf:rfdata:network:extract:EmptyNetworkParameters'));
end

% Get the type of stored matrix
storedtype = get(h, 'Type');

storedtype = upper(storedtype);
outtype = upper(outtype);

% Do matrix conversion if the method is available
switch storedtype
case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
    switch outtype
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        if nargin < 3
            z0 = 50;
        end
        outmatrix = convertmatrix(h, params, 'S', 'S', h.Z0, z0);
    otherwise
        outmatrix = convertmatrix(h, params, storedtype, outtype, h.Z0);
    end
    otherwise
    switch outtype
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        if nargin < 3
            z0 = 50;
        end
        outmatrix = convertmatrix(h, params, storedtype, outtype, z0);
    otherwise
        outmatrix = convertmatrix(h, params, storedtype, outtype);
    end
end
freq = h.Freq;