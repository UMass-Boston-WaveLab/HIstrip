function varargout = loglog(varargin)
%LOGLOG Plot the specified parameters on an X-Y plane using logarithmic
%scales for both the X- and Y- axes.
%   LOGLOG(...) is the same as PLOT(...), except logarithmic scales are
%   used for both the X- and Y- axes, and budget plots are not available.
%
%   HLINES = LOGLOG(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = LOGLOG(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
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
%   RFCKT.RFCKT/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the RFCKT object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:rfckt:loglog:NotEnoughInput'));
end

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
hlines = loglog(data, varargin{2:end});

if nargout == 1
    varargout{1} = hlines;
end