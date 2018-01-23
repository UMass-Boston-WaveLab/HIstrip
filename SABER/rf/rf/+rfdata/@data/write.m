function status = write(h, filename, dataformat, funit,                 ...
    printformat, freqformat)
%WRITE Create the formatted RF network data file.
%   STATUS = WRITE(H, FILENAME, DATAFORMAT, FUNIT, PRINTFORMAT, FREQFORMAT)
%   creates a .SNP, .YNP, .ZNP, .HNP or .AMP file using information from
%   data object H, returns STATUS = True if successful and False otherwise.
%
%   H is the RFDATA.DATA object that contains sufficient information to
%   write a .SNP, .YNP, .ZNP, .HNP or .AMP file. FILENAME is a string,
%   representing the name of the file to be written. DATAFORMAT is a string
%   that can only be 'RI','MA' or 'DB'. FUNIT is a string, representing the
%   frequency units, it can only be 'GHz','MHz','KHz' or 'Hz'. PRINTFORMAT
%   is a string that specifies the precision of the network and noise
%   parameters. FREQFORMAT is a string that specifies the precision of the
%   frequency. See the list of allowed precisions under FPRINTF.
% 
%   See also RFDATA.DATA, RFDATA.DATA/READ, RFDATA.DATA/ANALYZE

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(1,6)
checkproperty(h);

status = false;
if ~islegalsparam(h)
    error(message('rf:rfdata:data:write:IllegalNetParam'))
end

if hasnetworkreference(h)
    tempref = getreference(h);
    refPort = getnport(tempref.NetworkData);
    if refPort ~= size(h.S_Parameters, 1);
        error(message('rf:rfdata:data:write:UnanalyzedData'));
    end
end
% Assign local variables.
nPort = getnport(h);
OrigType = 'S_PARAMETERS';
WriteType = 'S_PARAMETERS'; %default type is S
Freq = get(h, 'Freq');
NetworkParameters = get(h, 'S_Parameters');
Z0 = get(h, 'Z0');
isAMP = false;

NoiseFreq = [];
NoiseParameters = [];
refobj = getreference(h);
if hasnoisereference(h)
    noisedata = get(refobj, 'NoiseData');
    NoiseFreq = get(noisedata, 'Freq');
    NoiseParameters = getnoisedata(noisedata);
end

% If 1, then if file exists, prompt user to confirm overwriting.
OVERWRITE_CHECK = 1;
if nargin == 1 || isempty(strtok(filename))
    [filename, pathname] = uiputfile('*.*P', 'Save as');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    filename = fullfile(pathname, filename);
    OVERWRITE_CHECK = 0;
end

if ~ischar(filename)
    error(message('rf:rfdata:data:write:FilenameNotString'))
end

% Get filename extension.
filename = strtrim(filename);
file_ext = fliplr(strtok(fliplr(filename), '.'));
% Check if the filename extension contains the correct number of ports and
% the parameter type.
if ~isempty(file_ext) && ~isempty(str2double(file_ext(2:end-1))) &&     ...
        upper(file_ext(end))=='P' &&                                    ...
        ~isempty(strfind('SYZH', upper(file_ext(1))))
    WriteType = [upper(file_ext(1)),'_PARAMETERS'];
    if str2double(file_ext(2:end-1)) ~= nPort
        error(message('rf:rfdata:data:write:NumberOfPortsMismatch',     ...
            file_ext, nPort))
    end
    if isemptysparam(h)
        error(message('rf:rfdata:data:write:EmptySparam'));
    end
elseif ~isempty(file_ext) && strcmpi(file_ext,'amp')
    isAMP = true;
    if nPort ~= 2
        error(message('rf:rfdata:data:write:TwoPortOnlyForAMP'))
    end
elseif any(strcmpi(file_ext, {'s2d', 'p2d'}))
    error(message('rf:rfdata:data:write:S2DP2DNotSupported'))
