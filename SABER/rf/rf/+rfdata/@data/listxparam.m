function list = listxparam(h, yparam)
%XLISTPARAM List the valid parameters for the RFDATA.DATA object.
%   LIST = LISTXPARAM(H, YPARAM) lists the valid independent parameters
%   that are valid for a dependent parameter, YPARAM.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

narginchk(1, 2)

% Case 1: One input
if nargin == 1
    list = {};
    if haspowerreference(h) || hasp2dreference(h)
        list(end+1:end+2) = {'Pin', 'AM'};
    end
    list(end+1) = {'Freq'};

    if hasmultireference(h)
        varnames = getnumericvars(h.Reference);
        list(end+1:end+numel(varnames)) = varnames;
    end
    list = list';

% Case 2: Two input
else
    ytype = category(h, yparam);
    switch ytype
        case 'AMAM/AMPM Parameters'
            list = {'AM'};

        case 'Phase Noise'
            list = {'Freq'};
            
        case {'Network Parameters', 'Noise Parameters'}
            list = {'Freq'};
            if hasmultireference(h)
                varnames = getnumericvars(h.Reference);
                list(end+1:end+numel(varnames)) = varnames;
            end
            list = list';
            
        otherwise
            list = listxparam(h);
            list = list(~strcmpi(list, 'AM')); % Remove AM
    end
end