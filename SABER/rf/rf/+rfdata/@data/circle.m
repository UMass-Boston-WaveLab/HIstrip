function varargout = circle(h, varargin)

%CIRCLE Draw circles on a Smith chart.
%   [HLINES, HSM] = CIRCLE(H, FREQ, TYPE1, VALUE1, ... TYPEN, VALUEN, HSM)
%   draws circles on a Smith chart and returns the following handles: 
%   HLINES: a vector of handles to line objects, with one handle per circle
%   HSM: the handle to the Smith chart
%
%   H is the handle to an RFDATA.DATA object. FREQ is a single frequency
%   point of interest. TYPE1, VALUE1, ... TYPEN, VALUEN are the type/value
%   pairs that specify the circles to plot. The supported circle TYPEs are:
%   'Ga'    --  Constant available power gain circle
%   'Gp'    --  Constant operating power gain circle
%   'Stab'  --  Stability circle
%   'NF'    --  Constant noise figure circle
%   'R'     --  Constant resistance circle
%   'X'     --  Constant reactance circle
%   'G'     --  Constant conductance circle
%   'B'     --  Constant susceptance circle
%   'Gamma' --  Constant reflection magnitude circle
%
%   The allowed VALUEs for the above types of circles are:
%   'Ga'    --  Scalar or vector of gains in dB
%   'Gp'    --  Scalar or vector of gains in dB
%   'Stab'  --  String 'in' or 'source' for input/source stability circle;
%               string 'out' or 'load' for output/load stability circle. 
%   'NF'    --  Scalar or vector of noise figures in dB
%   'R'     --  Scalar or vector of normalized resistance
%   'X'     --  Scalar or vector of normalized reactance
%   'G'     --  Scalar or vector of normalized conductance
%   'B'     --  Scalar or vector of normalized susceptance
%   'Gamma' --  Scalar or vector of non-negative reflection magnitude
%
%   HSM is an optional input argument that you can use to place circles on
%   an existing Smith chart.
%
%   See also RFDATA.DATA, RFDATA.DATA/SMITH

%   Copyright 2007-2009 The MathWorks, Inc.

nargoutchk(0,2);

% Check number of input arguments
narginchk(4,Inf)

% Must be 2-port
checknport(h, getnport(h), 2, 'circle', 'data')

% Check the second input argument, which must be a positive scalar
freq = varargin{1};
varargin = varargin(2:end);
if ~(isnumeric(freq) && isreal(freq) && isscalar(freq) ...
        && (freq > 0))
    error(message('rf:rfdata:data:circle:IncorrectFreq'))
end

% Check the last input argument, which may be a handle to a smith chart
hold_state = ishold; % Save the current hold state
if strcmpi(class(varargin{end}), 'rfchart.smith')
    hsm = varargin{end};
    varargin = varargin(1:end-1);
else
    fig = findfigure(h);
    hsm = [];
    hold_state = false;
    if ~(fig==-1)
        hold_state = ishold;
        % Current axes may contain a Smith chart
        if isappdata(gca, 'SmithChart')
            hsm = getappdata(gca, 'SmithChart');
        end
        % Create the chart
        if ~hold_state || ~strcmpi(class(hsm), 'rfchart.smith')
            hsm = rfchart.smith('NeedReset', h.NeedReset); 
        end
     else
        hsm = rfchart.smith('NeedReset', h.NeedReset);
    end
end

% Check types of circles and corresponding values
if mod(numel(varargin), 2) ~= 0 % Types and values must be in pairs
    if ischar(varargin{end})
        error(message('rf:rfdata:data:circle:TypeValueNotInPair',...
            varargin{end}))
    else
        error(message('rf:rfdata:data:circle:LastArgNotSmith'))
    end
end
checkcircletype(varargin(1:2:end)); 

% Get s_parameters at a single frequency.
[temptype,tempnet,tempz0] = nwa(h,freq);
mysparam = convertmatrix(h,tempnet,temptype,'S-PARAMETERS',tempz0,tempz0);
constants = getconstants(mysparam);
[nfmin,gammaopt,rn] = getnoise(h,freq); % Get noise parameters

