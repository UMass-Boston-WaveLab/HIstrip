function result = ga(h, freq)
%GA Calculate the available power gain.
%   RESULT = PA(H, FREQ) calculates the available power gain of the data
%   object. 
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default 
result = 1;
smatrix = get(h, 'S_Parameters');
if isempty(smatrix) || (numel(h.Freq) ~= numel(freq)) || (any(h.Freq(:) - freq(:)))
    [type, smatrix, own_z0] = nwa(h, freq);
    % Update the properties
    if strncmpi(type,'S',1)
        smatrix = s2s(smatrix, own_z0, h.z0);
    else
        smatrix = convertmatrix(h, smatrix, type, 'S_PARAMETERS', h.z0);
    end
end
if ~isempty(smatrix)
    result = powergain(smatrix, h.Z0, h.ZS, 'Ga');
end