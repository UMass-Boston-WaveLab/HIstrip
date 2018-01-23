function h = destroy(h,destroyData)
%DESTROY Destroy this object
%
%   See also RFDATA.REFERENCE

%   Copyright 2003-2007 The MathWorks, Inc.

% Delete objects associated with this object
if isa(h.NetworkData,'rfdata.network')
    delete(h.NetworkData);
end
if isa(h.NoiseData,'rfdata.noise')
    delete(h.NoiseData);
end
if isa(h.NFData,'rfdata.nf')
    delete(h.NFData);
end
if isa(h.PowerData,'rfdata.power')
    delete(h.PowerData);
end
if isa(h.IP3Data,'rfdata.ip3')
    delete(h.IP3Data);
end
if isa(h.MixerSpurData,'rfdata.mixerspur')
    delete(h.MixerSpurData);
end
if isa(h.P2DData,'rfdata.p2d')
    delete(h.P2DData);
end