function [eff ] = epseff( w,h2,epsr )
%EPSEFF calculates effective dielectric constant using expression due to
%Hammerstad and Jensen.

u=w/h2;

a=1+(1/49)*log((u.^4+(u/52).^2)./(u.^4+0.432))+(1/18.7)*log(1+(u./18.1).^3);

b=0.564*((epsr-0.9)/(epsr+3))^0.053;

eff = (epsr+1)./2+((epsr-1)./2).*(1+(10./u)).^(-a*b);
end
