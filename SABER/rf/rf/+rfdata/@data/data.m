classdef (CaseInsensitiveProperties,TruncatedProperties) ...
        data < rfdata.rfdata & rf.internal.netparams.Interface
%rfdata.data class
%   rfdata.data extends rfdata.rfdata.
%
%    rfdata.data properties:
%       Name - Property is of type 'string' (read only)
%       Freq - Property is of type 'MATLAB array' 
%       S_Parameters - Property is of type 'MATLAB array' 
%       GroupDelay - Property is of type 'MATLAB array' 
%       NF - Property is of type 'MATLAB array' 
%       OIP3 - Property is of type 'MATLAB array' 
%       Z0 - Property is of type 'MATLAB array' 
%       ZS - Property is of type 'MATLAB array' 
%       ZL - Property is of type 'MATLAB array' 
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%
%    rfdata.data methods:
%       analyze - Analyze the RFDATA.DATA object in the frequency domain.
%       calcgroupdelay - Calculate the group delay.
%       calculate - Calculate the specified parameters.
%       category - Check and find the category of the specified parameter.
%       checkproperty - Check the properties of the object.
%       circle - Draw circles on a Smith chart.
%       destroy - Destroy this object
%       extract - Extract the specified network parameters.
%       findimpedance - Find reference impedance.
%       ga - Calculate the available power gain.
%       getfigure - Get the right figure for plot.
%       getfile - Find and check the data filename extension.
%       getnport - Get the port number.
%       getop - Get operating conditions.
%       getreference - Get the reference.
%       hasip3reference - check if ip3 has reference.
%       hasmultireference - check if data has multiple references.
%       hasnetworkreference - check if network data has reference.
%       hasnfreference - check if nf data has reference.
%       hasnoisereference - check if noise data has reference.
%       hasp2dreference - HASPOWERREFERENCE check if data has
%                         power-dependent sparameter reference.
%       haspowerreference - check if data has pin-pout reference.
%       hasreference - check if data has reference.
%       listformat - List the valid formats for the specified PARAMETER.
%       listparam - List the valid parameters for the RFDATA.DATA object.
%       listxformat - XLISTFORMAT List the valid formats for the specified
%                     PARAMETER.
%       listxparam - XLISTPARAM List the valid parameters for the
%                    RFDATA.DATA object.
%       loglog - Plot the specified parameters on an X-Y plane using
%                logarithmic
%       modifyformat - Modify the format
%       noise - Calculate the noise correlation matrix.
%       nwa - Calculate the network parameters.
%       oip3 - Calculate the OIP3.
%       phasenoise - Calculate the phase noise.
%       plot - Plot the specified parameters on an X-Y plane.
%       plotyy - Plot the specified parameters on an X-Y plane with Y-axes
%                on both
%       polar - Plot the specified parameters on polar coordinates.
%       read - Read data from a Touchstone or .AMP file.
%       refinedeltafreq - Refine the delta frequencies.
%       restore - Restore the original data for plot.
%       semilogx - Plot the specified parameters on an X-Y plane using a
%                  logarithmic
%       semilogy - Plot the specified parameters on an X-Y plane using a
%                  logarithmic
%       setop - Set operating conditions.
%       setreference - Set the reference.
%       smith - Plot the specified parameters on a Smith chart.
%       sortimpedance - Sort the impedance.
%       table - Display the specified parameters in a table.
%       write - Create the formatted RF network data file.
%       xcategory - CATEGORY Check and find the category of the specified
%                   parameter.


    properties (Hidden)
        %NCKTS Property is of type 'int32' 
        nCkts = 1;
    end

    properties
        %FREQ Property is of type 'MATLAB array' 
        Freq = [  ];
    end
    methods 
        function set.Freq(obj,value)
            if ~isequal(obj.Freq,value)
                % DataType = 'MATLAB array'
                obj.Freq = setpositivevector(obj,value,'Freq', ...
                    true,false,true);
            end
        end
    end   % set and get functions for Freq

    properties
        %S_PARAMETERS Property is of type 'MATLAB array' 
        S_Parameters = [  ];
    end
    methods 
        function set.S_Parameters(obj,value)
            if ~isequal(obj.S_Parameters,value)
                % DataType = 'MATLAB array'
                obj.S_Parameters = setcomplexmatrix(obj,value, ...
                    'S_Parameters',true);
            end
        end
    end   % set and get functions for S_Parameters

    properties
        %GROUPDELAY Property is of type 'MATLAB array' 
        GroupDelay = [  ];
    end
    methods 
        function set.GroupDelay(obj,value)
            if ~isequal(obj.GroupDelay,value)
                % DataType = 'MATLAB array'
                obj.GroupDelay = setrealvector(obj,value, ...
                    'GroupDelay',true,true,true,false);
            end
        end
    end   % set and get functions for GroupDelay

    properties
        %NF Property is of type 'MATLAB array' 
        NF = 0;
    end
    methods 
        function set.NF(obj,value)
            if ~isequal(obj.NF,value)
                % DataType = 'MATLAB array'
                obj.NF = setnf(obj,value,'NF');
            end
        end
    end   % set and get functions for NF

    properties
        %OIP3 Property is of type 'MATLAB array' 
        OIP3 = inf;
    end
    methods 
        function set.OIP3(obj,value)
            if ~isequal(obj.OIP3,value)
                % DataType = 'MATLAB array'
                obj.OIP3 = setpositivevector(obj,value,'OIP3', ...
                    false,true,false);
            end
        end
    end   % set and get functions for OIP3

    properties (Hidden)
        %OIP2 Property is of type 'MATLAB array' 
        OIP2 = inf;
    end
    methods 
        function set.OIP2(obj,value)
            if ~isequal(obj.OIP2,value)
                % DataType = 'MATLAB array'
                obj.OIP2 = setpositivevector(obj,value,'OIP2', ...
                    false,true,false);
            end
        end
    end   % set and get functions for OIP2

    properties
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplexvector(obj,value,'Z0', ...
                    false,true,false);
            end
        end
    end   % set and get functions for Z0

    properties
        %ZS Property is of type 'MATLAB array' 
        ZS = complex(50,0);
    end
    methods 
        function set.ZS(obj,value)
            if ~isequal(obj.ZS,value)
                % DataType = 'MATLAB array'
                obj.ZS = setcomplexvector(obj,value,'ZS',false);
            end
        end
    end   % set and get functions for ZS

    properties
        %ZL Property is of type 'MATLAB array' 
        ZL = complex(50,0);
    end
    methods 
        function set.ZL(obj,value)
            if ~isequal(obj.ZL,value)
                % DataType = 'MATLAB array'
                obj.ZL = setcomplexvector(obj,value,'ZL',false);
            end
        end
    end   % set and get functions for ZL

    properties
        %INTPTYPE Property is of type 'InterpolationMethodDATATYPE
        % enumeration: {'Linear','Cubic','Spline'}' 
        IntpType = 'Linear';
    end
    methods 
        function set.IntpType(obj,value)
            enum_list = {'Linear','Cubic','Spline'};
            obj.IntpType = checkenum(obj, 'IntpType', value, enum_list);
         end
    end   % set function for IntpType

    properties (Hidden)
        %BUDGETDATA Property is of type 'handle' 
        BudgetData = [  ];
    end
    methods 
        function set.BudgetData(obj,value)
            % DataType = 'handle'
            obj.BudgetData = setdata(obj,value,'BudgetData');
        end
    end   % set and get functions for BudgetData

    properties (Hidden)
        %SPURPOWER Property is of type 'MATLAB array' 
        SpurPower = [  ];
    end

    properties (SetAccess=protected, Hidden)
        %REFERENCE Property is of type 'handle' (read only)
        Reference = [ ];
    end
    methods
        function set.Reference(obj,value)
            % DataType = 'handle'
            obj.Reference = setref(obj,value,'Reference');
         end
    end   % set and get functions for Reference

    properties (Hidden)
        %FREQOFFSET Property is of type 'MATLAB array' 
        FreqOffset = [  ];
    end
    methods
        function set.FreqOffset(obj,value)
            if ~isequal(obj.FreqOffset,value)
                % DataType = 'MATLAB array'
                obj.FreqOffset = setpositivevector(obj,value, ...
                    'FreqOffset',true,false,true);
            end
        end
    end   % set and get functions for FreqOffset

    properties (Hidden)
        %PHASENOISELEVEL Property is of type 'MATLAB array' 
        PhaseNoiseLevel = [  ];
    end
    methods 
        function set.PhaseNoiseLevel(obj,value)
            if ~isequal(obj.PhaseNoiseLevel,value)
                % DataType = 'MATLAB array'
                obj.PhaseNoiseLevel = setnegativevector(obj,value, ...
                    'PhaseNoiseLevel',true,false,true);
            end
        end
    end   % set and get functions for PhaseNoiseLevel

    properties (Hidden)
        %NEEDRESET Property is of type 'bool' 
        NeedReset = false;
    end

    properties (Hidden)
        %CKTOBJECTVARNAME Property is of type 'string' 
        CktObjectVarName = '';
    end


    methods  % constructor block
        function h = data(varargin)
        %DATA Object Constructor.
        %   H = RFDATA.DATA is a data object for the analyzed result of 
        %       an RFCKT object. The properties include,
        % 
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Freq           - Frequency (Hz)
        %   S_Parameters   - S Parameters
        %   NF             - Noise figure (dB)
        %   OIP3           - Output third order intercept point (W)
        %   Z0             - Reference impedance (ohms)
        %   ZS             - Source impedance (ohms)
        %   ZL             - Load impedance (ohms)
        %   IntpType       - Interpolation method. The choices are:
        %                    'Linear', 'Cubic' or 'Spline' 
        %
        %   rfdata.data methods:   
        %     Analysis
        %       analyze    - Analyze an RFDATA.DATA object in frequency
        %                    domain
        %
        %     Plots and Charts   
        %       circle     - Draw circles on a Smith chart
        %       loglog     - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scales for both the
        %                    X- and Y- axes
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
        %   To get detailed help on a method from the command line,
        %   type 'help rfdata.data/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfdata.data/plot'.
        %
        %   Example:
        %
        %      % Create an RFDATA.DATA object and read a Touchstone
        %      % data file
        %        h = rfdata.data
        %        h = read(h, 'default.s2p')
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21')         
        %      % Visualize the data
        %        figure(1)
        %        plot(h, 's21', 'db');       % Plot dB(S21) on the X-Y
        %                                      plane
        %        figure(2)
        %        polar(h, 's21');            % Plot S21 on a polar
        %                                      plane chart
        %        figure(3)
        %        smith(h, 'GAMMAIN', 'zy');  % Plot GAMMAIN on a ZY
        %                                      Smith chart
        %
        %   See also RFDATA, RFDATA.NETWORK, RFDATA.NOISE, RFDATA.NF,
        %   RFDATA.POWER, RFDATA.IP3, RFDATA.P2D, RFCKT

        %   Copyright 2003-2010 The MathWorks, Inc.

        % Create an RFDATA.DATA object

        if nargin==1 && strcmp(varargin{1},'PhantomConstruction')
            return
        end

        %UDD % h = rfdata.data;

        set(h, 'Name', 'Data object');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % data
        
    end  % constructor block

    methods  % method signatures
        h = analyze(varargin)
        gd = calcgroupdelay(h,freq,z0,aperture)
        [data,params,xdata] = calculate(varargin)
        dcategory = category(h,parameter)
        checkproperty(h)
        varargout = circle(h,varargin)
        h = destroy(h,destroyData)
        [outmatrix,freq] = extract(h,outtype,z0)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        result = ga(h,freq)
        fig = getfigure(h)
        [filename,filetype] = getfile(h,filename)
        nport = getnport(h)
        out = getop(h)
        refobj = getreference(h)
        y = hasip3reference(h)
        y = hasmultireference(h)
        y = hasnetworkreference(h)
        y = hasnfreference(h)
        y = hasnoisereference(h)
        y = hasp2dreference(h)
        y = haspowerreference(h)
        y = hasreference(h)
        list = listformat(varargin)
        list = listparam(varargin)
        list = listxformat(h,parameter)
        list = listxparam(h,yparam)
        varargout = loglog(varargin)
        out = modifyformat(h,in,option)
        [cmatrix,ctype] = noise(h,freq)
        [type,netparameters,z0] = nwa(h,freq)
        [result,iip3,p1db,psat,gcsat] = oip3(h,freq,ckt_oip3)
        phasenoiselevel = phasenoise(h,freqoffset)
        varargout = plot(varargin)
        varargout = plotyy(varargin)
        varargout = polar(varargin)
        h = read(h,filename)
        [deltafreq_left,deltafreq_right] = refinedeltafreq( ...
            h,freq,deltafreq_left,deltafreq_right,userspecified)
        h = restore(h)
        varargout = semilogx(varargin)
        hlines = semilogy(varargin)
        varargout = setop(h,varargin)
        setreference(h,refobj)
        [hlines,hsm] = smith(varargin)
        [zl,zs,z0] = sortimpedance(h,freq,zlin,zsin,z0in)
        table(varargin)
        status = write(h,filename,dataformat,funit,printformat,freqformat)
        dcategory = xcategory(h,parameter)
    end  % method signatures

    methods (Access = protected)
        copyObj = copyElement(h)
    end
    
    % definitions for rf.internal.netparams.Interface
    properties(Constant,Hidden)
        NetworkParameterNarginchkInputs = [1 1]
    end
    
    methods(Access = protected)
        function [str,data,freq,z0] = networkParameterInfo(obj,varargin)
            validateattributes(obj.Freq,{'numeric'},{'nonempty'}, ...
                '','Freq')
            validateattributes(obj.S_Parameters,{'numeric'}, ...
                {'nonempty'},'','S_Parameter')
            
            str = 'S';
            data = obj.S_Parameters;
            freq = obj.Freq;
            z0 = obj.Z0;
        end
    end
