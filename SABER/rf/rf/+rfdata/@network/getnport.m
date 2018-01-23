function nport = getnport(h)
%GETNPORT Get the port number.
%
%   See also RFDATA.NETWORK

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default
nport = 2;

% Determine the port number
data = get(h, 'Data');
if ~isempty(data) 
    nport = size(data, 1);
end