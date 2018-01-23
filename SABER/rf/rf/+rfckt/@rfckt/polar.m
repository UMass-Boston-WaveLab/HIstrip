function varargout = polar(varargin)
%POLAR Plot the specified parameters on polar coordinates.
%   HLINES = POLAR(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters on polar coordinates. The first input is the handle to the
%   RFCKT object, and the other inputs PARAMETER1, ..., PARAMETERN are the
%   parameters to be visualized.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object. 
%
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/SMITH,
%   RFCKT.RFCKT/PLOT

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
hlines = polar(data, varargin{2:end});

if nargout == 1
    varargout{1} = hlines;
end