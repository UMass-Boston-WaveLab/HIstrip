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
%   See also RFDATA.DATA, RFDATA.DATA/ANALYZE, RFDATA.DATA/CALCULATE

%   Copyright 2003-2007 The MathWorks, Inc.

narginchk(2,3);
% Get S-Parameters
sparams = get(h, 'S_Parameters');

% Check the S-Parameters
if isempty(sparams)
    error(message('rf:rfdata:data:extract:EmptySParameters'));
end

% Give a warning if the z0 parameter is superfluous.
if nargin ==3 && ~strncmpi(outtype, 'S', 1)
    warning(message('rf:rfdata:data:extract:SuperfluousZ0', outtype));
end

if hasnetworkreference(h) % If s_parameters have reference
    tempref = getreference(h);
    if isequal(tempref.NetworkData.Freq, h.Freq) && ...
            isequal(size(tempref.NetworkData.Data),  size(sparams))
        % Extract directly from NetworkData reference
        if nargin ==3 && strncmpi(outtype, 'S', 1)
            [outmatrix, freq] = extract(tempref.NetworkData, outtype, z0);
        else
            [outmatrix, freq] = extract(tempref.NetworkData, outtype);
        end
        return
    end
end

% Do matrix conversion on s_parameters
if nargin == 3
    outmatrix = convertmatrix(h, sparams, 'S_PARAMETERS', outtype, ...
        get(h, 'Z0'), z0);
else
    outmatrix = convertmatrix(h, sparams, 'S_PARAMETERS', outtype, ...
        get(h, 'Z0'));
end
freq = h.Freq;