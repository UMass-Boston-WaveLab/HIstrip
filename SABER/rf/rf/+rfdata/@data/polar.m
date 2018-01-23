function varargout = polar(varargin)
%POLAR Plot the specified parameters on polar coordinates.
%   HLINES = POLAR(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters on polar coordinates. The first input is the handle to the
%   RFDATA.DATA object, and the other inputs PARAMETER1, ..., PARAMETERN
%   are the parameters to be visualized.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFDATA.DATA object. 
%
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/SMITH,
%   RFDATA.DATA/PLOT

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Set the default
hlines = [];

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfdata:data:polar:NotEnoughInput'));
end

% Extract parameters and formats
[temp_varargin, conditions] = smartprocess(h, varargin{2:end});
format = {'None'}; % Format should always be None for smith chart
temp_varargin(2:2:end-2) = format;

% Calculate the data
[ydata, ynames, xdata] = calculate(h, temp_varargin{:}, conditions{:});
% Put xdata, ydata and ynames into cells if they are not already
[ydata, ynames, xdata] = putincell(h, ydata, ynames, xdata);

% If no data, don't plot
if (isempty(ynames) || isempty(ydata) || isempty(xdata)) || ...
        (numel(xdata)~=numel(ydata))
    if nargout == 1
        varargout{1} = [];
    end
    return
end

numsets = numel(ydata); % Number of data sets
xparam = temp_varargin{end-1};
xformat = temp_varargin{end};
% Get the information of X-axis
if strcmpi(xparam, 'Freq') && strcmpi(xformat, 'Auto')
    [~, ~, funit] = scalingfrequency(h, [1; h.Freq(:)], 'Auto');
    xformat = funit(2:end-1);
    [~, xdata] = scalingfrequency(h, xdata, xformat);
end
[xname, xunit] = xaxis(h, xparam, xformat);

% Get the figure for plot
fig = findfigure(h);
hold_state = false;
if ~(fig==-1)
    hold_state = ishold;
end

% Plot the data
plot_together = true;
for ii = 1:numsets-1
    if size(ydata{ii}, 1) ~= size(ydata{ii+1}, 1) ||                    ...
            size(ydata{ii}, 1) == 1
        plot_together = false;
        break
    end
end
legendcell = ynames;
my_th = [];
my_r = [];
for ii = 1:numsets
    [temp_th, temp_r] = cart2pol(real(ydata{ii}), imag(ydata{ii}));
    if plot_together
        my_th = [my_th, temp_th];
        my_r = [my_r, temp_r];
    else
        templines = polar(temp_th, temp_r);
        hold all;
        hlines = [hlines; templines(:)];
    end
end
if plot_together
    hlines = polar(my_th, my_r);
end
% Show the legend
addlegend(h, hlines, legendcell);
% Add datatip
tipcell = simplifytip(h, legendcell);
nhlines = numel(hlines);
for k=1:nhlines
    linesinfo = currentlineinfo(h, 'Polar', tipcell{k},                 ...
        simplifytip(h, xname), xdata{k}, xunit,                         ...
        'None', '');
    set(hlines(k), 'UserData', linesinfo);
end
datatip(h, fig, hlines);
if ~hold_state
    hold off
end
grid on;

if nargout == 1
    varargout{1} = hlines;
end