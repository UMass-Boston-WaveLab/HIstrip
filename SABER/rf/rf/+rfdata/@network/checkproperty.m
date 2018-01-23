function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.NETWORK

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
data = get(h, 'Data');
freq = get(h, 'Freq');
z0 = get(h, 'Z0');

% Check the freq, data and z0
if isempty(data)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message(['rf:rfdata:network:checkproperty:'                   ...
        'EmptyNetworkParameters'], rferrhole));
end
n = numel(freq);
[m1, m2, m3] = size(data);
k = numel(z0);
if n~=0 && n~=m3
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfdata:network:checkproperty:WrongFrequency',     ...
        rferrhole));
end
if k~=1 && k~=m3
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfdata:data:checkproperty:WrongImpedance',        ...
        rferrhole));
end
if n~=0
    [freq, index] = sort(freq);
    data(:,:,:) = data(:,:,index);
    if k == m3
        z0 = z0(index);
    end
end
set(h, 'Freq', freq, 'Data', data, 'Z0', z0);