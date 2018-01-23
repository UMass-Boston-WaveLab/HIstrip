function varargout = semilogx(varargin)
%SEMILOGX Plot the specified parameters on an X-Y plane using a logarithmic
%scale for the X-axis.
%   SEMILOGX(...) is the same as PLOT(...), except a logarithmic (base 10)
%   scale is used for the X-axis, and budget plots are not available.
%
%   HLINES = SEMILOGX(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = SEMILOGX(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
%   specified parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using
%   the specified FORMAT. FORMAT must be a valid format for all the
%   parameters.
%
%   Type LISTPARAM(H) to see the valid parameters for plot.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/LISTFORMAT,
%   RFCKT.RFCKT/SEMILOGY, RFCKT.RFCKT/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the RFCKT object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:rfckt:semilogx:NotEnoughInput'));
end

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
hlines = semilogx(data, varargin{2:end});

if nargout == 1
    varargout{1} = hlines;
end