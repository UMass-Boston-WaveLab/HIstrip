function [y, t] = timeresp(h, u, ts)
%TIMERESP Compute the time response of a rational function object.
%   [Y, T] = TIMERESP(H, U, TS) computes the output signal, Y, that the
%   rational function object, H, produces in response to the given input
%   signal U.
%
%     Y(n) = SUM(C.*X(n - DELAY/TS)) + D*U(n - DELAY/TS)
%
%     where  X(n+1) = F*X(n) + G*U(n), X(1) = 0 and
%     F = EXP(A*TS),  G = (F-1) ./ A;
%
%   A, C, DELAY and D are the properties of RFMODEL.RATIONAL object H:
%
%             A: Complex vector of poles of the rational function
%             C: Complex vector of residues of the rational function
%             D: Scalar value specifying direct feedthrough 
%         DELAY: Delay time (s)
%
%   H is the handle to the RFMODEL.RATIONAL object. U is the input signal.
%   TS is the sample time of U in seconds. Y is the output signal at
%   corresponding time, T, in seconds. 
%
%   See also RFMODEL.RATIONAL, RFMODEL.RATIONAL/ISPASSIVE, 
%   RFMODEL.RATIONAL/STEPRESP, RFMODEL.RATIONAL/FREQRESP,
%   RFMODEL.RATIONAL/WRITEVA, RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

% Check the input
narginchk(3,3);

% Check the inputs
u = squeeze(u);
if isempty(u) || ~isvector(u) || ~isnumeric(u) || any(isnan(u)) ||      ...
        any(~isreal(u)) || any(isinf(u))
    error(message('rf:rfmodel:rational:timeresp:WrongUInput'));
end
u = u(:);
if isempty(ts) || ~isscalar(ts) || ~isnumeric(ts) || isnan(ts) ||       ...
        ~isreal(ts) || ts <= 0 || isinf(ts)
    error(message('rf:rfmodel:rational:timeresp:WrongTsInput'));
end

% Check the property
checkproperty(h);
% Get the property
poles = h.A;
c = h.C;
d = h.D;   
delay = h.Delay;

% Calculate output signal
f = exp(poles*ts);
g = (f - 1)./poles;
x=zeros(length(poles), 1);
n = length(u);
y=zeros(n, 1);
for k=1:n
    y(k) = sum(c.*x) + d*u(k);
    x = f.*x + g*u(k);
end
delaynum = round(delay/ts);
y(delaynum+1:delaynum+n) = y;
y(1:delaynum) = 0;
y = real(y(:));
t = double(0:(delaynum+n-1))'*ts;