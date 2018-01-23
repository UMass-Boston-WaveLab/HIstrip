function nport = getnport(h)
%GETNPORT Get the port number.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default
nport = 2;

% Determine the port number
refobj = getreference(h);
if hasnetworkreference(h)
    netdata = refobj.NetworkData;
    nport = getnport(netdata);
else
    sparams = get(h, 'S_Parameters');
    if ~isempty(sparams) 
        nport = size(sparams, 1);
    end
end