% Check values based on their types
ninputs = numel(varargin);
for kk = 1:2:ninputs
    switch lower(varargin{kk})
        case 'stab'
            check_stab_value(varargin{kk+1});
        case 'ga'
            check_ga_value(varargin{kk+1}, mysparam);
        case 'gp'
            check_gp_value(varargin{kk+1}, mysparam, constants);
        case 'nf'
            check_nf_value(varargin{kk+1}, nfmin);
        case 'r'
            check_r_value(varargin{kk+1});
        case 'x'
            check_x_value(varargin{kk+1});
        case 'g'
            check_g_value(varargin{kk+1});
        case 'b'
            check_b_value(varargin{kk+1});
        case 'gamma'
            check_gamma_value(varargin{kk+1});
    end
end

axes(hsm.Axes);
axis([-1.2 1.2 -1.2 1.2])
if ~hold_state
    hold all % Use hold all in order to plot multiple lines
end

% Plot circles one by one
[~,tempf,funit] = scalingfrequency(h, freq);
ninputs = numel(varargin);
for kk = 1:2:ninputs
    [cen,rad,desc,info] = getcircle(mysparam,constants,nfmin,gammaopt,...
        rn,varargin{kk},varargin{kk+1});
    [tempx,tempy] = circlexy(cen,rad); % Get xdata and ydata of circles
    validate_circle(cen,rad,varargin{kk},varargin{kk+1},desc,tempx,tempy);
    if any(strcmpi(varargin{kk},{'r','x','g','b','gamma'}))
        templ = sprintf('%s',desc);
    else
        templ = sprintf('%s(Freq=%g%s)',desc,tempf,funit);
    end
    hlines((kk+1)/2) = plot(tempx,tempy,'DisplayName',templ); %#ok<AGROW>
    circletip(h, hlines((kk+1)/2),varargin{kk},info,hsm);
end

if ~hold_state
    hold off
end

if nargout > 0
    varargout{1} = hlines;
    if nargout ==2
        varargout{2} = hsm;
    end
end

end % of circle

%------------------------------------
function checkcircletype(type)
% Make sure the type of circles are supported.

allknowntypes = {'Stab','Ga','Gp','NF','R','X','G','B','Gamma'};
% Type is a cell of strings
ntype = numel(type);
for ii = 1:ntype
    if ~ischar(type{ii})
        error(message('rf:rfdata:data:circle:CircleTypeIsNotChar'))
    end
    if ~any(strcmpi(type{ii},allknowntypes))
        tempstr = sprintf('%s, ',allknowntypes{:});
        tempstr = tempstr(1:end-2);
        error(message('rf:rfdata:data:circle:UnknownCircleType',...
            tempstr,type{ii}));
    end
end

end % of checkcircletype

%--------------------------------------
function check_stab_value(val)

if ~any(strcmpi(val,{'in','out','load','source'}))
    error(message('rf:rfdata:data:circle:UnknownStabFlag'))
end

end % of check_stab_value

%--------------------------------------
function check_ga_value(val,sparam)
% Check gain values for available gain circles

check_real_vector(val,'constant available gain');
Gmax = 10*log10(powergain(sparam,'Gmag')); % Maximum gain   
if any(val > Gmax)
    error(message('rf:rfdata:data:circle:GaGreaterThanMax',...
        sprintf('%4.2f',Gmax )));
end

end % of check_ga_value

%--------------------------------------
function check_gp_value(val,sparam,constants)
% Check gain values for operating gain circles

check_real_vector(val,'constant operating gain');
% Find out if it is unconditionally stable
uncond_stab = isstable(sparam);
k = constants.K;

if uncond_stab % Unconditionally stable
    Gmax = 10*log10(powergain(sparam,'Gmag')); % Maximum gain   
    if any(val > Gmax)
        error(message('rf:rfdata:data:circle:GpGreaterThanMax',...
            sprintf('%4.2f',Gmax )))
    end
    
elseif k > 1 % Potentially unstable
    s12 = sparam(1,2,1);
    s21 = sparam(2,1,1);
    Gmin = 10*log10(abs(s21) / abs(s12) * (k + sqrt(k^2 - 1)));
    if any(val < Gmin)
        error(message('rf:rfdata:data:circle:GpLessThanMin',...
            sprintf('%4.2f',Gmin )))
    end
    
end

end % of check_gp_value

%--------------------------------------
function check_nf_value(val, nfmin)
% Check noise figure values of noise figure circles