else
    % Append the filename extension if it does not have one.
    filename = [filename, '.', upper(WriteType(1)), num2str(nPort), 'P'];
    OVERWRITE_CHECK = 1;
    if isemptysparam(h)
        error(message('rf:rfdata:data:write:EmptySparam'));
    end
end

if OVERWRITE_CHECK
    [tempfile, temppath] = strtok(fliplr(filename), filesep);
    tempfile = fliplr(tempfile);
    temppath = fliplr(temppath);
    % If the path to the file is not included in the filename, then check
    % if the file exists in the current directory.
    if isempty(temppath)
        if exist([pwd,filesep,tempfile], 'file')
            button = questdlg([pwd, filesep, tempfile,                  ...
                ' already exists. Do you want to replace it?'],         ...
                'Continue Operation','Yes','No','Yes');
            if strcmp(button,'No')
                status = false;
                return;
            end
        end
    else
        if exist(filename, 'file')
            button = questdlg([filename,                                ...
                ' already exists. Do you want to replace it?'],         ...
                'Continue Operation','Yes','No','Yes');
            if strcmp(button,'No')
                status = false;
                return;
            end
        end
    end  
end

if nargin < 3 || isempty(dataformat)
    dataformat = 'RI';
end

% Check if the units of frequency are missing or empty.
if nargin < 4 || isempty(funit)
    % Decide the unit of frequency.
    if median(Freq) >= 1e9
        funit = 'GHz';
    elseif median(Freq) >= 1e6
        funit = 'MHz';
    elseif median(Freq) >= 1e3
        funit = 'KHz';
    else
        funit = 'Hz';
    end
end
switch upper(funit)
    case 'GHZ'
        Freq = Freq./1e9;
    case 'MHZ'
        Freq = Freq./1e6;
    case 'KHZ'
        Freq = Freq./1e3;
    case 'HZ'

    otherwise
        error(message('rf:rfdata:data:write:IllegalFreqUnit'))
end
funit = [upper(funit(1:end-1)), lower(funit(end))];

% Check if printformat is missing or empty.
if nargin < 5 || isempty(printformat)
    printformat = '%22.10f';
else
    checkprintformat(printformat, 'Print format');
end

% Check if freqformat is missing or empty.
if nargin < 6 || isempty(freqformat)
    freqformat = '%-22.10f';
else
    checkprintformat(freqformat, 'Frequency format');
end

