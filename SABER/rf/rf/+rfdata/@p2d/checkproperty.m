function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.P2P

%   Copyright 2006-2007 The MathWorks, Inc.

% Get the properties
freq = get(h, 'Freq');
p1 = get(h, 'P1');
p2 = get(h, 'P2');
data = get(h, 'Data');
n = numel(freq);
m1 = numel(p1);
m2 = numel(p2);
m3 = numel(data);
if ((n==0) && ~((m1==1) && (m2==1) && (m3==1))) ||                      ...
        (~(n==0) && ~((n==m1) && (n==m2) && (n==m3)))
    error(message('rf:rfdata:p2d:checkproperty:UnmatchingCellSize'));
end
for ii=1:m1
    p1i = p1{ii};
    p2i = p2{ii};
    n1 = numel(p1i);
    n2 = numel(p2i);
    datai = data{ii};
    n3 = size(datai, 3);
    if ~((n1==n2) && (n1==n3))
        error(message('rf:rfdata:p2d:checkproperty:UnmatchingDataSize', ...
            ii, ii, ii));
    end
    [p1{ii}, index] = sort(p1i);
    p2{ii} = p2i(index);
    data{ii} = datai(:,:,index);
end
if n > 1
    [freq, index] = sort(freq);
    p1 = p1(index);
    p2 = p2(index);
    data = data(index); 
end
set(h, 'Freq', freq, 'P1', p1, 'P2', p2, 'Data', data);