check_real_vector(val,'constant noise figure');
% If noise parameters do not exist, throw error
if isempty(nfmin)
    error(message('rf:rfdata:data:circle:NoNoiseParameters'))
end

% Noise figure must be greater than nfmin
if any(val < nfmin)
    error(message('rf:rfdata:data:circle:NFSmallerThanMin',...
        sprintf('%4.2f',nfmin )))
end

end % of check_nf_value

%--------------------------------------
function check_r_value(val)
% Check resistance value

check_real_vector(val,'constant resistance circle');

end % of check_r_value

%--------------------------------------
function check_x_value(val)
% Check for reactance

check_real_vector(val,'constant reactance circle');

end % of check_x_value

%--------------------------------------
function check_g_value(val)
% Check for conductance

check_real_vector(val,'constant conductance circle');

end % of check_g_value

%--------------------------------------
function check_b_value(val)
% Check for susceptance

check_real_vector(val,'constant susceptance circle');

end % of check_b_value

%--------------------------------------
function check_gamma_value(val)
% Check for reflection coefficient

if ~(isnumeric(val) && isreal(val) && isvector(val) && all(val >= 0))
    error(message('rf:rfdata:data:circle:WrongReflectionMag'))
end

end % of check_gamma_value

%--------------------------------------
function check_real_vector(val,desc)
% Check for real vector

if ~(isnumeric(val) && isreal(val) && isvector(val))
    error(message('rf:rfdata:data:circle:NotRealVector',desc))
end

end % of check_real_vector

%-------------------------------------------
function [nfmin,gammaopt,rn] = getnoise(mydata,freq)
% Get noise parameters
if hasnoisereference(mydata) % Find out if nfmin, Gopt and Rn exist.
    tempref = getreference(mydata);
    noisedata = tempref.NoiseData;
    nfmin = calculate(noisedata,'FMIN',freq);
    gammaopt = calculate(noisedata,'GAMMAOPT',freq);
    rn = calculate(noisedata,'RN',freq);
else
    nfmin = [];
    gammaopt = [];
    rn = [];
end
end % of getnoise

%------------------------------------------
function [center,radius,desc,infostruct] = getcircle(sparam,constants,...
    nfmin,gammaopt,rn,type,value)
%GETCIRCLE Return centers and radius of all types of circles
% on the Smith chart.
%   It also returns a string, DESC to be used for legend and a structure,
%   INFOSTRUCT to be used for data tip.

infostruct = '';

switch lower(type)
    case 'stab'
        if strcmpi(value,'in') || strcmpi(value,'source')
            [center, radius] = stabilityincircle(sparam,constants);
            desc = 'Input Stability';
        else
            [center,radius] = stabilityoutcircle(sparam,constants);
            desc = 'Output Stability';
        end

        [xstabreg,ystabreg,stabcolor] = stableregion(center,radius,...
            sparam,value); % Get stable region
        
        infostruct = struct('sparam',sparam,'center',center,...
            'radius',radius,'value',value);
        infostruct.sregion = fill(xstabreg,ystabreg,stabcolor,...
            'HandleVisibility','off','HitTest','off','FaceAlpha',...
            0.1,'EdgeColor','none'); 
        
        if ~isstable(sparam)
            set(infostruct.sregion,'Visible','off')
        else
            set(infostruct.sregion,'Visible','on','FaceColor','g')
        end
        
        
    case 'ga'
        [center,radius] = gacircle(sparam,constants,value);
        desc = 'Available Gain';
        matchingcircle = getmatchingcircle(center,radius,sparam,...
            'gammaout');
        infostruct = struct('nfmin',nfmin,'gammaopt',gammaopt,'rn',rn,...
            'sparam',sparam,'center',center,'radius',radius);
        infostruct.matchingcircle = matchingcircle;
        
    case 'gp'
        [center,radius] = gpcircle(sparam,constants,value);
        desc = 'Operating Gain';
        matchingcircle = getmatchingcircle(center,radius,sparam,'gammain');
        infostruct = struct('sparam',sparam,'center',center,...
            'radius',radius);
        infostruct.matchingcircle = matchingcircle;
                
    case 'nf'
        [center,radius] = noisecircle(nfmin,gammaopt,rn,value);
        desc = 'Noise Figure';
        matchingcircle = getmatchingcircle(center,radius,sparam,...
            'gammaout');
        infostruct = struct('nfmin',nfmin,'gammaopt',gammaopt,'rn',rn,...
            'sparam',sparam,'center',center,'radius',radius);
        infostruct.matchingcircle = matchingcircle;
        
    case 'r'
        [center,radius] = rcircle(value);
        desc = 'Resistance';
    case 'x'
        [center,radius] = xcircle(value);
        desc = 'Reactance';
    case 'g'
        [center,radius] = gcircle(value);
        desc = 'Conductance';
    case 'b'
        [center,radius] = bcircle(value);
        desc = 'Susceptance';
    case 'gamma'
        [center,radius] = gammacircle(value);
        desc = '|Gamma|';
