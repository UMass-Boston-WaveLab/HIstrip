function [filename, filetype] = getfile(h, filename)
%GETFILE Find and check the data filename extension.
%   [FILENAME, FILETYPE] = GETFILE(H, FILENAME) checks the FILENAME to see
%   if it has a valid filename extension.  If it has, returns the filename
%   as well as the file type. Otherwise, the returned FILENAME and FILETYPE
%   are empty.
%
%   [FILENAME, FILETYPE] = GETFILE(H) allows the user to select a file and
%   then checks the filename.  If it is valid, returns the filename as well
%   as the file type. Otherwise, the returned FILENAME and FILETYPE are
%   empty.
%
%   H is the RFDATA.DATA object. FILENAME is a string, representing the
%   filename of a .SNP, .YNP, .ZNP, .HNP, .GNP, .S2D, .P2D or .AMP file.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default.
filetype = '';

% Get the filename
if nargin == 1 || (nargin == 2 && isempty(filename))
    % Ask user to select a file.
    [filename, pathname] = uigetfile({'*.*p;*.*P;*.s2d;*.S2D;*.p2d;*.P2D',...
        'All RF Files (*.*p,*.s2d,*.p2d)';...
        '*.s*p;*.S*P','SNP Files (*.s*p)';...
        '*.amp;*.AMP','AMP Files (*.amp)';...
        '*.s2d;*.S2D','S2D Files (*.s2d)';...
        '*.p2d;*.P2D','P2D Files (*.p2d)';...
        '*.y*p;*.Y*P','YNP Files (*.y*p)';...
        '*.z*p;*.Z*P','ZNP Files (*.z*p)';...
        '*.h*p;*.H*P','HNP Files (*.h*p)';...
        '*.g*p;*.G*P','GNP Files (*.g*p)';...
        '*.*','All Files (*.*)'},...
        'Select an RF data file');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    filename = fullfile(pathname, filename);
end

% Check the filename
if ~ischar(filename)
    error(message('rf:rfdata:data:getfile:filenamenotstring'));
end
filename = strtrim(filename);

file_ext = fliplr(strtok(fliplr(filename), '.'));
if numel(file_ext) < 3
    error(message('rf:rfdata:data:getfile:unsupportedfile'));
end

% Check the filename extension
if strncmpi(filename(end-2:end), 'amp', 3)
    filetype = 'AMP';
elseif strncmpi(filename(end-2:end), 's2d', 3)
    filetype = 'S2D';
elseif strncmpi(filename(end-2:end), 'p2d', 3)
    filetype = 'P2D';
elseif strncmpi(filename(end), 'p', 1)
    switch upper(file_ext(1))
        case 'S'
            filetype = 'SNP';
        case 'Y'
            filetype = 'YNP';
        case 'Z'
            filetype = 'ZNP';
        case 'H'
            filetype = 'HNP';
        case 'G'
            filetype = 'GNP';
        otherwise
            error(message('rf:rfdata:data:getfile:unsupportedfile'));
    end
else
    error(message('rf:rfdata:data:getfile:unsupportedfile'));
end

% Check if the file exists.
if ~exist(filename, 'file')
    error(message('rf:rfdata:data:getfile:filenotfound', filename));
end