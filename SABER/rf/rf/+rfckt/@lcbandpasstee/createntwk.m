function h = createntwk(varargin)
%CREATENTWK Create LC bandpass tee ladder filter network
%
%   See also RFCKT.LCBANDPASSTEE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC bandpass tee network
numSections = floor((numel(c)+1)/2);
la = l(1:2:end);
lb = l(2:2:end);
ca = c(1:2:end);
cb = c(2:2:end);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    comp1 = rfckt.seriesrlc('L', la(num)); 
    comp2 = rfckt.seriesrlc('C', ca(num)); 
    indx = indx+1;
    ckts{indx} = comp1;
    indx = indx+1;
    ckts{indx} = comp2;

    if num <= numel(lb)
        comp1 = rfckt.shuntrlc('L', lb(num)); 
        comp2 = rfckt.shuntrlc('C', cb(num)); 
        indx = indx+1;
        ckts{indx} = comp1;
        indx = indx+1;
        ckts{indx} = comp2;
    end
end

% Create cascade from individual LC circuits
set(h, 'Ckts', ckts);