end

end % of getcircle

%-------------------------------
function matchingcircle = getmatchingcircle(center,radius,sparam,flag)
% Get xdata and ydata of a circle that matches a constant gain circle

num_circle = numel(center); % Number of circles
matchingcircle = cell(1, numel(center));
% Get x and y of the corresponding gammas circles
for  ii = 1:num_circle
    [tempx,tempy] = circlexy(center(ii),radius(ii),256);
    tempz = gamma2z(tempx + 1i*tempy, 1);
    switch lower(flag)
        case 'gammain'
            tempgamma = gammain(repmat(sparam,[1,1,numel(tempz)]),1,tempz);
        otherwise
            tempgamma = gammaout(repmat(sparam,[1,1,numel(tempz)]),...
                1,tempz);
    end
    matchingcircle{ii} = conj(tempgamma);
end

end % of getmatchingcircle

%--------------------------------------------------
function [center,radius] = gacircle(sparam,constants,gain)
%GACIRCLE Return constant available power gain circle.

C1 = constants.C1;
D1 = constants.D1;
delta = constants.DELTA;

s11 = squeeze(sparam(1,1,1));
s12 = squeeze(sparam(1,2,1));
s21 = squeeze(sparam(2,1,1));
s22 = squeeze(sparam(2,2,1));

g = (10.^(gain/10)) ./ (abs(s21)^2); 
g = g(:);
center = g .* conj(C1) ./ (1 + g.*D1);
temp1 = (g.^2).*((abs(s12)*abs(s21))^2) - ...
    g.*(1 - abs(s11)^2 - abs(s22)^2 + abs(delta)^2) + 1;
temp2 = abs(1 + g.*D1);
radius = sqrt(temp1) ./ temp2;

end % of gacircle

%------------------------------------------
function [center,radius] = gammacircle(gamma)
%GAMMACIRCLE Return constant gamma circles.

center = zeros(size(gamma));
radius = gamma;

end % of gammacircle

%-----------------------------------------------
function [center,radius] = gpcircle(sparam,constants,gain)
%GPCIRCLE Return constant operating power gain circles.

C2 = constants.C2;
D2 = constants.D2;
delta = constants.DELTA;
s11 = squeeze(sparam(1,1,1));
s12 = squeeze(sparam(1,2,1));
s21 = squeeze(sparam(2,1,1));
s22 = squeeze(sparam(2,2,1));
g = (10.^(gain/10)) ./ (abs(s21)^2);
g = g(:);
center = g .* conj(C2) ./ (1 + g.*D2);
temp1 = (g.^2).*((abs(s12)*abs(s21))^2) - ...
    g.*(1 - abs(s11)^2 - abs(s22)^2 + abs(delta)^2) + 1;
temp2 = abs(1 + g.*D2);
radius = sqrt(temp1) ./ temp2;

end % of gpcircle

%------------------------------------------------
function [center,radius] = noisecircle(fmin,gammaopt,rn,nf)
%NOISECIRCLE Return constant noise figure circles.

f = (10.^(nf/10));
fmin = (10.^(fmin/10));

N = (f - fmin) .* (abs(1 + gammaopt).^2) ./ 4 ./ rn;
center = gammaopt ./(N + 1);
temp1 = N.^2 + N.*(1 - abs(gammaopt).^2);
temp2 = N + 1;
radius = sqrt(temp1) ./ temp2;

end % of noisecircle

%-----------------------------------------------
function [center,radius] = rcircle(r)
%RCIRCLE Return constant resistance circles.

center = r ./ (r + 1);
radius = abs(1 ./ (r + 1));

end % of rcircle