% AMP file does not require network parameters, need to check the existence
% of s_parameters first.
if ~isemptysparam(h)
  % Calculate the number of columns.
  Col = 2*nPort*nPort + 1;
  netdata = zeros(numel(Freq), Col); % Preallocate netdata.
  netdata(:,1) = Freq(:);

  % Find out the type of the network parameter.
  % WriteType = upper(WriteType);
  NetworkParameters = convertmatrix(h, NetworkParameters, OrigType,     ...
      WriteType, Z0, Z0);
  typetitle = [WriteType(1),'-Parameters'];


  % Generate 2D data matrix (netdata) based on NetworkParameters and its
  % format.
  % tempC will contain complex network parameters in 2D format.
  tempC = zeros(size(NetworkParameters,3), nPort*nPort);
  if nPort <= 2
      for p = 1:size(NetworkParameters,3)
          tempC(p, :) = reshape(NetworkParameters(:,:,p), 1, []);
      end
  else
      for p = 1:size(NetworkParameters,3)
          tempC(p, :) = reshape(NetworkParameters(:,:,p).', 1, []);
      end
  end

  switch upper(dataformat)
    case 'RI'
      netdata(:, 2:2:end) = real(tempC);
      netdata(:, 3:2:end) = imag(tempC);
    case 'MA'
      netdata(:, 2:2:end) = abs(tempC);
      netdata(:, 3:2:end) = angle(tempC)*180/pi;
    case 'DB'
      netdata(:, 2:2:end) = 20*log10(abs(tempC) + eps(tempC));
      netdata(:, 3:2:end) = angle(tempC)*180/pi;
    otherwise
      error(message('rf:rfdata:data:write:IllegalDataFormat'));
  end

  % Also generate the column headers for netdata.
  % colheader is a cell array that contains strings such as
  % 'reZ11', 'magY21', etc.
  switch nPort
    case 2 
      switch upper(dataformat)
        case 'RI'
          colheader = {['re',WriteType(1),'11'];                        ...
              ['im',WriteType(1),'11']; ['re',WriteType(1),'21'];       ...
              ['im',WriteType(1),'21']; ['re',WriteType(1),'12'];       ...
              ['im',WriteType(1),'12']; ['re',WriteType(1),'22'];       ...
              ['im',WriteType(1),'22']};
        case 'MA'
          colheader = {['mag',WriteType(1),'11'];                       ...
              ['ang',WriteType(1),'11']; ['mag',WriteType(1),'21'];     ...
              ['ang',WriteType(1),'21']; ['mag',WriteType(1),'12'];     ...
              ['ang',WriteType(1),'12']; ['mag',WriteType(1),'22'];     ...
              ['ang',WriteType(1),'22']};
        case 'DB'
          colheader = {['db',WriteType(1),'11'];                        ...
              ['ang',WriteType(1),'11']; ['db',WriteType(1),'21'];      ...
              ['ang',WriteType(1),'21']; ['db',WriteType(1),'12'];      ...
              ['ang',WriteType(1),'12']; ['db',WriteType(1),'22'];      ...
              ['ang',WriteType(1),'22']};
      end

      otherwise
        colheader = cell(2*nPort, nPort);
        switch upper(dataformat)
          case 'RI'
            for p = 1:nPort
              for k = 1:nPort
                if nPort >= 10
                  colheader{2*k-1,p} = ['re',WriteType(1),num2str(p),   ...
                      ',',num2str(k)];
                  colheader{2*k,p} = ['im',WriteType(1),num2str(p),     ...
                      ',',num2str(k)];
                else
                  colheader{2*k-1,p} = ['re',WriteType(1),num2str(p),   ...
                      num2str(k)];
                  colheader{2*k,p} = ['im',WriteType(1),num2str(p),     ...
                      num2str(k)];
                end
              end
            end
          case 'MA'
            for p = 1:nPort
              for k = 1:nPort
                if nPort >= 10
                  colheader{2*k-1, p} = ['mag', WriteType(1),           ...
                      num2str(p),',',num2str(k)];
                  colheader{2*k, p} = ['ang', WriteType(1),             ...
                      num2str(p),',',num2str(k)];
                else
                  colheader{2*k-1, p} = ['mag', WriteType(1),           ...
                      num2str(p), num2str(k)];
                  colheader{2*k, p} = ['ang', WriteType(1),             ...
                      num2str(p), num2str(k)];
                end
              end
            end
          case 'DB'
            for p = 1:nPort
              for k = 1:nPort
                if nPort >= 10
                  colheader{2*k-1, p} = ['db', WriteType(1),            ...
                      num2str(p), ',',num2str(k)];
                  colheader{2*k, p} = ['ang', WriteType(1),             ...
                      num2str(p), ',',num2str(k)];
                else
                  colheader{2*k-1, p} = ['db', WriteType(1),            ...
                      num2str(p),num2str(k)];
                  colheader{2*k, p} = ['ang', WriteType(1),             ...
                      num2str(p),num2str(k)];
                end
              end
            end
        end
  end
end

% create a cell array to store powerdata
if ~isemptypower(h, isAMP)
    powercell = cell(1, numel(h.Reference.PowerData.Pin));
    nPin = numel(h.Reference.PowerData.Pin);
    for k = 1:nPin
        % each cell contains an N by 3 matrix: [Pin, Pout, Phase]
        powercell{1, k} = [w2dbm(h.Reference.PowerData.Pin{k}),         ...
                w2dbm(h.Reference.PowerData.Pout{k}),                   ...
                h.Reference.PowerData.Phase{k}];
    end
end

% Open file, write comments and column headers.
fid = fopen(filename, 'wt');
% Throw an error when fid is -1
if fid == -1
    error(message('rf:rfdata:data:write:NoWritePermission', filename))  
end
% File header for AMP file
if isAMP
    fprintf(fid, '* %s: %s\n', filename,                                ...
       'the data of a nonlinear network in .AMP format of the MathWorks.');
end

% Write network parameters section if s_parameters exist
if ~isemptysparam(h)
    % SNP file:network parameters section header
    if ~isAMP
        % First line
        fprintf(fid, '# %s %s %s %s %s\n', funit, WriteType(1),         ...
            upper(dataformat), 'R', num2str(Z0));
        % Second line
        fprintf(fid, '! %s data\n', typetitle);
        % Third line that contains the column headers
        fprintf(fid, '! Freq');
        % Write column headers that show how numerical data is printed.
        switch nPort
            case {1, 2}
                headerformat = [repmat('%8s',1,2*nPort*nPort), '\n']; 
            case {3, 4}
                headerformat = repmat([repmat('%8s',1,2*nPort),         ...
                    '\n!', blanks(5)], 1, nPort); 
                headerformat = [headerformat, '\n'];
            otherwise
                % If nPort is larger than 4,
                % each line contains 4 network parameters
                headerformat = [repmat([repmat('%12s',1,8),             ...
                    '\n!', blanks(5)], 1, floor(2*nPort*nPort/8)),      ...
                    repmat('%12s',1,mod(2*nPort*nPort,8))];
                headerformat = [headerformat, '\n'];
        end
        fprintf(fid, headerformat, colheader{:}); 
    else % AMP file:network parameters section header
        fprintf(fid, '%s %s %s %s\n', WriteType(1), upper(dataformat),  ...
            'R', num2str(Z0)); % First line
        fprintf(fid, '%s %s\n', 'FREQ', funit); % Second line
        fprintf(fid, '* Freq'); % Third line contains the column headers
        % Write column headers that show how numerical data is printed.
        % Amplifier must be 2-port
        headerformat = [repmat('%8s',1,2*nPort*nPort), '\n']; 
        fprintf(fid, headerformat, colheader{:}); 
    end
    
    % Network parameters section data:write frequency and netdata.
    netformat = [' ', printformat];
    switch nPort
        case {1, 2}
            totformat = [freqformat, repmat(netformat, 1, Col-1), '\n'];
        case{3, 4}
            % Find the length of spaces before the second data line.
            tempL = floor(abs(str2double(freqformat(2:end-1))));
            totformat = [freqformat,                                    ...
                repmat([repmat(netformat,1,2*nPort),                    ...
                '\n', blanks(tempL)], 1, nPort)];
            totformat = deblank(totformat);
        otherwise 
            % If nPort is larger than 4,
            % (1) each line contains a max of 4 network parameters, and
            % (2) each port's data must start a new line.
            
            % Build totformat for "1st port"
            totformat = '';
            tempL = floor(abs(str2double(freqformat(2:end-1))));
            nDataLeft = 2*nPort;
            while nDataLeft > 0
                thisN = min(nDataLeft,8);
                newfmt = repmat(netformat,1,thisN);
                totformat = [totformat,blanks(tempL),newfmt,'\n']; %#ok<AGROW>
                nDataLeft = nDataLeft - thisN;
            end
            
            % Replicate totformat for all ports
            totformat = repmat(totformat,1,nPort);
            
            % Insert freqformat at the beginning
            totformat = [freqformat,totformat(tempL+1:end)];
    end
    fprintf(fid, totformat, netdata');
end

% Check if NoiseFreq and NoiseParameters are both nonempty, if NoiseFreq
% is a vector, if NoiseParameters is 2D, if the number of rows in
% NoiseParameters equals the number of noise frequency points, if it is a
% two-port network.
[s1,~,s3] = size(NoiseParameters);
[row, col] = size(squeeze(NoiseFreq));
if ~isempty(NoiseFreq) && ~isempty(NoiseParameters) &&                  ...
        (s3 == 1) && (row == 1 || col == 1)  &&                         ...
        (s1 == numel(NoiseFreq)) && (nPort == 2)
    if isemptysparam(h) && isemptypower(h, isAMP)
        fclose(fid);
        error(message('rf:rfdata:data:write:OnlyContainNoise')); 
    end
    % Write NoiseFreq and noisedata if they exist
    if ~isempty(NoiseFreq)
        switch upper(funit)
            case 'GHZ'
                NoiseFreq  = NoiseFreq ./1e9;
            case 'MHZ'
                NoiseFreq  = NoiseFreq ./1e6;
            case 'KHZ'
                NoiseFreq  = NoiseFreq ./1e3;
        end
        if ~isAMP % SNP file
            fprintf(fid, '! Noise Parameters\n'); %Add one comment line
            fprintf(fid, '! %s %s %s %s %s\n', ['Freq(',funit,')'],     ...
                'Fmin(dB)','GammmaOpt(MA:Mag)', 'GammmaOpt(MA:Ang)',    ...
                'RN/Zo'); % second line:comment
        else % AMP file
            % header for noise data
            fprintf(fid, '\n%s %s\n', 'NOI', 'RN'); % first line
            fprintf(fid, '%s %s\n', 'FREQ', funit); % second line
            fprintf(fid, '* %s %s %s %s %s\n', 'Freq', 'Fmin(dB)',      ...
                'GammmaOpt(MA:Mag)', 'GammmaOpt(MA:Ang)',               ...
                'RN/Zo'); % third line:comment
        end
        noisedata = [NoiseFreq(:), NoiseParameters];
        netformat = [' ', printformat];
        netformat = [freqformat, repmat(netformat, 1, 4), '\n'];
        fprintf(fid, netformat, noisedata');
    end
% elseif ~isempty(NoiseFreq) || ~isempty(NoiseParameters)
%     warning('Incorrect noise data, not written to the file')
elseif ~isemptynf(h, isAMP)
    switch upper(funit)
        case 'GHZ'
            NFFreq = h.Freq/1e9;
        case 'MHZ'
            NFFreq = h.Freq/1e6;
        case 'KHZ'
            NFFreq = h.Freq/1e3;
        otherwise
            NFFreq = h.Freq;
    end
    % header for nf data header
    fprintf(fid, '\n%s %s\n', 'NF', 'dB'); % first line
    fprintf(fid, '%s %s\n', 'FREQ', funit); % second line
    % write power data
    netformat = [freqformat, ' ', printformat, '\n'];
    fprintf(fid, netformat, [NFFreq, h.NF]');
end 

% For amp file, write power data to file
if ~isemptypower(h, isAMP)
    npowercell = numel(powercell);
    for k = 1:npowercell
        if ~isempty(h.Reference.PowerData.Freq)
            switch upper(funit)
                case 'GHZ'
                    PowerFreq = h.Reference.PowerData.Freq(k)/1e9;
                case 'MHZ'
                    PowerFreq = h.Reference.PowerData.Freq(k)/1e6;
                case 'KHZ'
                    PowerFreq = h.Reference.PowerData.Freq(k)/1e3;
                otherwise
                    PowerFreq = h.Reference.PowerData.Freq(k);
            end
        end
        % header for power data header
        fprintf(fid, '\n%s %s\n', 'POUT', 'dBm'); % first line
        if ~isempty(h.Reference.PowerData.Freq)
            fprintf(fid, ['%s %s %s ',freqformat,'%s\n'], 'PIN', 'dBm', ...
                'FREQ =', PowerFreq, funit); % second line
        else
            fprintf(fid, '%s %s\n', 'PIN', 'dBm'); % second line
        end
        fprintf(fid, '* %s %s %s\n', 'Pin', 'Pout',                     ...
            'Phase(degrees)'); % third line:comment
        % write power data
        netformat = [printformat, ' '];
        netformat = [repmat(netformat, 1, 3), '\n'];
        fprintf(fid, netformat, powercell{k}');
    end
    % If no power data exists, write IP3 data to file
elseif ~isemptyip3(h, isAMP)
    switch upper(funit)
        case 'GHZ'
            IP3Freq = h.Freq/1e9;
        case 'MHZ'
            IP3Freq = h.Freq/1e6;
        case 'KHZ'
            IP3Freq = h.Freq/1e3;
        otherwise
            IP3Freq = h.Freq;
    end
    % header for ip3 data header
    fprintf(fid, '\n%s %s\n', 'OIP3', 'dBm'); % first line
    fprintf(fid, '%s %s\n', 'FREQ', funit); % second line
    % write power data
    netformat = [freqformat, ' ', printformat, '\n'];
    fprintf(fid, netformat, [IP3Freq, w2dbm(h.OIP3)]');
end

% close the data file
fclose(fid);
status = true;

%--------------------------------------------------------------------------
function y = isemptysparam(h)
% Check the existence of S_Parameters
y = true;
if ~isempty(get(h, 'S_Parameters'))
    y = false;
end

%--------------------------------------------------------------------------
function result = islegalsparam(h)
%ISLEGALSPARAM Check for s_parameters in an RFDATA.DATA object.
%   RESULT = ISLEGALSPARAM(H) returns True if H is an RFDATA.DATA object
%   that contains legal s_parameters and False otherwise.

% Declare local variables.
Freq = get(h, 'Freq');
S_Parameters = get(h, 'S_Parameters');

% Set the default result to true.
result = true;

% Allow empty s_parameters
if isemptysparam(h)
    return
end

% Check S_Parameters
[~,~,s3,s4] = size(S_Parameters);
if s4 ~= 1 % S_Parameters must be 3D
    result = false;
    return
% The third dimension must equal the number of frequency points    
elseif s3 ~= numel(Freq)
    result = false;
end

%--------------------------------------------------------------------------
function noisedata = getnoisedata(noise)
fmin = get(noise, 'FMIN');
gammaopt = get(noise, 'GAMMAOPT');
rn = get(noise, 'RN');
noisedata(:, 1) = fmin;
noisedata(:, 2) = abs(gammaopt);
noisedata(:, 3) = unwrap(angle(gammaopt)) * 180 / pi;
noisedata(:, 4) = rn;

%--------------------------------------------------------------------------
function y = w2dbm(x)
% Watt to dBM conversion
y = 10*log10(1000*x);

%--------------------------------------------------------------------------
function y = isemptypower(h, isAMP)
% Check the existence of PowerData when fileformat is AMP
y = true;
if isAMP
    if haspowerreference(h)
        if ~isempty(h.Reference.PowerData.Pin)
            y = false;
        end
    end
end

%--------------------------------------------------------------------------
function y = isemptynf(h, isAMP)
% Check the existence of NFData when fileformat is AMP
y = true;
if isAMP
    if any(h.NF)
        y = false;
    end
end

%--------------------------------------------------------------------------
function y = isemptyip3(h, isAMP)
% Check the existence of OIP3Data when fileformat is AMP
y = true;
if isAMP
    if any(isfinite(h.OIP3))
        y = false;
    end
end

%--------------------------------------------------------------------------
function checkprintformat(printformat, name)
% Check if printformat is a C language conversion specifications
if ~ischar(printformat) || ~((isequal(regexpi(strtrim(printformat),     ...
        '%[+-]?[0-9]*[.]?[0-9]*[eg]'), 1) || ...
        isequal(regexp(strtrim(printformat), ...
        '%[+-]?[0-9]*[.]?[0-9]*[fdiu]'), 1)))
    error(message('rf:rfdata:data:write:IllegalPrintFormat', name));
end
