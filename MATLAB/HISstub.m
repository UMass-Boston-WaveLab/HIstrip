function [ Zin ] = HISstub(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L, startpos)
%Uses multiconductor ABCD unit cell model to calculate input impedance of a
%microstrip stub backed by a high-impedance surface (use two stubs to make
%an antenna, and this way you can combine them in series for dipole-like
%feeding or in parallel for patch-like feeding).
%startpos is the amount of the first unit cell _included_, if the stub
%doesn't start at the edge of a unit cell (gap center).

mu0 = pi*4e-7;
eps0=8.854e-12;

%termination impedance for upper layer to middle row (Z12)
Yslot = harringtonslotY(f, h_ant, w1);
Z0u = microstripZ0_pozar(w1, h_ant, eps1);
%apply length correction (back up by a distance of deltaL
Zu = Zincalc(Z0u, 1./Yslot, 2*pi*f*sqrt(eps0*mu0)*microstripdeltaL( w1,h_ant,eps1));


for ii = 1:length(f)

    [ABCD] = multicond_unitcell(w2+g, w1, w2, h_ant+h2, h2, rad, eps1, eps2, f(ii));
    
    %number of whole unit cells
    ncells = floor((L-startpos)/(w2+g));
    
%calculate prefix
    if startpos>(w2+g)
        error('Not allowed to have start position greater than the size of one unit cell');
    elseif startpos>0
        %prefix matrix has whatever unit cell parts happen before the first
        %unit cell
        if startpos<(w2+g)/2
            %just some electrical length and half the pi network
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            short_MTL = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, startpos-g);
            prefix = short_MTL*Cptopmat*Cpmat*Cmat;
        else
        	%electrical length, via inductance, electrical length, half the
        	%pi network.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, w2/2);
            Lmat = MTLviaABCD(h2, rad, 2*pi*f(ii));
            short_MTL1 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, startpos-w2/2-g);
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
        if postlen<g
            %should this have some tiny bit of the pi-network?
            postfix = eye(4);
        elseif postlen<(w2+g)/2 && postlen>g
            %just some electrical length and half the pi network
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            short_MTL = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, freq, startpos-g);
            postfix = Cptopmat*Cpmat*Cmat*short_MTL;
        else
        	%electrical length, via inductance, electrical length, half the
        	%pi network.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+h2, h2, w1, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, f(ii), w2/2);
            Lmat = MTLviaABCD(h2, rad, 2*pi*f(ii));
            short_MTL1 = ustripMTLABCD(w1, h_ant+h2,w2, h2, eps1, eps2, f(ii), startpos-w2/2-g);
            postfix = Cptopmat*Cpmat*Cmat*short_MTL2*Lmat*short_MTL1;
        end       
    else
        postfix = eye(4);
    end
    
    totalABCD=prefix*ABCD*postfix;
    
    %termination impedance for lower layer Z(22)
    botABCD = HISlayerABCD(w2, g, h2, rad, eps2, f(ii));
    [Zb,~] =bloch(botABCD, w2+g);
    
    %assume Z11 is infinity.  Then, termination impedance is Z12+Z22 for
    %the upper layer and Z22 for the bottom layer
    ZL = [Zu(ii)+Zb Zb; Zb Zb];
    A = totalABCD(1:2,1:2);
    B = totalABCD(1:2,3:4);
    C = totalABCD(3:4,1:2);
    D = totalABCD(3:4,3:4);
    
    Zin(:,:,ii) = (A*ZL+B)/(C*ZL+D);
    
end


end

