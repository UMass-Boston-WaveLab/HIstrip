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
%   TABLE(H, 'BUDGET', PARAMETER1, FORMAT1, ..., PARAMETERN, FORMATN)
%   displays the specified budget parameters of an RFCKT.CASCADE object in
%   the Variable Editor. 
%
%   Type LISTPARAM(H, 'BUDGET') to see the valid budget parameters.
%
%   See also OPENVAR, RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/LISTFORMAT,
%   RFCKT.RFCKT/PLOT, RFCKT.RFCKT/SMITH, RFCKT.RFCKT/POLAR

%   Copyright 2010 The MathWorks, Inc.

% Get the RFCKT object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:rfckt:table:NotEnoughInput'));
end

% Get the data object
data = getdata(h);
if strcmpi(varargin{2}, 'budget')
    if isa(h, 'rfckt.cascade')
        ckts = get(h, 'CKTS');
        if length(ckts) <= 1
            error(message('rf:rfckt:rfckt:table:OneCktOnly'));
        end
        budgetdata = get(data, 'BudgetData');
        if ~isa(budgetdata, 'rfdata.data')
            setflagindexes(h);
            updateflag(h, indexOfTheBudgetAnalysisOn, 1, MaxNumberOfFlags);
            updateflag(h, indexOfNeedToUpdate, 1, MaxNumberOfFlags);
            analyze(h, data.Freq);
        end
    else
        error(message('rf:rfckt:rfckt:table:NoBudgetDataForThisObject'));
    end
end
% Display data in a table
data = getdata(h);
data.CktObjectVarName = inputname(1);
table(data, varargin{2:end});
data.CktObjectVarName = '';