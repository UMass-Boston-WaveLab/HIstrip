classdef (CaseInsensitiveProperties,TruncatedProperties) ...
        series < rfckt.network
%rfckt.series class
%   rfckt.series extends rfckt.network.
%
%    rfckt.series properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       Ckts - Property is of type 'MATLAB array' 
%
%    rfckt.series methods:
%       checkproperty - Check the properties of the object.
%       nwa - Calculate the network parameters.



    methods  % constructor block
        function h = series(varargin)
        %SERIES Constructor.
        %   H = RFCKT.SERIES('CKTS', {CKT1, CKT2, ...}) returns a series
        %   connected network object, H, which contains a cell of 2-port
        %   RFCKT objects: CKT1, CKT2, .... The default CKTS is empty. 
        %
        %   A series RFCKT object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is filled during
        %                    analysis (read only)
        %   Ckts           - Cell of 2-port RFCKT objects
        %
        %   rfckt.series methods:   
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
        %       write      - Write AnalyzedResult formats SNP/YNP/ZNP/AMP
        %
        %     Data Access and Restoration  
        %       calculate  - Calculate the specified parameters
        %       extract    - Extract the specified network parameters  
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.series/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.series/plot'.
        %
        %   Example:
        %
        %      % Construct a series RFCKT object
        %        h = rfckt.series('Ckts', {rfckt.txline('LineLength',   ...
        %            .001), rfckt.passive, rfckt.txline('LineLength',   ...
        %            0.025, 'PV', 2.0e8)})
        %      % Do frequency domain analysis at the given frequency
        %        f = 1.85e9:1e7:2.55e9;        % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis         
        %      % Visualize the analyzed results
        %        figure(1)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %
        %   See also RFCKT, RFCKT.CASCADE, RFCKT.PARALLEL, RFCKT.HYBRID,
        %   RFCKT.HYBRIDG, RFDATA
        
        %   Copyright 2003-2015 The MathWorks, Inc.

        %UDD % h = rfckt.series;
        set(h,'Name','Series Connected Network');
        
        % Check the read only properties
        checkreadonlyproperty(h,varargin,{'Name','nPort','RFdata', ...
            'AnalyzedResult'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h,varargin{:});
        end
        checkproperty(h,true);
        end   % series
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h,for_constructor)
        [type,netparameters,z0] = nwa(h,freq)
        [cmatrix,ctype] = noise(h,freq)
    end  % method signatures

end  % classdef