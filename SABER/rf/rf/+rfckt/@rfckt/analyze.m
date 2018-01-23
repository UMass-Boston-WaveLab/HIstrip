function h = analyze(varargin)
%ANALYZE Analyze the RFCKT object in the frequency domain.
%   ANALYZE(H, FREQ, ZL, ZS, Z0, APERTURE) analyzes the RFCKT object in the
%   frequency domain at the simulation frequencies specified by the second
%   input FREQ. The first input is the handle to the RFCKT object to be
%   analyzed. The 3rd, 4th, 5th, and 6th inputs are optional: 
%
%   ZL is the circuit load impedance, the default is 50 ohms.
%   ZS is the circuit source impedance, the default is 50 ohms.
%   Z0 is the reference impedance of S-parameters, the default is 50 ohms.
%
%   APERTURE is used to determine two closely spaced frequencies at each
%   simulation frequency for the group delay calculation. Group delay is
%   the negative-slope of the S21's phase angle with respect to the
%   simulation frequencies FREQ:
%  
%     GroupDelay(FREQ) = 
%       - (unwrap(angle(S21(FREQ_RIGHT))) - unwrap(angle(S21(FREQ_LEFT))))
%       / (2*pi * (FREQ_RIGHT - FREQ_LEFT))
% 
%   where
%     FREQ_LEFT  = FREQ - FREQ * APERTURE/2      for APERTURE < 1
%     FREQ_LEFT  = FREQ - APERTURE/2             for APERTURE >= 1
%   and
%     FREQ_RIGHT = FREQ + FREQ * APERTURE/2      for APERTURE < 1
%     FREQ_RIGHT = FREQ + APERTURE/2             for APERTURE >= 1
%
%   APERTURE can be a positive scalar or a vector of the same length as the
%   simulation frequencies FREQ. If APERTURE is not specified, it will be
%   determined based on the simulation frequencies FREQ. 
%
%   See also RFCKT, RFCKT.RFCKT/CALCULATE, RFCKT.RFCKT/EXTRACT

%   Copyright 2003-2009 The MathWorks, Inc.

h = varargin{1};
% Get and check the input FREQ 
if nargin < 2
    error(message('rf:rfckt:rfckt:analyze:NoInputFreq'));
end

% Get the inputs
freq = checkfrequency(h, varargin{2});
m = numel(freq);
zl = 50;
zs = 50;
z0 = 50;
aperture = [];
selvarcell = {};
keep_looking = true;
if nargin >= 3
    if isnumeric(varargin{3})
        zl = varargin{3};
        CheckZ(zl, m, 'ZL', 2);
    else
        selvarcell = varargin(3:end);
         % All input arguments after are independent variables value pairs.
        keep_looking = false;
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
    if isnumeric(varargin{6})
        aperture = checkaperture(h, freq, varargin{6});
    else
        selvarcell = varargin(6:end);
        keep_looking = false;
    end
end
if nargin >= 7 && keep_looking
    selvarcell = varargin(7:end);
end

% Create an RFDATA.DATA object if needed
if ~isa(h.AnalyzedResult, 'rfdata.data')
    setrfdata(h, rfdata.data);
end
data = get(h, 'AnalyzedResult');

% Select proper reference
if ~isempty(selvarcell)
    checkcondition(data, selvarcell{:})
    setop(h, selvarcell{:});
end

[zl, zs, z0] = sortimpedance(data, varargin{2}, zl, zs, z0);
set(data, 'Zl', zl, 'Zs', zs, 'Z0', z0);

cflag = get(h, 'Flag');
setflagindexes(h);

% Check the properties of RFCKT object
if bitget(cflag, indexOfThePropertyIsChecked) == 0
    checkproperty(h);
end

% Calculate the group delay 
gd = calcgroupdelay(h, freq, z0, aperture);

% Calculate the network parameters
[type, netparameters, own_z0] = nwa(h, freq);
if ~isa(h, 'rfckt.cascade')
    if ~isa(h.SimData, 'rfdata.network')
        set(h, 'SimData', rfdata.network);
    end  
    simdata = get(h, 'SimData');
    simnetparameters = netparameters;
    set(simdata, 'Type', type,  'Data', simnetparameters, 'Freq', freq, ...
        'Z0', own_z0);
elseif isa(h, 'rfckt.cascade') &&                                       ...
        (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1)
    budgetdata = get(h, 'BudgetData');
    budgetsparams = s2s(budgetdata.S_Parameters, budgetdata.Z0, z0);
    set(budgetdata, 'S_Parameters', budgetsparams, 'Z0', z0);
end
% Calculate the S-parameters
if strncmpi(type,'S',1)
    sparams = s2s(netparameters, own_z0, z0);
else
    sparams = convertmatrix(data, netparameters, type, 'S_PARAMETERS', z0);
end

% Update the properties of RFDATA.DATA object
set(data, 'S_Parameters', sparams, 'Freq', freq, 'Z0', z0);

if (h.nPort == 2)
    nf = zeros(m, 1);
    ip3 = inf * ones(m, 1);
    % Calculate noise correlation matrix and OIP3
    if bitget(cflag, indexOfNoiseOn) 
        [cmatrix, ctype] = noise(h, freq);
        cmatrix = convertcorrelationmatrix(data, cmatrix, ctype,        ...
            'ABCD CORRELATION MATRIX', netparameters, type, own_z0);
        nf = noisefigure(data, cmatrix, z0);
    end
    if bitget(cflag, indexOfDoNonlinearAna) 
        ip3 = oip3(h, freq);
    end
else
    nf = 0;
    ip3 = inf;
end
ip3(ip3 <= 0) = eps;

set(data, 'NF', nf, 'OIP3', ip3, 'GroupDelay', gd);
if isa(h, 'rfckt.cascade')
    set(data, 'BudgetData', h.BudgetData);
end