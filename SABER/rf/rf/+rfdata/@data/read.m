function h = read(h, filename)
%READ Read data from a Touchstone or .AMP file.
%   H = READ(H, FILENAME) reads data from a data file and updates
%   properties of the RFDATA.DATA object, H. FILENAME is a string,
%   representing the filename of a .SNP, .YNP, .ZNP, .HNP, .GNP or .AMP
%   file.
%
%   H = READ(H) prompts users to select an .SNP, .YNP, .ZNP, .HNP, .GNP or
%   .AMP file and reads data from the data file.
%
%   See also RFDATA.DATA, RFDATA.DATA/WRITE, RFDATA.DATA/RESTORE

%   Copyright 2003-2008 The MathWorks, Inc.

%
copyflag = get(h, 'CopyPropertyObj');

% Get and check the data file name.
switch nargin
    case 1 
        [filename, filetype] = getfile(h);
    case 2
        [filename, filetype] = getfile(h, filename);
end
if isempty(filetype)
    return;
end

% Check if the file has already been read and if there is need to read it
% again
if ~isempty(h.Reference)
    temppath = fileparts(filename);
    if isempty(temppath)
        tempname = which(filename);
        tempinfo = dir(tempname);
    else
        tempname = filename;
        tempinfo = dir(filename);
    end
    if strcmp(h.Reference.Filename, tempname) &&                        ...
            strcmp(h.Reference.Date, tempinfo.date)
        restore(h); 
        return;
    end
end

% Read the data.
set(h, 'CopyPropertyObj', false);
switch filetype
    case {'YNP' 'SNP' 'ZNP' 'HNP' 'GNP'}
        refobj = readsnp(h, filename);
    case 'AMP'
        refobj = readamp(h, filename);
    case 'S2D'
        refobj = reads2d(h, filename);
    case 'P2D'
        refobj = readp2d(h, filename);
end

% Set the properties
set(refobj, 'Name', filename);
set(h, 'Reference', refobj);
restore(h); 
set(h, 'CopyPropertyObj', copyflag);
set(h.Reference, 'CopyPropertyObj', copyflag);

% save full file name and date modified
temppath = fileparts(filename);
if isempty(temppath)
    filename = which(filename);
end
tempinfo = dir(filename);
set(h.Reference, 'Filename', filename, 'Date', tempinfo.date);

%--------------------------------------------------------------------------
function refobj = readsnp(h, filename)
%READSNP Parser for Touchstone files.

% Set the default values.
NoiseFreq = [];
NoiseParameters = [];
Z0 = 50;

% Parse the header.
% Find the parameter NetworkType from filename.
file_ext = fliplr(strtok(fliplr(filename), '.'));
NetworkType = findnettype(h, upper(file_ext(1)));

% Find the number of columns in the parameter matrix.
nPort = str2double(file_ext(2:end-1));
if ( isnan(nPort) || isempty(nPort) )
    error(message('rf:rfdata:data:readsnp:unsupportedfile'))
end
Col = 2*nPort*nPort + 1;

% Read file for the first time, get DataFormat, the characteristic
% impedance Z0, the scaling factor FScale. Find the start of the numerical
% data.
fid = fopen(filename, 'rt');
if fid == -1
    error(message('rf:rfdata:data:readsnp:filenotfound', filename))
end

% find the option line
idx = 1;
temp_n=[];
while ~feof(fid)
    tline = textscan(fid, '%s', 1, 'delimiter', '\n', 'whitespace', '');
    temp_n = strmatch('#',strtrim(tline{1}));
    idx = idx + 1;
    if ~isempty(temp_n)
        break;
    end
end
if ~isempty(temp_n) && temp_n==1
    temp_n = idx-1;
end
if isempty(temp_n)
    error(message('rf:rfdata:data:readsnp:nooptline'))
end

cline = upper(strtrim(tline{1}{1}));

% Find the frequency scaling factor.
FScale = findfrequnit(h, cline);
if isempty(FScale)
    error(message('rf:rfdata:data:readsnp:nofrequnits'));

end

% Find the data format.
DataFormat = findnetformat(h, cline);
if isempty(DataFormat)
    error(message('rf:rfdata:data:readsnp:nonetworkformat'));
end

% Find Z0.
Rpos = strfind(cline, 'R');
if ~isempty(Rpos)
    Rpos = Rpos(end);
end
% Because str2num([]) gives error, need to check first.
if isempty(Rpos) || Rpos == numel(cline) || ...
        isempty(strtok(cline(Rpos+1:end)))
    warning(message('rf:rfdata:data:readsnp:Z0NotFound'));
else
    Z0 = findz0(h, cline(Rpos+1:end));
    if isempty(Z0) || ~isscalar(Z0)
        Z0 = 50;
        warning(message('rf:rfdata:data:readsnp:Z0NotValid'));
    end
end

% Check if the NetworkType of parameter is consistent.
if isempty(strfind(cline, upper(file_ext(1))))
    error(message('rf:rfdata:data:readsnp:nettypeinconsistent',         ...
        upper( file_ext( 1 ) )));
