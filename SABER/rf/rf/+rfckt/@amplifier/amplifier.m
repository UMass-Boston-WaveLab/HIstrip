classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        amplifier < rfckt.passive
%rfckt.amplifier class
%   rfckt.amplifier extends rfckt.passive.
%
%    rfckt.amplifier properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%       NetworkData - Property is of type 'handle' 
%       NoiseData - Property is of type 'MATLAB array' 
%       NonlinearData - Property is of type 'MATLAB array' 
%
%    rfckt.amplifier methods:
%       checkproperty - Check the properties of the object.
%       noise - Calculate the noise correlation matrix.
%       nwa - Calculate the network parameters.
%       oip3 - Calculate the OIP3.
%       read - Read amplifier data from a Touchstone or .AMP data file.
%       setop - Set the operating conditions.


    properties
        %NOISEDATA Property is of type 'MATLAB array' 
        NoiseData = 0;
    end
    methods 
        function value = get.NoiseData(obj)
            value = getnoisedata(obj);
        end
        function set.NoiseData(obj,value)
            % DataType = 'MATLAB array'
            obj.NoiseData = setnoisedata(obj,value,'NoiseData');
        end
    end   % set and get functions for NoiseData

    properties
        %NONLINEARDATA Property is of type 'MATLAB array' 
        NonlinearData = inf;
    end
    methods 
        function value = get.NonlinearData(obj)
            value = getnonlineardata(obj);
        end
        function set.NonlinearData(obj,value)
            % DataType = 'MATLAB array'
            obj.NonlinearData = setnonlineardata(obj,value,             ...
                'NonlinearData');
        end
    end   % set and get functions for NonlinearData

    properties (Hidden)
        %NFDATA Property is of type 'MATLAB array' 
        NFData = [  ];
    end
    methods 
        function value = get.NFData(obj)
            value = getnfdata(obj);
        end
        function set.NFData(obj,value)
            % DataType = 'MATLAB array'
            obj.NFData = setnfdata(obj,value,'NFData');
        end
    end   % set and get functions for NFData

    properties (Hidden)
        %POWERDATA Property is of type 'handle' 
        PowerData = [  ];
    end
    methods 
        function value = get.PowerData(obj)
            value = getpower(obj);
        end
        function set.PowerData(obj,value)
            % DataType = 'handle'
            obj.PowerData = setpower(obj,value,'PowerData');
        end
    end   % set and get functions for PowerData

    properties (Hidden)
        %IP3DATA Property is of type 'handle' 
        IP3Data = [  ];
    end
    methods 
        function value = get.IP3Data(obj)
            value = getip3(obj);
        end
        function set.IP3Data(obj,value)
            % DataType = 'handle'
            obj.IP3Data = setip3(obj,value,'IP3Data');
        end
    end   % set and get functions for IP3Data

    properties (Hidden)
        %IIP3 Property is of type 'double' 
        IIP3 = inf;
    end
    methods
        function set.IIP3(obj,value)
            if ~isequal(obj.IIP3,value)
                checkrealscalardouble(obj, 'IIP3', value)
                obj.IIP3 = value;
            end
        end
    end

    properties (Hidden)
        %OIP3 Property is of type 'double' 
        OIP3 = inf;
    end
    methods
        function set.OIP3(obj,value)
            if ~isequal(obj.OIP3,value)
                checkrealscalardouble(obj, 'OIP3', value)
                obj.OIP3 = value;
            end
        end
    end

    properties (Hidden)
        %NF Property is of type 'double' 
        NF = 0;
    end
    methods 
        function set.NF(obj,value)
            if ~isequal(obj.NF,value)
                % DataType = 'double'
                checkrealscalardouble(obj, 'NF', value)
                obj.NF = setnoisefigure(obj,value,'NF');
            end
        end
    end   % set and get functions for NF

    properties (Hidden)
        %DOANALYSIS Property is of type 'bool' 
        DoAnalysis = true;
    end
    methods 
        function set.DoAnalysis(obj,value)
            if ~isequal(obj.DoAnalysis,value)
                checkbool(obj, 'DoAnalysis', value)
                obj.DoAnalysis = logical(value);
            end
        end
    end


    methods  % constructor block
        function h = amplifier(varargin)
        %AMPLIFIER Constructor.
        %   H = RFCKT.AMPLIFIER('PROPERTY1', VALUE1, 'PROPERTY2',
        %   VALUE2, ...) returns an amplifier object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.amplifier'. 
        %
        %   An amplifier object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is generated during
        %                    analysis (read only)
        %   IntpType       - Interpolation method. The choices are:
        %                    'Linear', 'Cubic' or 'Spline' 
        %   NetworkData    - RFDATA.NETWORK object for frequency-dependent
        %                    network parameters
        %   NoiseData      - Noise parameters. The choices are:
        %                    Scalar              - for NF in dB
        %                    RFDATA.NF object    - for frequency-dependent
        %                                          NF
        %                    RFDATA.NOISE object - for frequency-dependent
        %                                          spot noise
        %   NonlinearData  - Nonlinear parameters. The choices are:
        %                    Scalar              - for OIP3 in dBm
        %                    RFDATA.IP3 object   - for frequency-dependent
        %                                          IP3
        %                    RFDATA.POWER object - for Pin/Pout data
        %
        %   RFDATA.NETWORK, RFDATA.NF, RFDATA.NOISE, RFDATA.IP3 and
        %   RFDATA.POWER are RFDATA objects; for details, type
        %   'help rfdata'.
        %
        %   The default NetworkData, NoiseData and NonlinearData are taken
        %   from the 'default.amp' data file. 
        %
        %   rfckt.amplifier methods:
        %
        %     Analysis
        %       analyze    - Analyze an RFCKT object in frequency domain
        %
        %     Plots and Charts   
        %       circle     - Draw circles on a Smith chart
        %       loglog     - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scales for both
        %                    the X- and Y- axes
        %       plot       - Plot the specified parameters on the X-Y plane
        %       plotyy     - Plot the specified parameters on the X-Y plane
        %                    with y tick labels on the left and right
        %       polar      - Plot the specified parameters on a polar plane
        %                    chart
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
        %       write      - Write AnalyzedResult in SNP/YNP/ZNP/AMP
        %                    formats
        %
        %     Data Access and Restoration  
        %       calculate  - Calculate the specified parameters
        %       extract    - Extract the specified network parameters  
        %       restore    - Restore the data to the original frequencies
        %                    for plot
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.amplifier/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance,
        %   'help rfckt.amplifier/plot'.
        %
        %   Example:
        %
        %      % Create an amplifier object
        %        h = rfckt.amplifier
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21')      
        %      % Visualize the original data in 'default.amp' data file
        %        figure(1)
        %        plot(h, 'Pout', 'dbm');       % Plot Pout in dBm on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %      % Plot phase of S21 and group delay
        %        figure(3)
        %        plotyy(h, 'S21', 'Angle', 'GroupDelay', 'ns');  
        %      % Do frequency domain analysis at the given frequency
        %        f = 1.9e9:1e7:2.5e9;          % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % Visualize the analyzed results
        %        figure(4)
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(5)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %      % Restore the data to the original frequencies and plot
        %        restore(h);
        %        figure(6)
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %
        %   See also RFCKT, RFCKT.PASSIVE, RFCKT.MIXER, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.
        
        h = h@rfckt.passive('PhantomConstruction');
        if nargin==1 && strcmp(varargin{1},'PhantomConstruction')
            return
        end

        %UDD % h = rfckt.amplifier;
        set(h, 'Name', 'Amplifier', 'File', 'default.amp');
        
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
        checkproperty(h, true);
        end   % amplifier
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h,for_constructor)
        [cmatrix,ctype] = noise(h,freq)
        [type,netparameters,z0] = nwa(h,freq)
        result = oip3(h,freq)
        h = read(h,filename)
        varargout = setop(h,varargin)
    end  % method signatures

