classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        mixer < rfckt.amplifier
%rfckt.mixer class
%   rfckt.mixer extends rfckt.amplifier.
%
%    rfckt.mixer properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%       NetworkData - Property is of type 'handle' 
%       NoiseData - Property is of type 'MATLAB array' 
%       NonlinearData - Property is of type 'MATLAB array' 
%       MixerSpurData - Property is of type 'handle' 
%       MixerType - Property is of type 'MixerTypeDATATYPE enumeration:
%                   {'Downconverter','Upconverter'}' 
%       FLO - Property is of type 'MATLAB array' 
%       FreqOffset - Property is of type 'MATLAB array' 
%       PhaseNoiseLevel - Property is of type 'MATLAB array' 
%
%    rfckt.mixer methods:
%       addmixspur - Add mixer spurs.
%       checkproperty - Check the properties of the object.
%       convertfreq - Convert the input frequency to get the output
%                     frequency.
%       plot - Plot the parameters on an X-Y plane.
%       read - Read mixer data from a Touchstone or .AMP data file.
%       refinedeltafreq - Refine the delta frequencies.


    properties
        %MIXERSPURDATA Property is of type 'handle' 
        MixerSpurData = [  ];
    end
    methods 
        function value = get.MixerSpurData(obj)
            value = getmixerspur(obj);
        end
        function set.MixerSpurData(obj,value)
            % DataType = 'handle'
            obj.MixerSpurData = setmixerspur(obj,value,'MixerSpurData');
        end
    end   % set and get functions for MixerSpurData

    properties
        % MIXERTYPE Property is of type 'MixerTypeDATATYPE enumeration:
        % {'Downconverter','Upconverter'}' 
        MixerType = 'Downconverter';
    end
    methods 
        function set.MixerType(obj,value)
            enum_list = {'Downconverter','Upconverter'};
            obj.MixerType = checkenum(obj, 'MixerType', value, enum_list);
         end
    end   % set function for MixerType
 
    properties
        %FLO Property is of type 'MATLAB array' 
        FLO = 1e9;
    end
    methods 
        function set.FLO(obj,value)
            if ~isequal(obj.FLO,value)
                % DataType = 'MATLAB array'
                obj.FLO = setpositive(obj,value,'FLO',true,false,false);
            end
        end
    end   % set and get functions for FLO

    properties
        %FREQOFFSET Property is of type 'MATLAB array' 
        FreqOffset = [  ];
    end
    methods 
        function set.FreqOffset(obj,value)
            if ~isequal(obj.FreqOffset,value)
                % DataType = 'MATLAB array'
                obj.FreqOffset = setfreqoffset(obj,value,'FreqOffset');
            end
        end
    end   % set and get functions for FreqOffset

    properties
        %PHASENOISELEVEL Property is of type 'MATLAB array' 
        PhaseNoiseLevel = [  ];
    end
    methods 
        function set.PhaseNoiseLevel(obj,value)
            if ~isequal(obj.PhaseNoiseLevel,value)
                % DataType = 'MATLAB array'
                obj.PhaseNoiseLevel = setphasenoise(obj,value,          ...
                    'PhaseNoiseLevel');
            end
        end
    end   % set and get functions for PhaseNoiseLevel


    methods  % constructor block
        function h = mixer(varargin)
        %MIXER Constructor.
        %   H = RFCKT.MIXER('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns an RFCKT object H representing a mixer and local
        %   oscillator (LO, the LO frequency is FLO) with two-ports
        %   (RF and IF), based on the properties specified by the input
        %   arguments in the PROPERTY/VALUE pairs. Any properties you do
        %   not specify retain their default values, which can be viewed by
        %   typing 'h = rfckt.mixer'. 
        %
        %   A mixer object has the following properties. All the properties
        %   are writable except for the ones explicitly noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name            - Object name. (read only)
        %   nPort           - Number of ports. (read only)
        %   AnalyzedResult  - Analyzed result. It is generated during
        %                     analysis (read only)
        %   IntpType        - Interpolation method. The choices are:
        %                     'Linear', 'Cubic' or 'Spline' 
        %   NetworkData     - RFDATA.NETWORK object for
        %                     frequency-dependent network parameters
        %   NoiseData       - Noise parameters. The choices are:
        %                     Scalar              - for NF in dB
        %                     RFDATA.NF object    - for frequency-dependent
        %                                           NF
        %                     RFDATA.NOISE object - for frequency-dependent
        %                                           spot noise
        %   NonlinearData   - Nonlinear parameters. The choices are:
        %                     Scalar              - for OIP3 in dBm
        %                     RFDATA.IP3 object   - for frequency-dependent
        %                                           IP3
        %                     RFDATA.POWER object - for Pin/Pout data
        %   MixerSpurData   - RFDATA.MIXERSPUR object
        %   MixerType       - Type of mixer. The choices are:
        %                     'Downconverter' or 'Upconverter'                      
        %   FLO             - Local oscillator frequency (Hz)
        %   FreqOffset      - Phase noise frequency offset (Hz)
        %   PhaseNoiseLevel - Phase noise level (dBc/Hz)
        %
        %
        %   RFDATA.NETWORK, RFDATA.NF, RFDATA.NOISE, RFDATA.IP3,
        %   RFDATA.POWER and MixerSpurData are RFDATA objects; for details,
        %   type 'help rfdata'.
        %
        %   The default NetworkData and NoiseData are taken from the
        %   'default.s2p' data file. 
        %
        %   rfckt.mixer methods:
        %
        %     Analysis
        %       analyze    - Analyze an RFCKT object in frequency domain
        %
        %     Plots and Charts   
        %       circle     - Draw circles on a Smith chart
        %       loglog     - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scales for both the
        %                    X- and Y- axes
        %       plot       - Plot the specified parameters on the X-Y plane
        %       plotyy     - Plot the specified parameters on the X-Y plane
        %                    with y tick labels on the left and right
        %       polar      - Plot the specified parameters on a
        %                    polar plane chart
        %       semilogx   - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scale for the X-axis
        %       semilogy   - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scale for the Y-axis
        %       smith      - Plot the specified parameters on a Smith chart
        %       table      - Display the specified parameters in a table
        %
        %     Parameters and Formats   
        %       listformat - List the valid formats for a parameter
        %       listparam  - List the valid parameters that can be
        %                    visualized
        %
        %     Operating Conditions   
        %       getop      - Get the operating conditions
        %       setop      - Set the operating conditions
        %
        %     Data I/O   
        %       read       - Read RF data in SNP/YNP/ZNP/AMP formats
        %       write      - Write AnalyzedResult formats SNP/YNP/ZNP/AMP
        %
        %     Data Access and Restoration  
        %       calculate  - Calculate the specified parameters
        %       extract    - Extract the specified network parameters  
        %       restore    - Restore the data to the original frequencies
        %                    for plot
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.mixer/<METHOD>', where METHOD is one of the methods
        %   listed above. For instance, 'help rfckt.mixer/plot'.
        %
        %   Example:
        %
        %      % Create a mixer object
        %        h = rfckt.mixer
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21')      
        %      % Visualize the original data in 'default.s2p' data file
        %        figure(1)
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %      % Do frequency domain analysis at the given frequency
        %        f = 1.9e9:1e7:2.5e9;          % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % Visualize the analyzed results
        %        figure(3)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(4)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %      % Restore the data to the original frequencies and plot
        %        restore(h);
        %        figure(5)
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %
        %   See also RFCKT, RFCKT.PASSIVE, RFCKT.AMPLIFIER, RFDATA
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        h = h@rfckt.amplifier('PhantomConstruction');

        %UDD % h = rfckt.mixer;
        set(h, 'Name', 'Mixer', 'File', 'default.s2p');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult'});

        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end

        % Read the data file
        filename = get(h, 'File');
        if ~isempty(filename) 
            h = read(h, filename);
            if nargin    % If nargin is zero, next statement will print
                set(h, varargin{:});
            end
        end
        if ~isempty(varargin)
            restore(h);
        end
        checkproperty(h, true)
        end   % mixer
        
    end  % constructor block

    methods  % method signatures
        spurdata = addmixspur(h,spurdata,zl,zs,z0,cktindex)
        checkproperty(h,for_constructor)
        out = convertfreq(h,in,varargin)
        varargout = plot(varargin)
        h = read(h,filename)
        [deltafreq_left,deltafreq_right] = refinedeltafreq(h,freq,      ...
            deltafreq_left,deltafreq_right,userspecified)
    end  % method signatures

end  % classdef


function out = setmixerspur(h, in, prop_name)
if ~isempty(in) && ~isa(in, 'rfdata.mixerspur')
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:mixer:schema:NotMixerSpurObj', rferrhole));
end
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
end
refobj = getreference(data);
if isempty(in)
    set(refobj, 'MixerSpurData', []);
else
    mixspurdataobj = get(refobj, 'MixerSpurData');
    if ~isa(mixspurdataobj, 'rfdata.mixerspur')
        set(refobj, 'MixerSpurData', rfdata.mixerspur);
        mixspurdataobj = get(refobj, 'MixerSpurData');
    end
    set(mixspurdataobj, 'PinRef', in.PinRef, 'PLORef', in.PLORef, ...
        'Data', in.Data, 'Block', h.Block);
end
out = get(refobj, 'MixerSpurData');
end   % setmixerspur


function out = getmixerspur(h)
out = [];
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasreference(data)
    return
end
refobj = getreference(data);
if isa(refobj.MixerSpurData, 'rfdata.mixerspur')
    out = refobj.MixerSpurData;
    return
end
end   % getmixerspur


function out = setfreqoffset(h, out, prop_name)
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
if isempty(out)
    set(data, 'FreqOffset', []);
else
	out = setpositivevector(h, out, prop_name, true, false, true);
    n = length(out);
    set(data, 'FreqOffset', [0.5 * out(1) out(1:n)' 1.5 * out(n)]);
end
end   % setfreqoffset


function out = setphasenoise(h, out, prop_name)
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
if isempty(out)
    set(data, 'PhaseNoiseLevel', []);
else
	out = setnegativevector(h, out, prop_name, true, false, true);
    n = length(out);
    set(data, 'PhaseNoiseLevel', [out(1) out(1:n)' out(n)]);
end
end   % setphasenoise


