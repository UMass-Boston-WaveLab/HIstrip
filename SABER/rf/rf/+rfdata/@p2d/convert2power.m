function power = convert2power(h)
%CONVERT2POWER Convert an RFDATA.P2D object into an RFDATA.POWER object.
%
%   See also RFDATA.P2P

%   Copyright 2006-2009 The MathWorks, Inc.

Freq = h.Freq;
Pin = h.P1;
Pout = h.P2;
Z0 = h.Z0;

sparam = h.Data;
Phase = cell(numel(sparam), 1);
% Convert angle of S21 to phase
nsparam = numel(sparam);
for ii = 1:nsparam
    Phase{ii} = unwrap(angle(squeeze(sparam{ii}(2,1,:))))*180/pi;
end
power = rfdata.power('Freq', Freq, 'Pin', Pin, 'Pout', Pout, ...
    'Phase', Phase, 'Z0', Z0);