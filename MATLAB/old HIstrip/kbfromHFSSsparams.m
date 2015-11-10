function [k,freq,gamma,legarray] = kbfromHFSSsparams( HFSS_filea_S11, HFSS_filea_S21, HFSS_fileb_S11, HFSS_fileb_S21, zfile, na, nb, a)
%KBFROMHFSSSPARAMS Uses two sets of HFSS simulation results to
%unambiguously solve for phase and attenuation constants of a 2-port
%structure composed of na or nb unit cells of physical length a.  Two files
%must use the same set of frequency points. (and the same set of
%variations, if some model parameter was varied).  They should have
%different numbers of unit cells (na and nb), and na & nb should be
%mutually prime. This method is due to Valerio et al., IEEE Trans. Ant.
%Propagat., June 2011.  S parameters from HFSS should be calculated using
%the "renormalize all modes" option, normalized to 50 ohms.
%   Detailed explanation goes here

 plotindex = 1;
[freqa, S11a, legvals] = read_HFSS_file_S(HFSS_filea_S11);
[freqa, S21a, legvals] = read_HFSS_file_S(HFSS_filea_S21);
[freqb, S11b, legvals] = read_HFSS_file_S(HFSS_fileb_S11);
[freqb, S21b, legvals] = read_HFSS_file_S(HFSS_fileb_S21);

if freqa ~=freqb
    error('Two HFSS files must use the same set of frequency points')
else
    freq = freqa;
end

if ~ischar(zfile)
    Z0 = repmat(zfile, length(freq));
else
[zfreq, Zvals, legstrings] = read_HFSS_file_Z(zfile);
indices = zeros(size(zfreq));
if (length(freq)<=length(zfreq))
    for ii = 1:length(freq)
        indices = indices | zfreq == freq(ii);
    end
    Z0 = Zvals(indices);
else %use nearest Zvals
    Z0 = interp1(zfreq, Zvals, freq, 'nearest');
end
end

k = 2*pi*freq*1e6/(3e8);
[gamma_a, Z_a] = computebasegamma(S11a, S21a, na, a, Z0, freq);
[gamma_b, Z_b] = computebasegamma(S11b, S21b, nb, a, Z0, freq);

degeneracy_a = (0:(2*pi/(na)):(0.9999999*2*pi))/a; %exclude the last point
degeneracy_b = (0:(2*pi/(nb)):(0.9999999*2*pi))/a; %it's the same as 0

%find the minimum difference between the gamma_a+degeneracy_a(p) and
%gamma_b+degeneracy_b(q) for each frequency point and model variation.
nvars = size(S11a,2);
gamma = zeros(length(freq), nvars);

for jj = 1:nvars
    for ii = 1:length(freq)
%         %check for 2pi ambiguities
        if abs(real(gamma_a(ii,jj))-real(gamma_b(ii,jj)))>2*pi/a
           gamma_a(ii,jj) = gamma_a(ii,jj)+2*pi*floor((real(gamma_b(ii,jj))-real(gamma_a(ii,jj)))/(2*pi/a))/a;
        end
        options_a = kron((real(gamma_a(ii,jj)))+degeneracy_a+j*imag(gamma_a(ii,jj)), ones(size(degeneracy_b)));
        options_b = kron(ones(size(degeneracy_a)), (real(gamma_b(ii,jj)))+degeneracy_b+j*imag(gamma_b(ii,jj)));
        test = abs(real(options_a)-real(options_b));
        [~,ansindex] = min(test);
        savetest(:,ii,jj) = test;
        %two sim results might not be exactly the same so let's clean up the
        %data with some averaging?
        err(ii,jj) = abs(real(options_a(ansindex)-options_b(ansindex)));
        tol = max(2*pi/na, 2*pi/nb)/a;
        if err(ii,jj)>tol
            warning('Large disagreement between datasets at variation %.0f, frequency number %.0f', jj,ii);
        end
        gamma(ii, jj) = (options_a(ansindex)+ options_b(ansindex))/2;
    end
end


for jj = 1:nvars
    legarray{2*jj-1} = [legvals{jj} ' Phase Constant'];
    legarray{2*jj} = [legvals{jj} ' Attenuation'];
end
colors = ['b' 'r'; 'c' 'm'; 'g' 'y'];

%% do all the plots

figure;
set(gca, 'fontSize', 12)
plot(freq, real(Z_b(:, plotindex)),'k', freq, imag(Z_b(:,plotindex)),'--k','linewidth', 2);
xlabel('Frequency [MHz]')
ylabel('Impedance [\Omega]')
title('Bloch Mode Impedance Derived from HFSS Simulated S Parameters')
 ylim([-500 1000])
 grid on
% 
% for jj = 1:length(plotindex)
%     legarray2{jj} = [legvals{plotindex(jj)} ' Real'];
%     legarray2{nvars+jj} = [legvals{plotindex(jj)} ' Imag'];
% end
% legend(legarray2,'interpreter','none')

end

function [gamma, Zchar] = computebasegamma(S11, S21, n, a, Z0, freq)
nvars = size(S11,2);
for jj = 1:nvars
    for ii = 1:length(freq)
        S = [S11(ii,jj), S21(ii,jj);
            S21(ii,jj), S11(ii,jj)];
        ABCD = getABCDfromS(S, Z0(ii));
        [V, D] = eig(ABCD);
        prop(:,ii,jj) = sort(diag(D));
        if abs(prop(1,ii,jj))==abs(prop(2,ii,jj))
            warn('ABCD eigenvalues are equal')
        end
        % always choose the smaller eigenvalue to ensure passivity
        % Choose positive phase constant (temp should be >0) - amounts to
        % having angle function wrap to 2pi instead of +-pi
        temp = -angle(prop(2,ii,jj));
        if temp<0
            temp = temp+2*pi;
        end
        gamma(ii,jj) = temp/(n*a) + j*log(abs(prop(2,ii,jj)))/(n*a);
        %by the way, this turns out the same as getting Zchar from the
        %eigenvectors
        Zchar(ii,jj) = -2*ABCD(1,2)/(ABCD(1,1)-ABCD(2,2)-sqrt((ABCD(1,1)+ABCD(2,2))^2-4));
        if real(Zchar(ii,jj))<0
            Zchar(ii,jj) =-2*ABCD(1,2)/(ABCD(1,1)-ABCD(2,2)+sqrt((ABCD(1,1)+ABCD(2,2))^2-4));
        end
    end
end
end




function [ABCD] = getABCDfromS(S,Z0)
A = ((1+S(1,1))*(1-S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));
B = Z0*((1+S(1,1))*(1+S(2,2))-S(1,2)*S(2,1))/(2*S(2,1));
C = ((1-S(1,1))*(1-S(2,2))-S(1,2)*S(2,1))/(2*S(2,1)*Z0);
D = ((1-S(1,1))*(1+S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));

ABCD = [A B; C D];

end

