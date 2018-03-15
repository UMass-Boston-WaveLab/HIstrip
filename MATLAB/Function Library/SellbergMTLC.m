function [ C ] = SellbergMTLC( distances, heights, widths, thicknesses, layers, epsilons)
%SELBERGMTLC Based on F. Selberg, "Simple Determination of All Capacitances
%for a Set of Parallel Microstrip Lines," IEEE Trans Microw Theory Tech,
%vol. 46, no. 2, Feb. 1998.  Calculates the per-unit-length capacitance of
%a collection of parallel microstrip lines. Permits up to two dielectric
%layers.
%VARIABLE DEFINITIONS
%distances provides the matrix of center-to-center distances between pairs
%of conductors, or between the conductor and ground. It is an NxN matrix.
%
%heights provides the 1XN vector of all the conductor heights above ground.
%
%widths is a 1xN vector with all the conductor widths.
%
%thicknesses provides the 1xN vector of all the conductor thicknesses.
%
%layers provides a 1xN vector of layer indices (1 or 2 for each conductor,
%where 1 is the upper layer), indicating which layer the conductor is on
%top of.
%
%epsilons contains the relative dielectric constants of the layers.
eps0=8.854e-12;
N = length(heights);
Lambda = zeros(size(distances));
for ii = 1:N
    for jj = ii:N
        %only fill half the matrix, then assume symmetry
        %calculate constants for effective dielectric constant for layered
        %media
        if layers(ii)==layers(jj) || layers(ii)==1
            %this probably doesn't do capacitance between lines on different
            %layers exactly right.
            if ii==jj
                k=(log(1+4*thicknesses(ii)/widths(ii))/log(1+4*heights(ii)/widths(ii)))^0.8;
                s=-(thicknesses(ii)/heights(ii))^0.4;
                
            else
                k=log(1+5*(thicknesses(ii)*thicknesses(jj))/distances(ii,jj)^2)/log(1+5*(heights(ii)*heights(jj))/distances(ii,jj)^2);
                s=-(thicknesses(ii)*thicknesses(jj)/(heights(ii)*heights(jj)))^0.2;
            end
            epseq = (k*epsilons(1)^s+(1-k)*epsilons(2)^s)^(1/s);
        else
            epseq=epsilons(layers(ii));
        end
        if ii==jj
            beta =log(1.15+1.17/epseq);
            alpha=1.07*(epseq-1)^1.15;
            P=2*(widths(ii)+thicknesses(ii))/(heights(ii)+0.5*thicknesses(ii)*(1-1/epseq));
            Pii=epseq*P+alpha*P^(beta/(1+1.6*P));
            Lambda(ii,jj)=(1/(2*pi))*log(1+4*pi/Pii);
        else
            eta = epseq^-0.66;
            delta = 1+0.36*(epseq-1)^0.65;
            gamma = 3.6*tanh(0.09*(epseq-1));
            D = distances(ii,jj)/sqrt((heights(ii)+thicknesses(ii)/4)*(heights(jj)+thicknesses(jj)/4));
            Delta = gamma*D^1.5+delta*D^eta;
            Lambda(ii,jj) = (1/(4*pi))*log(1+(2/Delta)^2);
            Lambda(jj,ii) = Lambda(ii,jj);
        end
        
    end
end


C = eps0*inv(Lambda);


end

