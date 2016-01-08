function [ Zin ] = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L, startpos, Lsub, Wsub, viaflag)
%Uses multiconductor ABCD unit cell model to calculate input impedance of a
%microstrip stub backed by a high-impedance surface (use two stubs to make
%an antenna, and this way you can combine them in series for dipole-like
%feeding or in parallel for patch-like feeding).
%startpos is the amount of the first unit cell _included_, if the stub
%doesn't start at the edge of a unit cell (gap center).

mu0 = pi*4e-7;
eps0=8.854e-12;

%termination impedance for upper layer to middle row (Z12)
% Yslot = harringtonslotY(f, h_ant, w1);
% Z0u = microstripZ0_pozar(w1, h_ant, eps1);
% %apply length correction (back up by a distance of deltaL
% Zu = Zincalc(Z0u, 1./Yslot, 2*pi*f*sqrt(eps0*mu0)*microstripdeltaL( w1,h_ant,eps1));


%I'm going to use this to estimate the length correction that should be
%applied because of the open end of the stub.  
deltaL=microstripdeltaL(w1, h_ant, eps1);
%deltaL=0;
for ii = 1:length(f)
    Zu(ii) = JHWslotZ(h_ant, w1, f(ii), eps1 );  %seriously compare options for Y here
    [ABCD] = multicond_unitcell(w2+g, w1, w2, h_ant+h2, h2, rad, eps1, eps2, f(ii), viaflag);
    
    %number of whole unit cells
    ncells = floor((L-startpos)/(w2+g));
    
%calculate prefix
    if startpos>(w2+g)
        error('Not allowed to have start position greater than the size of one unit cell');
    elseif startpos>0
        %prefix matrix has whatever unit cell parts happen before the first
        %unit cell
        if startpos<g/2
            prefix=eye(4);
        elseif startpos<(w2+g)/2
            %just some electrical length and half the pi network
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            short_MTL = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, startpos-g/2);
            prefix = short_MTL*Cptopmat*Cpmat*Cmat;
        else
        	%electrical length, via inductance, electrical length, half the
        	%pi network.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, w2/2);
            if viaflag
                Lmat = MTLviaABCD(h2, rad, f(ii));
            else 
                Lmat=eye(4);
            end
            short_MTL1 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, startpos-w2/2-g/2);
            prefix = short_MTL1*Lmat*short_MTL2*Cptopmat*Cpmat*Cmat;
        end       
    else
        prefix = eye(4);
    end
    
    %calculate postfix
    postlen = L-ncells*(w2+g)-startpos;
    if postlen>0
        %prefix matrix has whatever unit cell parts happen before the first
        %unit cell
        if postlen<g/2
            %should this have some tiny bit of the pi-network? 
            postfix = eye(4);
        elseif postlen<(w2+g)/2 && postlen>=g/2
            %half the pi network plus electrical length
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            short_MTL = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, f(ii), postlen-g/2);
            postfix = Cmat*Cpmat*Cptopmat*short_MTL;
        else
        	%half the pi network, electrical length, via inductance, 
            %electrical length.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, f(ii), w2/2);
            if viaflag
                Lmat = MTLviaABCD(h2, rad, 2*pi*f(ii));
            else
                Lmat=eye(4);
            end
            short_MTL1 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, f(ii), postlen-w2/2-g/2);
            postfix = Cmat*Cpmat*Cptopmat*short_MTL2*Lmat*short_MTL1;
        end       
    else
        postfix = eye(4);
    end
    
    totalABCD=prefix*ABCD^ncells*postfix*ustripMTLABCD(w1,h_ant+h2,w2, h2, eps1, eps2, f(ii), deltaL);  %deltaL was added later because I assume it should be there
    
    %termination impedance for lower layer Z(22)
    [botABCD,ABCDL, ABCDgaphalf1, ABCDgaphalf2, ABCDline] = HISlayerABCD(w2, g, h2, rad, eps2, f(ii), viaflag);
    
    botn = floor((Lsub-L)/(w2+g))-1; %number of unit cells in just the substrate - don't count the last one
    % Zedge = 1./real(harringtonslotY(f(ii),h2, Wsub));  
    Zedge=JHWslotZ(h2, w2, f(ii), eps2 );
    % last unit cell shouldn't have gap cap on RHS
    ABCDt = (botABCD^botn)*ABCDgaphalf1*ABCDline*ABCDL*ABCDline;
    A=ABCDt(1,1);
    B = ABCDt(1,2);
    C=ABCDt(2,1);
    D=ABCDt(2,2);
    Zinb(ii) = (A*Zedge+B)/(C*Zedge+D);
    
    Lvia=viaL(h2,rad);
    %Zb needs to have the stuff that happens between it and the start of a
    %unit cell, also
    Z0b=microstripZ0_pozar(w2, h2, eps2); %characteristic impedance of bottom "line" (row of patches)
    epsf=epseff(w2,h2,eps2);
    botprefix = Lsub-L-(botn+1)*(w2+g);
    if botprefix<g/2
        Zbot(ii)=Zinb(ii);
    elseif botprefix<(w2+g)/2
        %TL section * half of pi network
        [Cg,Cp1,~]=microstripgapcap(eps2, g, h2, w2);
        ZCg=-j/(2*pi*f(ii)*2*Cg);
        ZCp=1/(j*2*pi*f(ii)*Cp1);
        ZL = 1 / (1/(ZCg + Zinb(ii)) + 1/ZCp); 
        Zbot(ii) = Zincalc(Z0b, ZL, (botprefix-g/2)*2*pi*f(ii)*sqrt(epsf)/(3e8)); 
    else
        %TL section * via * TL section * half of pi network
        [Cg,Cp1,~]=microstripgapcap(eps2, g, h2, w2);
        ZCg=1/(j*2*pi*f(ii)*2*Cg);
        ZCp=1/(j*2*pi*f(ii)*Cp1);
        ZL1 = 1 / (1/(ZCg + Zinb(ii)) + 1/ZCp); 
        if viaflag
        ZLvia=j*2*pi*f(ii)*Lvia;
        ZL2 = 1/( 1/ZLvia + 1/Zincalc(Z0b,ZL1,(w2/2)*2*pi*f(ii)*sqrt(epsf)/(3e8))); 
        else
            ZL2 = Zincalc(Z0b,ZL1,(w2/2)*2*pi*f(ii)*sqrt(epsf)/(3e8));
        end
        Zbot(ii)=Zincalc(Z0b, ZL2, (botprefix-w2/2-g/2)*2*pi*f(ii)*sqrt(epsf)/(3e8));
    end
    
    
    %assume Z11 is infinity.  Then, termination impedance is Z12+Z22 for
    %the upper layer and Z22 for the bottom layer
    ZL = [Zu(ii)+Zbot(ii) Zbot(ii); Zbot(ii) Zbot(ii)];
    A = totalABCD(1:2,1:2);
    B = totalABCD(1:2,3:4);
    C = totalABCD(3:4,1:2);
    D = totalABCD(3:4,3:4);
    
    Zin(:,:,ii) = (A*ZL+B)/(C*ZL+D);
    
end


end