end

% Choose the number of lines to import at each time (balance between speed
% and memory usage)
NN = 1000; 


% Count the number of lines in the file
frewind(fid);
idx = 1;
while 1
    tline = textscan(fid, '%s', NN, 'delimiter', '\n', 'whitespace', '');
    if numel(tline{1})<NN,
        idx = idx + numel(tline{1});
        break,
    end
    idx = idx + NN;
end
frewind(fid);

% current number of parameters at current frequency point
pcounter = 0;
% buffer that holds complete data of one frequency point
netline = zeros(1,Col);
% numerical array that holds all the network parameters
netdata = [];
lastFreq = -1;
freqIdx = 1;
ntempdata = idx - 1;
noise_data = zeros(ntempdata, 5);
noise_data_flag = 0;
nidx = 0;
for k = 1:ceil(ntempdata/NN)
    temp = textscan(fid, '%s', NN, 'delimiter', '\n', 'whitespace', '');
    temp = temp{1};
    for kt = 1:numel(temp)
        tempL = sscanf(temp{kt}, '%f');
        if numel(tempL)>0
            % if start on a new frequency point
            if ((nPort == 2) && (pcounter == 0))
                thisFreq = tempL(1);
                if isempty(thisFreq)
                    error(message('rf:rfdata:data:readsnp:errinnetparam'))
                end
                %if start of noise data
                if (thisFreq < lastFreq || numel(tempL) == 5);
                    noise_data_flag = 1;
                end
                lastFreq = thisFreq;
            end
            if noise_data_flag==1
                if (numel(tempL) ~= 5)
                    error(message('rf:rfdata:data:readsnp:errinnoiparam'))
                end
                nidx = nidx + 1;
                noise_data(nidx,:) = tempL;
            else
                % Convert the data section from characters to numbers.
                pcounter = pcounter + numel(tempL);
                % Check if number of data points matches number of ports.
                if pcounter > Col
                    error(message(['rf:rfdata:data:readsnp:'            ...
                        'paramnotmatchports']))
                    % if data points of one frequency point is complete
                elseif pcounter == Col
                    netline(pcounter-numel(tempL)+1:pcounter) = tempL;
                    if freqIdx==1
% Once we have read in a full line of S-parameter data, corresponding to 
% the first frequency point, we can estimate the number of frequency points
% in the file and from this pre-allocate the memory for the network data
%
% In the numerator:
%
% ntempdata is the total number of lines in the file and prior to the first 
% network parameter data line we have read in approximately kt+(k-1)*NN-1
% lines of header information so we subtract that amount
%
% In the denominator: 
%
% The network data for each frequency point consists of nPort*nPort values.
% We need to divide this by the number of values per line of data to get
% the number of lines per frequency point.  If there is only one line of
% data, it will contain the network data plus one extra value (the
% frequency data). Hence to account for this case we estimate the number of
% values per line to be numel(tempL)-1, which will be low for the case
% where there are multiple lines of data so we will overallocate memory, 
% which we will trim later.
%
                        estNfreq = ceil((ntempdata-(kt+(k-1)*NN-1))/    ...
                            (nPort*nPort/(numel(tempL)-1)));
                        netdata = zeros(estNfreq,Col);
                    end
                    netdata(freqIdx,:) = netline;  %#ok
                    freqIdx = freqIdx+1;
                    pcounter = 0; % reset counter
                else
                    netline(pcounter-numel(tempL)+1:pcounter) = tempL;
                end
            end
        end
    end
    if numel(temp)<NN,
        break
    end
end
fclose(fid);

if isempty(netdata)
    error(message('rf:rfdata:data:readsnp:nonetdata'))
end


noise_data = noise_data(1:nidx,:);

netdata = netdata(1:freqIdx-1,:);
% pcounter will be reset if the total number of parameters are
% correct.
if pcounter ~= 0
    error(message('rf:rfdata:data:readsnp:incompletenetparam'))
end

% Process network parameters
% Get the Freq property.
Freq = netdata(:,1)*FScale;
% netdata will contain only network parameters.
netdata = netdata(:,2:end);
NetworkParameters = getnetdata(h, netdata, DataFormat);

% Process noise data section
if ((nPort == 2) && ~isempty(noise_data))
    NoiseFreq = noise_data(:,1)*FScale;
    NoiseParameters = noise_data(:,2:end);
end

% Collect property data for the RFDATA.REFERENCE object
refobj = get(h, 'Reference');
if ~isa(refobj, 'rfdata.reference')
    refobj = rfdata.reference('CopyPropertyObj', false);
end
[Fmin, Gammaopt, Rn] = getnoisedata(h, NoiseParameters, 'MA', 1);
update(refobj, NetworkType, Freq, NetworkParameters, Z0, NoiseFreq,     ...
    Fmin, Gammaopt, Rn, [], {}, {}, {});

%--------------------
% [EOF]