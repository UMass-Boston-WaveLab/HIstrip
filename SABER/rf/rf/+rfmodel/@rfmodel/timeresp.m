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
%   See also RFMODEL, RFMODEL.RFMODEL/FREQRESP, RFMODEL.RFMODEL/WRITEVA,
%   RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

error(message('rf:rfmodel:rfmodel:timeresp:NotForThisObject',           ...
    upper( class( h ) )));