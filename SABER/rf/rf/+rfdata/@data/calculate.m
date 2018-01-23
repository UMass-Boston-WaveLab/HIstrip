function [data, params, xdata] = calculate(varargin)
%CALCULATE Calculate the specified parameters.
%   [DATA,PARAMS,FREQ] = CALCULATE(H, PARAMETER1, ..., PARAMETERN, FORMAT) 
%   calculates the required parameters for the RFDATA.DATA object and
%   returns them in cell array data.
%
%   The first input is the handle to the RFDATA.DATA object, the last input
%   is the FORMAT, and the other inputs (PARAMETER1, ..., PARAMETERN) are
%   the parameters that can be visualized from the data object. 
%
%   Type LISTPARAM(H) to list valid parameters for the RFDATA.DATA object.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified PARAMETER.
%
%   See also RFDATA.DATA, RFDATA.DATA/ANALYZE, RFDATA.DATA/LISTPARAM,
%   RFDATA.DATA/LISTFORMAT

%   Copyright 2003-2010 The MathWorks, Inc.

% Get the object
h = varargin{1};

table = 0; 
if strcmpi(varargin{end}, 'table')
    table = 1;
end

% Extract parameters and formats
[varargin, conditions] = smartprocess(h, varargin{2:end});
% Check compatibility of x and y-parameters
checkxyinput(h, varargin{:});
% Check compatibility of y-formats and y-parameters
checkyinput(h, 2+table*(length(varargin)/2 -1), varargin{:});
% Check compatibility of x-format and x-parameter
checkxinput(h, varargin{:});

% Find out if there is frequency input
[freq_cell, conditions] = processargin(h, conditions, 'Freq');
freq_cell = freq_cell(1);
if ~isempty(freq_cell{1})
    checkfrequency(h, freq_cell{1});
end

% Find out if there is power input
[power_cell, conditions] = processargin(h, conditions, 'Pin');
power_cell = power_cell(1);
if ~isempty(power_cell{1})
    set(h,'Name','Pin')
    setrealvector(h, power_cell{1}, 'Pin', 1, 0, 0, 0);
    power_cell{1} = 0.001*10.^(power_cell{1}/10); % Convert to Watts     
end

checkopcondition(h, conditions{:}); % Check conditions

% Find out if there are operating conditions in the input arguments
selections = [];
if hasmultireference(h)
    multiref = h.Reference;
    varnamevalue_cell = simplifycondition(h, conditions);

    if ~isempty(varnamevalue_cell) % There are conditions to select
        varnamevalue_cell = expandcondition(h, varnamevalue_cell);
        % Find selections of references that
        % match independent variable values
        selections = cell(size(varnamevalue_cell, 1), 1);
        nselections = numel(selections);
        for ii = 1:nselections
            selections{ii} = select(multiref, varnamevalue_cell{ii,:});
        end
    end
end

% Calculate the required data
xparam = varargin{end-1};
% No user-specified frequency is
if isempty(freq_cell) || isempty(freq_cell{1})
    freq_cell{1} = h.Freq;
    if ~strcmpi(xparam, 'Freq')
        temp_freq = [];
        if hasmultireference(h)
            temp_freq = cat(1, getuniquefreq(multiref, 'Power'), ...
                getuniquefreq(multiref, 'P2D'));
        elseif haspowerreference(h)
            temp_freq = get(get(getreference(h), 'PowerData'), 'Freq');
        elseif hasp2dreference(h)
            temp_freq = get(get(getreference(h), 'P2DData'), 'Freq');
        end
        if ~isempty(temp_freq)
            freq_cell{1} = temp_freq;
        end
        if numel(freq_cell{1}) > 3
            freq_cell{1} = [min(freq_cell{1}), median(freq_cell{1}), ...
                max(freq_cell{1})];
        end
    end
end

% If no user-specified pin is given
if isempty(power_cell) || isempty(power_cell{1})
    if hasmultireference(h)
        power_cell{1} = cat(1, getuniquepower(multiref, 'Power'), ...
            getuniquepower(multiref, 'P2D'));
    elseif haspowerreference(h)
        temp = get(get(getreference(h), 'PowerData'), 'Pin');
        power_cell{1} = unique(cat(1, temp{:}));
    elseif hasp2dreference(h)
        temp = get(get(getreference(h), 'P2DData'), 'P1');
        power_cell{1} = unique(cat(1, temp{:}));
    end
    if ~any(strcmpi(xparam, {'Pin', 'AM'})) && numel(power_cell{1}) > 3
        power_cell{1} = [min(power_cell{1}), median(power_cell{1}), ...
            max(power_cell{1})];
    end
end

xformat = varargin{end};
% Replace auto frequency unit with a real unit
if strcmpi(xformat, 'Auto') && strcmpi(xparam, 'Freq')
    xformat = 'Hz';
