classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        lchighpasstee < rfckt.ladderfilter
%rfckt.lchighpasstee class
%   rfckt.lchighpasstee extends rfckt.ladderfilter.
%
%    rfckt.lchighpasstee properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       L - Property is of type 'MATLAB array' 
%       C - Property is of type 'MATLAB array' 
%
%    rfckt.lchighpasstee methods:
%       checkproperty - Check the properties of the object.
%       createntwk - Create LC highpass tee ladder filter network



    methods  % constructor block
        function h = lchighpasstee(varargin)
        %LCHIGHPASSTEE Constructor.
        %   H = RFCKT.LCHIGHPASSTEE('L', VALUE1, 'C', VALUE2) returns an LC
        %   highpass tee filter object, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing 
        %   'h = rfckt.lchighpasstee'. 
        %
        %   An LC highpass tee filter object has the following properties.
        %   All the properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is generated during
        %                    analysis (read only)
        %   L              - Vector containing the inductances (henries)
        %   C              - Vector containing the capacitances (farads)
        % 
        %   rfckt.lchighpasstee methods:   
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
        %   'help rfckt.lchighpasstee/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance,
        %   'help rfckt.lchighpasstee/plot'.
        %
        %   Example:
        %
        %      % Create an LC highpass tee filter
        %        h = rfckt.lchighpasstee('C', [1e-12 4e-12], 'L',       ...
        %            [2e-9 2.5e-9])
        %      % Do frequency domain analysis at the given frequency
        %        f = .9e9:1e8:6e9;             % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21') 
        %      % Visualize the analyzed results
        %        figure(1)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %
        %   See also RFCKT, RFCKT.LCBANDPASSPI, RFCKT.LCBANDPASSTEE,
        %   RFCKT.LCBANDSTOPPI, RFCKT.LCBANDSTOPTEE, RFCKT.LCHIGHPASSPI,
        %   RFCKT.LCLOWPASSPI, RFCKT.LCLOWPASSTEE, RFDATA
          
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.lchighpasstee;
        set(h, 'Name', 'LC Highpass Tee');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult'});
        
        switch nargin
            case 0
                % Set default L and C
                set(h, 'L', 5.5907e-6, 'C', [4.7524e-10  4.7524e-10]);
            otherwise
                % Set the values for the properties
                if nargin    % If nargin is zero, next statement will print
                    set(h, varargin{:});
                end
        end
        
        checkproperty(h)
        end   % lchighpasstee
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h)
        h = createntwk(varargin)
    end  % method signatures

end  % classdef