classdef modulator < rf.internal.rfbudget.RFElement
%MODULATOR Create a modulator object.
%   OBJ = MODULATOR creates a modulator object with default property
%   values.  A modulator is a 2-port RF circuit object that can be included
%   in the elements vector of an rfbudget object.  A modulator can also be
%   added to a circuit object.
%
%   OBJ = MODULATOR(Name,Value) specifies modulator properties with one or
%   more Name, Value pair arguments.
%
%PROPERTIES:
%   Name - The name of the object, specified as a nonempty character vector
%   (Default = 'Modulator').  All names must be valid MATLAB variable
%   names.
%
%   Gain - The available power gain, specified as a real finite scalar in
%   dB (Default = 0). 
%
%   NF - The noise figure, specified as a real finite non-negative scalar
%   in dB (Default = 0).
%
%   OIP3 - The third-order output-referred intercept point, specified as a
%   real nonnan scalar in dBm (Default = Inf).
%
%   LO - The frequency of the local oscillator, specified as a real finite
%   positive scalar in Hz (Default = 1e9).
%
%   ConverterType - The conversion direction, specified as the character
%   vector 'Up' or 'Down' (Default = 'Up').
%
%   Zin - The input impedance, specified as a positive-real-part finite
%   scalar in Ohm (Default = 50).  A complex value is allowed, but must
%   have positive real part.
%
%   Zout - The output impedance, specified as a positive-real-part finite
%   scalar in Ohm (Default = 50).  A complex value is allowed, but must
%   have positive real part.
%
%EXAMPLE:
%    % Create a downconverter modulator with LO = 100 MHz.
%    m = modulator('ConverterType','Down','LO',100e6)
%
% See also rfbudget, amplifier, rfelement, circuit, nport, rfBudgetAnalyzer

