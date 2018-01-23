function h = analyze(varargin)
%ANALYZE Analyze the RFDATA.DATA object in the frequency domain.
%   ANALYZE(H, FREQ, ZL, ZS, Z0) analyzes the data object in the frequency
%   domain at the simulation frequencies specified by the second input
%   FREQ. The first input is the handle to the RFDATA.DATA object to be
%   analyzed. The 3rd, 4th and 5th inputs are optional: 
%
%   ZL is the load impedance, the default is 50 ohms.
%   ZS is the source impedance, the default is 50 ohms.
%   Z0 is the reference impedance of S-parameters, the default is 50 ohms.
%
%   See also RFDATA.DATA, RFDATA.DATA/CALCULATE, RFDATA.DATA/EXTRACT

%   Copyright 2003-2007 The MathWorks, Inc.

h = varargin{1};
% Get and check the input FREQ 
if nargin < 2
    error(message('rf:rfdata:data:analyze:NoInputFreq'));
end

% Get the inputs
freq = checkfrequency(h, varargin{2});
m = numel(freq);
zl = 50;
zs = 50;
z0 = 50;
selvarcell = {};
keep_looking = true;
if nargin >= 3
    if isnumeric(varargin{3})
        zl = varargin{3};
        CheckZ(zl, m, 'ZL', 2);
    else
        selvarcell = varargin(3:end);
        keep_looking = false; % All input arguments after are independent variables value pairs.
    end
end
if nargin >= 4 && keep_looking
    if isnumeric(varargin{4})
        zs = varargin{4};
        CheckZ(zs, m, 'ZS', 2);
    else
        selvarcell = varargin(4:end);
        keep_looking = false;
    end
end
if nargin >= 5 && keep_looking
    if isnumeric(varargin{5})
        z0 = varargin{5};
        CheckZ(z0, m, 'Z0', 2);
    else
        selvarcell = varargin(5:end);
        keep_looking = false;
    end
end
if nargin >= 6 && keep_looking
    if ~isnumeric(varargin{6})
        selvarcell = varargin(6:end);
        keep_looking = false;
    end
end
if nargin >= 7 && keep_looking
    selvarcell = varargin(7:end);
end

% Select proper reference
if ~isempty(selvarcell)
    checkcondition(h, selvarcell{:})
    setop(h, selvarcell{:});
end

[zl, zs, z0] = sortimpedance(h, varargin{2}, zl, zs, z0);
set(h, 'Zl', zl, 'Zs', zs, 'Z0', z0);

% Check the properties 
checkproperty(h);

% Calculate the group delay 
gd = calcgroupdelay(h, freq, z0);

% Calculate the network parameters 
[type, netparameters, own_z0] = nwa(h, freq);

% Update the properties
set(h, 'Freq', freq, 'S_Parameters', s2s(netparameters, own_z0, z0));

% Calculate noise figure and OIP3 for 2-port
if (getnport(h) == 2)
    nf = zeros(m, 1);
    ip3 = inf * ones(m, 1);
    if hasnoisereference(h) || hasnfreference(h)
        [cmatrix, ctype] = noise(h, freq);
        if ~isempty(cmatrix)
            cmatrix = convertcorrelationmatrix(h, cmatrix, ctype,'ABCD CORRELATION MATRIX', ...
                netparameters, 'S_Parameters', own_z0);
            nf = noisefigure(h, cmatrix, z0);
        end
    end
    if hasip3reference(h) || haspowerreference(h) || hasp2dreference(h)
        ip3 = oip3(h, freq);
    end
else
    nf = 0;
    ip3 = inf;
end

% Update the properties
set(h, 'NF', nf, 'OIP3', ip3, 'GroupDelay', gd);