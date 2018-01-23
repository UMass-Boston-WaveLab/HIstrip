function h = read(h, filename)
%READ Read data from a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%   H = READ(H, FILENAME) reads data from a data file and updates
%   properties of the RFDATA of H. FILENAME is a string,
%   representing the filename of a .SNP, .YNP, .ZNP or .AMP file.
%
%   H = READ(H) read the data from H.File file. The default H.File is
%   'passive.s2p'.
%
%   See also RFCKT.DATAFILE, RFCKT.DATAFILE/WRITE, RFCKT.DATAFILE/RESTORE

%   Copyright 2003-2005 The MathWorks, Inc.

% Get the data object
data = get(h, 'AnalyzedResult');
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = get(h, 'AnalyzedResult');
end
if nargin == 1
    filename = h.File;
else
    h.File = filename;
end

if isempty(filename)
    data = read(data);
    set(h, 'File', data.Reference.Name);
    setnport(h, getnport(data));
else
    data = read(data, filename);
    setnport(h, getnport(data));
end