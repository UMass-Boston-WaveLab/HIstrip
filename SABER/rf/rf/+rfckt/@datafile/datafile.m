classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        datafile < rfckt.rfckt
%rfckt.datafile class
%   rfckt.datafile extends rfckt.rfckt.
%
%    rfckt.datafile properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%       File - Property is of type 'MATLAB array' 
%
%    rfckt.datafile methods:
%       calcgroupdelay - Calculate the group delay.
%       checkproperty - Check the properties of the object.
%       findimpedance - Find reference impedance.
%       noise - Calculate the noise correlation matrix.
%       nwa - Calculate the network parameters.
%       read - Read data from a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%       refinedeltafreq - Refine the delta frequencies.
%       restore - Restore the data to the original frequencies for plot.
%       setop - Set the operating conditions.


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
        function h = datafile(varargin)
        %DATAFILE Constructor.
        %   H = RFCKT.DATAFILE('PROPERTY1', VALUE1, 'PROPERTY2',
        %   VALUE2, ...) returns a datafile object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.datafile'. 
        %
        %   A datafile object has the following properties. All the
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
        %   File           - Data file name (Touchstone or AMP file)
        %
        %   The default NetworkData, NoiseData and NonlinearData are taken
        %   from the 'default.amp' data file. 
        %
        %   rfckt.datafile methods:
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
        %   'help rfckt.datafile/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.datafile/plot'.
        %
        %   Example:
        %
        %      % Create a datafile object
        %        h = rfckt.datafile('File','default.s2p')
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
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(4)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a ZY
        %                                        Smith chart
        %      % Restore the data to the original frequencies and plot
        %        restore(h);
        %        figure(5)
        %        plot(h, 'S21', 'db');         % Plot S21 in dB on the
        %                                        X-Y plane
        %
        %   See also RFCKT, RFCKT.PASSIVE, RFCKT.AMPLIFIER,
        %            RFCKT.MIXER, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.datafile;
        set(h, 'Name', 'Data File', 'File', 'passive.s2p');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort',            ...
            'RFdata', 'AnalyzedResult'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        
        % Read the data file
        filename = get(h, 'File');
        if ~isempty(filename) 
            h = read(h, filename);
        end
        end   % datafile
        
    end  % constructor block

    methods  % method signatures
        gd = calcgroupdelay(h,freq,z0,aperture)
        checkproperty(h)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        [cmatrix,ctype] = noise(h,freq)
        [type,netparameters,z0] = nwa(h,freq)
        h = read(h,filename)
        [deltafreq_left,deltafreq_right] = refinedeltafreq(h,freq,      ...
            deltafreq_left,deltafreq_right,userspecified)
        h = restore(h)
        varargout = setop(h,varargin)
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
    error(message('rf:rfckt:datafile:schema:NotAString', rferrhole));
end
end   % setfilename