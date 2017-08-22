function [deltaL] = deltaL(epsilonr, W, h)

epseff = epsiloneff(epsilonr, W, h);

Q1 = 0.434907*((epseff^0.81+0.26)/(epseff^0.81-0.189))*((W/h)^0.8544+0.236)/((W/h)^0.8544+0.87);
Q2 = 1+(W/h)^0.371/(2.358*epsilonr+1);
Q3 = 1+(0.5274/epseff^0.9236)*atan(0.084*(W/h)^(19413/Q2));
Q4 = 1+0.0377*(6-5*exp(0.036*(1-epsilonr)))*atan(0.067*(W/h)^1.456);
Q5 = 1-0.218*exp(-7.5*W/h);

deltaL = h*Q1*Q3*Q5/Q4;