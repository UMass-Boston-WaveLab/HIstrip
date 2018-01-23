function varargout = plot(varargin)
%PLOT Plot the specified parameters on an X-Y plane.
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
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
%   HLINES = PLOT(H, 'BUDGET', ...) plots the specified budget parameters
%   of an RFCKT.CASCADE object. For detail, please type help
%   rfckt.cascade/plot.
%
%   HLINES = PLOT(H, 'MIXERSPUR', ...) plots the spur power of an
%   RFCKT.MIXER object or an RFCKT.CASCADE object that contains one or more
%   mixers. For detail, please type help rfckt.cascade/plot or help
%   rfckt.mixer/plot.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/LISTFORMAT,
%   RFDATA.DATA/TABLE, RFDATA.DATA/SMITH, RFDATA.DATA/POLAR

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the data object
h = varargin{1};

if ischar(varargin{end}) && any(strcmpi(varargin{end},                  ...
        {'plot', 'semilogx', 'semilogy', 'loglog'}))
    plotfun = varargin{end};
    varargin = varargin(1:end-1);
else
    plotfun = 'plot';
end

% Check the input number
if numel(varargin) < 2
    error(message('rf:rfdata:data:plot:NotEnoughInput'));
end

% Find out if it is a budget plot
do_budgetplot = false;
mydata = h;
if strcmpi(varargin{2}, 'budget')
    budgetdata = get(h, 'BudgetData');
    if nargin < 3
        error(message('rf:rfdata:data:plot:NotEnoughInput'));
    elseif isa(budgetdata, 'rfdata.data') 
        do_budgetplot = true;
        varargin = varargin([1, 3:end]);
        mydata = budgetdata;
    else
        error(message('rf:rfdata:data:plot:NoBudgetData'));
    end
elseif strcmpi(varargin{2}, 'mixerspur')
    if ~isempty(get(h, 'SpurPower')) && (numel(varargin) == 5)
        if nargout == 1
            varargout{1} = mixerspurplot(h, varargin{3:end}); 
        else
            mixerspurplot(h, varargin{3:end}); 
        end
        return;
    else
        error(message('rf:rfdata:data:plot:UsingRFCKTForMixerSpur'));
    end
end

% Extract parameters and formats
[temp_varargin, conditions] = smartprocess(h, varargin{2:end});
original_xformat = temp_varargin{end};
if do_budgetplot
    [freq_cell, conditions] = processargin(h, conditions, 'Freq');
    power_cell = processargin(h, conditions, 'Pin');
    checkbudget(h, temp_varargin, freq_cell, power_cell)
end
checkyinput(h, 1, temp_varargin{:}); % Only one y-axis format is allowed.

[ydata, ynames, xdata] = calculate(mydata, varargin{2:end});

% Put xdata, ydata and ynames into cells if they are not already
[ydata, ynames, xdata] = putincell(h, ydata, ynames, xdata);
% If no data, don't plot
if isempty(ynames) || isempty(ydata) || isempty(xdata)
    if nargout == 1
        varargout{1} = [];
    end
    return
end
if numel(xdata)~=numel(ydata)
    if nargout == 1
        varargout{1} = [];
    end
    return
end
numsets = numel(ydata); % Number of data sets
xparam = temp_varargin{end-1};
xformat = temp_varargin{end};
ytype = category(h, temp_varargin{1});
yformat = modifyformat(h, temp_varargin{2});
% Get the information of X-axis
if strcmpi(original_xformat, 'Auto') && strcmpi(xparam, 'Freq')
    [~, ~, funit] = scalingfrequency(h, [1; h.Freq(:)], 'Auto');
    xformat = funit(2:end-1);
    [~, xdata] = scalingfrequency(h, xdata, xformat);
end
[xname, xunit] = xaxis(h, xparam, xformat);

% Do budget plot
if do_budgetplot
    if nargout == 1
        varargout{1} = budgetplot(h, ydata, ynames, yformat, xdata, ...
                                                   xparam, xformat);
    else
        budgetplot(h, ydata, ynames, yformat, xdata, xparam, xformat);
    end
    return
end

% Get the figure for plot
fig = findfigure(h);
hold_state = false;
if ~(fig==-1)
    hold_state = ishold;
end
plotcell = cell(1, 2*numsets);
for ii = 1:numsets
    plotcell{2*ii-1} = xdata{ii};
    plotcell{2*ii} = ydata{ii};
end
legendcell = ynames;
if ~strcmp(ytype, 'Phase Noise')
    hlines = builtin(plotfun, plotcell{:});
else
    hlines = builtin('semilogx', plotcell{:});
end
if ~hold_state
    % Set labels
    if ~strcmp(yformat, 'None')
        ylabel(yformat);
    end
    set(get(gca,'YLabel'),'Rotation',90.0);
    xlabel(sprintf('%s %s', xname, xunit));
    hold off;
end
addlegend(h, hlines, legendcell);
% Add datatip
tipcell = simplifytip(h, legendcell);
nhlines = numel(hlines);
for k=1:nhlines
    linesinfo = currentlineinfo(h, 'X-Y Plot', tipcell{k},              ...
        simplifytip(h, xname), xdata{k}, xunit,                         ...
        modifyformat(h, temp_varargin{2}, 2), '');
    set(hlines(k), 'UserData', linesinfo);
end
datatip(h, fig, hlines);
grid on;

if nargout == 1
    varargout{1} = hlines;
end