function status = write(varargin)
%WRITE Create the formatted RF network data file.
%   STATUS = WRITE(H, FILENAME, DATAFORMAT, FUNIT, PRINTFORMAT, FREQFORMAT)
%   creates a .SNP, .YNP, .ZNP, .HNP or .AMP file using information from
%   the property 'AnalyzedResult', returns STATUS = True if successful and
%   False otherwise.
%
%   H is the RFCKT object whose property 'AnalyzedResult' contains
%   sufficient information to write a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%   FILENAME is a string, representing the name of the file to be written.
%   DATAFORMAT is a string that can only be 'RI','MA' or 'DB'. FUNIT is a
%   string, representing the frequency units, it can only be 'GHz','MHz',
%   'KHz' or 'Hz'. PRINTFORMAT is a string that specifies the precision of
%   the network and noise parameters. FREQFORMAT is a string that specifies
%   the precision of the frequency. See the list of allowed precisions
%   under FPRINTF.
% 
%   See also RFCKT, RFCKT.RFCKT/READ, RFCKT.RFCKT/ANALYZE

%   Copyright 2003-2009 The MathWorks, Inc.

status = false;

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Write the data by calling the method of RFDATA.DATA object
if isa(data, 'rfdata.data')
    status = write(data, varargin{2:end});
end