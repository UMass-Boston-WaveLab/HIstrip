function varargout = plotyy(varargin)
%PLOTYY Plot the specified parameters on an X-Y plane with Y-axes on both
%the left and right sides.
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER) plots the specified
%   parameter on an X-Y plane using a predefined pair of formats. For
%   S-parameters, PLOTYY uses 'dB' on the left Y-axis and 'Degrees' on the
%   right Y-axis. The first input H is the handle to the RFDATA.DATA
%   object, and the second input PARAMETER is the parameter to be
%   visualized.
%
%   Type LISTPARAM(H) to see valid parameters for the RFDATA.DATA object.
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1, ..., PARAMETERN) plots
%   the parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   pre-defined pair of formats.  
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER, FORMAT1, FORMAT2) plots
%   the PARAMETER on an X-Y plane using the specified formats: FORMAT1 for
%   the left Y-axis and FORMAT2 for the right Y-axis.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. 
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1, ..., PARAMETERN,
%   FORMAT1, FORMAT2) plots the parameters PARAMETER1, ..., PARAMETERN on
%   an X-Y plane using the specified formats: FORMAT1 for the left Y-axis
%   and FORMAT2 for the right Y-axis.
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1_1, ..., PARAMETER1_N1,
%   FORMAT1, PARAMETER2_1, ..., PARAMETER2_N2, FORMAT2) plots the
%   parameters PARAMETER1_1, ..., PARAMETER1_N1 on the left Y-axis using
%   FORMAT1, and PARAMETER2_1, ..., PARAMETER2_N2 on the right Y-axis using
%   FORMAT2. 
%     
%   This method returns the handles of the two axes created in AX and the
%   handles of the graphics objects from each plot in HLINES1 and HLINES1.
%   AX(1) is the left axes and AX(2) is the right axes. 
%
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/LISTFORMAT,
%   RFDATA.DATA/PLOT

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,3);

% Set the default
ax = [];
hlines1 = [];
hlines2 = [];
if nargout > 0
    varargout{1} = ax;
    if nargout > 1
        varargout{2} = hlines1;
        if nargout == 3
            varargout{3} = hlines2;
        end
    end
end
% Get the data object
h = varargin{1};

if ischar(varargin{end}) && any(strcmpi(varargin{end},                  ...
        {'semilogx', 'semilogy', 'loglog', 'plot'}))
    plotfun  = varargin{end};
    varargin = varargin(1:end-1);
else
    plotfun = 'plot';
end

% Check the input number
if numel(varargin) < 2
    error(message('rf:rfdata:data:plotyy:NotEnoughInput'));
end
if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfdata:data:plotyy:NotForBudgetData'));
end

% Extract parameters and formats
[temp_varargin, usePLOT, yformatposition] = plotyyprocess(h,            ...
    varargin{2:end});
if usePLOT; plot(h, temp_varargin{:}); return; end;
   
[temp_varargin, conditions] = smartprocess(h, temp_varargin{:});
original_xname = temp_varargin{end-1};  % X-axis name
original_xformat = temp_varargin{end};  % X-axis format
checkyinput(h, 2, temp_varargin{:});    % Only two y-axis formats allowed.
temp_varargin = temp_varargin(1:end-2); % Take out x-axis input arguments
ntemp_varargin = numel(temp_varargin);
for ii = 2:2:ntemp_varargin
    temp_varargin{ii} = modifyformat(h, temp_varargin{ii});
end
ytype = category(h, temp_varargin{1});
if strcmp(ytype, 'Phase Noise')
    plotfun = 'semilogx';
end

temp = temp_varargin(2:2:end);
unique_formats = myunique(temp); % Find out two unique formats
varset = cell(1, 2);
yformat = cell(1, 2);
if numel(unique_formats) == 1
    % Variables for y-axis 1
    varset{1} = [temp_varargin{1:(2*yformatposition(1)-2)},...
        {original_xname},{original_xformat},conditions];
    % Variables for y-axis 2
    varset{2} = [temp_varargin{(2*yformatposition(1)-1):end},...
        {original_xname},{original_xformat},conditions];
    yformat{1} = unique_formats{1};
    yformat{2} = unique_formats{1};
else % Two unique formats
    for kk = 1:2
        idx = find(strcmpi(unique_formats{kk}, temp_varargin));
        idx_1 = idx - 1;
        temp = temp_varargin(sort([idx_1(:)', idx(:)']));
        varset{kk} = [temp,{original_xname},{original_xformat},conditions];
        yformat{kk} = unique_formats{kk};
    end
end

