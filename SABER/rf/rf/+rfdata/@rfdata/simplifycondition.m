function conditions = simplifycondition(h, conditions)
%SIMPLIFYCONDITION Remove irrelevant operating conditions.
%
%   See also RFDATA

%   Copyright 2006-2009 The MathWorks, Inc.

% Make sure numeric conditions have numeric value
if hasmultireference(h)
    % Reshape input into two rows, first row contains condition names
    % and second row contains condition values.
    tempc = reshape(conditions, 2, []);
    cnames = tempc(1, :); % Condition names
    cvalues = tempc(2, :); % Condition values
    lidx = true(1, numel(cnames));

    tempops = getvarnames(h.Reference);
    ncnames = numel(cnames);
    for ii = 1:ncnames
        if ~any(strcmpi(cnames{ii}, tempops)) % irrelevant conditions
            lidx(ii) = false;
        end
    end

    if ~all(lidx)
        cnames = cnames(lidx);
        ncnames = numel(cnames);
        cvalues = cvalues(lidx);
        conditions = cell(1, 2*ncnames);
        conditions(1:2:end) = cnames;
        conditions(2:2:end) = cvalues;
    end
end