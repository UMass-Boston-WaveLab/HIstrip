classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        reference < rfdata.rfdata
%rfdata.reference class
%   rfdata.reference extends rfdata.rfdata.
%
%    rfdata.reference properties:
%       Name - Property is of type 'string' (read only)
%       NetworkData - Property is of type 'handle' 
%       NoiseData - Property is of type 'handle' 
%       NFData - Property is of type 'handle' 
%       PowerData - Property is of type 'handle' 
%       IP3Data - Property is of type 'handle' 
%       P2DData - Property is of type 'handle' 
%       MixerSpurData - Property is of type 'handle' 
%
%    rfdata.reference methods:
%       checkproperty - Check the properties of the object.
%       destroy - Destroy this object
%       findimpedance - Find reference impedance.
%       update - Update the properties with the inputs.
%       updateip3 - Update the IP3Data with the inputs.
%       updatemixerspur - Update the MixerSpurData with the inputs.
%       updatep2d - Update the P2DData with the inputs.
%       updatepower - Update the PowerData with the inputs.


    properties
        %NETWORKDATA Property is of type 'handle' 
        NetworkData = [  ];
    end
    methods 
        function set.NetworkData(obj,value)
            % DataType = 'handle'
            obj.NetworkData = setnetwork(obj,value,'NetworkData');
        end
    end   % set and get functions for NetworkData

    properties
        %NOISEDATA Property is of type 'handle' 
        NoiseData = [ ];
    end
    methods 
        function set.NoiseData(obj,value)
            % DataType = 'handle'
            obj.NoiseData = setnoise(obj,value,'NoiseData');
        end
    end   % set and get functions for NoiseData

    properties
        %NFDATA Property is of type 'handle' 
        NFData = [  ];
    end
    methods 
        function set.NFData(obj,value)
            % DataType = 'handle'
            obj.NFData = setnf(obj,value,'NFData');
        end
    end   % set and get functions for NFData

    properties
        %POWERDATA Property is of type 'handle' 
        PowerData = [  ];
    end
    methods 
        function set.PowerData(obj,value)
            % DataType = 'handle'
            obj.PowerData = setpower(obj,value,'PowerData');
        end
    end   % set and get functions for PowerData

    properties
        %IP3DATA Property is of type 'handle' 
        IP3Data = [  ];
    end
    methods 
        function set.IP3Data(obj,value)
            % DataType = 'handle'
            obj.IP3Data = setip3(obj,value,'IP3Data');
        end
    end   % set and get functions for IP3Data

    properties
        %P2DDATA Property is of type 'handle' 
        P2DData = [  ];
    end
    methods 
        function set.P2DData(obj,value)
            % DataType = 'handle'
            obj.P2DData = setp2d(obj,value,'P2DData');
        end
    end   % set and get functions for P2DData

    properties
        %MIXERSPURDATA Property is of type 'handle' 
        MixerSpurData = [  ];
    end
    methods 
        function set.MixerSpurData(obj,value)
            % DataType = 'handle'
            obj.MixerSpurData = setmixerspur(obj,value,'MixerSpurData');
        end
    end   % set and get functions for MixerSpurData

    properties (Hidden)
        %IIP3 Property is of type 'MATLAB array' 
        IIP3 = [  ];
    end
    methods 
        function set.IIP3(obj,value)
            if ~isequal(obj.IIP3,value)
                % DataType = 'MATLAB array'
                obj.IIP3 = setpositivevector(obj,value,'IIP3',          ...
                    true,true,true);
            end
        end
    end   % set and get functions for IIP3

    properties (Hidden)
        %OIP3 Property is of type 'MATLAB array' 
        OIP3 = [  ];
    end
    methods 
        function set.OIP3(obj,value)
            if ~isequal(obj.OIP3,value)
                % DataType = 'MATLAB array'
                obj.OIP3 = setpositivevector(obj,value,'OIP3',          ...
                    true,true,true);
            end
        end
    end   % set and get functions for OIP3

    properties (Hidden)
        %ONEDBC Property is of type 'MATLAB array' 
        OneDBC = [  ];
    end
    methods 
        function set.OneDBC(obj,value)
            if ~isequal(obj.OneDBC,value)
                % DataType = 'MATLAB array'
                obj.OneDBC = setpositivevector(obj,value,'OneDBC',      ...
                    true,true,true);
            end
        end
    end   % set and get functions for OneDBC

    properties (Hidden)
        %PS Property is of type 'MATLAB array' 
        PS = [  ];
    end
    methods 
        function set.PS(obj,value)
            if ~isequal(obj.PS,value)
                % DataType = 'MATLAB array'
                obj.PS = setpositivevector(obj,value,'PS',              ...
                    true,true,true);
            end
        end
    end   % set and get functions for PS

    properties (Hidden)
        %GCS Property is of type 'MATLAB array' 
        GCS = [  ];
    end
    methods 
        function set.GCS(obj,value)
            if ~isequal(obj.GCS,value)
                % DataType = 'MATLAB array'
                obj.GCS = setpositivevector(obj,value,'GCS',            ...
                    true,true,true);
            end
        end
    end   % set and get functions for GCS

    properties (Hidden)
        %NONLINEARDATAFREQ Property is of type 'MATLAB array' 
        NonlinearDataFreq = [  ];
    end
    methods 
        function set.NonlinearDataFreq(obj,value)
            if ~isequal(obj.NonlinearDataFreq,value)
                % DataType = 'MATLAB array'
                obj.NonlinearDataFreq = setpositivevector(obj,value,    ...
                    'NonlinearDataFreq',true,false,true);
            end
        end
    end   % set and get functions for NonlinearDataFreq

    properties (Hidden)
        %DATE Property is of type 'MATLAB array' 
        Date = '';
    end

    properties (Hidden)
        %FILENAME Property is of type 'MATLAB array' 
        Filename = '';
    end


    methods  % constructor block
        function h = reference(varargin)
        %REFERENCE Data Object Constructor.
        %   H = RFDATA.REFERENCE('PROPERTY1', VALUE1, 'PROPERTY2',
        %   VALUE2, ...) returns a data object for REFERENCE data, H, based
        %   on the properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfdata.reference'. 
        % 
        %   A REFERENCE data object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   NetworkData    - Network parameters
        %   NoiseData      - Spot noise data
        %   NFData         - Noise Figure data
        %   PowerData      - Power data
        %   IP3Data        - IP3 data
        %   P2DData        - P2D data
        %       
        %   See also RFDATA, RFDATA.NETWORK, RFDATA.NOISE, RFDATA.NF,
        %   RFDATA.POWER, RFDATA.IP3, RFDATA.P2D, RFCKT
          
        %   Copyright 2003-2007 The MathWorks, Inc.
        
        % Create an RFDATA.REFERENCE object

        %UDD % h = rfdata.reference;
        set(h, 'Name', 'Reference data');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % reference
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h)
        h = destroy(h,destroyData)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        h = update(h,networktype,freq,netparams,z0,noisefreq,fmin,      ...
            gammaopt,rn,pfreq,pin,power,phase)
        h = updateip3(h,type,freq,data)
        h = updatemixerspur(h,ploref,pinref,data)
        h = updatep2d(h,freq,p1,p2,data)
        h = updatepower(h,pfreq,pin,power,phase)
    end  % method signatures

    methods (Access = protected)
        copyObj = copyElement(h)
    end

end  % classdef


function out = setnetwork(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.network')) 
    error(message('rf:rfdata:reference:schema:NotNetworkObj',           ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setnetwork


function out = setnoise(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.noise')) 
    error(message('rf:rfdata:reference:schema:NotNoiseObj',             ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setnoise

    
function out = setnf(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.nf')) 
    error(message('rf:rfdata:reference:schema:NotNFObj',                ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setnf

    
function out = setpower(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.power')) 
    error(message('rf:rfdata:reference:schema:NotPowerObj',             ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setpower


function out = setip3(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.ip3')) 
    error(message('rf:rfdata:reference:schema:NotIP3Obj',               ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setip3


function out = setmixerspur(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.mixerspur')) 
    error(message('rf:rfdata:reference:schema:NotMixerSpurObj',         ...
        prop_name, upper( prop_name )));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setmixerspur


function out = setp2d(h, in, prop_name)
if isempty(in)
    out = in;
    h.Date = '';
    return
end
if (~isa(in, 'rfdata.p2d'))
    error(message('rf:rfdata:reference:schema:NotP2DObj',               ...
        prop_name));
end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
h.Date = '';
end   % setp2d