function [freq, gamma, err] = bloch4_HFSS(filename1, filename2, n1, n2, a)
%n1 and n2 are the numbers of unit cells, a is the unit cell size
% in the HFSS files filename1 and filename2.  

% get Z matrices out of filenmae1 and filename2.
% terminals are named Ti1, Ti2 at input and To1, To2 at output, and Z is 
% stored in real and imaginary parts.
[freq, Z1] = read_HFSS_Z_table(filename1);
[~,Z2] = read_HFSS_Z_table(filename2);
tic
%convert Z2n to ABCD2n
for ii = 1:length(freq)
    ABCD1 = ZtoABCD2n(Z1(:,:,ii));
    ABCD2 = ZtoABCD2n(Z2(:,:,ii));

    
    %do modal analysis on ABCD2n (write a separate function for this probably)
    %use Faria's technique from 2004 paper to get base gamma values, but then
    %we have to disambiguate
    % we can't simply use the 2004 technique on the ABCD^n matrices because the
    % terminal-modal conversion matrices aren't symmetric
    [~,~,~,gam1n, ABCDmod1] = fariamodal(ABCD1,n1*a); %for a unit cell that is n*a
    [~,~,~,gam2n, ABCDmod2] = fariamodal(ABCD2,n2*a); 
    %real part is attenuation, imag is phase 
    %forward propagating waves have e^{-gamma*z}
    gam1base(:,ii) = gam1n;
    gam2base(:,ii) = gam2n;
    
    degen1 = (0:(2*pi/(n1)):(0.99999999999*2*pi))/a;
    degen2 = (0:(2*pi/(n2)):(0.99999999999*2*pi))/a;
    for jj = 1:2
        if abs(imag(gam1base(jj,ii))-imag(gam2base(jj,ii)))>2*pi/a
            gam1base(jj,ii) = gam1base(jj,ii)+j*2*pi*floor(imag(gam2base(jj,ii)-gam1base(jj,ii))/(2*pi/a))/a;
        end
        opt1 = kron(j*(imag(gam1base(jj,ii))+degen1)+real(gam1base(jj,ii)), ones(size(degen2)));
        opt2 = kron(ones(size(degen1)),j*(imag(gam2base(jj,ii))+degen2)+real(gam2base(jj,ii)));
        test = abs(imag(opt1-opt2));
        [~,index] = min(test);
        tol = max(2*pi/n1, 2*pi/n2)/a;
        err(jj,ii) = abs(imag(opt1(index)-opt2(index)));
        if err>tol
            warning('Large disagreement between datasets for prop constant %.0f at frequency = %.1f',jj,freq(ii));
        end
        gamma(ii,jj) = ((opt1(index)+opt2(index))/2);
    end
    
end
toc
end

function [freq, Z] = read_HFSS_Z_table(file)
%the terminals have to be named in a way that's compatible with
%index_chooser.  Also it's only meant for a 2*2 model.
[a, b, c] = xlsread(file);
freq = a(:,1);
%b has all the labels, and a is data
%b contains real and imaginary parts, so we have twice as much as needed
for ii = 1:((length(b)-1)/2)
    %b(2*ii) contains the imaginary part label
    terma = b{2*ii}(7:9);
    termb = b{2*ii}(11:13);
    inda = index_chooser(terma);
    indb = index_chooser(termb);
    %b(2*ii+1) contains the real part label, but it will have the same
    %indices
    Z(inda, indb, :) = j*a(:, 2*ii)+a(:,2*ii+1);
end
end

function [ind] = index_chooser(term)
    switch term
        case 'Ti1'
            ind = 1;
        case 'Ti2'
            ind = 2;
        case 'To1'
            ind = 3;
        case 'To2'
            ind = 4;
    end
end