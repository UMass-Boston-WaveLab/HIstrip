function z0 = getz0(h)
%GETZ0 Get characteristic impedance
%   Z0 = GETZ0(H) gets the txline characteristic impedance.
%
%   See also RFCKT.BASETXLINE

%   Copyright 2003-2009 The MathWorks, Inc.

% Get the result
z0 = get(h, 'Z0');