end  % classdef


function out = setnoisedata(h, in, prop_name)
out = in;
if isempty(in)
    set(h, 'NF', 0);
    setnfdata(h, [], prop_name);
    setnoise(h, [], prop_name);
elseif isscalar(in) && isnumeric(in) && isreal(in)
    set(h, 'NF', in); 
    setnfdata(h, [], prop_name);
    setnoise(h, [], prop_name);
elseif isa(in, 'rfdata.noise')
    set(h, 'NF', 0);
    setnfdata(h, [], prop_name);
    out = setnoise(h, in, prop_name);
elseif isa(in, 'rfdata.nf')
    set(h, 'NF', 0);
    out = setnfdata(h, in, prop_name);
    setnoise(h, [], prop_name);
else
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:WrongNoiseData', rferrhole));
end
end   % setnoisedata


function out = setnoise(h, in, prop_name)
out = in;
if ~isempty(in) && ~isa(in, 'rfdata.noise') 
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:NotNoiseObj', rferrhole));
end
data = h.AnalyzedResult;
if isempty(in)&&isempty(data)
    return;
end
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
refobj = getreference(data);
if isempty(in) && isempty(refobj)
    return;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
    refobj = getreference(data);
end
noisedataobj = get(refobj, 'NoiseData');
if isempty(in)
    set(refobj, 'NoiseData', []);
