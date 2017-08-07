function [ Cs, Cp1,Cp2 ] = microstripgapcap( epsr,s, h, w1, varargin)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
if ~isempty(varargin)
    w2=varargin{1};
else
    w2=w1;
end


Q5=1.23/(1+0.12*(w2/w1-1)^0.9);
Q1 = 0.04598*(0.03+(w1/h)^Q5)*(0.272+0.07*epsr);
Q2=0.107*(w1/h+9)*(s/h)^3.23+2.09*(s/h)^1.05*(1.5+0.3*w1/h)/(1+0.5*w1/h);
Q3 = exp(-0.5978*(w2/w1)^1.35)-0.55;
Q4=exp(-0.5978*(w1/w2)^1.35)-0.55;

Cs = 1e-12*500*h*exp(-1.86*s/h)*Q1*(1+4.19*(1-exp(-0.785*(sqrt(h/w1)*w2/w1))));

C1=sqrt(epseff(w1,h,epsr))*microstripdeltaL(w1,h,epsr)/(3e8 * microstripZ0_2(w1,h,epsr));
C2=sqrt(epseff(w2,h,epsr))*microstripdeltaL(w2,h,epsr)/(3e8 * microstripZ0_2(w2,h,epsr));

Cp1 = 1e-12*C1*(Q2+Q3)/(Q2+1);
Cp2=1e-12*C2*(Q2+Q4)/(Q2+1);

end

