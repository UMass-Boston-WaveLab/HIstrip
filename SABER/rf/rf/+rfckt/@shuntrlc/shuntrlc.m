classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        shuntrlc < rfckt.rlcckt
%rfckt.shuntrlc class
%   rfckt.shuntrlc extends rfckt.rlcckt.
%
%    rfckt.shuntrlc properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       R - Property is of type 'MATLAB array' 
%       L - Property is of type 'MATLAB array' 
%       C - Property is of type 'MATLAB array' 
%
%    rfckt.shuntrlc methods:
%       checkproperty - Check the properties of the object.
%       nwa - Calculate the network parameters.



    methods  % constructor block
        function h = shuntrlc(varargin)
        %SHUNTRLC Constructor.
        %   H = RFCKT.SHUNTRLC('PROPERTY1', VALUE1, 'PROPERTY2',        ...
        %       VALUE2, ...)
        %   returns a shunt RLC object, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing
        %   'h = rfckt.shuntrlc'. 
        %
        %   A a shunt RLC object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is generated during
        %                    analysis (read only)
        %   R              - Resistance (ohms)
        %   L              - Inductance (henries)
        %   C              - Capacitance (farads)
        %
        %   rfckt.shuntrlc methods:   
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
        %     Data Access and Restoration  
        %       calculate  - Calculate the specified parameters
        %       extract    - Extract the specified network parameters  
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.shuntrlc/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.shuntrlc/plot'.
        %
        %   Example:
        %
        %      % Create a shunt RLC circuit
        %        h = rfckt.shuntrlc('L',4.7e-5,'C',2.2e-10)
        %      % Do frequency domain analysis at the given frequency
        %        f = logspace(4,8,1000);       % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21') 
        %      % Visualize the analyzed results
        %        figure(1)
        %        semilogx(h, 'S21', 'dB');     % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %
        %   See also RFCKT, RFCKT.SERIESRLC, RFDATA
          
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.shuntrlc;
        set(h, 'Name', 'Shunt RLC', 'R', Inf, 'L', Inf, 'C', 0);
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % shuntrlc
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h)
        [type,netparameters,z0] = nwa(h,freq)
    end  % method signatures

end  % classdef