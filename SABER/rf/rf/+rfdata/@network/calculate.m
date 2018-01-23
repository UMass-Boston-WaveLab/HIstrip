function [data, param, freq] = calculate(h, parameter, z0, zl, zs)
%CALCULATE Calculate the required power parameter.
%   [DATA, PARAM, FREQ] = CALCULATE(H, PARAMETER, Z0, Zl, ZS) calculates
%   the required parameter and the frequencies.
%
%   The first input is the handle to the object, the second input is the
%   parameter that can be visualized from this object.  Z0 is the reference
%   impedance. If omitted, the stored Z0 is used.  ZL is the load
%   impedance. ZS is the source impedance. The defaults of ZL and Zs are 50
%   ohms. 
%
%   See also RFDATA.NETWORK

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default for returned data
data = []; 
param = '';

% Get the paramsmeters
own_z0 = get(h, 'Z0');
if nargin < 3; z0 = own_z0; end;
if nargin < 4; zl = 50; end;
if nargin < 5; zs = 50; end;
[sdata, freq] = extract(h, 'S_Parameters');
nport = size(sdata, 1);

switch upper(parameter)
case 'GAMMAIN'
    data = gammain(sdata, z0, zl);
case 'GAMMAOUT'
    data = gammaout(sdata, z0, zs);
case 'VSWRIN'
    gamma = gammain(sdata, z0, zl);
    data = vswr(gamma);
case 'VSWROUT'
    gamma = gammaout(sdata, z0, zs);
    data = vswr(gamma);
otherwise
    if strncmpi(parameter(1), 'S', 1)
        [index1, index2] = sparamsindexes(h, parameter, nport);
        if 0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
            data = sdata(index1, index2, :);
            data = data(:);
            return;
        end
    end
    error(message('rf:rfdata:network:calculate:InvalidInput', parameter));
end
param = modifyname(h, parameter, nport);