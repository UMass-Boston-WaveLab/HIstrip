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
data = read(data, filename);
setnport(h, getnport(data));
if (getnport(data) ~= 2)
    return
end
ref = getreference(data);
sparam = data.S_Parameters;
if ~isempty(sparam)
    if ~ispassive(sparam,'Impedance',data.Z0)
        hclass = upper(class(h));
        if isempty(h.Block)
            hname = h.Name;
            hrep = 'RFCKT.AMPLIFIER object';
        else
            hname = get_param(h.Block,'Name');
            hrep = 'General Amplifier block';
        end
        error(message('rf:rfckt:passive:read:WrongRFCKTObjNotPassive',hname,hclass,filename,hrep))
    end
end
if isa(ref.NoiseData, 'rfdata.noise')
    if isempty(h.Block)
        hname = h.Name;
        hrep = 'RFCKT.AMPLIFIER';
    else
        hname = get_param(h.Block, 'Name');
        hrep = 'General Amplifier block';
    end
    error(message('rf:rfckt:passive:read:WrongRFCKTObjNoise',           ...
        hname, upper( class( h ) ), filename, hrep));
          
elseif isa(ref.NFData, 'rfdata.nf')
    if isempty(h.Block)
        hname = h.Name;
        hrep = 'RFCKT.AMPLIFIER';
    else
        hname = get_param(h.Block, 'Name');
        hrep = 'General Amplifier block';
    end
    error(message('rf:rfckt:passive:read:WrongRFCKTObjNF',              ...
        hname, upper( class( h ) ), filename, hrep));
elseif isa(ref.PowerData, 'rfdata.power')
    if isempty(h.Block)
        hname = h.Name;
        hrep = 'RFCKT.AMPLIFIER';
    else
        hname = get_param(h.Block, 'Name');
        hrep = 'General Amplifier block';
    end
    error(message('rf:rfckt:passive:read:WrongRFCKTObjPower',           ...
        hname, upper( class( h ) ), filename, hrep));
elseif isa(ref.IP3Data, 'rfdata.ip3')
    if isempty(h.Block)
        hname = h.Name;
        hrep = 'RFCKT.AMPLIFIER';
    else
        hname = get_param(h.Block, 'Name');
        hrep = 'General Amplifier block';
    end
    error(message('rf:rfckt:passive:read:WrongRFCKTObjIP3',             ...
        hname, upper( class( h ) ), filename, hrep));
elseif isa(ref.MixerspurData, 'rfdata.mixerspur')
    if isempty(h.Block)
        hname = h.Name;
        hrep = 'RFCKT.MIXER';
    else
        hname = get_param(h.Block, 'Name');
        hrep = 'General Mixer block';
    end
    error(message('rf:rfckt:passive:read:WrongRFCKTObjSpur',            ...
        hname, upper( class( h ) ), filename, hrep));
end
if all(data.NF == 0)
    restore(h);
end