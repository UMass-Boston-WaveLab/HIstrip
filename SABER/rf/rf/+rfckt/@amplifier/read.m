function h = read(h, filename)
%READ Read amplifier data from a Touchstone or .AMP data file.
%   H = READ(H, FILENAME) reads amplifier data from a .SNP, .YNP, .ZNP,
%   .HNP, or .AMP file and updates the property: NetworkData, NoiseData,
%   NFData, PowerData, and IP3Data. 
%
%   FILENAME is a Touchstone or .AMP data file name. If empty, NetworkData,
%   NoiseData, NFData, PowerData, and IP3Data. are empty. 
%
%   See also RFCKT.AMPLIFIER, RFCKT.AMPLIFIER/WRITE, RFCKT.AMPLIFIER/RESTORE

%   Copyright 2003-2007 The MathWorks, Inc.

if nargin == 1
    filename = '';
end
% Get the data object
data = get(h, 'AnalyzedResult');
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = get(h, 'AnalyzedResult');
end
if hasreference(data)
    data.Reference.Date = '';
end
data = read(data, filename);
setnport(h, getnport(data));
if h.nPort ~= 2 
    rferrhole1 = '';
    if isempty(h.Block)
        rferrhole1 = [h.Name, ': '];
    end
    rferrhole2 = upper(class(h));
    error(message('rf:rfckt:amplifier:read:TwoPortDataOnly',            ...
        rferrhole1, rferrhole2));
end
ref = getreference(data);
if isa(ref.MixerspurData, 'rfdata.mixerspur')
    if isempty(h.Block)
        rferrhole1 = h.Name;
        rferrhole4 = 'RFCKT.MIXER';
    else
        rferrhole1 = get_param(h.Block, 'Name');
        rferrhole4 = 'General Mixer block';
    end
    rferrhole2 = upper(class(h));
    rferrhole3 = filename;
    error(message('rf:rfckt:amplifier:read:WrongRFCKTObj',              ...
        rferrhole1, rferrhole2, rferrhole3, rferrhole4));
end
if all(data.NF == 0)
    restore(h);
end