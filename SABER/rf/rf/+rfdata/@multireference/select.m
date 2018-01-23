function result = select(h, varargin)
%SELECT Select references from multiple references to match the input
% variable names and their values.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

result = []; % Initialize to empty meaning no selection found
allvars = h.IndependentVars;
idx_left = 1:numel(allvars); % Search scope
num_input = numel(varargin);
if num_input == 0
    return
end

% Number of elements in varargin must be even
% if mod(num_input, 2) ~= 0
%     id = sprintf('rf:%s:select:OddVarargin', strrep(class(h),'.',':'));
%     error(id, 'Operating conditions must appear in name and value pairs.');
% end

for ii = 1:num_input/2

    myvar = varargin{2*ii - 1}; % Variable name
%     if ~ischar(myvar) % Check variable name    
%         id = sprintf('rf:%s:select:VarnameNotChar', strrep(class(h),'.',':'));
%         error(id, 'Operating condition must be string.');
%     end

    myvalue = varargin{2*ii}; % Variable value
    
    % Find the matching variable names
    idx_match = []; % Index of independent variable sets
    tempvalue = cell(numel(allvars), 1); % Temporary holder for variable values
    nallvars = numel(allvars);
    for kk = 1:nallvars
        if any(kk == idx_left) % Check if index is in scope
            % Find the index of those independent variable sets, where the
            % matching variable name is found.
            idx_name = find(strcmpi(allvars{kk}(:,1), myvar));
            if ~isempty(idx_name)
                idx_match = [idx_match, kk];
                tempvalue{numel(idx_match)} = allvars{kk}{idx_name(1), 2};
            end
        end
    end
    
    if isempty(idx_match) % No matching variable name found
        continue
    else
        tempvalue = tempvalue(1:numel(idx_match));
    end
    
    if isnumeric(myvalue) && ~isempty(myvalue) % For numeric value
        tempnum = str2num(char(tempvalue));
        if numel(tempnum) == numel(idx_match);
            minval = min(abs(tempnum - myvalue));
            idx_match = idx_match(abs(tempnum - myvalue) == minval);
            % Issue a warning when difference is greater than 10 percent.
            if minval/myvalue > 0.1
                pos = find(abs(tempnum - myvalue) == minval);
                warning(message(['rf:rfdata:multireference:select:'     ...
                    'BigDifference'],                                   ...
                    myvar, sprintf( '%g', tempnum( pos( 1 ) ) )));
            end
        else
            continue
        end       
    else % For non-numeric value
        idx_match = idx_match(strcmpi(tempvalue, myvalue));
        if isempty(idx_match)
            continue
        end
    end
    
    if numel(idx_match) == 1
        result = idx_match;
        return
    end
    
    idx_left = idx_match;

end

result = idx_left; % Multiple selections found