else
    if ~hasnoisereference(data)
        set(refobj, 'NoiseData', rfdata.noise);
        noisedataobj = get(refobj, 'NoiseData');
    end
    set(noisedataobj, 'Freq', in.Freq, 'FMIN', in.FMIN, 'GAMMAOPT',     ...
        in.GAMMAOPT, 'RN', in.RN, 'Block', h.Block);
end
out = get(refobj, 'NoiseData');
end   % setnoise


function out = setnfdata(h, in, prop_name)
out = in;
if isempty(in) || (isnumeric(in)&&isscalar(in)&&isreal(in)&&(in ==0))  
    in = [];
elseif isnumeric(in) && isscalar(in) && isreal(in) && in>0
    freq = [];
    nf = in;    
    z0 = 50;    
elseif isa(in, 'rfdata.nf')
    freq = in.Freq;
    nf = in.Data;  
    z0 = in.Z0;
else
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:NotNFObj', rferrhole));
end
data = h.AnalyzedResult;
if isempty(in)&&isempty(data)
    return;
end
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
refobj = getreference(data);
if isempty(in)&&isempty(refobj)
    return;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
    refobj = getreference(data);
end
if isempty(in)
    set(refobj, 'NFData', []);
else
    nfdataobj = get(refobj, 'NFData');
    if ~hasnfreference(data)
        set(refobj, 'NFData', rfdata.nf);
        nfdataobj = get(refobj, 'NFData');
    end
    set(nfdataobj, 'Freq', freq, 'Data', nf, 'Z0', z0, 'Block', h.Block);
end
out = get(refobj, 'NFData');
end   % setnfdata

    
function out = setnonlineardata(h, in, prop_name)
out = in;
if isempty(in)
    setpower(h, [], prop_name);
    setip3(h, [], prop_name);
    setp2d(h, [], prop_name);
    set(h, 'OIP3', Inf, 'IIP3', Inf);
elseif isscalar(in) && isnumeric(in) && isreal(in)
    setpower(h, [], prop_name);
    setip3(h, [], prop_name);
    setp2d(h, [], prop_name);
    set(h, 'OIP3', in, 'IIP3', Inf);
elseif isa(in, 'rfdata.power')
    setip3(h, [], prop_name);
    setp2d(h, [], prop_name);
    set(h, 'OIP3', Inf, 'IIP3', Inf);
    out = setpower(h, in, prop_name);
elseif isa(in, 'rfdata.ip3')
    setpower(h, [], prop_name);
    setp2d(h, [], prop_name);
    set(h, 'OIP3', Inf, 'IIP3', Inf);
    out = setip3(h, in, prop_name);
elseif isa(in, 'rfdata.p2d')
    setip3(h, [], prop_name);
    setpower(h, [], prop_name);
    out = setp2d(h, in, prop_name);
    set(h, 'OIP3', Inf, 'IIP3', Inf);
else
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:WrongNonlinearData',       ...
        rferrhole));
end
end   % setnonlineardata


