% Calculates unitary matrix for S parameters to check for losses.

function unitary(S11, S12, S21, S22, depth, size)

% Builds S parameter matrix and allocates space for conj. trans. matrix.
sMatrix = [S11 S12; S21 S22];
sMatrixConjTrans = zeros(size,size,depth);

% Builds conj. trans. matrix.
for ii = 1:depth
    sMatrixConjTrans(:,:,ii) = sMatrix(:,:,ii)';
end

% Checks for passivivity and losslessness.
results = zeros(size,size,depth);
for ii = 1:depth
    results(:,:,ii) = sMatrixConjTrans(:,:,ii)*sMatrix(:,:,ii);
end

% Converts S parameters to dB.
for ii = 1:depth
    results(:,:,ii) = abs(results(:,:,ii));
    results(:,:,ii) = 20*log10(results(:,:,ii));
end

% Converts diagonal values of results into arrays for plotting.
% Switch handles 2x2 or 4x4 matrix for either reflect or thru/line cases.
switch size
    case 4
        for ii = 1:depth
            results11(1,ii) = results(1,1,ii);
            results22(1,ii) = results(2,2,ii);
            results33(1,ii) = results(3,3,ii);
            results44(1,ii) = results(4,4,ii);
        end
    case 2
        for ii = 1:depth
            results11(1,ii) = results(1,1,ii);
            results22(1,ii) = results(2,2,ii);
        end
    otherwise      
end

% Plots the above results arrays vs frequency. Switch does same as above.
freqs = linspace(3,3+(depth/10)-0.1,depth);
switch size
    case 4
        plot(freqs,results11,'-x',freqs,results22,'-o',freqs,results33,'-*',freqs,results44,'-+');
        legend('[S]''[S]11','[S]''[S]22','[S]''[S]33','[S]''[S]44');
        xlabel('Frequency (GHz)');
        ylabel('dB');
        title('Results of [S]''[S] for uncorrected Line Standard');
    case 2
        plot(freqs,results11,freqs,results22);
        legend('[S]''[S]11','[S]''[S]22');
        xlabel('Frequency (GHz)');
        ylabel('dB');
        title('Results of [S]''[S] for uncorrected Reflect Standard');
    otherwise
end