function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.REFERENCE

%   Copyright 2003-2009 The MathWorks, Inc.

nport = 2;
z0 = 50;
% Check the properties
if isa(h.NetworkData, 'rfdata.network')
    checkproperty(h.NetworkData);
    nport = getnport(h.NetworkData);
    z0 = h.NetworkData.Z0;
end
if isa(h.NoiseData, 'rfdata.noise')
    checkproperty(h.NoiseData);
    h.NoiseData.Z0 = z0;
end
if isa(h.NFData, 'rfdata.nf')
    checkproperty(h.NFData);
    h.NFData.Z0 = z0;
end
if isa(h.PowerData, 'rfdata.power')
    checkproperty(h.PowerData);
    h.PowerData.Z0 = z0;
end
if isa(h.IP3Data, 'rfdata.ip3')
    checkproperty(h.IP3Data);
    h.IP3Data.Z0 = z0;
end
if isa(h.MixerSpurData, 'rfdata.mixerspur')
    checkproperty(h.MixerSpurData);
    h.MixerSpurData.Z0 = z0;
end
if isa(h.P2DData, 'rfdata.p2d')
    checkproperty(h.P2DData);
    h.P2DData.Z0 = z0;
end

if nport ~= 2 && isa(h.NoiseData, 'rfdata.noise')
   error(message('rf:rfdata:reference:checkproperty:NoiseDataforTwoPortOnly', h.Name));
end
if nport ~= 2 && isa(h.NFData, 'rfdata.nf')
   error(message('rf:rfdata:reference:checkproperty:NFDataforTwoPortOnly', h.Name));
end
if nport ~= 2 && isa(h.PowerData, 'rfdata.power') 
   error(message('rf:rfdata:reference:checkproperty:PowerDataforTwoPortOnly', h.Name));
end
if nport ~= 2 && isa(h.IP3Data, 'rfdata.ip3') 
   error(message('rf:rfdata:reference:checkproperty:IP3DataforTwoPortOnly', h.Name));
end
if nport ~= 2 && isa(h.P2DData, 'rfdata.p2d')
    error(message('rf:rfdata:reference:checkproperty:P2DDataforTwoPortOnly', h.Name));
end
if nport ~= 2 && isa(h.MixerSpurData, 'rfdata.mixerspur') 
   error(message('rf:rfdata:reference:checkproperty:MixerSpurDataforTwoPortOnly', h.Name));
end
if isa(h.NoiseData, 'rfdata.noise') && isa(h.NFData, 'rfdata.nf') && any(h.NFData.Data ~= 0)
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    else
        rferrhole = 'This block';
    end
    warning(message('rf:rfdata:reference:checkproperty:TWONoiseData', rferrhole));
end
if isa(h.PowerData, 'rfdata.power') && isa(h.IP3Data, 'rfdata.ip3') && any(h.IP3Data.Data ~= inf)
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    else
        rferrhole = 'This block';
    end
    warning(message('rf:rfdata:reference:checkproperty:TWONonlinearData', rferrhole));
end