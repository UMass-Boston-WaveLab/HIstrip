function varargout = circle(h, varargin)
%CIRCLE Draw circles on a smith chart.
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
%   See also RFCKT.CASCADE, RFCKT.CASCADE/SMITH

%   Copyright 2007 The MathWorks, Inc.

nargoutchk(0,2);

data = getdata(h);

if ~is_spotnoise_first(h)
    [hlines, hsm] = circle(data, varargin{:});
else
    newdata = copy(data); % Make a new data object
    newnoise = copy(h.Ckts{1}.NoiseData);
    newnet = rfdata.network('Type', 'S_Parameters', 'Z0',               ...
        newdata.Z0, 'Data', newdata.S_Parameters, 'Freq', newdata.Freq);
    if ~hasreference(newdata)
        newrefdata = rfdata.reference('NoiseData',newnoise, ...
            'NetworkData',newnet);
        setreference(newdata, newrefdata);
    else
        newrefdata = getreference(newdata);
        set(newrefdata, 'NetworkData', newnet, 'NoiseData', newnoise);
    end
    [hlines, hsm] = circle(newdata, varargin{:});
end

if nargout > 0
    varargout{1} = hlines;
    if nargout == 2
        varargout{2} = hsm;
    end
end

end % of circle

function result = is_spotnoise_first(h)
% Determine if the first circuit in the cascade is an amplifier that
% contains sport noise data.

result = false;
if numel(h.Ckts) >= 1 && isa(h.Ckts{1}, 'rfckt.amplifier') &&           ...
        isa(h.Ckts{1}.NoiseData, 'rfdata.noise')
    result = true;
end

end % is_spotnoise_first