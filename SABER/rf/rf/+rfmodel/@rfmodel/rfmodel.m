classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rfmodel < rfbase.rfbase
%rfmodel.rfmodel class
%   rfmodel.rfmodel extends rfbase.rfbase.
%
%    rfmodel.rfmodel properties:
%       Name - Property is of type 'string' (read only)
%
%    rfmodel.rfmodel methods:
%       freqresp - Compute the frequency response of a rational function
%                  object.
%       impulse  - Compute the impulse response of a rational function
%                  object.
%       timeresp - Compute the time response of a rational function object.
%       writeva  - Write Verilog-A description of a rational function
%                  object.



    methods  % method signatures
        [resp,freq] = freqresp(h,freq)
        [resp,t] = impulse(h,ts,n)
        [y,t] = timeresp(h,u,ts)
        status = writeva(h,filename,innets,outnets,discipline,          ...
            printformat,filestoinclude)
    end  % method signatures

end  % classdef