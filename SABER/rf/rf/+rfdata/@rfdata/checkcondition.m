function checkcondition(h, varargin)
%CHECKCONDITION Check if operating conditions are valid.
%
%   See also RFDATA

%   Copyright 2006-2009 The MathWorks, Inc.

if mod(numel(varargin), 2) ~= 0
    error(message('rf:rfdata:data:checkcondition:OddNumberOfInput'));
end

% Reshape input into two rows, first row contains condition names an second
% row contains condition values.
inputvars = reshape(varargin, 2, []);
cnames = inputvars(1, :); % Condition names
% cvalues = inputvars(2, :); % Condition values

ncnames = numel(cnames);
for ii = 1:ncnames
    if ~ischar(cnames{ii})
        error(message('rf:rfdata:data:checkcondition:ConditionNotChar'));
    end
end