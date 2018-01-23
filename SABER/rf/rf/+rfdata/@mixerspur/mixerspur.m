classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        mixerspur < rfdata.rfdata

%rfdata.mixerspur class
%   rfdata.mixerspur extends rfdata.rfdata.
%
%    rfdata.mixerspur properties:
%       Name - Property is of type 'string' (read only)
%       PLORef - Property is of type 'double' 
%       PinRef - Property is of type 'double' 
%       Data - Property is of type 'MATLAB array' 


    properties
        %PLOREF Property is of type 'double' 
        PLORef = 0;
    end

    properties
        %PINREF Property is of type 'double' 
        PinRef = 0;
    end

    properties
        %DATA Property is of type 'MATLAB array' 
        Data = [  ];
    end
    methods 
        function set.Data(obj,value)
            if ~isequal(obj.Data,value)
                % DataType = 'MATLAB array'
                obj.Data = setspurtable(obj,value,'Data');
            end
        end
    end   % set and get functions for Data

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
        function h = mixerspur(varargin)
        %MIXERSPUR Data Object Constructor.
        %   H = RFDATA.MIXERSPUR('PROPERTY1', VALUE1, 'PROPERTY2',
        %   VALUE2, ...) returns a data object, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing
        %   'h = rfdata.mixerspur'. 
        %
        %   A MIXERSPUR data object has the following properties. All the
        %   properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   PLORef         - Reference LO power (dBm)
        %   PinRef         - Reference input power (dBm)
        %   Data           - Mixer spur table (dB)
        %
        %   Example:
        %
        %      % Create a MIXERSPUR data object
        %        h = rfdata.mixerspur('Data', [2 5 3; 1 0 99; 10 99 99])
        %
        %   See also RFDATA, RFDATA.POWER, RFDATA.IP3, RFDATA.P2D,
        %   RFDATA.NETWORK, RFDATA.NOISE, RFDATA.NF, RFCKT

        %   Copyright 2004-2007 The MathWorks, Inc.

        % Create an RFDATA.MIXERSPUR object

        %UDD % h = rfdata.mixerspur;
        set(h, 'Name', 'Intermodulation table');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');

        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % mixerspur

    end  % constructor block

    methods
        function checkproperty(h)  % Turns class from abstract to concrete
        end
    end

end  % classdef


function out = setspurtable(h, out, prop_name)
if isempty(out)
    return
end
% First check size
[s1, s2, s3] = size(out);
if (s3 ~= 1) || (s1 ~= s2) || (s1 <= 2)
    error(message('rf:rfdata:mixerspur:schema:WrongSpurTableSize',      ...
        prop_name, upper( class( h ) )));
end
if ~isreal(out) || any(out(:) > 99) || any(out(:) < 0)
    error(message('rf:rfdata:mixerspur:schema:ElementOutofRange',       ...
        prop_name, upper( class( h ) )));
end
end   % setspurtable
