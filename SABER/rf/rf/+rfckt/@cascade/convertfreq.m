function out = convertfreq(h,in,varargin)
%CONVERTFREQ Convert the input frequency to get the output frequency.
%    OUTPUT = CONVERTFREQ(h, input) Convert the input frequency to
%    get the output frequency.
%
%   See also RFCKT.CASCADE

%   Copyright 2003-2007 The MathWorks, Inc.

p = inputParser;
addOptional(p,'throwmessage',true);
addParameter(p,'isspurcalc',false);
parse(p,varargin{:});

throwmsg = p.Results.throwmessage;
spurbool = p.Results.isspurcalc;

out = in;
% Get and check the cascaded CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Calculate the output frequency
for ii=1:nckts
    ckt = ckts{ii};
    out = convertfreq(ckt,out,throwmsg,'isSpurCalc',spurbool);
end