function h = destroy(h,destroyData)
%DESTROY Destroy this object
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

% Delete objects associated with this object
if isa(h.AnalyzedResult,'rfdata.data')
    delete(h.AnalyzedResult);
end
if isa(h.SimData,'rfdata.network')
    delete(h.SimData);
end
udata = get(h, 'UserData');
nudata = length(udata);
for jj = 1:nudata
    if isa(udata{jj}, 'rfbase.rfbase')
        delete(udata{jj});
    end
end