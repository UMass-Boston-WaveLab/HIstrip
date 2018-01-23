function checknport(h, actn, expn, fname, classname)
% Throw an error when number of ports is not as expected.
%
%   See also RFDATA

%   Copyright 2006-2009 The MathWorks, Inc.

if actn ~= expn
    error(message('rf:rfdata:rfdata:checknport:InvalidNPorts',          ...
        upper( classname ), upper( fname ), expn, actn))
end