function [ Zin ] = prllHISstub( f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L1,L2)
%PRLLHISSTUB finds the two-terminal (upper to ground) input impedance of a
%combination of two HIS-backed stubs in parallel (i.e. a probe fed
%HIS-backed patch antenna)


Zin1 = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L1,0);
Zin2 = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L2,0);

for ii=1:length(f)
    Yin1=inv(Zin1(:,:,ii));
    Yin2=inv(Zin2(:,:,ii));
    
    Zinmat=inv(Yin1+Yin2);
    
    Zin(ii)=Zinmat(1,1);
end

end

