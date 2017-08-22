function [ epseff ] = epsiloneff( epsr, W, h )
%Expressions due to Hammerstad & Jensen, valid for epsr<128 and
%0.01<W/h<100

u=W/h;
a=1+(1/49)*log((u^4+(u/52)^2)/(u^4+0.432))+(1/18.7)*log(1+(u/18.1)^3);
b=0.564*((epsr-0.9)/(epsr+3))^0.053;

epseff = (epsr+1)/2 +((epsr-1)/2)*(1+10*h/W)^(-a*b);


end

