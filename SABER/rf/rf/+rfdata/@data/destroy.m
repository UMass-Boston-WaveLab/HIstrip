function h = destroy(h,destroyData)
%DESTROY Destroy this object
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Delete objects associated with this object
if hasreference(h)
    delete(h.Reference);
end