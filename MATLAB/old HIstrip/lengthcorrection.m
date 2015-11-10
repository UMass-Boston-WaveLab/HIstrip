function [deltaL] = lengthcorrection(w,h,epseff, epsr)

R1 = 0.434907*(epseff^0.81+0.26)*((w/h)^0.8544+0.236)/((epseff^0.81-0.189)*((w/h)^0.8544+0.87));
R2 = 1+(w/h)^0.371/(2.358*epsr+1);
R3 = 1+(0.5274*atan(0.084*(w/h)^(1.9413/R2)))/epseff^0.9236;
R4 = 1+0.0377*atan(0.067*(w/h)^1.456)*(6-5*exp(0.036*(1-epsr)));
R5 = 1-0.218*exp(-7.5*w/h);

deltaL = R1*R3*R5/R4;