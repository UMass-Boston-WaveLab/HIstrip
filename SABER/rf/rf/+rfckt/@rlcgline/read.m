function h = read(h,filename)
%READ Read passive network parameters from a Touchstone data file.
%   H = READ(H, FILENAME) reads passive network parameters from a .SNP,
%   .YNP, .ZNP, or .HNP file and updates the property: NetworkData. 
%
%   FILENAME is a Touchstone data file name. If empty, NetworkData is
%   empty. 
%
%   See also RFCKT.PASSIVE, RFCKT.PASSIVE/WRITE, RFCKT.PASSIVE/RESTORE

%   Copyright 2003-2015 The MathWorks, Inc.

if nargin == 1
    filename = '';
end

% Get the data object
data = get(h,'AnalyzedResult');
if ~isa(data,'rfdata.data')
    setrfdata(h,rfdata.data);
    data = get(h,'AnalyzedResult');
end
if hasreference(data)
    data.Reference.Date = '';
end
data = read(data,filename);
setnport(h,getnport(data));
if (getnport(data) ~= 2)
    return
end

sparam = data.S_Parameters;
if ~isempty(sparam)
    if ~ispassive(sparam,'Impedance',data.Z0) 
        error(message('rf:rfckt:rlcgline:read:WrongRFCKTObj',h.Name,upper(class(h)),filename))
    end
end

s = s2rlgc(data.S_Parameters,h.LineLength,data.Freq,data.Z0);

h.Freq = data.Freq;
h.R = squeeze(s.R);
h.L = squeeze(s.L);
h.G = squeeze(s.G);
h.C = squeeze(s.C);