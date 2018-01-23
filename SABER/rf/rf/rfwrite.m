function rfwrite(varargin)
% RFWRITE Write RF network data to a Touchstone file.
%
% RFWRITE(DATA,FREQ,FILENAME) creates a Touchstone data file named
% FILENAME. DATA must be an NxNxK matrix, where N is the number of ports of
% the data to be written, and K is the number of frequencies.  FREQ is a
% numeric vector of length K, representing the values of the frequencies in
% Hz.
%
% RFWRITE(NETOBJ,FILENAME) creates a Touchstone data file from a scalar
% network parameter object NETOBJ.  NETOBJ can be one of the following
% types: sparameters, tparameters, yparameters, zparameters, hparameters,
% or gparameters.
%
% RFWRITE(___,Name,Value) creates a Tocuhstone file using the options
% specified in the name-value pairs following the FILENAME.
%
%     Name-value pair arguments:
%     --------------------------
%  
%     'FrequencyUnit'         Determines the scaling used in the file when
%                             writing frequency values.  Valid values for
%                             'FrequencyUnit' are: 'GHz','MHz','kHz', and
%                             'Hz'.
%  
%                             Default: 'GHz'
%  
%     'Parameter'             Which network parameter type to convert to
%                             before writing the file. Valid values for
%                             'Parameter' are: 'S','Y','Z','h', and 'g'.
%  
%                             Default: 'S'
%  
%     'Format'                The format to store the parameter values in.
%                             Valid values are: 'MA','DB', and 'RI'.
%  
%                             Default: 'MA'
%  
%     'ReferenceResistance'   A positive scalar determining which reference
%                             resistance to use in the file.
%  
%                             Default: 50
%  
%     EXAMPLE:
%     
%     % Read in S-parameter data
%     S50 = sparameters('passive.s2p');
%     
%     % Convert to 100 Ohms
%     S100 = sparameters(S50,100);
%     
%     % Write the new data to a file
%     rfwrite(S100,'passive100.s2p')
%  
%     See also sparameters, tparameters, yparameters, zparameters,
%     hparameters, gparameters, abcdparameters

narginchk(2,11)

isanetparam = isa(varargin{1},'rf.internal.netparams.AllParameters');
if ~isnumeric(varargin{1}) && ~isanetparam
    validateattributes(varargin{1},{'numeric','sparameters',...
        'tparameters','yparameters','zparameters','hparameters',...
        'gparameters','abcdparameters'},{},'rfwrite','',1)
end

p = inputParser;
defparam = rf.file.touchstone.Data.getdefaultparam;
defformat = rf.file.touchstone.Data.getdefaultformat;

% Parse inputs depending on the type of the first
if isanetparam
    narginchk(2,10)
    addRequired(p,'networkparamobject')
    defformat = 'RI';
    classstr = class(varargin{1});
    if any(strcmpi(classstr(1),{'s','y','z','h','g'}))
        defparam = upper(classstr(1));
    end
else
    narginchk(3,11)
    addRequired(p,'networkdata')
    addRequired(p,'frequencies')
end

% Inputs shared by both code paths
addRequired(p,'filename')
addParameter(p,'frequencyunit',...
    rf.file.touchstone.Data.getdefaultfrequnit,...
    @(x)validateattributes(x,{'char'},{'row'},'rfwrite','FrequencyUnit'));
addParameter(p,'parameter',defparam,...
    @(x)validateattributes(x,{'char'},{'row'},'rfwrite','Parameter'));
addParameter(p,'format',defformat,...
    @(x)validateattributes(x,{'char'},{'row'},'rfwrite','Format'));
addParameter(p,'referenceresistance',...
    rf.file.touchstone.Data.getdefaultrefimp,...
    @(x)validateattributes(x,{'numeric'},{'scalar'},'rfwrite','ReferenceResistance'));

parse(p,varargin{:})

% Return if user does not wish to overwrite existing file
fname = p.Results.filename;
if exist(fname,'file')
    qstr = sprintf('%s already exists. Do you want to replace it?',fname);
    button = questdlg(qstr,'Continue Operation','Yes','No','Yes');
    if strcmp(button,'No')
        return
    end
end

% "Remember" which param type to end with
switch lower(p.Results.parameter)
    case 'y'
        netfunc = @yparameters;
    case 'z'
        netfunc = @zparameters;
    case 'h'
        netfunc = @hparameters;
    case 'g'
        netfunc = @gparameters;
    otherwise
        netfunc = @sparameters;
end

% Create an "inputobj" from other object or data input
z0 = p.Results.referenceresistance;
if isanetparam
    inputobj = p.Results.networkparamobject;
    if isa(inputobj,'rf.internal.netparams.ScatteringParameters')
        % For S- and T-parameters
        if any(strcmpi('referenceresistance',p.UsingDefaults))
            z0 = inputobj.Impedance;
        else
            scatfunc = str2func(class(inputobj));
            inputobj = scatfunc(inputobj,z0);
        end
    end
else
    % If numeric
    if isequal(netfunc,@sparameters)
        inputobj = netfunc(p.Results.networkdata,p.Results.frequencies,z0);
    else
        inputobj = netfunc(p.Results.networkdata,p.Results.frequencies);
    end
end

% Convert inputobj to the specified param type
if isequal(netfunc,@sparameters) && ...
        ~isa(inputobj,'rf.internal.netparams.ScatteringParameters')
    netobj = netfunc(inputobj,z0);
else
    netobj = netfunc(inputobj);
end

data3D = netobj.Parameters;
freq = netobj.Frequencies;
nsdata = [];

% Create the option line and a touchstone object
optline = sprintf('# %s %s %s R %s',p.Results.frequencyunit,...
    p.Results.parameter,p.Results.format,num2str(z0));
ts = rf.file.touchstone.Data(data3D,freq,nsdata,optline);

write(ts,fname)
