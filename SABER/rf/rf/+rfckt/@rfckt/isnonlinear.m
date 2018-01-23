function result = isnonlinear(h)
%ISNONLINEAR Is this a nonlinear circuit.
%   RESULT = ISNONLINEAR(H) returns TRUE if the object is a nonlinear
%   circuit, and FALSE if it's not. 
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

% Check the property
checkproperty(h);
% Check the flag
cflag = get(h, 'Flag');
setflagindexes(h);
if bitget(cflag, indexOfNonLinear)==1
    result = true;
else
    result = false;
end