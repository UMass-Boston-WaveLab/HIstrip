classdef (CaseInsensitiveProperties,TruncatedProperties) ...
        rfckt < rfbase.rfbase & rf.internal.netparams.Interface
%rfckt.rfckt class
%   rfckt.rfckt extends rfbase.rfbase.
%
%    rfckt.rfckt properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%
%    rfckt.rfckt methods:
%       analyze - Analyze the RFCKT object in the frequency domain.
%       calcgroupdelay - Calculate the group delay.
%       calcpout - Calculate output power.
%       calculate - Calculate the specified parameters.
%       circle - Draw circles on a Smith chart.
%       convertfreq - Convert the input freqquency to get the output
%                     frequency.
%       destroy - Destroy this object
%       extract - Extract the specified network parameters.
%       findimpedance - Find reference impedance.
%       getdata - Get the data.
%       getop - Get operating conditions.
%       getz0 - Get characteristic impedance
%       isnonlinear - Is this a nonlinear circuit.
%       listformat - List the valid formats for the specified PARAMETER.
%       listparam - List the valid parameters for the RFCKT object.
%       loglog - Plot the specified parameters on an X-Y plane using
%                logarithmic
%       noise - Calculate the noise correlation matrix.
%       oip3 - Calculate the OIP3.
%       plot - Plot the specified parameters on an X-Y plane.
%       plotyy - Plot the specified parameters on an X-Y plane with
%                Y-axes on both
%       polar - Plot the specified parameters on polar coordinates.
%       read - Read data from a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%       refinedeltafreq - Refine the delta frequencies.
%       restore - Restore the data to the original frequencies for plot.
%       semilogx - Plot the specified parameters on an X-Y plane using a
%                  logarithmic
%       semilogy - Plot the specified parameters on an X-Y plane using a
%                  logarithmic
%       setflagindexes - Set the indexes for flag.
%       setnport - Set the port number.
%       setop - Set operating conditions.
%       setrfdata - Set rfdata.
%       smith - Plot the specified parameters on a Smith chart.
%       table - Display the specified parameters in a table.
%       updateflag - Update the Flag.
%       write - Create the formatted RF network data file.


    properties (SetAccess=protected)
        %NPORT Property is of type 'int32' (read only)
        nPort = 2;
    end
    methods 
        function set.nPort(obj,value)
            if ~isequal(obj.nPort,value)
                % DataType = 'int32'
                obj.nPort = setpositive(obj,value,'nPort', ...
                    false,false,false);
            end
        end
    end   % set and get functions for nPort

    properties (SetAccess=protected)
        %ANALYZEDRESULT Property is of type 'handle' (read only)
        AnalyzedResult = [  ];
    end
    methods 
        function set.AnalyzedResult(obj,value)
            % DataType = 'handle'
            obj.AnalyzedResult = setdata(obj,value,'AnalyzedResult');
        end
    end   % set and get functions for AnalyzedResult

    properties (SetAccess=protected, Hidden)
        %FLAG Property is of type 'int32' (read only)
        Flag = 28;
    end

    properties (Hidden)
        %SIMULATIONFREQ Property is of type 'MATLAB array' 
        SimulationFreq = [  ];
    end
    methods 
        function set.SimulationFreq(obj,value)
            if ~isequal(obj.SimulationFreq,value)
                % DataType = 'MATLAB array'
                obj.SimulationFreq = setpositivevector(obj,value, ...
                    'SimulationFreq',true,false,true);
            end
        end
    end   % set and get functions for SimulationFreq

    properties (Hidden)
        %DEFAULTFREQ Property is of type 'MATLAB array' 
        DefaultFreq = [  ];
    end
    methods 
        function set.DefaultFreq(obj,value)
            if ~isequal(obj.DefaultFreq,value)
                % DataType = 'MATLAB array'
                obj.DefaultFreq = setpositivevector(obj,value, ...
                    'DefaultFreq',true,false,true);
            end
        end
    end   % set and get functions for DefaultFreq

    properties (Hidden)
        %RFDATA Property is of type 'handle' 
        RFdata = [  ];
    end
    methods 
        function set.RFdata(obj,value)
            % DataType = 'handle'
            obj.RFdata = setdata1(obj,value,'RFdata');
        end
    end   % set and get functions for RFdata

    properties (Hidden)
        %USERDATA Property is of type 'MATLAB array' 
        UserData = {  };
    end
    methods 
        function set.UserData(obj,value)
            % DataType = 'MATLAB array'
            obj.UserData = setuserdata(obj,value,'UserData');
        end
    end   % set and get functions for UserData

    properties (Hidden)
        %SIMDATA Property is of type 'handle' 
        SimData = [  ];
    end
    methods 
        function set.SimData(obj,value)
            % DataType = 'handle'
            obj.SimData = setsimdata(obj,value,'SimData');
        end
    end   % set and get functions for SimData


    methods  % method signatures
        h = analyze(varargin)
        gd = calcgroupdelay(h,freq,z0,aperture)
        [pl,freqout] = calcpout(h,pavs,freq,zl,zs,z0,varargin)
        [data,params,freq] = calculate(varargin)
        varargout = circle(h,varargin)
        out = convertfreq(h,in,varargin)
        h = destroy(h,destroyData)
        [outmatrix,freq] = extract(varargin)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        data = getdata(h)
        out = getop(h)
        z0 = getz0(h)
        result = isnonlinear(h)
        list = listformat(varargin)
        list = listparam(varargin)
        varargout = loglog(varargin)
        [cmatrix,ctype] = noise(h,freq)
        result = oip3(h,freq)
        varargout = plot(varargin)
        varargout = plotyy(varargin)
        varargout = polar(varargin)
        h = read(h,filename)
        [deltafreq_left,deltafreq_right] = refinedeltafreq(h,freq, ...
            deltafreq_left,deltafreq_right,userspecified)
        h = restore(h)
        varargout = semilogx(varargin)
        varargout = semilogy(varargin)
        setflagindexes(h)
        setnport(h,nport)
        varargout = setop(h,varargin)
        setrfdata(h,data)
        [hlines,hsm] = smith(varargin)
        table(varargin)
        updateflag(h,index,iflag,nflags)
        status = write(varargin)
    end  % method signatures

    methods (Abstract)   % Makes this class abstract
        checkproperty(h)
    end

    methods (Access = protected)
        copyObj = copyElement(h)
    end
    
    methods % JJW 4/24/2012
        function tf = isrfcktvalid(obj)
            tf = isvalid(obj);
        end
    end
    
    methods(Access = protected) % JJW 11/27/2013
        function [type,cktparams,cktz0] = spurnwa(h,freq,varargin)
            [type,cktparams,cktz0] = nwa(h,freq);
        end
    end

    % definitions for rf.internal.netparams.Interface
    properties(Constant,Hidden)
        NetworkParameterNarginchkInputs = [1 1]
    end
    
    methods(Access = protected)
        function [str,data,freq,z0] = networkParameterInfo(obj,varargin)
            rfd = obj.AnalyzedResult;
            if isempty(rfd)
                error(message('rflib:shared:RFCKT2MeAnalyzeResFieldEmpty'))
            else
                [str,data,freq,z0] = networkParameterInfo(rfd,varargin{:});
            end
        end
    end
