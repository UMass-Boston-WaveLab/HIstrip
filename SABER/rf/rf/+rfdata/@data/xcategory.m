function dcategory = xcategory(h, parameter)
%CATEGORY Check and find the category of the specified parameter.
%   DCATEGORY = CATEGORY(H, PARAMETER) checks the PARAMETER and returns
%   its category. 
%
%   Type LISTPARAM(H) to see valid parameter for the RFDATA.DATA object.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default
dcategory = '';      

% Check the data to find its category
switch upper(parameter)
    case {'FREQ' 'FREQUENCY'}
        dcategory = 'Frequency';
    case {'PIN' 'P1'}
        dcategory = 'Input Power';
    case {'AM'}
        dcategory = 'AM';
    otherwise
        if hasmultireference(h)
            varnames = getnumericvars(h.Reference);
            if  any(strcmpi(parameter, varnames))
                dcategory = 'Operating Condition';
            end
        end
end