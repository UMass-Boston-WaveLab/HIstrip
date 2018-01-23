function refobj = getreference(h)
%GETREFERENCE Get the reference.
%   REFOBJ = GETREFERENCE(H) gets the property REFERENCE if there is a
%   single reference or returns the selected reference if there are
%   multiple references.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

refobj = h.Reference;
if isa(refobj, 'rfdata.multireference')
    % if ~isempty(refobj.References) && refobj.Selection
    refobj = refobj.References{refobj.Selection};
    % end
end