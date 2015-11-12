function [ Zin ] = seriesHISstub( f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L1,L2)
%SERIESHISSTUB finds the two-terminal (upper to ground) input impedance of a
%combination of two HIS-backed stubs in series (i.e. differential feed like
%a dipole)


Zin1 = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L1,0);
Zin2 = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L2,0);

for ii=1:length(f)
    Y=inv(Zin1(:,:,ii)+Zin2(:,:,ii));
    
    Zin(ii)=1/Y(1,1);
end

end