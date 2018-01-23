classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        cascade < rfckt.network
%rfckt.cascade class
%   rfckt.cascade extends rfckt.network.
%
%    rfckt.cascade properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       Ckts - Property is of type 'MATLAB array' 
%
%    rfckt.cascade methods:
%       checkproperty - Check the properties of the object.
%       circle - Draw circles on a smith chart.
%       convertfreq - Convert the input frequency to get the output
%                     frequency.
%       dobudget - Set the flag for budget analysis.
%       noise - Calculate the noise correlation matrix.
%       nwa - Calculate the network parameters.
%       oip3 - Calculate the OIP3.
%       plot - Plot the parameters on an X-Y plane.


    properties (Hidden)
        %BUDGETDATA Property is of type 'handle' 
        BudgetData = [  ];
    end


    methods  % constructor block
        function h = cascade(varargin)
        %CASCADE Constructor.
        %   H = RFCKT.CASCADE('CKTS', {CKT1, CKT2, ...}) returns a cascaded
        %   network object, H, which contains a cell of 2-port RFCKT
        %   objects: CKT1, CKT2, ... The default CKTS is empty. 
        %
        %   A cascaded RFCKT object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is filled during analysis 
        %                    (read only)
        %   Ckts           - Cell of 2-port RFCKT objects
        %
        %   rfckt.cascade methods:   
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
        %   'help rfckt.cascade/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.cascade/plot'.
        %
        %   Example:
        %
        %      % Construct a cascaded RFCKT object
        %        h = rfckt.cascade('Ckts',                              ...
        %            {rfckt.txline('LineLength', .001),                 ...
        %            rfckt.amplifier,                                   ...
        %            rfckt.txline('LineLength', 0.025, 'PV', 2.0e8)})
        %      % Do frequency domain analysis at the given frequency
        %        f = 1.85e9:1e7:2.55e9;             % Simulation frequency
        %        analyze(h,f);                      % Do frequency domain
        %                                             analysis         
        %      % Plot the Budget S21 Parameters and Noise Figure
        %        figure(1)
        %        plot(h, 'budget', 'S21', 'NF');
        %      % Display the Budget S21 and Noise Figure in a table
        %        table(h, 'budget', 'S21', 'NF');      
        %
        %   See also RFCKT, RFCKT.SERIES, RFCKT.PARALLEL, RFCKT.HYBRID,
        %   RFCKT.HYBRIDG, RFDATA
        
        %   Copyright 2003-2010 The MathWorks, Inc.
          
        %UDD % h = rfckt.cascade;
        set(h, 'Name', 'Cascaded Network');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult'});
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h, true);
        end   % cascade
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h,for_constructor)
        varargout = circle(h,varargin)
        out = convertfreq(h,in,varargin)
        dobudget(h)
        [cmatrix,ctype] = noise(h,freq)
        [type,netparameters,z0] = nwa(h,freq,varargin)
        result = oip3(h,freq)
        varargout = plot(varargin)
    end  % method signatures
    
    methods(Access = protected) % JJW 11/27/2013
        function [type,cktparams,cktz0] = spurnwa(h,freq,varargin)
            p = inputParser;
            addParameter(p,'isspurcalc',false);
            parse(p,varargin{:});
            
            [type,cktparams,cktz0] = nwa(h,freq,'isSpurCalc',p.Results.isspurcalc);
        end
    end

end  % classdef