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
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/LISTFORMAT,
%   RFDATA.DATA/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfdata:data:loglog:NotEnoughInput'));
end
if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfdata:data:loglog:NotForBudgetData'));
end

hlines = plot(h, varargin{2:end}, 'loglog');
% Rescale axes
xylimits = axis;
if xylimits(1) > 0.0  && xylimits(2) > 0.0  &&                          ...
        (xylimits(2)/xylimits(1) < 10)
    xylimits(2) = 10^round(log10(xylimits(2)) + 0.5);
    axis(xylimits);
elseif xylimits(1) < 0.0  && xylimits(2) < 0.0  &&                      ...
        (xylimits(1)/xylimits(2) < 10)
    xylimits(2) = -10^round(log10(-xylimits(2)) - 0.5);
    axis(xylimits);
end
if xylimits(3) > 0.0  && xylimits(4) > 0.0  &&                          ...
        (xylimits(4)/xylimits(3) < 10)
    xylimits(4) = 10^round(log10(xylimits(4)) + 0.5);
    axis(xylimits);
elseif xylimits(3) < 0.0  && xylimits(4) < 0.0  &&                      ...
        (xylimits(3)/xylimits(4) < 10)
    xylimits(4) = -10^round(log10(-xylimits(4)) - 0.5);
    axis(xylimits);
end

if nargout == 1
    varargout{1} = hlines;
end