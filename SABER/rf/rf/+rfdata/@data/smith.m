function [hlines, hsm] = smith(varargin)
%SMITH Plot the specified parameters on a Smith chart.
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN) plots the
%   specified parameters on a Z Smith chart. The first input is the
%   handle to the RFDATA.DATA object, and the other inputs PARAMETER1, ...,
%   PARAMETERN are the parameters to be visualized.
%
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN, TYPE) plots the
%   specified parameters on the specified TYPE of Smith chart. TYPE could
%   be 'Z', 'Y', or 'ZY'.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFDATA.DATA
%   object. 
%
%   This method has two outputs. The first is a column vector of handles to
%   lineseries objects, one handle per plotted line. The second output is
%   the handle to the Smith chart.
% 
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/POLAR,
%   RFDATA.DATA/PLOT 

%   Copyright 2004-2010 The MathWorks, Inc.

% Set the default
hsm = [];

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfdata:data:smith:NotEnoughInput'));
end

% Check and find the smith chart type
if isempty(charttype(varargin{end}))
    type = 'z';
else
    type = varargin{end};
    varargin = varargin(1:end-1); % Remove chart type from varargin
end

% Check the input number again
if numel(varargin) < 2
    error(message('rf:rfdata:data:smith:NotEnoughInput'));
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
if isempty(ynames) || isempty(ydata) || isempty(xdata); return; end;
if numel(xdata)~=numel(ydata)
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
hsm = [];
hold_state = false;
if ~(fig==-1)
    hold_state = ishold;
    % Current axes may contain a Smith chart
    if isappdata(gca, 'SmithChart')
        hsm = getappdata(gca, 'SmithChart');
    end
    % Create the chart
    if ~hold_state || ~strcmpi(class(hsm), 'rfchart.smith')
        hsm = rfchart.smith('Type', type, 'NeedReset', h.NeedReset); 
    end
 else
    hsm = rfchart.smith('Type', type, 'NeedReset', h.NeedReset);
end
hold on;

% Plot the data
plotcell = cell(1, 2*numsets);
for ii = 1:numsets
    plotcell{2*ii-1} = real(ydata{ii});
    if ~isreal(ydata{ii}) % complex number
        plotcell{2*ii} = imag(ydata{ii});
    else % real number
        plotcell{2*ii} = zeros(size(ydata{ii}));
    end
end
legendcell = ynames;
hlines = builtin('plot', plotcell{:});
% Show the legend
addlegend(h, hlines, legendcell);
% Add datatip
tipcell = simplifytip(h, legendcell);
nhlines = numel(hlines);
for k=1:nhlines
    linesinfo = currentlineinfo(h, '',                                  ...
        tipcell{k}, simplifytip(h, xname), xdata{k}, xunit,             ...
        'None', '', h.ZS, h.Z0, h.ZL);
    set(hlines(k), 'UserData', linesinfo);
end
datatip(h, fig, hlines);
if ~hold_state; hold off; end;


function returntype = charttype(type)
% Set the default
returntype = '';
% Check the type
if nargin == 1 && ischar(type)
    switch upper(type)
    case {'Z', 'Y', 'YZ', 'ZY'}
        returntype = type;
    otherwise
        returntype = '';
    end
end