classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rational < rfmodel.rfmodel
%rfmodel.rational class
%  rfmodel.rational extends rfmodel.rfmodel.
%
%  rfmodel.rational properties:
%     Name - Property is of type 'string' (read only)
%     A - Property is of type 'MATLAB array' 
%     C - Property is of type 'MATLAB array' 
%     D - Property is of type 'double' 
%     Delay - Property is of type 'double' 
%
%  rfmodel.rational methods:
%     checkproperty - Check the properties of the object.
%     freqresp - Compute the frequency response of a rational function
%                object.
%     impulse - Compute the impulse response of a rational function object.
%     ispassive - Check the passivity of a rational function object.  
%     stepresp - Compute the step response of a rational function object.
%     timeresp - Compute the time response of a rational function object.
%     writeva - Write Verilog-A description of a rational function object.


    properties (AbortSet, SetObservable, GetObservable)
        %A Property is of type 'MATLAB array' 
        A = [  ];
    end
    methods 
        function set.A(obj,value)
            if ~isequal(obj.A,value)
                % DataType = 'MATLAB array'
                obj.A = setcomplexvector(obj,value,'A',true);
            end
        end
    end   % set and get functions for A

    properties (AbortSet, SetObservable, GetObservable)
        %C Property is of type 'MATLAB array' 
        C = [  ];
    end
    methods 
        function set.C(obj,value)
            if ~isequal(obj.C,value)
                % DataType = 'MATLAB array'
                obj.C = setcomplexvector(obj,value,'C',true);
            end
        end
    end   % set and get functions for C

    properties (AbortSet, SetObservable, GetObservable)
        %D Property is of type 'double' 
        D = 0;
    end
    methods
        function set.D(obj,value)
            if ~isequal(obj.D,value)
                checkrealscalardouble(obj, 'D', value)
                obj.D = value;
            end
        end
    end

    properties (AbortSet, SetObservable, GetObservable, Hidden)
        %E Property is of type 'double' 
        E = 0;
    end
    methods
        function set.E(obj,value)
            if ~isequal(obj.E,value)
                checkrealscalardouble(obj, 'E', value)
                obj.E = value;
            end
        end
    end        

    properties (AbortSet, SetObservable, GetObservable)
        %DELAY Property is of type 'double' 
        Delay = 0.0;
    end
    methods 
        function set.Delay(obj,value)
            if ~isequal(obj.Delay,value)
                % DataType = 'double'
                checkrealscalardouble(obj, 'Delay', value)
                obj.Delay = setpositive(obj,value,'Delay',              ...
                    true,false,false);
            end
        end
    end   % set and get functions for Delay


    methods  % constructor block
        function h = rational(varargin)
        %RATIONAL Constructor.
        %   H = RFMODEL.RATIONAL('A', VALUE1, 'C', VALUE2, 'D', VALUE3, ...
        %       'Delay', VALUE4)
        %   returns the handle to a rational function object, H, based on
        %   the properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. 
        %
        %              C(1)     C(2)         C(n) 
        %     F(S) = (------ + ------ + ... ------ + D) * EXP(-S*DELAY)
        %             S-A(1)   S-A(2)       S-A(n)
        %
        %   where S = j*2*PI*FREQ. 
        %
        %   Any properties you do not specify retain their default values.
        %   To see the defaults, type 'rationalmodel = rfmodel.rational'. 
        %
        %   A rational function object has the following properties. All
        %   the properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   A              - Complex vector of poles of the rational
        %                    function
        %   C              - Complex vector of residues of the rational
        %                    function
        %   D              - Scalar value specifying direct feedthrough 
        %   DELAY          - Delay time (s)
        %
        %   rfmodel.rational methods:   
        %
        %     ispassive    - Check the passivity of a rational function
        %                    object
        %     timeresp     - Compute the time response of a rational
        %                    function object
        %     stepresp     - Compute the step response of a rational
        %                    function object
        %     freqresp     - Compute the frequency response of a rational
        %                    function object 
        %     writeva      - Write Verilog-A description of a rational
        %                    function object
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfmodel.rational/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance,
        %   'help rfmodel.rational/freqresp'.
        %
        %   Example:
        %
        %      % Create a rational function model
        %        rationalmodel = rfmodel.rational('A',[-5e9,-3e9,-4e6], ...
        %                        'C',[6e8,2e9,4e9]);                 
        %        f = [1e6:1.0e7:3e9];                        % Simulation
        %                                                      frequencies
        %        [resp, freq] = freqresp(rationalmodel, f);  % Compute
        %                                                      frequency
        %                                                      response
        %
        %   See also RFMODEL, RATIONALFIT
        
        %   Copyright 2006-2009 The MathWorks, Inc.

        %UDD % h = rfmodel.rational;
        set(h, 'Name', 'Rational Function');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');

        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h, true);
        end   % rational

    end  % constructor block

    methods  % method signatures
        checkproperty(h,for_constructor)
        [resp,freq] = freqresp(h,freq)
        [resp,t] = impulse(h,ts,n)
        result = ispassive(h)
        [y,t] = stepresp(h,ts,n,trise)
        [y,t] = timeresp(h,u,ts)
        status = writeva(h,filename,innets,outnets,discipline,          ...
            printformat,filestoinclude)
    end  % method signatures

end  % classdef