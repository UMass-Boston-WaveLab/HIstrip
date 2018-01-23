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
%   HLINES = PLOT(H, 'BUDGET', PARAMETER1, ..., PARAMETERN) plots the
%   specified budget parameters PARAMETER1, ..., PARAMETERN of an
%   RFCKT.CASCADE object using the default format. All the parameters must
%   have same default format.
%
%   HLINES = PLOT(H, 'BUDGET', PARAMETER1, ..., PARAMETERN, FORMAT) plots
%   the specified budget parameters PARAMETER1, ..., PARAMETERN of an
%   RFCKT.CASCADE object using the specified FORMAT. FORMAT must be a valid
%   format for all the parameters.
%
%   Type LISTPARAM(H, 'BUDGET') to see the valid budget parameters.
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
%   See also RFCKT.CASCADE, RFCKT.CASCADE/LISTPARAM,
%   RFCKT.CASCADE/LISTFORMAT,RFCKT.CASCADE/TABLE, RFCKT.CASCADE/SMITH,
%   RFCKT.CASCADE/POLAR

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1);

h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:cascade:plot:NotEnoughInput'));
end

% Check the inputs
if strcmpi(varargin{2}, 'budget')
    data = getdata(h);
    ckts = get(h, 'CKTS');
    if length(ckts) <= 1
        error(message('rf:rfckt:cascade:plot:OneCktOnly'));
    end
    budgetdata = get(data, 'BudgetData');
    if ~isa(budgetdata, 'rfdata.data')
        setflagindexes(h);
        % To see if the analysis is needed
        updateflag(h, indexOfTheBudgetAnalysisOn, 1, MaxNumberOfFlags);
        updateflag(h, indexOfNeedToUpdate, 1, MaxNumberOfFlags);
        analyze(h, data.Freq);
    end
    hlines = plot(data, varargin{2:end});
elseif strcmpi(varargin{2}, 'mixerspur')
    if ~isa(h.AnalyzedResult, 'rfdata.data')
        setrfdata(h, rfdata.data);
    end
    data = get(h, 'AnalyzedResult');
    pin = 0; fin = 1e9; k = 'all';
    spurdata = get(data, 'SpurPower');
    if ~isempty(spurdata) && ~isempty(spurdata.Pout{1})
        pin = spurdata.Pout{1}(1);
    end
    if ~isempty(spurdata) && ~isempty(spurdata.Freq{1})
        fin = spurdata.Freq{1}(1);
    end
    ckts = get(h, 'CKTS');
    nckts = length(ckts);
    hasspurtable = false;
    nmixers = 0;
    findfinandz0 = false;
    z0 = 50;
    for ii=1:nckts
        if isa(ckts{ii}, 'rfckt.mixer')
            nmixers = nmixers + 1;
            if isa(ckts{ii}.MixerSpurData, 'rfdata.mixerspur')
                hasspurtable = true;
            end
            if ~findfinandz0 && isa(ckts{ii}.NetworkData, 'rfdata.network')
                [smatrix, freq] = extract(ckts{ii}.NetworkData,         ...
                    'S_Parameters');
                [~, idx] = max(abs(smatrix(2,1,:)));
                if isempty(spurdata) || isempty(spurdata.Freq{1})
                    fin = freq(idx);
                end
                z0 = ckts{ii}.NetworkData.Z0;
                findfinandz0 = true;
            end
        end
    end
    if ~hasspurtable
        error(message('rf:rfckt:cascade:plot:NoMixerSpurData'));
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
        error(message('rf:rfckt:cascade:plot:TooManyInputs'));
    end
    if ~strncmpi(k, 'all', 3) && ( ~isscalar(k) || ~isnumeric(k) ||     ...
            isnan(k) || ~isreal(k) || (k < 0) || isinf(k) || (k > nckts))
        error(message('rf:rfckt:cascade:plot:WrongKInput'));
    end
    if isempty(pin) || ~isscalar(pin) || ~isnumeric(pin) ||             ...
            isnan(pin) || ~isreal(pin) || isinf(pin)
        error(message('rf:rfckt:cascade:plot:WrongPinInput'));
    end
    if isempty(fin) || ~isscalar(fin) || ~isnumeric(fin) ||             ...
            isnan(fin) || ~isreal(fin) || fin < 0 || isinf(fin)
        error(message('rf:rfckt:cascade:plot:WrongfreqInput'));
    end
    if convertfreq(h, fin, false) < 0
        error(message('rf:rfckt:cascade:plot:FinIsTooSmall', fin));
    end
    spurdata = [];
    spurdata.NMixers = 0;
    spurdata.TotalNMixers = nmixers;
    spurdata.Fin(1) = fin;
    spurdata.Pin(1) = pin;
    spurdata.Idxin{1} = 'Desired signal';
    spurdata.Freq{1}(1) = fin;
    spurdata.Pout{1}(1) = pin;
    spurdata.Indexes{1}{1} = 'Desired signal';
    for ii=1:nckts
        spurdata.Freq{ii+1} = [];
        spurdata.Pout{ii+1} = [];
        spurdata.Indexes{ii+1}{1} = '';
    end
    zl = z0; zs = z0;
    spurdata = calcemixspur(h, spurdata, zl, zs, z0, 1);
    spurdata.Fin = []; spurdata.Fin(1) = fin;
    spurdata.Pin = []; spurdata.Pin(1) = pin;
    spurdata.Indexes{1}{1} = 'Input signal';
    set(data, 'SpurPower', spurdata);
    hlines = plot(data, varargin{2}, k, pin, fin);
else
    data = getdata(h);
    hlines = plot(data, varargin{2:end});
end

if nargout == 1
    varargout{1} = hlines;
end