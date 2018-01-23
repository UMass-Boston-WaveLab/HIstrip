classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        passive < rfckt.rfckt
%rfckt.passive class
%   rfckt.passive extends rfckt.rfckt.
%
%    rfckt.passive properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%       NetworkData - Property is of type 'handle' 
%
%    rfckt.passive methods:
%       calcgroupdelay - Calculate the group delay.
%       checkproperty - Check the properties of the object.
%       findimpedance - Find reference impedance.
%       noise - Calculate the noise correlation matrix.
%       nwa - Calculate the network parameters.
%       read - Read passive network parameters from a Touchstone data file.
%       refinedeltafreq - Refine the delta frequencies.
%       restore - Restore the data to the original frequencies for plot.


    properties
        % INTPTYPE Property is of type 'InterpolationMethodDATATYPE
        % enumeration: {'Linear','Cubic','Spline'}' 
        IntpType = 'Linear';
    end
    methods 
        function set.IntpType(obj,value)
            enum_list = {'Linear','Cubic','Spline'};
            obj.IntpType = checkenum(obj, 'IntpType', value, enum_list);
         end
    end   % set function for IntpType

    properties
        %NETWORKDATA Property is of type 'handle' 
        NetworkData = [  ];
    end
    methods 
        function value = get.NetworkData(obj)
            value = getnetwork(obj);
        end
        function set.NetworkData(obj,value)
            % DataType = 'handle'
            obj.NetworkData = setnetwork(obj,value,'NetworkData');
        end
    end   % set and get functions for NetworkData

    properties (Hidden)
        %FILE Property is of type 'MATLAB array' 
        File = '';
    end
    methods 
        function set.File(obj,value)
            if ~isequal(obj.File,value)
                % DataType = 'MATLAB array'
                obj.File = setfilename(obj,value,'File');
            end
        end
    end   % set and get functions for File


    methods  % constructor block
        function h = passive(varargin)
        %PASSIVE Constructor.
        %   H = RFCKT.PASSIVE('PROPERTY1', VALUE1, 'PROPERTY2', 
        %   VALUE2, ...) returns a passive circuit object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.passive'. 
        %
        %   A passive circuit object has the following properties. All the
        %   properties are writable except for the ones explicitly
        %   noted otherwise.
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
        %
        %   RFDATA.NETWORK is an RFDATA object; for details, type
        %   'help rfdata.network'.
        %
        %   The default NetworkData is taken from the 'passive.s2p'
        %   data file. 
        %
        %   rfckt.passive methods:
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
        %   'help rfckt.passive/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.passive/plot'.
        %
        %   Example:
        %
        %      % Create a passive object
        %        h = rfckt.passive
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21')      
        %      % Visualize the original data in 'default.amp' data file
        %        figure(1)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
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
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
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
        %   See also RFCKT, RFCKT.AMPLIFIER, RFCKT.MIXER, RFDATA
        
        %   Copyright 2003-2010 The MathWorks, Inc.
        
        if nargin==1 && strcmp(varargin{1},'PhantomConstruction')
            return
        end
        
        %UDD % h = rfckt.passive;
        set(h, 'Name', 'Passive', 'File', 'passive.s2p');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort',            ...
            'RFdata', 'AnalyzedResult'});
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
        end   % passive
        
    end  % constructor block

    methods  % method signatures
        gd = calcgroupdelay(h,freq,z0,aperture)
        checkproperty(h,for_constructor)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        [cmatrix,ctype] = noise(h,freq)
        [type,netparameters,z0] = nwa(h,freq)
        h = read(h,filename)
        [deltafreq_left,deltafreq_right] = refinedeltafreq(h,freq,      ...
            deltafreq_left,deltafreq_right,userspecified)
        h = restore(h)
    end  % method signatures

end  % classdef


function out = setfilename(h, out, prop_name)
if isempty(out)
    return
end
if (~isa(out, 'char')) 
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:passive:schema:NotAString', rferrhole));
end
end   % setfilename


function out = setnetwork(h, in, prop_name)
if ~isempty(in) && ~isa(in, 'rfdata.network')
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:passive:schema:NotARFDATANetwork', rferrhole));
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
    set(refobj, 'NetworkData', []);
else
    if ~hasnetworkreference(data)
        set(refobj, 'NetworkData', rfdata.network);
    end
    networkdataobj = get(refobj, 'NetworkData');
    set(networkdataobj, 'Freq', in.Freq, 'Data', in.Data,               ...
        'Type', in.Type, 'Z0', in.Z0, 'Block', h.Block);
end
out = get(refobj, 'NetworkData');
end   % setnetwork


function out = getnetwork(h)
out = [];
data = h.AnalyzedResult;
if ~isa(data, 'rfdata.data') || ~hasreference(data)
    return
end
refobj = getreference(data);
out = get(refobj, 'NetworkData');
end   % getnetwork