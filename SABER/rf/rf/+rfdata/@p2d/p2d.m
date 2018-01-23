classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        p2d < rfdata.rfdata
%rfdata.p2d class
%   rfdata.p2d extends rfdata.rfdata.
%
%    rfdata.p2d properties:
%       Name - Property is of type 'string' (read only)
%       Type - Property is of type 'MATLAB array' (read only)
%       Freq - Property is of type 'MATLAB array' 
%       P1 - Property is of type 'MATLAB array' 
%       P2 - Property is of type 'MATLAB array' 
%       Data - Property is of type 'MATLAB array' 
%
%    rfdata.p2d methods:
%       calculate - Calculate the required power-dependent parameter.
%       checkproperty - Check the properties of the object.
%       convert2power - Convert an RFDATA.P2D object into an RFDATA.POWER
%                       object.
%       interp - Interpolate the required power-dependent parameters.


    properties (SetAccess=protected)
        %TYPE Property is of type 'MATLAB array' (read only)
        Type = 'S-Parameters';
    end
    methods 
        function set.Type(obj,value)
            if ~isequal(obj.Type,value)
                % DataType = 'MATLAB array'
                obj.Type = setnetworkparametertype(obj,value,           ...
                    'Type',false);
            end
        end
    end   % set and get functions for Type

    properties
        %FREQ Property is of type 'MATLAB array' 
        Freq = [  ];
    end
    methods 
        function set.Freq(obj,value)
            if ~isequal(obj.Freq,value)
                % DataType = 'MATLAB array'
                obj.Freq = setpositivevector(obj,value,                 ...
                    'Freq',true,false,true);
            end
        end
    end   % set and get functions for Freq

    properties
        %P1 Property is of type 'MATLAB array' 
        P1 = { 1 };
    end
    methods 
        function set.P1(obj,value)
            if ~isequal(obj.P1,value)
                % DataType = 'MATLAB array'
                obj.P1 = setpowercell(obj,value,'P1');
            end
        end
    end   % set and get functions for P1

    properties
        %P2 Property is of type 'MATLAB array' 
        P2 = { 1 };
    end
    methods 
        function set.P2(obj,value)
            if ~isequal(obj.P2,value)
                % DataType = 'MATLAB array'
                obj.P2 = setpowercell(obj,value,'P2');
            end
        end
    end   % set and get functions for P2

    properties
        %DATA Property is of type 'MATLAB array' 
        Data = { [ 0, 0; 1, 0 ] };
    end
    methods 
        function set.Data(obj,value)
            if ~isequal(obj.Data,value)
                % DataType = 'MATLAB array'
                obj.Data = setparamcell(obj,value,'Data');
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
        function h = p2d(varargin)
        %P2D Data Object Constructor.
        %   H = RFDATA.P2D('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a data object for P2D data, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing 'h = rfdata.p2d'. 
        % 
        %   A P2D data object has the following properties. All the
        %   properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Type           - Type of data. (read only)
        %   Freq           - Frequency (Hz)
        %   P1             - Power incident at port 1 (W)
        %   P2             - Power incident at port 2 (W)
        %   Data           - Power-dependent network parameters
        %
        %   See also RFDATA, RFDATA.IP3, RFDATA.POWER, RFDATA.NETWORK,
        %   RFDATA.NOISE, RFDATA.NF, RFCKT
          
        %   Copyright 2006-2007 The MathWorks, Inc.
        
        % Create an RFDATA.P2D object

        %UDD % h = rfdata.p2d;
        set(h, 'Name', 'P2D data');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name','Type'});
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % p2d
        
    end  % constructor block

    methods  % method signatures
        [ydata,param,xdata] = calculate(h,parameter,varargin)
        checkproperty(h)
        power = convert2power(h)
        [out_mat,freq,power] = interp(h,parameter,varargin)
    end  % method signatures

end  % classdef


function out = setpowercell(h, out, prop_name)
if isempty(out) || (~iscell(out))
    error(message('rf:rfdata:p2d:schema:EmptyPowerCell',                ...
        prop_name, upper( class( h ) )));
end
nout = numel(out);
for ii=1:nout
    if ( isempty(out{ii}) || (~isnumeric(out{ii})) ||                   ...
            (~isreal(out{ii})) || (~isvector(out{ii})) ||               ...
            any(out{ii}<0) || any(isnan(out{ii})) || any(isinf(out{ii})) )
        error(message('rf:rfdata:p2d:schema:IllegalPowerCell',          ...
            prop_name, upper( class( h ) )));
    end
    % convert to column vector
    if ( size(out{ii}, 1) == 1 )
        out{ii} = out{ii}';
    end
end
h.PropertyChanged = true;
end   % setpowercell


%------------------------------------------
function out = setparamcell(h, out, prop_name)
if isempty(out) || (~iscell(out))
    error(message('rf:rfdata:p2d:schema:EmptyNetparamCell',             ...
        prop_name, upper( class( h ) )));
end
nout = numel(out);
for ii=1:nout
    temp = squeeze(out{ii});
    if ( isempty(out{ii}) || (~isnumeric(out{ii})) ||                   ...
            (size(out{ii}, 1)~=2) || (size(out{ii}, 2)~=2) ||           ...
            (size(temp, 4)~=1) || any(isnan(out{ii}(:))) ||             ...
            any(isinf(out{ii}(:))) )
        error(message('rf:rfdata:p2d:schema:IllegalNetparamSize',       ...
            prop_name, upper( class( h ) )));
    end
end
h.PropertyChanged = true;
end   % setparamcell