%---------------------------------------------
function [center,radius] = xcircle(x)
%XCIRCLE Return constant reactance circles.

center = 1 + 1i*(1 ./ x);
radius = abs(1 ./ x);

end % of xcircle

%---------------------------------------------
function [center,radius] = gcircle(g)
%GCIRCLE Return constant conductance circles.

[center, radius] = rcircle(g);
center = -center;

end % of gcircle

%-------------------------------------
function [center,radius] = bcircle(b)
%BCIRCLE Return constant susceptance circles.

[center, radius] = xcircle(b);
center = -center;

end % of bcircle

%------------------------------------------------
function [center,radius] = stabilityincircle(sparam,constants)
%STABILITYINCIRCLE Return input stability circle.

C1 = constants.C1;
D1 = constants.D1;
s12 = squeeze(sparam(1, 2, 1));
s21 = squeeze(sparam(2, 1, 1));
center = conj(C1) ./ D1;
radius = abs(s12.*s21) ./ abs(D1);

end % of stabilityincircle

%-------------------------------------------------------
function [center,radius] = stabilityoutcircle(sparam,constants)
%STABILITYOUTCIRCLE Return output stability circle.

C2 = constants.C2;
D2 = constants.D2;
s12 = squeeze(sparam(1, 2, 1));
s21 = squeeze(sparam(2, 1, 1));
center = conj(C2) ./ D2;
radius = abs(s12.*s21) ./ abs(D2);

end % of stabilityoutcircle

%--------------------------------------------------------------
function [x,y,color] = stableregion(cstab,rstab,sparam,type)
%STABLEREGION Return xdata and ydata of the line that encloses the stable
%region.

% Find all points on the stability circle that are also inside the unite
% circle
[xstab,ystab] = circlexy(cstab,rstab); % Get xdata and ydata of circles
idx = (abs(xstab + 1i*ystab) <= 1);
if ~all(idx) % stability circle is not completely inside unit circle
    [x,y,color] = getregion1(cstab,rstab,sparam,type,xstab,ystab);
else
    [x,y,color] = getregion2(cstab,rstab,sparam,type,xstab,ystab);
end

end % of stableregion

%-----------------------------------------
function [x,y,color] = getregion1(cstab,rstab,sparam,type,xstab,ystab)
% For cases when stability circle is not completely inside unit circle
  
% Find all points on the stability circle that are also inside the unite
% circle
idx = (abs(xstab + 1i*ystab) <= 1);
x = xstab(idx);
y = ystab(idx);

% Get s11 and s22
s11 = sparam(1,1,1);
s22 = sparam(2,2,1);
switch lower(type)
    case {'in','source'} % Input stability circle, use Gammaout and S22.
        color = 'b';
        if abs(s22) < 1 % Stable region includes center of unit circle
            include_origin = true;
        else
            include_origin = false;
        end

    otherwise % Output stability circle, use Gammain and S11.
        color = 'g';
        if abs(s11) < 1 % Stable region includes center of unit circle
            include_origin = true;
        else
            include_origin = false;
        end
end

% Get all points on the unit circle
tempang = linspace(0, 2*pi, 1024);
allpts = exp(1i*tempang);
% Find points that are outside stability circle
idx = (abs(allpts - cstab) > rstab);
pts_outside = allpts(idx);
pts_inside = allpts(~idx);

is_origin_inside = (abs(cstab) <  rstab);
if include_origin
    if  is_origin_inside
        x = [x,real(pts_inside)];
        y = [y,imag(pts_inside)];
    else
        x = [x,real(pts_outside)];
        y = [y,imag(pts_outside)];
    end
else
    if  is_origin_inside
        x = [x,real(pts_outside)];
        y = [y,imag(pts_outside)];
    else
        x = [x,real(pts_inside)];
        y = [y,imag(pts_inside)];
    end
end

% Sort all points by angle
allpts = x + 1i*y;
[~,idx] = sort(angle(allpts));
allpts = allpts(idx);
x = real(allpts);
y = imag(allpts);

end % of getregion1

%-----------------------------------------
function [x,y,color] = getregion2(cstab,rstab,sparam,type,x,y)
% For cases when stability circle is completely inside unit circle
  
