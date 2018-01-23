function [names, values] = getnumericvars(h)
%GETNUMERICVARS Return unique independent numeric variable names and values.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

[names, values] = getvarnames(h);
idx = true(1, numel(names));
nnames = numel(names);
for ii = 1:nnames
    temp = str2double(values{ii});
    if ~isnumeric(temp) || isnan(temp) || isempty(temp)
        idx(ii) = false;
    end
end
names = names(idx);
values = str2num(char(values(idx)));