% Calculate parameters
ydata = cell(1, 2); ynames = cell(1, 2); xdata = cell(1, 2);
[ydata{1}, ynames{1}, xdata{1}] = calculate(h, varset{1}{:});
[ydata{2}, ynames{2}, xdata{2}] = calculate(h, varset{2}{:});
% Refine legend
ylegend = cell(1, 2);
ylegend{1} = refinelegend(h, ynames{1}, yformat{1});
ylegend{2} = refinelegend(h, ynames{2}, yformat{2});
for ii=1:2
    % Put xdata, ydata and ynames into cells if they are not already
    [ydata{ii}, ynames{ii}, xdata{ii}] = putincell(h, ydata{ii},        ...
        ynames{ii}, xdata{ii});
    % If no data, don't plot
    if isempty(ynames{ii}) || isempty(ydata{ii}) || isempty(xdata{ii})
        return
    end
    if numel(xdata{ii})~=numel(ydata{ii})
        return
    end
    % Combine all data in ydata{ii} into a matrix
    [ydata{ii}, xdata{ii}] = combine2mat(h, ydata{ii}, xdata{ii}); 
end
% Scale xdata if frequency is set to 'Auto'
if strcmpi(original_xformat, 'Auto') && strcmpi(original_xname, 'Freq')
    [~, ~, funit] = scalingfrequency(h, [1; h.Freq(:)], 'Auto');
    original_xformat = funit(2:end-1);
    [~, xdata{1}] = scalingfrequency(h, xdata{1}, original_xformat);
    [~, xdata{2}] = scalingfrequency(h, xdata{2}, original_xformat);
end
[xname, xunit] = xaxis(h, original_xname, original_xformat);

% Get the figure for plot
fig = findfigure(h);
hold_state = false;
if ~(fig==-1)
    hold_state = ishold; 
end
% Use MATLAB plotyy function
[ax,hlines1,hlines2] = plotyy(xdata{1},ydata{1},xdata{2},ydata{2},plotfun);

% Add legend
hlines = [hlines1(:);hlines2(:)];
legendstrs = [ylegend{1}(:);ylegend{2}(:)];
legend(hlines,legendstrs,'Location','NorthEast');

% Set labels
if ~hold_state
    if ~strcmp(yformat{1}, 'None')
        set(get(ax(1),'Ylabel'), 'String', yformat{1}, 'Rotation', 90.0)
    end
    if ~strcmp(yformat{2}, 'None')
        set(get(ax(2),'Ylabel'), 'String', yformat{2}, 'Rotation',90.0)
    end
    xlabel(ax(1), sprintf('%s %s', xname, xunit));
    hold off;
end
% Add datatip
tipcell = simplifytip(h, ynames{1});
nhlines1 = numel(hlines1);
for k=1:nhlines1
    linesinfo = currentlineinfo(h, 'X-Y Plot', tipcell{k},              ...
        simplifytip(h, xname), xdata{1}, xunit,                         ...
        modifyformat(h, yformat{1}, 2), '');
    set(hlines1(k), 'UserData', linesinfo);
end
datatip(h, fig, hlines1);
%
tipcell = simplifytip(h, ynames{2});
nhlines2 = numel(hlines2);
for k=1:nhlines2
    linesinfo = currentlineinfo(h, 'X-Y Plot', tipcell{k},              ...
        simplifytip(h, xname), xdata{2}, xunit,                         ...
        modifyformat(h, yformat{2}, 2), '');
    set(hlines2(k), 'UserData', linesinfo);
end
datatip(h, fig, hlines2);

grid on;

if nargout > 0
    varargout{1} = ax;
    if nargout > 1
        varargout{2} = hlines1;
        if nargout == 3
            varargout{3} = hlines2;
        end
    end
end

%-------------------------------------
function [y, x] = combine2mat(h, y, x)
% Combine all data in a cell into a matrix
numTrace = size(y, 2);
x1 = x{1};
try
    y = cell2mat(y);
catch
    for kk = 2:numTrace
        y{kk} = interpolate(h, x{kk}, y{kk}, x1, 'linear');
    end
    y = cell2mat(y);
end
x = x{1};

%----------------------------------------
function names = refinelegend(h, names, format)
if isempty(format) || strcmpi(format, 'None');  return;  end;
% Refine legend for plotyy
nnames = numel(names);
for k=1:nnames
    [token, rem] = strtok(names{k}, '(');
    switch upper(token)
        case {'OIP3' 'IIP3' 'OIP2' 'IIP2' 'POUT' 'P_{OUT}' 'NF'         ...
                'NTEMP' 'GROUPDELAY'}
            token = sprintf('%s [%s]', token, modifyformat(h, format, 2));
        otherwise
            token = sprintf('%s(%s)', modifyformat(h, format, 2), token);
    end
    names{k} = [token, rem];
end

%----------------------------------
function [out, idx] = myunique(in)
[~, idx] = unique(in, 'first');
idx = sort(idx);
out = in(idx);