function table(varargin)
%TABLE Display the specified parameters in a table.
%   TABLE(H, PARAMETER1, FORMAT1, ..., PARAMETERN, FORMATN) displays the
%   specified parameters PARAMETER1, ..., PARAMETERN in the Variable
%   Editor. The method creates a variable in the MATLAB workspace. The
%   variable name is constructed from the object and parameter names you
%   provide. The PARAMETER and FORMAT should be specified in pairs. If the
%   FORMAT is not specified, the default format is used. 
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   TABLE(H, 'BUDGET', ...) displays the specified budget parameters of an
%   RFCKT.CASCADE object. For detail, please type help rfckt.cascade/plot.
%
%   Type LISTPARAM(H, 'BUDGET') to see the valid budget parameters.
%
%   See also OPENVAR, RFDATA.DATA, RFDATA.DATA/LISTPARAM, 
%   RFDATA.DATA/LISTFORMAT, RFDATA.DATA/PLOT, RFDATA.DATA/SMITH,
%   RFDATA.DATA/POLAR

%   Copyright 2010 The MathWorks, Inc.

% Get the data object
h = varargin{1};

% Check the input number
if numel(varargin) < 2
    error(message('rf:rfdata:data:table:NotEnoughInput'));
end
varname = '';
if h.CktObjectVarName
    varname = h.CktObjectVarName;
end

% Find out if it is a budget display
do_budgetplot = false;
mydata = h;
if strcmpi(varargin{2}, 'budget')
    varname = [varname '_' varargin{2}];
    budgetdata = get(h, 'BudgetData');
    if nargin < 3
        error(message('rf:rfdata:data:table:NotEnoughInput'));
    elseif isa(budgetdata, 'rfdata.data') 
        do_budgetplot = true;
        varargin = varargin([1, 3:end]);
        mydata = budgetdata;
    else
        error(message('rf:rfdata:data:table:NoBudgetData'));
    end
end

% Extract parameters and formats
[temp_varargin, conditions] = smartprocess(h, varargin{2:end}, 'table');
original_xformat = temp_varargin{end};
if do_budgetplot
    [freq_cell, conditions] = processargin(h, conditions, 'Freq');
    power_cell = processargin(h, conditions, 'Pin');
    checkbudget(h, temp_varargin, freq_cell, power_cell)
end
% Only one y-axis format is allowed.
checkyinput(h, length(temp_varargin)/2 -1, temp_varargin{:});

[ydata, ynames, xdata] = calculate(mydata, varargin{2:end}, 'table');

% If no data, don't display
if isempty(ynames) || isempty(ydata) || isempty(xdata)
    return
end

numsets = numel(ydata); % Number of data sets
xparam = temp_varargin{end-1};
xformat = temp_varargin{end};
yformats = cell(numsets, 1);
for jj=1:numsets
    yformats{jj} = modifyformat(h, temp_varargin{2*jj}, 2);
    varname = [varname '_' temp_varargin{2*jj -1}];
end
% Get the information of X-axis
if strcmpi(original_xformat, 'Auto') && strcmpi(xparam, 'Freq')
    [~, ~, funit] = scalingfrequency(h, [1; h.Freq(:)], 'Auto');
    xformat = funit(2:end-1);
    [~, xdata] = scalingfrequency(h, xdata, xformat);
end
[xname, xunit] = xaxis(h, xparam, xformat);

% Get the data
if do_budgetplot
    datatable = budgettable(h, ydata, ynames, yformats, xdata, xname,   ...
        xunit);
else
    datatable = cell(length(xdata)+1, numsets+1);
    % Fill the data table
    if isempty(xunit)
        datatable{1, 1} = xname;
    else
        datatable{1, 1} = [xname, ' ', xunit];
    end
    for jj=1:numsets
        yformat = modifyformat(h, temp_varargin{2*jj}, 2);
        if isempty(yformat)
            datatable{1, jj+1} = simplifytip(h, ynames{jj});
        else
            datatable{1, jj+1} = [simplifytip(h,                        ...
                ynames{jj}), ' [', yformat, ']'];
        end
    end
    for ii = 1:length(xdata)
        datatable{ii+1, 1} = xdata(ii);
        for jj=1:1:numsets
            datatable{ii+1, jj+1} = ydata{jj}(ii);
        end
    end
end
    
% Display the data in a table
assignin('base', varname, datatable);
evalin('base', ['openvar ' varname]);