properties (SetObservable)
        LO
        ConverterType
    end
    
    properties (Access = private, Constant)
        DefaultLO = 1e9
        DefaultConverterType = 'Up'
    end
    
    methods (Access = protected, Hidden)
        function p = makeInputParser(obj)
            p = makeInputParser@rf.internal.rfbudget.RFElement(obj);
            % Choose the same defaults as rfckt.mixer
            addParameter(p,'LO',obj.DefaultLO);
            addParameter(p,'ConverterType',obj.DefaultConverterType);
        end
        
        function setParsedProperties(obj,p)
            setParsedProperties@rf.internal.rfbudget.RFElement(obj,p);
            obj.LO = p.Results.LO;
            obj.ConverterType = p.Results.ConverterType;
        end
    end
    
    methods
        function obj = modulator(varargin)
            narginchk(0,20)
            p = makeInputParser(obj);
            parse(p,varargin{:});
            setParsedProperties(obj,p);
        end
        
        function set.LO(obj,value)
            validateattributes(value,{'numeric'}, ...
                {'nonempty','scalar','real','finite','positive'}, ...
                '','LO')
            obj.LO = value;
        end
        
        function set.ConverterType(obj,value)
            if ~ischar(value) || ~isempty(value)
                validateattributes(value,{'char'},{'row'},'','ConverterType')
            else
                validatestring(value,{'Down','Up'});
            end
            obj.ConverterType = value;
        end
    end
    
    methods (Access = protected)
        function op = objectProperties(obj)
            op = objectProperties@rf.internal.rfbudget.RFElement(obj);
            if obj.LO ~= obj.DefaultLO
                [y,e] = engunits(obj.LO);
                val = sprintf('%.15g',y);
                if e ~= 1
                    val = sprintf('%se%d',val,round(log10(1/e)));
                end
                op{end+1,1} = 'LO';
                op{end,2} = val;
            end
            if ~strcmp(obj.ConverterType,obj.DefaultConverterType)
                op{end+1,1} = 'ConverterType';
                op{end,2} = sprintf('''%s''',obj.ConverterType);
            end
        end
    end
    
    % Abstract from rf.internal.rfbudget.Element
    
    methods (Access = protected)
        function h = rbBlock(obj,sys,x,y,rconn,freq)
            src = 'rfBudgetAnalyzer_lib/Modulator';
            h = add_block(obj,src,sys,x,y);
            freqNegative = (freq < 0);
            freq = abs(freq);
            ConvType = obj.ConverterType;
            % If the input frequency is negative, than the convertor type
            % is opposite in RF Blockset, where the frequencies are positive.
            if freqNegative
                if strcmpi(ConvType,'Down')
                    ConvType = 'Up';
                else
                    ConvType = 'Down';
                end
            end
            b = sprintf('%s/%s',get(h,'Path'),get(h,'Name'));
            set_param(b,'ConverterType',ConvType);            
            switch ConvType
                case 'Down'
                    RF = freq;
                    LOfreq = obj.LO;
                    IM = abs(RF - 2*LOfreq);
                    RFoutU = RF + LOfreq;
                    RFoutL = abs(RF - LOfreq); % RFoutL is the IF
                    if LOfreq < RF
                        [freq,e,freq_prefix] = ...
                            engunits([IM RF-1 RF RFoutL RFoutL+1 RFoutU]);
                        sparamIR = 'cat(3,Sstop,Sstop,Spass) % HighPass';
                    elseif RF < LOfreq
                        [freq,e,freq_prefix] = ...
                            engunits([RF RF+1 IM RFoutL RFoutL+1 RFoutU]);
                        sparamIR = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                    else % RF == LOfreq (IQ demodulation)
                        % Since we're now using IQ demodulators, this is
                        % never reached.
                        [freq,e,freq_prefix] = ...
                            engunits([1e9 1.5e9 2e9 1e9 1.5e9 2e9]);
                        sparamIR = 'cat(3,Spass,Spass,Spass)';
                    end
                    sparamCS = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                case 'Up'
                    IF = freq;
                    LOfreq = obj.LO;
                    IM = IF + 2*LOfreq;
                    RFoutU = IF + LOfreq;
                    RFoutL = abs(IF - LOfreq);                    
                    [freq,e,freq_prefix] = ...
                        engunits([IF IF+1 IM RFoutL RFoutU-1 RFoutU]);
                    sparamIR = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                    sparamCS = 'cat(3,Sstop,Sstop,Spass) % HighPass';
            end
            if e < 1e-9 % g1426787 limit to GHz
                freq = (1e-9/e)*freq;
                freq_prefix = 'G';
            elseif e > 1
                freq = (1/e)*freq;
                freq_prefix = '';
            end
            [LOfreq,e,LOfreq_prefix] = engunits(obj.LO);
            if e < 1e-9 % g1426787 limit to GHz
                LOfreq = (1e-9/e)*LOfreq;
                LOfreq_prefix = 'G';
            elseif e > 1
                LOfreq = (1/e)*LOfreq;
                LOfreq_prefix = '';
            end            
            % Stopping a channel using an Sparam block of: [1 0; 0 1] may
            % cause some nodes to be considered by the solver as floating,
            % to avoid that we use pi circuit representation with
            % y11=y22=0, y12=-1/(K*Z0), with large K and Z0 assumed 50 Ohm.
            % This translates to: S11=S22=K/(K+2), S12 = 2/(K+2)
            RF_Const = simrfV2_constants();
            K = sprintf('%.15g',1/value(RF_Const.GMIN,'1/Ohm')/50);
            b = sprintf('%s/%s',get(h,'Path'),get(h,'Name'));
            set_param(b, ...
                'Zin',sprintf('%.15g',obj.Zin), ...
                'Zout',sprintf('%.15g',obj.Zout), ...
                'linear_gain',sprintf('%.15g',obj.Gain), ...
                'NF',sprintf('%.15g',obj.NF), ...
                'IP3',sprintf('%.15g',obj.OIP3), ...
                'LOFreq',sprintf('%.15g',LOfreq), ...
                'LOFreq_unit',sprintf('%sHz',LOfreq_prefix),...
                'Sstop',['[' K '/(' K '+2) 2/(' K '+2);' ...
                         '2/(' K '+2) ' K '/(' K '+2)]'], ...
                'Spass','[0 1; 1 0]', ...
                'SparamIR',sparamIR, ...
                'SparamFreqIR',sprintf('[%.15g %.15g %.15g]', ...
                freq(1), freq(2), freq(3)), ...
                'SparamFreqIR_unit',sprintf('%sHz',freq_prefix), ...
                'SparamCS',sparamCS, ...
                'SparamFreqCS',sprintf('[%.15g %.15g %.15g]', ...
                freq(4), freq(5), freq(6)), ...
                'SparamFreqCS_unit',sprintf('%sHz',freq_prefix));
                        
            ph = get(h,'PortHandles');
            add_line(sys,rconn,ph.LConn(1),'autorouting','on')
            set(h,'SetFilters','on');
        end
    end
    
    methods (Hidden)
        function [x,rconnOut] = rbBlocks(obj,sys,x,y,dx,dy,rconn,freq, ...
                b,i,freqdelta)
            % If input frequency FREQ is 0 use an IQ Modulator to move away
            % from 0 even if it was a DownConverter
            if freq == 0
                % IQ Modulator
                src = 'rfBudgetAnalyzer_lib/IQ Modulator';
                p = get_param(src,'Position');
                pos = obj.newPos(p,x,y);
                h = add_block(src,[sys '/' obj.Name], ...
                    'MakeNameUnique','on', ...
                    'BackgroundColor','lightBlue', ...
                    'Position',pos);
                % Subtracting freqdelta keeps the output freq the same.
                LOfreq = obj.LO - freqdelta;
                [lo,e,lo_prefix] = engunits(LOfreq);
                if e < 1e-9 % g1426787 limit to GHz
                    lo = (1e-9/e)*lo;
                    lo_prefix = 'G';
                elseif e > 1
                    lo = (1/e)*lo;
                    lo_prefix = '';
                end
                Nout = b.OutputPower(i) - b.SNR(i); % dB
                Nin0 = 10*log10(b.kT*b.SignalBandwidth)+30;
                if i > 1
                    % Since the noise added by the modulator doesn't
                    % propogate back to the preceding elements of the
                    % chain:
                    % SNR_into_mod = SNR_out_of_mod + ...
                    %                (NF_total - NF_up_to_mod)
                    % which means:
                    % Noise_into_mod = Noise_out_of_mod  + ...
                    %                  (P_into_mod - P_out_of_mod) - ...
                    %                  (NF_total - NF_up_to_mod)
                    % Note that (P_into_mod - P_out_of_mod) is the total
                    % gain of the added modulator, including impedance
                    % mismatch:
                    Gtot = (b.TransducerGain(i)-b.TransducerGain(i-1));
                    Nin = Nout - Gtot - (b.NF(i)-b.NF(i-1));
                else
                    Gtot = b.TransducerGain(1);
                    Nin = Nin0;
                end
                % For noise calculations, power is added in the combiner,
                % and with the voltage division at the matched output, 
                % the overall is half the power in.
                Gtot = Gtot - 10*log10(2);
                noiseFloor = 10*log10(10^(Nout/10) - ...
                    (10^((Nin + Gtot)/10) - 10^((Nin0 + Gtot)/10))) - ...
                    10*log10(b.SignalBandwidth);
                % noiseFloor must be rounded up when exporting to RF
                % Blockset, to avoid edge cases when noisefloor is
                % slightly below -174dBm/Hz + G -3dB
                noiseFloor_exp = floor(log10(abs(noiseFloor)));
                noiseFloor_mantisa = noiseFloor * 10^(-noiseFloor_exp);
                noiseFloorStr = sprintf('%.15g', ...
                    (ceil(noiseFloor_mantisa*1e15)*1e-15) * ...
                    10^(noiseFloor_exp));
                if (freqdelta == 0)
                    set(h,'IRFiltersOnInit','on','CSFilterOnInit','off');
                    IF = freqdelta;
                    IM = IF + 2*LOfreq;
                    [filterFreq,e,filterFreq_prefix] = ...
                        engunits([IF IF+1 IM 1e9 1.5e9 2e9]);
                    sparamIR = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                    sparamCS = 'cat(3,Spass,Spass,Spass)';
                else
                    set(h,'IRFiltersOnInit','on','CSFilterOnInit','on');
                    IF = freqdelta;
                    IM = IF + 2*LOfreq;
                    RFoutU = IF + LOfreq;
                    RFoutL = abs(IF - LOfreq);                    
                    [filterFreq,e,filterFreq_prefix] = ...
                        engunits([IF IF+1 IM RFoutL RFoutU-1 RFoutU]);
                    sparamIR = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                    sparamCS = 'cat(3,Sstop,Sstop,Spass) % HighPass';
                end
                if e < 1e-9 % g1426787 limit to GHz
                    filterFreq = (1e-9/e)*filterFreq;
                    filterFreq_prefix = 'G';
                elseif e > 1
                    filterFreq = (1/e)*filterFreq;
                    filterFreq_prefix = '';
                end
                RF_Const = simrfV2_constants();
                K = sprintf('%.15g',1/value(RF_Const.GMIN,'1/Ohm')/50);
                set(h, ...
                    'Zin',sprintf('%.15g',obj.Zin), ...
                    'Zout',sprintf('%.15g',obj.Zout), ...
                    'linear_gain',sprintf('%.15g',obj.Gain), ...
                    'NFloor',noiseFloorStr, ...
                    'IP3',sprintf('%.15g',obj.OIP3), ...
                    'LOFreq',sprintf('%.15g',lo), ...
                    'LOFreq_unit',[lo_prefix 'Hz'], ...
                    'Sstop',['[' K '/(' K '+2) 2/(' K '+2);' ...
                    '2/(' K '+2) ' K '/(' K '+2)]'], ...
                    'Spass','[0 1; 1 0]', ...
                    'SparamIR',sparamIR, ...
                    'SparamFreqIR',sprintf('[%.15g %.15g %.15g]', ...
                    filterFreq(1), filterFreq(2), filterFreq(3)), ...
                    'SparamFreqIR_unit', ...
                    sprintf('%sHz',filterFreq_prefix), ...
                    'SparamCS',sparamCS, ...
                    'SparamFreqCS',sprintf('[%.15g %.15g %.15g]', ...
                    filterFreq(4), filterFreq(5), filterFreq(6)), ...
                    'SparamFreqCS_unit',sprintf('%sHz',filterFreq_prefix));
                set(h,'SetFilters','on');
                ph = get(h,'PortHandles');
                add_line(sys,rconn(1),ph.LConn(1),'autorouting','on')
                add_line(sys,rconn(2),ph.LConn(2),'autorouting','on')
                rconnOut = ph.RConn(1);
                pos = get(h,'Position');
                x = pos(3) + dx;
            elseif b.OutputFrequency(i) == 0
                % IQ Demodulator
                src = 'rfBudgetAnalyzer_lib/IQ Demodulator';
                p = get_param(src,'Position');
                pos = obj.newPos(p,x,y);
                h = add_block(src,[sys '/' obj.Name], ...
                    'MakeNameUnique','on', ...
                    'BackgroundColor','lightBlue', ...
                    'Position',pos);
                % Subtracting freqdelta keeps the output above zero.
                LOfreq = obj.LO - freqdelta;
                [lo,e,lo_prefix] = engunits(LOfreq);
                if e < 1e-9 % g1426787 limit to GHz
                    lo = (1e-9/e)*lo;
                    lo_prefix = 'G';
                elseif e > 1
                    lo = (1/e)*lo;
                    lo_prefix = '';
                end
                RF = freq;
                IM = abs(RF - 2*LOfreq);
                RFoutU = RF + LOfreq;
                RFoutL = abs(RF - LOfreq); % RFoutL is the IF, here = 0
                if (freqdelta == 0)
                    set(h,'IRFilterOnInit','off','CSFiltersOnInit','on');
                    [filterFreq,e,filterFreq_prefix] = ...
                        engunits([1e9 1.5e9 2e9 RFoutL RFoutL+1 RFoutU]);
                    sparamIR = 'cat(3,Spass,Spass,Spass)';
                    sparamCS = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                else
                    set(h,'IRFilterOnInit','on','CSFiltersOnInit','on');
                    % For IQ demodulator LO is equal to RF to get IF = 0,
                    % but since in the testbench we are going to IF = BW,
                    % LOfreq is always smaller than RF:
                    [filterFreq,e,filterFreq_prefix] = ...
                        engunits([IM RF-1 RF RFoutL RFoutL+1 RFoutU]);
                    sparamIR = 'cat(3,Sstop,Sstop,Spass) % HighPass';
                    sparamCS = 'cat(3,Spass,Sstop,Sstop) % LowPass';
                end
                if e < 1e-9 % g1426787 limit to GHz
                    filterFreq = (1e-9/e)*filterFreq;
                    filterFreq_prefix = 'G';
                elseif e > 1
                    filterFreq = (1/e)*filterFreq;
                    filterFreq_prefix = '';
                end
                RF_Const = simrfV2_constants();
                K = sprintf('%.15g',1/value(RF_Const.GMIN,'1/Ohm')/50);
                set(h, ...
                    'Zin',sprintf('%.15g',obj.Zin), ...
                    'Zout',sprintf('%.15g',obj.Zout), ...
                    'linear_gain',sprintf('%.15g',obj.Gain), ...
                    'NF',sprintf('%.15g',obj.NF), ...
                    'IP3',sprintf('%.15g',obj.OIP3), ...
                    'LOFreq',sprintf('%.15g',lo), ...
                    'LOFreq_unit',[lo_prefix 'Hz'], ...
                    'Sstop',['[' K '/(' K '+2) 2/(' K '+2);' ...
                    '2/(' K '+2) ' K '/(' K '+2)]'], ...
                    'Spass','[0 1; 1 0]', ...
                    'SparamIR',sparamIR, ...
                    'SparamFreqIR',sprintf('[%.15g %.15g %.15g]', ...
                    filterFreq(1), filterFreq(2), filterFreq(3)), ...
                    'SparamFreqIR_unit', ...
                    sprintf('%sHz',filterFreq_prefix), ...
                    'SparamCS',sparamCS, ...
                    'SparamFreqCS',sprintf('[%.15g %.15g %.15g]', ...
                    filterFreq(4), filterFreq(5), filterFreq(6)), ...
                    'SparamFreqCS_unit',sprintf('%sHz',filterFreq_prefix));
                set(h,'SetFilters','on');
                ph = get(h,'PortHandles');
                add_line(sys,rconn(1),ph.LConn(1),'autorouting','on')
                rconnOut(1) = ph.RConn(1);
                rconnOut(2) = ph.RConn(2);
                pos = get(h,'Position');
                x = pos(3) + dx;
            else % RF to RF
                [x,rconnOut] = ...
                    rbBlocks@rf.internal.rfbudget.Element(obj,sys,x,y, ...
                    dx,dy,rconn,freq);
            end
        end
    end
    
    % Abstract from rf.internal.circuit.Element
    
    properties (Constant, Access = protected)
        HeaderDescription = 'Modulator'
        DefaultName = 'Modulator'
    end
    
    methods(Hidden, Access = protected)
        function plist1 = getLocalPropertyList(obj)
            plist1.Name = obj.Name;
            plist1.Gain = obj.Gain;
            plist1.NF = obj.NF;
            plist1.OIP3 = obj.OIP3;
            plist1.LO = obj.LO;
            plist1.ConverterType = obj.ConverterType;
            plist1.Zin = obj.Zin;
            plist1.Zout = obj.Zout;
        end
        
        function out = localClone(in)
            out = modulator( ...
                'LO',in.LO, ...
                'ConverterType',in.ConverterType);
            copyProperties(in,out)
        end
    end
end
