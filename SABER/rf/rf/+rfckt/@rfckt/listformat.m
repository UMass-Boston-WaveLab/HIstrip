function list = listformat(varargin)
%LISTFORMAT List the valid formats for the specified PARAMETER.
%   LIST = LISTFORMAT(H, PARAMETER) lists the valid formats for the
%   specified PARAMETER.
%    
%   Type LISTPARAM(H) to get the valid parameters of the RFCKT object.
%
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/ANALYZE,
%   RFCKT.RFCKT/PLOT, RFCKT.RFCKT/TABLE, RFCKT.RFCKT/PLOTYY,
%   RFCKT.RFCKT/CALCULATE

%   Copyright 2003-2009 The MathWorks, Inc.

% Get the object and inputs
h = varargin{1};
data = getdata(h);

% Get the list by calling the method of RFDATA.DATA object
list = listformat(data, varargin{2:end});