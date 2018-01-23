function output = antennaMatchObjectiveFun(matchingNW,Lvalues,freq,ZL,Z0)
%ANTENNAMATCHOBJECTIVEFUN is the objective function used by the example
% Designing Broadband Matching Networks (Part I: Antenna), which can be
% found in broadband_match_antenna.m.
%
% OUTPUT = ANTENNAMATCHOBJECTIVEFUN(MATCHINGNW,LVALUES,FREQ,Z0)
% returns the current value of the objective function stored in OUTPUT
% evaluated after updating the inductor values in the object, MATCHINGNW.
% The inductor values are stored in the variable LVALUES.
%
% ANTENNAMATCHOBJECTIVEFUN is an objective function of RF Toolbox demo:
% Designing Broadband Matching Networks (Part I: Antenna)

%   Copyright 2008-2015 The MathWorks, Inc.

% Ensure positive element values
if any(Lvalues <= 0)                                                       
    output = Inf;
    return
end

% Update the element values in the matching network
matchingNW.Inductances(1) = Lvalues(1);
matchingNW.Inductances(end) = Lvalues(end);

% Perform analysis on tuned matching network
S = sparameters(matchingNW,freq,Z0);

% Calculate input reflection coefficient 'gammaIn'
gIn = gammain(S,ZL);

% Cost function
output = mean(abs(gIn));

% Other possible choices for objective function could be : -
% output =  max(abs(gIn));
% output = -1*mean(Gt_pass);

% Animate
l = smithchart(gIn);
set(l,'DisplayName','Optimizing \Gamma_i_n');
drawnow