function out = setpower(h, in, prop_name)
out = in;
if ~isempty(in) && ~isa(in, 'rfdata.power')
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:NotPowerObj', rferrhole));
end
data = h.AnalyzedResult;
if isempty(in)&&isempty(data)
    return;
end
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
refobj = getreference(data);
if isempty(in)&&isempty(refobj)
    return;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
    refobj = getreference(data);
end
if isempty(in)
    set(refobj, 'PowerData', []);
else
    powerdataobj = get(refobj, 'PowerData');
    if ~haspowerreference(data)
        set(refobj, 'PowerData', rfdata.power);
        powerdataobj = get(refobj, 'PowerData');
    end
    set(powerdataobj, 'Freq', in.Freq, 'Pin', in.Pin, 'Pout', in.Pout,  ...
        'Phase', in.Phase, 'Z0', in.Z0, 'Block', h.Block);
end
out = get(refobj, 'PowerData');
end   % setpower


function out = setip3(h, in, prop_name)
out = in;
if ~isempty(in) && ~isa(in, 'rfdata.ip3')
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:NotIP3Obj', rferrhole));
end
data = h.AnalyzedResult;
if isempty(in)&&isempty(data)
    return;
end
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
refobj = getreference(data);
if isempty(in)&&isempty(refobj)
    return;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
    refobj = getreference(data);
end
if isempty(in)
    set(refobj, 'IP3Data', []);
else
    ip3dataobj = get(refobj, 'IP3Data');
    if ~hasip3reference(data)
        set(refobj, 'IP3Data', rfdata.ip3);
        ip3dataobj = get(refobj, 'IP3Data');
    end
    set(ip3dataobj, 'Freq', in.Freq, 'Type', in.Type,                   ...
        'Data', in.Data, 'Z0', in.Z0, 'Block', h.Block);
end
out = get(refobj, 'IP3Data');
end   % setip3


function out = setp2d(h, in, prop_name)
out = in;
if ~isempty(in) && ~isa(in, 'rfdata.p2d')
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:amplifier:schema:NotP2DObj', rferrhole));
end
data = h.AnalyzedResult;
if isempty(in) && isempty(data)
    return;
end
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = h.AnalyzedResult;
end
refobj = getreference(data);
if isempty(in) && isempty(refobj)
    return;
end
if ~hasreference(data)
    setreference(data, rfdata.reference);
    refobj = getreference(data);
end
if isempty(in)
    set(refobj, 'P2DData', []);
else
    p2ddataobj = get(refobj, 'P2DData');
    if ~hasp2dreference(data)
        set(refobj, 'P2DData', rfdata.p2d);
        p2ddataobj = get(refobj, 'P2DData');
    end
    set(p2ddataobj, 'Freq', in.Freq, 'Data', in.Data,                   ...
        'Z0', in.Z0, 'P1', in.P1, 'P2', in.P2, 'Block', h.Block);
end
out = get(refobj, 'P2DData');
end   % setp2d


function out = getnoisedata(h)
out = 0;
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasreference(data)
    return
end
refobj = getreference(data);
if isa(refobj.NoiseData, 'rfdata.noise')
    out = refobj.NoiseData;
    return
end
if isa(refobj.NFData, 'rfdata.nf')
    out = refobj.NFData;
    return
end
out = h.NF;
end   % getnoisedata


function out = getnfdata(h)
out = [];
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasnfreference(data)
    return
end
refobj = getreference(data);
out = refobj.NFData;
end   % getnfdata


function out = getnonlineardata(h)
out = inf;
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasreference(data)
    return
end
refobj = getreference(data);
if isa(refobj.P2DData, 'rfdata.p2d')
    out = refobj.P2DData;
    return
end
if isa(refobj.PowerData, 'rfdata.power')
    out = refobj.PowerData;
    return
end
if isa(refobj.IP3Data, 'rfdata.ip3')
    out = refobj.IP3Data;
    return
end
out = h.OIP3;
end   % getnonlineardata


function out = getip3(h)
out = [];
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasip3reference(data)
    return
end
refobj = getreference(data);
out = refobj.IP3Data;
end   % getip3


function out = getpower(h)
out = [];
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~haspowerreference(data)
    return
end
refobj = getreference(data);
out = refobj.PowerData;
end   % getpower


