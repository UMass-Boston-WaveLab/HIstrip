function h = destroy(h,destroyData)
%DESTROY Destroy this object
%
%   See also RFCKT.LADDERFILTER

%   Copyright 2004-2007 The MathWorks, Inc.

% Delete objects associated with this object
ckts = get(h, 'Ckts');
nckts = length(ckts);

for ii=1:nckts
    ckt = ckts{ii};
    if isa(ckt,'rfckt.rfckt')
        delete(ckt)
    end
end

if isa(h.AnalyzedResult,'rfdata.data')
    delete(h.AnalyzedResult);
end