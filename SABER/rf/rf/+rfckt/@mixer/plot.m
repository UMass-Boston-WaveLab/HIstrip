function varargout = plot(varargin)
%PLOT Plot the parameters on an X-Y plane.
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
%   specified parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using
%   the specified FORMAT. FORMAT must be a valid format for all the
%   parameters.
%
%   Type LISTPARAM(H) to see the valid parameters for plot.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   HLINES = PLOT(H, 'BUDGET', ...) plots the specified budget parameters
%   of an RFCKT.CASCADE object. For detail, please type help
%   rfckt.cascade/plot.
%
%   HLINES = PLOT(H, 'MIXERSPUR', K, PIN, FIN) plots the spur power of an
%   RFCKT.MIXER object or an RFCKT.CASCADE object that contains one or more
%   mixers. 
%   K is the index of the circuit object for which to plot spur power. Its
%   value can be an integer or 'ALL'. The default is 'ALL'. This value
%   creates a budget plot of the spur power for H. Use 0 to plot the power
%   at the input of H.
%   PIN is a scalar in dBm that specifies the input power at which to plot
%   spur power. The default is 0 dBm. Once you create a spur plot for an
%   object, the previous input power value is used for subsequent plots
%   until you specify a different value.
%   FIN is a positive scalar in Hz that specifies the input frequency at
%   which to plot spur power. If H is an RFCKT.MIXER object, the default
%   value of FIN is the input frequency at which dB(S21) of the mixer is
%   highest. If H is an RFCKT.CASCADE object, the default value of FIN is
%   the input frequency at which dB(S21) of the first mixer in the cascade
%   is highest. Once you create a spur plot for an object, the previous
%   input frequency value is used for subsequent plots until you specify a
%   different value.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   See also RFCKT.MIXER, RFCKT.MIXER/LISTPARAM, RFCKT.MIXER/LISTFORMAT,
%   RFCKT.MIXER/TABLE, RFCKT.MIXER/SMITH, RFCKT.MIXER/POLAR

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1)

h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:mixer:plot:NotEnoughInput'));
end

% Get the data object
data = getdata(h);

% Check the inputs
if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfckt:mixer:plot:OneCktOnly'));
elseif strcmpi(varargin{2}, 'mixerspur')
    if ~isa(h.MixerSpurData, 'rfdata.mixerspur')
        warning(message('rf:rfckt:mixer:plot:NoMixerSpurData'));
    end
    pin = 0; fin = 1e9; k = 'all'; z0 = 50;
    spurdata = get(data, 'SpurPower');
    if ~isempty(spurdata) && ~isempty(spurdata.Pout{1})
        pin = spurdata.Pout{1}(1);
    end
    if ~isempty(spurdata) && ~isempty(spurdata.Freq{1})
        fin = spurdata.Freq{1}(1);
    end
    if isa(h.NetworkData, 'rfdata.network')
        [smatrix, freq] = extract(h.NetworkData, 'S_Parameters');
        [~, idx] = max(abs(smatrix(2,1,:)));
        if isempty(spurdata) || isempty(spurdata.Freq{1})
            fin = freq(idx);
        end
        z0 = h.NetworkData.Z0;
    end
    if nargin == 3 
        k = varargin{3};
    elseif nargin == 4
        k = varargin{3};
        pin = varargin{4};
    elseif nargin == 5
        k = varargin{3};
        pin = varargin{4};
        fin = varargin{5};
    elseif nargin ~= 2
        error(message('rf:rfckt:mixer:plot:TooManyInputs'));
    end
    if ~strncmpi(k, 'all', 3) && ( ~isscalar(k) || ~isnumeric(k) ||     ...
            isnan(k) || ~isreal(k) || (k < 0) || isinf(k) || (k > 1))
        error(message('rf:rfckt:mixer:plot:WrongKInput'));
    end
    if isempty(pin) || ~isscalar(pin) || ~isnumeric(pin) ||             ...
            isnan(pin) || ~isreal(pin) || isinf(pin)
        error(message('rf:rfckt:mixer:plot:WrongPinInput'));
    end
    if isempty(fin) || ~isscalar(fin) || ~isnumeric(fin) ||             ...
            isnan(fin) || ~isreal(fin) || fin < 0 || isinf(fin)
        error(message('rf:rfckt:mixer:plot:WrongfreqInput'));
    end
    if convertfreq(h, fin, false) < 0
        error(message('rf:rfckt:mixer:plot:FinIsTooSmall', fin));
    end
    spurdata = [];
    spurdata.NMixers = 1;
    spurdata.TotalNMixers = 1;
    spurdata.Fin(1) = fin;
    spurdata.Pin(1) = pin;
    spurdata.Idxin{1} = 'Desired signal';
    spurdata.Freq{1}(1) = fin;
    spurdata.Pout{1}(1) = pin;
    spurdata.Indexes{1}{1} = 'Desired signal';
    spurdata.Freq{2} = [];
    spurdata.Pout{2} = [];
    spurdata.Indexes{2}{1} = '';
    zl = z0; zs = z0;
    spurdata = calcemixspur(h, spurdata, zl, zs, z0, 1);
    spurdata.Fin(1) = [];  spurdata.Fin(1) = fin;
    spurdata.Pin(1) = [];  spurdata.Pin(1) = pin;
    spurdata.Indexes{1}{1} = 'Input signal';
    set(data, 'SpurPower', spurdata);
    hlines = plot(data, varargin{2}, k, pin, fin);
else
    hlines = plot(data, varargin{2:end});
end

if nargout == 1
    varargout{1} = hlines;
end