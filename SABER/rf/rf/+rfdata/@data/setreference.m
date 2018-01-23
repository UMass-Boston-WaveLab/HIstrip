function setreference(h, refobj)
%SETREFERENCE Set the reference.
%   SETREFERENCE(H, REFOBJ) sets the property REFERENCE.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the property
if ~isempty(refobj) && (~isa(refobj, 'rfdata.reference'))               ...
        && (~isa(refobj, 'rfdata.multireference'))
    error(message('rf:rfdata:data:setreference:WrongDataObject'));
end
set(h, 'Reference', refobj);
%setReference(h,refobj);