end  % classdef

function out = setdata1(h, out, prop_name)
if isempty(out)
    return
end
if (~isa(out, 'rfdata.data')) 
    if isempty(h.Block)
        rferrhole1 = h.Name;
        rferrhole2 = prop_name;
    else
        rferrhole1 = upper(class(h));
        rferrhole2 = prop_name;
    end
    error(message('rf:rfckt:rfckt:schema:NotRFdataObj', ...
        rferrhole1, rferrhole2));
end
end   % setdata1


function out = setdata(h, in, prop_name)
if isempty(in)
    set(h, 'RFdata', in);
    out = in;
    return
end
if (~isa(in, 'rfdata.data')) 
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:rfckt:schema:NotRFdataObj', ...
            rferrhole1, rferrhole2));


end
if h.CopyPropertyObj
    out = copy(in); 
    set(h, 'RFdata', out);
else
    set(h, 'RFData', in);
    out = in;
end
end   % setdata


function out = setsimdata(h, in, prop_name)
if isempty(in)
    out = in;
    return
end
if (~isa(in, 'rfdata.network')) 
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:rfckt:schema:NotNetworkDdataObj', ...
            rferrhole1, rferrhole2));


end
if h.CopyPropertyObj
    out = copy(in);
else
    out = in;
end
end   % setsimdata


function out = setuserdata(h, in, prop_name)
if isempty(in)
    out = in;
    return
end
if ~isa(in, 'cell')
    if isempty(h.Block)
        rferrhole1 = h.Name;
        rferrhole2 = prop_name;
    else
        rferrhole1 = upper(class(h));
        rferrhole2 = prop_name;
    end
    error(message('rf:rfckt:rfckt:schema:NotACKTCell', ...
        rferrhole1, rferrhole2));
end
nckts = length(in);
out = cell(1,nckts);
for ii = 1:nckts
    ckt = in{ii};
    if ~isa(ckt, 'rfckt.rfckt') 
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:rfckt:schema:NotACKTObj', ...
            rferrhole1, rferrhole2));

    elseif get(ckt, 'nPort') ~= 2
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:rfckt:schema:NotATwoPort', ...
            rferrhole1, rferrhole2));

    end
    out{ii} = copy(ckt);
end
end   % setuserdata

