function checkproperty(h, for_constructor)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.PARALLEL

%   Copyright 2003-2007 The MathWorks, Inc.

if nargin < 2
    for_constructor = false;
end

% Check the properties
ckts = get(h, 'CKTS');
nckts = length(ckts);

if isempty(ckts) && ~for_constructor
    error(message('rf:rfckt:parallel:checkproperty:EmptyCKTS'));
end

for ii=1:nckts
    ckt = ckts{ii};
    checkproperty(ckt);
    if isnonlinear(ckt)
        error(message('rf:rfckt:parallel:checkproperty:LinearOnly'));
    end
    if get(ckt, 'nPort') ~= 2
        error(message('rf:rfckt:parallel:checkproperty:TwoPortOnly'));
    end
end