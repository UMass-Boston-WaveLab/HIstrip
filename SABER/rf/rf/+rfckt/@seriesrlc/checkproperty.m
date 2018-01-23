function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.SERIESRLC

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
r = get(h, 'R');
l = get(h, 'L');
c = get(h, 'C');

% Check the properties
if (r < 0 || r == Inf)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:seriesrlc:checkproperty:InvalidR', rferrhole));
end

if (l < 0 || l == Inf)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:seriesrlc:checkproperty:InvalidL', rferrhole));
end 

if (c <= 0)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:seriesrlc:checkproperty:InvalidC', rferrhole));
end