function [ Z0 ] = microstripZ0_pozar( W, h,epsr )
%Implements microstrip design equations from Pozar

epseff = (epsr+1)/2 + (epsr-1)./(2*sqrt(1+12.*(h./W)));

if W/h<1
    Z0 = 60*log(8*h/W+W/(4*h))/sqrt(epseff);
else
    Z0 = 120*pi/(sqrt(epseff)*(W/h+1.393+0.667*log(W/h+1.444)));
end


end

