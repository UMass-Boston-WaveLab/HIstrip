classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
    power < rfdata.rfdata
%rfdata.power class
%   rfdata.power extends rfdata.rfdata.
%
%    rfdata.power properties:
%       Name - Property is of type 'string' (read only)
%       Freq - Property is of type 'MATLAB array' 
%       Pin - Property is of type 'MATLAB array' 
%       Pout - Property is of type 'MATLAB array' 
%       Phase - Property is of type 'MATLAB array' 
%
%    rfdata.power methods:
%       calculate - Calculate the required power parameter.
%       checkproperty - Check the properties of the object.
%       interp - Interpolate the required power-dependent parameters.
%       interpam - Interpolate AM using INTERP1 function.


    properties
        %FREQ Property is of type 'MATLAB array' 
        Freq = [  ];
    end
    methods 
        function set.Freq(obj,value)
            if ~isequal(obj.Freq,value)
                % DataType = 'MATLAB array'
                obj.Freq = setpositivevector(obj,value,'Freq',          ...
                    true,false,true);
            end
        end
    end   % set and get functions for Freq

    properties
        %PIN Property is of type 'MATLAB array' 
        Pin = { [ 1, 10 ] };
    end
    methods 
        function set.Pin(obj,value)
            if ~isequal(obj.Pin,value)
                % DataType = 'MATLAB array'
                obj.Pin = setpowercell(obj,value,'Pin');
            end
        end
    end   % set and get functions for Pin

    properties
        %POUT Property is of type 'MATLAB array' 
        Pout = { [ 1, 10 ] };
    end
    methods 
        function set.Pout(obj,value)
            if ~isequal(obj.Pout,value)
                % DataType = 'MATLAB array'
                obj.Pout = setpowercell(obj,value,'Pout');
            end
        end
    end   % set and get functions for Pout

    properties
        %PHASE Property is of type 'MATLAB array' 
        Phase = {  };
    end
    methods 
        function set.Phase(obj,value)
            if ~isequal(obj.Phase,value)
                % DataType = 'MATLAB array'
                obj.Phase = setphasecell(obj,value,'Phase');
            end
        end
    end   % set and get functions for Phase

    properties (Hidden)
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplex(obj,value,'Z0',false,true,false);
            end
        end
    end   % set and get functions for Z0


    methods  % constructor block
        function h = power(varargin)
        %POWER Data Object Constructor.
        %   H = RFDATA.POWER('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a data object for Pin/Pout data, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing 
        %   'h = rfdata.power'. 
        % 
        %   A POWER data object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Freq           - Frequency (Hz)
        %   Pin            - Input power (W)
        %   Pout           - Output power (W)
        %   Phase          - Phase shift (degree)
        %
        %   Example:
        %
        %      % Create a POWER data object
        %        f = [2.08 2.10]*1.0e9;
        %        pin = {[0.001 0.002],[0.001 0.005 0.01]};
        %        pout = {[0.0025 0.0031],[0.0025 0.0028 0.0028]};
        %        phase = {[27.1 35.3],[15.4 19.3 21.1]};
        %        h = rfdata.power('Freq', f, 'Pin', pin, 'Pout', pout,  ...
        %           'Phase', phase)
        %
        %   See also RFDATA, RFDATA.IP3, RFDATA.P2D, RFDATA.NETWORK,
        %   RFDATA.NOISE, RFDATA.NF, RFCKT
        
        %   Copyright 2003-2007 The MathWorks, Inc.
        
        % Create an RFDATA.POWER object

        %UDD % h = rfdata.power;
        set(h, 'Name', 'Power data');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');

        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % power

    end  % constructor block

    methods  % method signatures
        [data,param,xdata] = calculate(h,parameter,varargin)
        checkproperty(h)
        [out_mat,freq,power] = interp(h,parameter,varargin)
        newy = interpam(h,x,y,newx)
    end  % method signatures

 end  % classdef


function out = setpowercell(h, out, prop_name)
if isempty(out)
    error(message('rf:rfdata:power:schema:EmptyPowerCell',              ...
        prop_name, upper( class( h ) )));
end
nout = numel(out);
for ii=1:nout 
    if ( (~isnumeric(out{ii})) || (~isreal(out{ii})) )
        error(message('rf:rfdata:power:schema:NotARealCell',            ...
            prop_name, upper( class( h ) )));
    end
    [row, col] = size(out{ii});
    if ~isnumeric(out{ii}) || min([row,col])~=1 || any(isnan(out{ii}))
        error(message('rf:rfdata:power:schema:NotARealCell',            ...
            prop_name, upper( class( h ) )));
    end
    if row == 1
        out{ii} = out{ii}';
    end
end
h.PropertyChanged = true;
end   % setpowercell


function out = setphasecell(h, out, prop_name)
if isempty(out)
    return
end
nout = numel(out);
for ii=1:nout 
    if ( (~isnumeric(out{ii})) || (~isreal(out{ii})) )
        error(message('rf:rfdata:power:schema:NotARealCell',            ...
            prop_name, upper( class( h ) )));
    end
    [row, col] = size(out{ii});
    if ~isnumeric(out{ii}) || min([row,col])~=1 || any(isnan(out{ii}))
        error(message('rf:rfdata:power:schema:NotARealCell',            ...
            prop_name, upper( class( h ) )));
    end
    if row == 1
        out{ii} = out{ii}';
    end
end
h.PropertyChanged = true;
end   % setphasecell