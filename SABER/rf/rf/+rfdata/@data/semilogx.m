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
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/LISTFORMAT,
%   RFDATA.DATA/SEMILOGY, RFDATA.DATA/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfdata:data:semilogx:NotEnoughInput'));
end
if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfdata:data:semilogx:NotForBudgetData'));
end

hlines = plot(h, varargin{2:end}, 'semilogx');
% Rescale x-axis
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

if nargout == 1
    varargout{1} = hlines;
end