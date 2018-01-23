function z0 = getz0(h)
%GETZ0 Get characteristic impedance
%   Z0 = GETZ0(H) gets the txline characteristic impedance.
%
%   See also RFCKT

%   Copyright 2005-2009 The MathWorks, Inc.

error(message('rf:rfckt:rfckt:getz0:NotForThisObject', upper( class(h) )));