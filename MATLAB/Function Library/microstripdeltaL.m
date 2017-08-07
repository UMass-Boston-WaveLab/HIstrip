function [ deltaL ] = microstripdeltaL( w,h,epsr)
%DELTAL computes effective length correction at open end of microstrip line
%using the expression from Kirschning, Jansen, and Koster.

eff = epseff(w,h,epsr);

zeta1 = 0.434907*(eff^0.81 + 0.26*(w/h)^0.8544 + 0.236)/(eff^0.81-0.189*(w/h)^0.8544+0.87);
zeta2 = 1+(w/h)^0.371/(2.358*epsr+1);
zeta3 = 1 + (0.5274*atan(0.084*(w/h)^(1.9413/zeta2)))/(eff^0.9236);
zeta4 = 1+0.0377*atan(0.067*(w/h)^1.456)*(6-5*exp(0.036*(1-epsr)));
zeta5=1-0.218*exp(-7.5*w/h);

deltaL = h*zeta1*zeta3*zeta5/zeta4;

end

