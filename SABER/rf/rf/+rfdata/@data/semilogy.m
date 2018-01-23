function varargout = semilogy(varargin)
%SEMILOGY Plot the specified parameters on an X-Y plane using a logarithmic
%scale for the Y-axis.
%   SEMILOGY(...) is the same as PLOT(...), except a logarithmic (base 10)
%   scale is used for the Y-axis, and budget plots are not available.
%
%   HLINES = SEMILOGY(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = SEMILOGY(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
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
%   RFDATA.DATA/SEMILOGX, RFDATA.DATA/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfdata:data:semilogy:NotEnoughInput'));
end
if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfdata:data:semilogy:NotForBudgetData'));
end

hlines = plot(h, varargin{2:end}, 'semilogy');
% Rescale y-axis
xylimits = axis;
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