end
xtype = xcategory(h, xparam);
nport = getnport(h); 
varargin = varargin(1:end-2);
ninputs = numel(varargin);
k1 = 0;
data = cell(1, ninputs/2);
params = cell(1, ninputs/2);
xdata = cell(1, ninputs/2);
for jj = 1:2:ninputs
    % Check the data
    parameter = varargin{jj};
    format = varargin{jj+1};
    ytype = category(h, parameter);

    switch ytype
        case 'Network Parameters'
            % Calculating parameters vs frequency
            if strcmpi(xtype, 'Frequency')
                % Multiple selections of references
                if hasmultireference(h) && ~isempty(selections)
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            temprfdata.Reference.Selection =            ...
                                selections{qq}(ii);         % Set selection
                            temprfdata = analyze(temprfdata,            ...
                                freq_cell{1}, get(h,'ZL'), get(h,'ZS'), ...
                                get(h,'Z0'));
                            [ay, ap, ax] =                              ...
                                netcalculate(temprfdata,                ...
                                temprfdata.S_Parameters, parameter,     ...
                                nport, temprfdata.Z0, temprfdata.ZL,    ...
                                temprfdata.ZS, format); 
                            ax = formatting(h, ax, xformat);
                            ap = appendvars(temprfdata, ap);
                            k1 = k1 + 1;
                            data{k1} = ay(:);
                            params{k1} = ap;
                            xdata{k1} = repmat(ax(:), 1, size(data{k1},2));
                        end
                    end

                else % Only current selection of references
                     % or single reference
                    temprfdata = h;
                    k1 = k1 + 1;     
                    [data{k1}, params{k1}, ax] =                        ...
                        netcalculate(temprfdata,                        ...
                        temprfdata.S_Parameters, parameter,             ...
                        nport, temprfdata.Z0, temprfdata.ZL,            ...
                        temprfdata.ZS, format);            
                    ax = formatting(h, ax, xformat);
                    xdata{k1} = repmat(ax(:), 1, size(data{k1}, 2));
                    params(k1) = appendvars(h, params(k1));
                end

            % Calculating parameters vs operating conditions
            elseif strcmpi(xtype, 'Operating Condition')
                if hasmultireference(h)
                    if isempty(selections)
                        selections = {1:numel(multiref.References)};
                    end
                    myfreq = freq_cell{1};
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        tempy = [];
                        tempx = [];
                        nsection = numel(selections{qq});
                        for ii = 1:nsection
                            % First check if the variable exists in
                            % selections(ii)
                            [pos, val] = hasvar(multiref, xparam,       ...
                                selections{qq}(ii));
                            val = str2double(val);     % Convert to numeric
                            if pos
                                temprfdata.Reference.Selection =        ...
                                    selections{qq}(ii); % Set selection
                                temprfdata = analyze(temprfdata,        ...
                                    myfreq, get(h,'ZL'), get(h,'ZS'),   ...
                                    get(h,'Z0'));
                                [ay, ap] = netcalculate(temprfdata,     ...
                                    temprfdata.S_Parameters, parameter, ...
                                    nport, temprfdata.Z0,               ...
                                    temprfdata.ZL, temprfdata.ZS, format);
                                % Each column corresponds to
                                % one variable value
                                tempy = [tempy, ay(:)];
                                % Each row corresponds to
                                % one frequency value
                                tempx = [tempx, val]; % Row column
                            end
                        end
                        % Sort variable value in ascending order
                        [tempx, idx] = sort(tempx);
                        tempy = tempy(:, idx);
                        numtrace = size(tempy, 1);
                        ap = repmat(ap, numtrace, 1);
                        ap = appendvec(h, ap, myfreq, 'Freq');
                        if ~isequal(selections,                         ...
                                1:numel(multiref.References))
                            % Append more variable values in params
                            ap = appendinput(ap, varnamevalue_cell(qq, :));
                        end
                        k1 = k1 + 1;
                        data{k1} = tempy.';
                        params{k1} = ap;
                        xdata{k1} = repmat(tempx.', 1, size(data{k1}, 2));
                    end
                end
            end

        case 'Noise Parameters'
            % Calculating parameters vs frequency
            if strcmpi(xtype, 'Frequency')
                % Multiple selections of references
                if hasmultireference(h) && ~isempty(selections)
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            temprfdata.Reference.Selection =            ...
                                selections{qq}(ii); % Set selection
                            [ay, ap, ax] = calculatenoise(temprfdata,   ...
                                parameter, format, freq_cell{1});
                            ax = formatting(h, ax, xformat);
                            ap = appendvars(temprfdata, ap);
                            k1 = k1 + 1;
                            data{k1} = ay(:);
                            params{k1} = ap;
                            xdata{k1} = repmat(ax(:), 1, size(data{k1},2));
                        end
                    end

                % Only current selection of references or single reference
                else
                    k1 = k1 + 1;
                    [data{k1}, params{k1}, ax] = ...
                        calculatenoise(h, parameter, format, freq_cell{1});
                    ax = formatting(h, ax, xformat);
                    params(k1) = appendvars(h, params(k1));
                    xdata{k1} = repmat(ax(:), 1, size(data{k1}, 2));
                end

            % Calculating parameters vs independent variable
            elseif strcmpi(xtype, 'Operating Condition')
                if hasmultireference(h)
                    if isempty(selections)
                        selections = {1:numel(multiref.References)};
                    end
                    myfreq = freq_cell{1};
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        tempy = [];
                        tempx = [];
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            % First check if the variable exists in
                            % selections(ii)
                            [pos, val] = hasvar(multiref, xparam,       ...
                                selections{qq}(ii));
                            val = str2double(val); % Convert to numeric
                            if pos
                                temprfdata.Reference.Selection =        ...
                                    selections{qq}(ii); % Set selection
                                [ay, ap] = calculatenoise(temprfdata,   ...
                                    parameter, format, myfreq);
                                % Each column corresponds to
                                % one variable value
                                tempy = [tempy, ay(:)];
                                % Each row corresponds to
                                % one frequency value
                                tempx = [tempx, val]; % Row column
                            end
                        end
                        % Sort variable value in ascending order
                        [tempx, idx] = sort(tempx);
                        tempy = tempy(:, idx);
                        numtrace = size(tempy, 1);
                        ap = repmat(ap, numtrace, 1);
                        ap = appendvec(h, ap, myfreq, 'Freq');
                        if ~isequal(selections,                         ...
                                1:numel(multiref.References))
                            % Append more variable values in params
                            ap = appendinput(ap, varnamevalue_cell(qq, :));
                        end
                        k1 = k1 + 1;
                        data{k1} = tempy.';
                        params{k1} = ap;
                        xdata{k1} = repmat(tempx.', 1, size(data{k1}, 2));
                    end
                end
            end
            
        case 'Phase Noise'
            % Get the phase noise data
            k1 = k1 + 1;
            params{k1} = modifyname(h, parameter, nport);
            params(k1) = appendvars(h, params(k1));
            temp = h.PhaseNoiseLevel;
            data{k1} = formatting(h, temp, 'None');
            xdata{k1} = formatting(h, h.FreqOffset, xformat);
            
        case {'Power Parameters' 'AMAM/AMPM Parameters'}
            if ~strcmpi(xtype, 'Operating Condition')
                % Multiple selections of references
                if hasmultireference(h) && ~isempty(selections)
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            temprfdata.Reference.Selection =            ...
                                selections{qq}(ii); % Set selection
                            [ay, ap, ax] = calculatepower(temprfdata,   ...
                                parameter, format, xparam, xformat,     ...
                                freq_cell, power_cell);
                            ap = appendvars(temprfdata, ap);
                            k1 = k1 + 1;
                            data{k1} = ay;
                            params{k1} = ap;
                            xdata{k1} = repmat(ax(:), 1, size(data{k1},2));
                        end
                    end

                % Only current selection of references or single reference
                else
                    k1 = k1 + 1;
                    [data{k1}, params{k1}, xdata{k1}] =                 ...
                        calculatepower(h, parameter, format, xparam,    ...
                        xformat, freq_cell, power_cell);
                    params{k1} = appendvars(h, params{k1});
                    xdata{k1} = repmat(xdata{k1}, 1, size(data{k1}, 2));
                end
                
            else % Calculating parameters vs independent variable
                if hasmultireference(h) && (haspowerreference(h) ||     ...
                        hasp2dreference(h))
                    if isempty(selections)
                        selections = {1:numel(multiref.References)};
                    end
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        tempmat = [];
                        tempx = [];
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            % First check if the variable exists in
                            % selections(ii)
                            [pos, val] = hasvar(multiref, xparam,       ...
                                selections{qq}(ii));
                            val = str2double(val); % Convert to numeric
                            if pos
                                temprfdata.Reference.Selection =        ...
                                    selections{qq}(ii); % Set selection
                                myref = getreference(temprfdata);
                                if haspowerreference(temprfdata)
                                    powerdata = myref.PowerData;
                                else % Has P2D reference
                                    powerdata =                         ...
                                        convert2power(myref.P2DData);
                                end
                                [mymat, myfreq, mypower] =              ...
                                    interp(powerdata, parameter,        ...
                                    h.IntpType, freq_cell{:}, ...
                                    power_cell{:});
                                % Row -> Power
                                tempmat = cat(3, tempmat, mymat);
                                % Column->Freq, third dimension -> Variable
                                tempx = [tempx, val]; % Vector of variables
                            end
                        end
                        % Sort variable value in ascending order
                        [tempx, idx] = sort(tempx);
                        tempmat = tempmat(:, :, idx);
                        numpower = size(tempmat, 1);
                        numfreq = size(tempmat, 2);
                        numvar = size(tempmat, 3);
                        numtrace = numpower*numfreq;
                        ap = modifyname(h, parameter, 2);
                        ap = repmat({ap}, numtrace, 1);
                        ap = appendmat(h, ap, myfreq, mypower, 'Pin');
                        if ~isequal(selections,                         ...
                                1:numel(multiref.References))
                            % Append more variable values in params
                            ap = appendinput(ap, varnamevalue_cell(qq, :));
                        end
                        tempmat = reshape(shiftdim(tempmat, 2),         ...
                            numvar, numtrace);
                        [tempmat, tempx] = formatpowerparam(h,          ...
                            parameter, tempmat, tempx, format, xformat);
                        k1 = k1 + 1;
                        data{k1} = tempmat;
                        params{k1} = ap;
                        xdata{k1} = repmat(tempx(:), 1, size(data{k1}, 2));
                    end
                end
            end
            
        case {'Large Parameters'}
            if ~strcmpi(xtype, 'Operating Condition')
                % Multiple selections of references
                if hasmultireference(h) && ~isempty(selections)
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            temprfdata.Reference.Selection =            ...
                                selections{qq}(ii); % Set selection
                            [ay, ap, ax] =                              ...
                                calculatelargesparam(temprfdata,        ...
                                parameter, format, xparam, xformat,     ...
                                freq_cell, power_cell);
                            ap = appendvars(temprfdata, ap);
                            k1 = k1 + 1;
                            data{k1} = ay;
                            xdata{k1} = repmat(ax(:), 1, size(data{k1},2));
                            params{k1} = ap;
                        end
                    end

                % Only current selection of references or single reference
                else
                    k1 = k1 + 1;
                    [data{k1}, params{k1}, xdata{k1}] =                 ...
                        calculatelargesparam(h, parameter, format,      ...
                        xparam, xformat, freq_cell, power_cell);
                    params{k1} = appendvars(h, params{k1});
                    xdata{k1} = repmat(xdata{k1}, 1, size(data{k1}, 2));
                end
                
            else % Calculating parameters vs independent variable
                if hasmultireference(h) && hasp2dreference(h)
                    if isempty(selections)
                        selections = {1:numel(multiref.References)};
                    end
                    temprfdata = copy(h);
                    nselections = numel(selections);
                    for qq = 1:nselections
                        tempmat = [];
                        tempx = [];
                        nselection = numel(selections{qq});
                        for ii = 1:nselection
                            % First check if the variable exists in
                            % selections(ii)
                            [pos, val] = hasvar(multiref, xparam,       ...
                                selections{qq}(ii));
                            val = str2double(val); % Convert to numeric
                            if pos
                                temprfdata.Reference.Selection =        ...
                                    selections{qq}(ii); % Set selection
                                myref = getreference(temprfdata);
                                [mymat, myfreq, mypower] =              ...
                                    interp(myref.P2DData, parameter,    ...
                                    h.IntpType, freq_cell{:}, ...
                                    power_cell{:});
                                % Row -> Power
                                tempmat = cat(3, tempmat, mymat);
                                % Column->Freq, third dimension -> Variable
                                tempx = [tempx, val]; % Vector of variables
                            end
                        end
                        tempmat = formatting(h, tempmat, format);
                        % Sort variable value in ascending order
                        [tempx, idx] = sort(tempx);
                        tempmat = tempmat(:, :, idx);
                        numpower = size(tempmat, 1);
                        numfreq = size(tempmat, 2);
                        numvar = size(tempmat, 3);
                        numtrace = numpower*numfreq;
                        ap = modifyname(h, parameter, 2);
                        ap = repmat({ap}, numtrace, 1);
                        ap = appendmat(h, ap, myfreq, mypower, 'Pin');
                        if ~isequal(selections,                         ...
                                1:numel(multiref.References))
                            % Append more variable values in params
                            ap = appendinput(ap, varnamevalue_cell(qq, :));
                        end
                        k1 = k1 + 1;
                        data{k1} = reshape(shiftdim(tempmat, 2),        ...
                            numvar, numtrace);
                        params{k1} = ap;
                        xdata{k1} = repmat(tempx(:), 1, size(data{k1}, 2));
                    end
                end
            end
    end
end
params = cleanstr(params); % Clean up the parameter strings
params = simplifyparamcell(params); % Simplify parameter names
xdata = simplifyydatacell(xdata);
xdata = simplifyxdatacell(xdata); % Simplify xdata
data = simplifyydatacell(data); % Simplify ydata


function [result, param, xdata] = netcalculate(h, netdata, parameter,   ...
    nport, z0, zl, zs, reqformat)
result = [];
param = {};
xdata = [];
if isempty(h.S_Parameters)
    warning(message('rf:rfdata:data:calculate:NoNetworkParameters',     ...
        parameter));
    return
end
% Calculate the data from the network parameters
param =  modifyname(h, parameter, nport);
xdata = h.Freq;
switch upper(parameter)
case 'TF1'
    complexdata = s2tf(netdata, z0, zs, zl);
    result = formatting(h, complexdata, reqformat);
case 'TF2'
    complexdata = s2tf(netdata, z0, zs, zl, 2);
    result = formatting(h, complexdata, reqformat);
case 'TF3'
    complexdata = s2tf(netdata, z0, zs, zl, 3);
    result = formatting(h, complexdata, reqformat);
case 'K'
    realdata = stabilityk(netdata);
    result = formatting(h, realdata, reqformat);
case 'DELTA'
    [~, ~, ~, realdata] = stabilityk(netdata);
    result = formatting(h, realdata, reqformat);
case 'MU'
    realdata = stabilitymu(netdata);
    result = formatting(h, realdata, reqformat);
case 'MUPRIME'
    [~, realdata] = stabilitymu(netdata);
    result = formatting(h, realdata, reqformat);
case 'GROUPDELAY'
    realdata = h.GroupDelay;
    if isempty(realdata)
        realdata = repmat(0.0, numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'GT'
    realdata = powergain(netdata, z0, zs, zl, parameter);
    if any(strcmpi(reqformat, {'dB' 'Magnitude (decibels)'}))
        reqformat = 'DB10';
    end
    result = formatting(h, realdata, reqformat);
case 'GA'
    realdata = powergain(netdata, z0, zs, parameter);
    if any(strcmpi(reqformat, {'dB' 'Magnitude (decibels)'}))
        reqformat = 'DB10';
    end
    result = formatting(h, realdata, reqformat);
case 'GP'
    realdata = powergain(netdata, z0, zl, parameter);
    if any(strcmpi(reqformat, {'dB' 'Magnitude (decibels)'}))
        reqformat = 'DB10';
    end
    result = formatting(h, realdata, reqformat);
case {'GMAG', 'GMSG'}
    realdata = powergain(netdata, parameter);
    if any(strcmpi(reqformat, {'dB' 'Magnitude (decibels)'}))
        reqformat = 'DB10';
    end
    result = formatting(h, realdata, reqformat);
case 'GAMMAMS'
    complexdata = gammams(netdata);
    result = formatting(h, complexdata, reqformat);
case 'GAMMAML'
    complexdata = gammaml(netdata);
    result = formatting(h, complexdata, reqformat);    
case 'GAMMAIN'
    complexdata = gammain(netdata, z0, zl);
    % Format the required data
    result = formatting(h, complexdata, reqformat);
case 'GAMMAOUT'
    complexdata = gammaout(netdata, z0, zs);
    % Format the required data
    result = formatting(h, complexdata, reqformat);
case 'VSWRIN'
    complexdata = gammain(netdata, z0, zl);
    realdata = vswr(complexdata);
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'VSWROUT'
    complexdata = gammaout(netdata, z0, zs);
    realdata = vswr(complexdata);
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'NF'
    realdata = get(h, 'NF');
    if isempty(realdata)
        realdata = zeros(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, 'NONE');
case 'NFACTOR'
    realdata = get(h, 'NF');
    if isempty(realdata)
        realdata = zeros(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, 'DB10LINEAR');
case 'NTEMP'  % 290*(nfactor-1)
    realdata = get(h, 'NF');
    if isempty(realdata)
        realdata = zeros(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, 'DB10LINEAR');
    result = 290*(result-1);
case 'IIP3'
    gt = powergain(netdata, z0, zs, zl, 'Gt');
    realdata = get(h, 'OIP3')./gt;
    if isempty(realdata)
        realdata = Inf(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'OIP3'
    realdata = get(h, 'OIP3');
    if isempty(realdata)
        realdata = Inf(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'IIP2'
    gt = powergain(netdata, z0, zs, zl, 'Gt');
    realdata = get(h, 'OIP2')./gt;
    if isempty(realdata)
        realdata = Inf(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'OIP2'
    realdata = get(h, 'OIP2');
    if isempty(realdata)
        realdata = Inf(numel(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, numel(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
otherwise
    if strncmpi(parameter(1), 'S', 1)
        [index1, index2] = sparamsindexes(h, parameter, nport);
        if 0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
            complexdata = netdata(index1, index2, :);
            complexdata = complexdata(:);
            % Format the required data
            result = formatting(h, complexdata, reqformat);
            return;
        end
    end
    error(message('rf:rfdata:data:calculate:InvalidInputParam',parameter));
end


function result = formatting(h, data, reqformat)
% Format the data

result = [];
% Check the data
if isempty(data)
    return
end
% Update the result according to the required format
if ~iscell(data)
    switch upper(reqformat)
        case {'DB' 'MAGNITUDE (DECIBELS)'}
            temp = abs(data);
            idx = (temp == 0);
            temp(idx) = temp(idx) + eps(temp(idx));
            result = 20.*log10(temp);
        case {'DB10'}
            temp = abs(data);
            idx = (temp == 0);
            temp(idx) = temp(idx) + eps(temp(idx));
            result = 10.*log10(temp);
        case {'DB10LINEAR'}
            result = 10 .^ (data/10);
        case 'REAL'
            result = real(data);
        case {'IMAG' 'IMAGINARY'}
            result = imag(data);
        case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
            result = abs(data);
        case {'ANGLE' 'ANGLE (DEGREES)'}
            result = unwrap(angle(data)) * 180 / pi;
        case 'ANGLE (RADIANS)'
            result = unwrap(angle(data));
        case 'NONE'
            result = data;     
        case 'S'
            result = data;
        case 'MS'
            result = data * 1.e3;
        case 'US'
            result = data * 1.e6;
        case 'NS'
            result = data * 1.e9;
        case 'PS'
            result = data * 1.e12;
        case 'DBM'
            temp = abs(data);
            idx = (temp == 0);
            temp(idx) = temp(idx) + eps(temp(idx));
            result = 10.*log10(temp) + 30;
        case 'DBW'
            temp = abs(data);
            idx = (temp == 0);
            temp(idx) = temp(idx) + eps(temp(idx));
            result = 10.*log10(temp);
        case {'W' 'WATTS'}
            result = abs(data);
        case {'MW'}
            result = 1000 * abs(data);
        case {'HZ', 'KHZ', 'MHZ', 'GHZ', 'THZ', 'AUTO'}
            [~, result] = scalingfrequency(h, data, reqformat);
        otherwise
            result = [];
    end
end


function params = appendvars(h, params)
% APPENDVARS Append independent variable names
% and values to the parameter names.
if ~hasmultireference(h)
    return
end
currentvars = getop(h);
tempstr = strcat(currentvars(:, 1), {'='}, currentvars(:, 2), {';'});
tempstr = strcat(tempstr{:});
params = strcat(params, {'('}, tempstr, {')'});


function param = appendvec(h, param, vec, varname)
%APPENDVEC Append vector values to the parameter names.
switch upper(varname)
    case {'PIN','POUT'}
        [name, data, unit] = scalingpower(h, vec, 'dBm', varname);
    case {'FREQ'}
        [name, data, unit] = scalingfrequency(h, vec);
end
strmat = num2str(data(:));
tempstr = mat2cell(strmat, ones(1, size(strmat, 1)), size(strmat, 2));
tempstr = strtrim(tempstr);
tempstr = strcat(name, {'='}, tempstr, unit, ';');
param = strcat(param, {'('}, tempstr, {')'});


function param = appendmat(h, param, freq, power, ptype)
%APPENDMAT Append matrix values to the parameter names.
[pname, power, punit] = scalingpower(h, power, 'dBm', ptype);
[fname, freq, funit] = scalingfrequency(h, freq);
numpower = numel(power);
nfreq = numel(freq);
for idx_freq = 1:nfreq
    powerstr = num2str(power(:));
    powerstr = strtrim(mat2cell(powerstr, ones(1, size(powerstr, 1)), ...
        size(powerstr, 2)));
    freqstr = num2str(freq(idx_freq));
    param((idx_freq-1)*numpower+1:idx_freq*numpower) = ...
        strcat(param((idx_freq-1)*numpower+1:idx_freq*numpower), ...
        {'('}, pname, {'='}, powerstr, punit, {';'}, ...
        fname, {'='}, freqstr, funit, {';)'});
end


function ap = appendinput(ap, my_cell)
%APPENDINPUT Append input variable values to the parameter names.
my_cell = reshape(my_cell, 2, [])';
append_str = '';
for ii = 1:size(my_cell, 1)
    name = my_cell{ii, 1};
    val = my_cell{ii, 2};
    if isnumeric(val) && ~isempty(val)
        tempstr = strcat(name, '=', num2str(val), ';');
    elseif ischar(val)
        tempstr = strcat(name, '=', val, ';');
    end
    append_str = strcat(append_str, tempstr);
end
ap = strcat(ap, '(', append_str, ')');

function param = cleanstr(param)
%CLEANSTR Remove unnecessary brackets and semicolons from parameter names.
nparam = numel(param);
for ii = 1:nparam
    param{ii} = strrep(param{ii}, ')(', '');
    param{ii} = strrep(param{ii}, ';)', ')');
end


function [ndata, param, freq] = calculatenoise(h, parameter, format, freq)
%FORMATNOISE Format noise parameters.
ndata = [];
if ~hasnoisereference(h)
    warning(message('rf:rfdata:data:calculate:NoNoisedata', parameter));
    return
end
myref = getreference(h);
mynoise = myref.NoiseData;
[ndata, param, freq] = calculate(mynoise, parameter, freq);
if strcmpi(parameter,'FMIN')
    if strcmpi(format,'DB') || strcmpi(format,'MAGNITUDE (DECIBELS)')
        ndata = formatting(h, ndata, 'None');
    else
        ndata = formatting(h, ndata, 'DB10LINEAR');
    end
else
    ndata = formatting(h, ndata, format);
end


function [pdata, param, xdata] = calculatelargesparam(h, parameter,     ...
    format, xparam, xformat, freq_cell, power_cell)
% Get the power-dependent large s-parameters
pdata = [];
param = '';
xdata = [];
if ~hasp2dreference(h)
    warning(message('rf:rfdata:data:calculate:NoLargeSparam', parameter));
    return
end
p2ddata = get(getreference(h), 'P2DData');
% Calculate the required data
[pdata, param, xdata] = calculate(p2ddata, [parameter, '-', xparam], ...
    h.IntpType, freq_cell{:}, power_cell{:});
pdata = formatting(h, pdata, format);
xdata = formatting(h, xdata, xformat);


function [ydata, param, xdata] = calculatepower(h, yparam, yformat,     ...
    xparam, xformat, freq_cell, power_cell)
% Calculate power parameters
ydata = [];
param = '';
xdata = [];
if ~(haspowerreference(h) || hasp2dreference(h))
    return
end
if haspowerreference(h)
    powerdata = get(getreference(h), 'PowerData');
else
    powerdata = convert2power(get(getreference(h), 'P2DData'));
end
% Calculate the required data
[ydata, param, xdata] = calculate(powerdata, [yparam, '-', xparam],     ...
    h.IntpType, freq_cell{:}, power_cell{:});
[ydata, xdata] = formatpowerparam(h, yparam, ydata, xdata, yformat,     ...
    xformat);


function [ydata, xdata] = formatpowerparam(h, parameter, ydata, xdata,  ...
    yformat, xformat)
% Format the power parameters
if strcmpi(parameter, 'Pout') || strcmpi(parameter, 'AM/AM') ||         ...
        strcmpi(parameter, 'AM')
    ydata = formatting(h, ydata, yformat);
    xdata = formatting(h, xdata, xformat);
elseif strcmpi(parameter, 'Phase') || strcmpi(parameter, 'AM/PM') ||    ...
        strcmpi(parameter, 'PM')
    ydata = formattingphase(ydata, yformat);
    xdata = formatting(h, xdata, xformat);
end


function data = formattingphase(data, reqformat)
% Format the phase data
% The input data must be in degrees
switch upper(reqformat)
    case {'ANGLE' 'ANGLE (DEGREES)'}

    case 'ANGLE (RADIANS)'
        data = unwrap(data*pi/180);
end


function param = simplifyparamcell(param)
% Simplify parameter name cell
if ~iscell(param)
    return
end
temp_param = {};
nparam = numel(param);
for ii = 1:nparam
    if iscell(param{ii})
        temp_param = {temp_param{:}, param{ii}{:}};
    else
        temp_param = {temp_param{:}, param{ii}};
    end
end
param = temp_param;


function xdata = simplifyxdatacell(xdata)
% Simplify xdata cell
if ~iscell(xdata)
    return
end
make_change = true;
nxdata = numel(xdata);
for ii = 1:nxdata-1
    if ~isequal(xdata{ii}, xdata{ii+1})
        make_change = false;
        break
    end
end
if make_change % All xdata are the same
    xdata = xdata{1};
end


function ydata = simplifyydatacell(ydata)
% Simplify ydata cell
if ~iscell(ydata)
    return
end
temp_ydata = {};
nydata = numel(ydata);
for ii = 1:nydata
    [row, col] = size(ydata{ii});
    temp = mat2cell(ydata{ii}, row, ones(1, col));
    temp_ydata = {temp_ydata{:}, temp{:}};
end
ydata = temp_ydata;


function checkopcondition(h, varargin)
%CHECKOPCONDITION Check if operating conditions.

if numel(varargin) == 0
    return
end

if mod(numel(varargin), 2) ~= 0
    error(message('rf:rfdata:data:calculate:OddNumberOfInput'));
end

% Reshape input into two rows, first row contains condition names an second
% row contains condition values.
inputvars = reshape(varargin, 2, []);
cnames = inputvars(1, :); % Condition names
cvalues = inputvars(2, :); % Condition values

ncnames = numel(cnames);
for ii = 1:ncnames
    if ~ischar(cnames{ii})
        error(message('rf:rfdata:data:calculate:ConditionNotChar'));
    end
end

paramslist = listparam(h);
formatslist = listformat(h);
xparamslist = listxparam(h);
xformatslist = listxformat(h);
if ~hasmultireference(h)
    if ischar(cvalues{1}) && any(strcmpi(cnames{1}, paramslist))
        error(message('rf:rfdata:data:calculate:InvalidFormat',         ...
            cvalues{ 1 }, cnames{ 1 }));
    elseif ischar(cvalues{1}) && ~any(strcmpi(cvalues{1}, paramslist))  ...
            && ~any(strcmpi(cvalues{1}, xparamslist)) &&                ...
            ~any(strcmpi(cvalues{1}, formatslist)) &&                   ...
            ~any(strcmpi(cvalues{1}, xformatslist))
        error(message('rf:rfdata:data:calculate:InvalidParamOrFormat',  ...
            cvalues{ 1 }));
    elseif ~any(strcmpi(cnames{1}, {'Freq', 'Pin'}))
        error(message('rf:rfdata:data:calculate:NotMultiRef', cnames{1}));
    else
        return
    end
end

allconditions = getvarnames(h.Reference);
allconditions = {allconditions{:}, 'Freq', 'Pin'};
for ii = 1:ncnames
    if ~any(strcmpi(allconditions, cnames{ii}))
        if ischar(cvalues{ii}) && any(strcmpi(cvalues{ii}, paramslist)) 
            error(message('rf:rfdata:data:calculate:InvalidFormatOP',   ...
                cvalues{ ii }, cnames{ ii }));
          elseif ischar(cvalues{ii}) &&                                 ...
                  ~any(strcmpi(cvalues{ii}, paramslist)) &&             ...
                  ~any(strcmpi(cvalues{ii}, xparamslist)) &&            ...
                  ~any(strcmpi(cvalues{ii}, formatslist)) &&            ...
                  ~any(strcmpi(cvalues{ii}, xformatslist))
            error(message('rf:rfdata:data:calculate:InvalidInputOP',    ...
                cvalues{ ii }));
        else
            error(message('rf:rfdata:data:calculate:ConditionNotValid', ...
                cnames{ ii }));
        end
    end
end


function checkxinput(h, varargin)
%CHECKXINPUT Check if x-axis parameters and formats are compatible.

xparam = varargin{end-1}; % X-axis parameter
xformat = varargin{end}; % X-axis format

if ~any(strcmpi(xparam, listxparam(h)))
    error(message('rf:rfdata:data:calculate:InvalidXParam', xparam))
end

allformat = [listxformat(h, xparam); 'None'];
if ~any(strcmpi(xformat, allformat))
    error(message('rf:rfdata:data:calculate:InvalidXFormat',            ...
        xformat, xparam))
end


function checkxyinput(h, varargin)
%CHECKXYINPUT Check if x-axis and y-axis parameters are compatible.

% Reshape input into two rows, first row contains parameters and second row
% contains formats.
inputvars = reshape(varargin, 2, []);
inputparams = inputvars(1, :); % First row
xparam = inputparams{end}; % X-axis parameter
xtype = xcategory(h, xparam); % X-axis category
ytype = cell(size(inputparams));
ninputparams = numel(inputparams);
for ii = 1:ninputparams - 1
    ytype{ii} = category(h, inputparams{ii});
end

if strcmpi(xtype, 'Input Power') % X-axis parameter is power
    for ii = 1:ninputparams - 1
        if strcmpi(ytype{ii}, 'Noise Parameters') || ...
                strcmpi(ytype{ii}, 'Network Parameters') || ...
                strcmpi(ytype{ii}, 'Phase Noise')
            error(message(['rf:rfdata:data:calculate:'                  ...
                'NotDependOnInputPower'], inputparams{ ii }, xparam))
        end
    end
end

if strcmpi(xtype, 'AM') % X-axis parameter is AM
    for ii = 1:ninputparams - 1
        if ~strcmpi(ytype{ii}, 'AMAM/AMPM Parameters')
            error(message('rf:rfdata:data:calculate:NotDependOnAM',     ...
                inputparams{ ii }, xparam))
        end
    end
end

for ii = 1:ninputparams - 1
    if strcmpi(ytype{ii}, 'AMAM/AMPM Parameters')
        if ~strcmpi(xtype, 'AM')
            error(message(['rf:rfdata:data:calculate:'                  ...
                'NoXParamNeededForAM'], inputparams{ ii }))
        end
    end
end