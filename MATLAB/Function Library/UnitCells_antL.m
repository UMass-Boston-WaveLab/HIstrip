function [ antL ] = UnitCells_antL(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L_ant, startpos, ~, ~, viaflag)


%% Uses multiconductor ABCD unit cell model to create 4x4 ABCD matrix for
%unit cell(S) that relate the ends of the HIS backed structure
%feeding or in parallel for patch-like feeding).
%startpos is the amount of the first unit cell _included_, if the stub
%doesn't start at the edge of a unit cell (gap center).




%% termination impedance for upper layer to middle row (Z12)
% Yslot = harringtonslotY(f, h_ant, w1);
% Z0u = microstripZ0_pozar(w1, h_ant, eps1);
% %apply length correction (back up by a distance of deltaL
% Zu = Zincalc(Z0u, 1/Yslot, 2*pi*f*sqrt(eps0*mu0)*microstripdeltaL( w1,h_ant,eps1));


%I'm going to use this to estimate the length correction that should be
%applied because of the open end of the stub.  

deltaL = microstripdeltaL(w_ant, h_ant, eps1);
%deltaL=0;

for ii = 1:length(f)
    Zu(ii) = JHWslotZ(h_ant, w_ant, f(ii), eps1 );  %seriously compare options for Y here
    [ABCD] = multicond_unitcell(f,  w_ant, w2+g, h_ant+H_sub, H_sub, rad, eps1, eps2, f(ii), viaflag);
    
    %number of whole unit cells
    ncells = floor((L_ant-startpos)/(w2+g));
    
%calculate prefix
%prefix matrix has whatever unit cell parts happen before the first unit cell
    if startpos>(w2+g)
        error('Not allowed to have start position greater than the size of one unit cell');
   
    elseif startpos>0
       
        if startpos<g/2
            prefix = eye(4);
        elseif startpos<(w2+g)/2
            %just some electrical length and half the pi network
            
           [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+H_sub, H_sub, w_ant, w2, eps1, eps2, g, f(ii));
           short_MTL = ustripMTLABCD(w_ant, h_ant+H_sub,w2, H_sub, eps1, eps2, freq, startpos-g/2);
           prefix = short_MTL*Cptopmat*Cpmat*Cmat;
        else
        	%electrical length, via inductance, electrical length, half the
        	%pi network.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+H_sub, H_sub, w_ant, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w_ant, h_ant+H_sub,w2, H_sub, eps1, eps2, freq, w2/2);
            if viaflag
                Lmat = MTLviaABCD(H_sub, rad, f(ii));
            else 
                Lmat=eye(4);
            end
            short_MTL1 = ustripMTLABCD(w_ant, h_ant+H_sub,w2, H_sub, eps1, eps2, freq, startpos-w2/2-g/2);
            prefix = short_MTL1*Lmat*short_MTL2*Cptopmat*Cpmat*Cmat;
        end       
    else
        prefix = eye(4);
    end
    
 %% Calculate postfix
    postlen = L_ant-ncells*(w2+g)-startpos;
    if postlen>0
        %prefix matrix has whatever unit cell parts happen before the first
        %unit cell
        if postlen<g/2
            %should this have some tiny bit of the pi-network? 
            postfix = eye(4);
        elseif postlen<(w2+g)/2 && postlen>=g/2
            
            %half the pi network plus electrical length
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+H_sub, H_sub, w_ant, w2, eps1, eps2, g, f(ii));
            short_MTL = ustripMTLABCD(w_ant, h_ant+H_sub,w2, H_sub, eps1, eps2, f(ii), postlen-g/2);
            postfix = Cmat*Cpmat*Cptopmat*short_MTL;
            
        else
        	%half the pi network, electrical length, via inductance, 
            %electrical length.
            
            [Cmat, Cpmat, Cptopmat] = MTLcapABCD(h_ant+H_sub, H_sub, w_ant, w2, eps1, eps2, g, f(ii));
            
            short_MTL2 = ustripMTLABCD(w_ant,h_ant+H_sub,w2, H_sub, eps1, eps2, f(ii), w2/2);
            if viaflag
                Lmat = MTLviaABCD(H_sub, rad, 2*pi*f(ii));
            else
                Lmat=eye(4);
            end
            short_MTL1 = ustripMTLABCD(w_ant, h_ant+H_sub,w2, H_sub, eps1, eps2, f(ii), postlen-w2/2-g/2);
            postfix = Cmat*Cpmat*Cptopmat*short_MTL2*Lmat*short_MTL1;
        end       
    else
        postfix = eye(4);
    end
    
%% Compile total unit cell(s) structure for stub backed by HIS
    totalABCD = prefix*ABCD^ncells*postfix*ustripMTLABCD(w_ant,h_ant+H_sub,w2, H_sub, eps1, eps2, f(ii), deltaL);  %deltaL was added later because I assume it should be there
    

   

    antL = totalABCD;
    
end


end
