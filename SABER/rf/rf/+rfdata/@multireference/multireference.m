classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        multireference < rfdata.rfdata
%rfdata.multireference class
%   rfdata.multireference extends rfdata.rfdata.
%
%    rfdata.multireference properties:
%       Name - Property is of type 'string' (read only)
%       References - Property is of type 'MATLAB array' 
%       IndependentVars - Property is of type 'MATLAB array' 
%       Selection - Property is of type 'int32' 
%
%    rfdata.multireference methods:
%       changeop - Change operating conditions to match the input.
%       checkproperty - Check the properties of the object.
%       destroy - Destroy this object
%       getallvalues - Return all recorded values for a given operating
%                      condition. 
%       getnumericvars - Return unique independent numeric variable names
%                        and values.
%       getuniquefreq -  Return unique frequency points.
%       getuniquepower -  Return unique power points.
%       getvarnames - Return unique independent variable names and values.
%       hasvar - Returns index if varname is one of the independent
%                variable names of the selection.
%       listop - List operating conditions.
%       select - Select references from multiple references to match the
%                input variable names and their values.


    properties
        %REFERENCES Property is of type 'MATLAB array' 
        References = {  };
    end
    methods 
        function set.References(obj,value)
            % DataType = 'MATLAB array'
            obj.References = setreferences(obj,value,'References');
        end
    end   % set and get functions for References

    properties
        %INDEPENDENTVARS Property is of type 'MATLAB array' 
        IndependentVars = {  };
    end
    methods 
        function set.IndependentVars(obj,value)
            % DataType = 'MATLAB array'
            obj.IndependentVars = setindependentvars(obj,value,         ...
                    'IndependentVars');
        end
    end   % set and get functions for IndependentVars

    properties
        %SELECTION Property is of type 'int32' 
        Selection = 0;
    end
    methods 
        function set.Selection(obj,value)
            if ~isequal(obj.Selection,value)
                % DataType = 'int32'
                obj.Selection = setselection(obj,value,'Selection');
            end
        end
    end   % set and get functions for Selection

    properties (Hidden)
        %DATE Property is of type 'MATLAB array' 
        Date = '';
    end

    properties (Hidden)
        %FILENAME Property is of type 'MATLAB array' 
        Filename = '';
    end


    methods  % constructor block
        function h = multireference(varargin)
        %MULTIREFERENCE Data Object Constructor.
        %   H = RFDATA.MULTIREFERENCE('PROPERTY1',VALUE1,'PROPERTY2',
        %   VALUE2,...) returns a multi-reference data object, H, based on
        %   the specified properties. The properties include,
        % 
        %               Name: 'Multiple reference data' (read only)
        %         References: Reference data
        %    IndependentVars: Independent variables
        %       
        %   See also RFDATA, RFDATA.DATA, RFDATA.NETWORK, RFDATA.NOISE,
        %   RFDATA.NF, RFDATA.POWER, RFDATA.IP3, RFDATA.P2D,
        %   RFDATA.REFERENCE, RFCKT
          
        %   Copyright 2006-2007 The MathWorks, Inc.
        
        % Create an RFDATA.REFERENCE object

        %UDD % h = rfdata.multireference;
        set(h, 'Name', 'Multiple reference data');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % multireference
        
    end  % constructor block

    methods  % method signatures
        changeop(h,varargin)
        checkproperty(h)
        h = destroy(h,destroyData)
        values = getallvalues(h,condition)
        [names,values] = getnumericvars(h)
        freq = getuniquefreq(h,datatype)
        power = getuniquepower(h,datatype,ptype)
        [names,values] = getvarnames(h)
        [pos,val] = hasvar(h,varname,selection)
        varargout = listop(h,varargin)
        result = select(h,varargin)
    end  % method signatures

end  % classdef


function out = setreferences(h, in, prop_name)
if isempty(in)
    h.Date = '';
    out = in;
    return
end
if ~iscell(in)
    error(message('rf:rfdata:multireference:schema:ReferencesNotCell',  ...
        prop_name, upper( prop_name )));
end
nin = numel(in);
for ii = 1:nin
    if ~isa(in{ii}, 'rfdata.reference')
        error(message(['rf:rfdata:multireference:schema:'               ...
            'ReferencesNotRefObj'], prop_name, upper( prop_name )));
    end
end
if h.CopyPropertyObj
    temp = cell(size(in));
    nin = numel(in);
    for ii = 1:nin
        temp{ii} = copy(in{ii});
    end
end
out = temp;
h.Date = '';
end   % setreferences


function out = setindependentvars(h, out, prop_name)
if isempty(out)
    h.Date = '';
    return
end
if ~iscell(out)
    error(message(['rf:rfdata:multireference:schema:'                   ...
        'IndependentVarsNotCell'], prop_name, upper( prop_name )));
end
nout = numel(out);
for ii = 1:nout
    if ~iscell(out{ii}) || size(out{ii},2) ~= 2  
        error(message(['rf:rfdata:multireference:schema:'               ...
            'IndependentVarsNotCell'], prop_name, upper( prop_name )));

    end
    noutii = numel(out{ii});
    for kk = 1:noutii
        if ~ischar(out{ii}{kk})
            error(message(['rf:rfdata:multireference:schema:'           ...
                'IndependentVarsNotChar'], prop_name, upper( prop_name )));
        end
    end
end
h.Date = '';
end   % setindependentvars


function out = setselection(h, out, prop_name)
if out > numel(h.References) || out < 0
    error(message(['rf:rfdata:multireference:schema:'                   ...
        'SelectionOutofRange'], prop_name, upper( prop_name )));
end
end   % setselection