end  % classdef

function out = setdata(h, out, prop_name)
if isempty(out)
    return
end
if (~isa(out, 'rfdata.data')) 
    error(message('rf:rfdata:data:schema:NotRFdataObj', ...
        prop_name, upper( class( h ) )));
end
end   % setdata

function out = setref(h, in, prop_name)
if isempty(in)
    out = in;
    return
end
if (~isa(in, 'rfdata.reference') && ~isa(in, 'rfdata.multireference')) 
    error(message('rf:rfdata:data:schema:NotRefOrMultirefObj', ...
        prop_name, upper( class( h ) )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
end   % setref

function out = setnf(h, out, prop_name)
if isempty(out)
    error(message('rf:rfdata:data:schema:EmptyNotAllowed', ...
        prop_name, upper( class( h ) )));
end
out = real(out);
[row, col] = size(squeeze(out));
if ~isnumeric(out) || min([row,col])~=1 || any(isnan(out))
    error(message('rf:rfdata:data:schema:NotAPositiveVector', ...
        prop_name, upper( class( h ) )));
end
if row == 1
    out = out(:);
end
index = find(out < 0);
if ~isempty(index)
    out(index) = 0;
end    
if any(out<0) 
    error(message('rf:rfdata:data:schema:NotAPositiveVector', ...
        prop_name, upper( class( h ) )));
end
end   % setnf
