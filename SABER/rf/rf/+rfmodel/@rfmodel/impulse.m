function [resp, t] = impulse(h, ts, n)
%IMPULSE Compute the impulse response of a rational function object.
%   [RESP, T] = IMPULSE(H, TS, N) computes the impulse response, RESP, of
%   the rational function object, H, over the time period specified by TS
%   and N. 
%
%   H is the handle to the RFMODEL.RATIONAL object. TS is the sample time.
%   N is the total number of samples. RESP is the impulse response, and T
%   is the time samples of the impulse response. 
%
%   See also RFMODEL, RFMODEL.RFMODEL/FREQRESP, RFMODEL.RFMODEL/TIMERESP,
%   RFMODEL.RFMODEL/WRITEVA, RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

error(message('rf:rfmodel:rfmodel:impulse:NotForThisObject',            ...
    upper( class( h ) )));