function checkproperty(h,for_constructor)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFMODEL.RATIONAL

%   Copyright 2006-2015 The MathWorks, Inc.

if nargin < 2
    for_constructor = false;
end
if for_constructor
    return
end

if ~isscalar(h)
    validateattributes(h,{'rfmodel.rational'},{'scalar'},'', ...
        'rfmodel.rational',1)
end

% Check the properties
if length(h.A) ~= length(h.C)
    error(message('rf:rfmodel:rational:checkproperty:MismatchedNumsofPolesandResidues',h.Name))
end