function out = convertfreq(h,in,varargin)
%CONVERTFREQ Convert the input frequency to get the output frequency.
%    OUTPUT = CONVERTFREQ(h, input) Convert the input frequency to
%    get the output frequency.
%
%   See also RFCKT.MIXER

%   Copyright 2003-2007 The MathWorks, Inc.

p = inputParser;
addOptional(p,'throwmessage',true);
addParameter(p,'isspurcalc',false);
parse(p,varargin{:});

throwmsg = p.Results.throwmessage;
spurbool = p.Results.isspurcalc;

switch h.MixerType
  case 'Downconverter'
    out = in - h.FLO;
    negidx = out <= 0;
    if spurbool
        out(negidx) = -1*out(negidx);
    else
        if all(negidx)
            out = -out;
        end
    end
  case 'Upconverter'
    out = in + h.FLO;
end
out = sort(out);
if throwmsg
    index = find(out == 0.0);
    if any(index)
        out(index) = 1.0;
    end
    if any (out < 0)
        rferrhole = '';
        if isempty(h.Block)
            rferrhole = [h.Name, ': '];
        end
        error(message(['rf:rfckt:mixer:convertfreq:'                    ...
            'MixerNegativeOutFrequency'], rferrhole));
    end
end