% Get s11 and s22
s11 = sparam(1,1,1);
s22 = sparam(2,2,1);
switch lower(type)
    case {'in','source'} % Input stability circle, use Gammaout and S22.
        color = 'b';
        if abs(s22) < 1 % Stable region includes center of unit circle
            include_origin = true;
        else
            include_origin = false;
        end

    otherwise % Output stability circle, use Gammain and S11.
        color = 'g';
        if abs(s11) < 1 % Stable region includes center of unit circle
            include_origin = true;
        else
            include_origin = false;
        end
end

% Get all points on the unit circle
tempang = linspace(0,2*pi,1024);
allpts = exp(1i*tempang);
xunit = real(allpts);
yunit = imag(allpts);

is_origin_inside = (abs(cstab) <  rstab);
if include_origin
    if  is_origin_inside
        % Everything inside the stability circle is stable
    else
        x = [x(1),xunit,x(end:-1:1)];
        y = [y(1),yunit,y(end:-1:1)];
    end
else % Not include origin
    if  is_origin_inside
        x = [x(1),xunit,x(end:-1:1)];
        y = [y(1),yunit,y(end:-1:1)];
    else
        % Everything inside the stability circle is stable
    end
end

end % of getregion2

%-------------------------------------------------------
function [x,y] = circlexy(c,r,nump)
%CIRCLEXY Return xdata and ydata of circles based on center and radius.

if nargin < 3
    nump = 1024; % Default number of points
end
num_c = numel(c);
x = nan(1,num_c*(nump+1));
y = nan(1,num_c*(nump+1));

for kk = 1:num_c
    angles = linspace(0,2*pi,nump);
    allpoints = c(kk) + r(kk) .* exp(1i*angles);
    x((kk-1)*(nump+1)+1 : kk*(nump+1)-1) = real(allpoints);
    y((kk-1)*(nump+1)+1 : kk*(nump+1)-1) = imag(allpoints);
    
end

x = x(1:end-1);
y = y(1:end-1);

end % of circlexy

%----------------------------------------------------
function result = isstable(sparam)
%ISSTABLE Return true if the 2-port network is unconditionally stable.

result = false;

[mu, muprime] = stabilitymu(sparam);
if all(mu > 1) || all(muprime > 1)
    result = true;
end

end % of isstable

%----------------------------------------------------
function validate_circle(cen,rad,type,value,desc,x,y)
%VALIDATE_CIRCLE throw an error if circle does not exist and give a warning
%if circle is completely out of the Smith chart.

if isnumeric(value)
    valstr = ['[',strtrim(sprintf('%g ',value)),']'];
else
    valstr = value;
end
% Throw an error if circle does not exist.
if any(isnan(cen) | isnan(rad) | ~isreal(rad))   
    error(message('rf:rfdata:data:circle:CircleNotExist',desc,type,valstr))
end

tempidx = ~isnan(x) & ~isnan(y);
x = x(tempidx);
y = y(tempidx);
% Give a warning if circle is out of sight.
if ~any(strcmpi(type,{'R','X','G','B','Gamma'})) % No warning
    censtr = '';
    ncen = numel(cen);
    for ii = 1:ncen
        censtr = strcat(censtr, {' '}, num2str(cen(ii)));
    end
    censtr = strtrim(censtr{1});
    radstr = strtrim(sprintf('%g ', rad));
    if all(abs(cen) - 1 - abs(rad) > 0.42)
        warning(...
            message('rf:rfdata:data:circle:CircleOutOfChart_Outside',...
            desc,type,valstr,desc,censtr,radstr))
    elseif all(abs(cen) - 1 - abs(rad) < 0) && all(abs(x + 1i*y) > 1)
        warning(...
            message('rf:rfdata:data:circle:CircleOutOfChart_Enclose',...
            desc,type,valstr,desc,censtr,radstr))
    end
end
end % of validate_circle


function result = getconstants(sparam)
%GETCONSTANTS Return K, B1, B2, DELTA, C1, C2, D1, D2.

[k,b1,b2,delta] = stabilityk(sparam);

result.K = k;
result.B1 = b1;
result.B2 = b2;
result.DELTA = delta;

s11 = squeeze(sparam(1,1,:));
s22 = squeeze(sparam(2,2,:));

result.C1 = s11 - delta.*conj(s22);
result.C2 = s22 - delta.*conj(s11);
result.D1 = abs(s11).^2 - abs(delta).^2;
result.D2 = abs(s22).^2 - abs(delta).^2;
end