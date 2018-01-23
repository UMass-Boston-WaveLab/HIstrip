function h = createntwk(varargin)
%CREATENTWK Create LC bandtop tee ladder filter network
%
%   See also RFCKT.LCBANDSTOPTEE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC bandstop tee network
numSections = floor((numel(c)+1)/2);
la = l(1:2:end);
lb = l(2:2:end);
ca = c(1:2:end);
cb = c(2:2:end);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    comp1 = rfckt.seriesrlc('L', la(num)); 
    comp2 = rfckt.seriesrlc('C', ca(num)); 
    seriesckt = rfckt.parallel;
    seriesckt.Ckts = {comp1, comp2}; 
    ckts{indx} = seriesckt;

    indx = indx+1;
    if num <= numel(lb)
        comp1 = rfckt.shuntrlc('L', lb(num)); 
        comp2 = rfckt.shuntrlc('C', cb(num)); 
        shuntckt = rfckt.series;
        shuntckt.Ckts = {comp1, comp2}; 
        ckts{indx} = shuntckt;
    end
end

% Create cascade from individual RLC circuits
set(h, 'Ckts', ckts);