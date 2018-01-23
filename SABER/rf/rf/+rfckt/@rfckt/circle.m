function varargout = circle(h, varargin)
%CIRCLE Draw circles on a Smith chart.
%   [HLINES, HSM] = CIRCLE(H, FREQ, TYPE1, VALUE1, ... TYPEN, VALUEN, HSM)
%   draws circles on a Smith chart and returns the following handles: 
%   HLINES: a vector of handles to line objects, with one handle per circle
%   HSM: the handle to the Smith chart
%
%   H is the handle to an RFCKT object. FREQ is a single frequency
%   point of interest. TYPE1, VALUE1, ... TYPEN, VALUEN are the type/value
%   pairs that specify the circles to plot. The supported circle TYPEs are:
%   'Ga'    --  Constant available power gain circle
%   'Gp'    --  Constant operating power gain circle
%   'Stab'  --  Stability circle
%   'NF'    --  Constant noise figure circle
%   'R'     --  Constant resistance circle
%   'X'     --  Constant reactance circle
%   'G'     --  Constant conductance circle
%   'B'     --  Constant susceptance circle
%   'Gamma' --  Constant reflection magnitude circle
%
%   The allowed VALUEs for the above types of circles are:
%   'Ga'    --  Scalar or vector of gains in dB
%   'Gp'    --  Scalar or vector of gains in dB
%   'Stab'  --  String 'in' or 'source' for input/source stability circle;
%               string 'out' or 'load' for output/load stability circle. 
%   'NF'    --  Scalar or vector of noise figures in dB
%   'R'     --  Scalar or vector of resistance
%   'X'     --  Scalar or vector of reactance
%   'G'     --  Scalar or vector of conductance
%   'B'     --  Scalar or vector of susceptance
%   'Gamma' --  Scalar or vector of non-negative reflection magnitude
%
%   HSM is an optional input argument that you can use to place circles on
%   an existing Smith chart.
%
%   See also RFCKT, RFCKT.RFCKT/SMITH

%   Copyright 2007-2009 The MathWorks, Inc.

nargoutchk(0,2);

data = getdata(h);
[hlines, hsm] = circle(data, varargin{:});

if nargout > 0
    varargout{1} = hlines;
    if nargout == 2
        varargout{2} = hsm;
    end
end