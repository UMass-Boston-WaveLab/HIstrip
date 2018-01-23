function list = listparam(varargin)
%LISTPARAM List the valid parameters for the RFDATA.DATA object.
%   LIST = LISTPARAM(H) lists the valid parameters for plot.
%
%   LIST = LISTPARAM(H, 'BUDGET') lists the valid parameters for budget
%   plot.
%
%   See also RFDATA.DATA, RFDATA.DATA/LISTFORMAT, RFDATA.DATA/PLOT, 
%   RFDATA.DATA/TABLE, RFDATA.DATA/SMITH, RFDATA.DATA/ANALYZE, 
%   RFDATA.DATA/CALCULATE  

%   Copyright 2003-2010 The MathWorks, Inc.

% Get the object
h = varargin{1};

% Set the default
list = {};
nport = getnport(h);

% List the valid parameters 
if (nargin >= 2 ) && strcmpi(varargin{2}, 'budget')
    budgetdata = get(h, 'BudgetData');
    list = {};
    if isa(budgetdata, 'rfdata.data') 
        list(end+1:end+10) = {'S11' 'S12' 'S21' 'S22' 'VSWRIn' 'VSWROut' ...
            'OIP3' 'IIP3' 'NF' 'Gt'};
    else
        error(message('rf:rfdata:data:listparam:EmptyBudgetData'));
    end
else
    % Add the network parameters
    if ~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters'))
        for ii=1:nport
            for jj=1:nport
                if ii >= 10 || jj >= 10
                    parameter = strcat('S', num2str(ii), ',', num2str(jj));
                else
                    parameter = strcat('S', num2str(ii), num2str(jj));
                end
                list(end+1) = {parameter};
            end
        end
        if nport == 2
            list(end+1:end+10) = {'GroupDelay', 'GammaIn' 'GammaOut' 'VSWRIn' 'VSWROut' ...
                'OIP3' 'IIP3' 'NF' 'NFactor', 'NTemp'};
            % Add TF1, TF2 and TF3
            list(end+1:end+3) = {'TF1' 'TF2' 'TF3'};   
            % Add power gain parameters
            list(end+1:end+5) = {'Gt' 'Ga' 'Gp' 'Gmag' 'Gmsg'};     
            % Add GammaMS and GammaML
            list(end+1:end+2) = {'GammaMS' 'GammaML'};
            % Add K and Mu
            list(end+1:end+4) = {'K' 'Delta' 'Mu' 'MuPrime'};
        end
    end

    % Add the noise parameters
    if hasnoisereference(h)
        list(end+1:end+3) = {'Fmin' 'GammaOPT' 'RN'};
    end

    % Add the Pout parameters
    if haspowerreference(h) || hasp2dreference(h)
        list(end+1:end+4) = {'Pout' 'Phase' 'AM/AM' 'AM/PM'};
    end

    % Add the Phase Noise
    if ~isempty(h.FreqOffset) && ~isempty(h.PhaseNoiseLevel)
        list(end+1) = {'PhaseNoise'};
    end

    % Add P2D Parameters
    if hasp2dreference(h)
        list(end+1:end+4) = {'LS11' 'LS12' 'LS21' 'LS22'};
    end
end

% If empty data object, throw error
if isempty(list)
    error(message('rf:rfdata:data:listparam:EmptyData'));
else
    list = list';
end