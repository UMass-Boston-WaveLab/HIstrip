function checkproperty(h, for_constructor)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.CASCADE

%   Copyright 2003-2007 The MathWorks, Inc.

if nargin < 2
    for_constructor = false;
end

% Check the properties
ckts = get(h, 'CKTS');
nckts = length(ckts);

if isempty(ckts) && ~for_constructor
    error(message('rf:rfckt:cascade:checkproperty:EmptyCKTS')); 
end

setflagindexes(h);
updateflag(h, indexOfNonLinear, 0, MaxNumberOfFlags);
for ii=1:nckts
    ckt = ckts{ii};
    if get(ckt, 'nPort') ~= 2
        error(message('rf:rfckt:cascade:checkproperty:TwoPortOnly'));
    end
    checkproperty(ckt);
    if bitget(get(ckt, 'Flag'), indexOfNonLinear) == 1
        updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
    end
end