function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.NF

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
freq = get(h, 'Freq');
data = get(h, 'Data');
n = numel(freq);
m = numel(data);
if ~((n ==0 && m == 1) || (n==m))
    error(message('rf:rfdata:nf:checkproperty:WrongDataSize'));
end
if n ~= 0
    [freq, index] = sort(freq);
    data = data(index);
end
set(h, 'Freq', freq, 'Data', data);