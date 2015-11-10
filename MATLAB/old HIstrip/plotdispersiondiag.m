function [] = plotdispersiondiag(k,freq,gamma,legarray,a,titletext, orient)
%still needs:   different colors for different values of ii
%               plot aspect ratio
%               testing
nvars= size(gamma,2);
plotindex = 1;

if orient=='h'
    figure;
    for ii = 1:length(plotindex)
        set(gca, 'fontSize', 12)
        scatter(k*a,wrapToPi(real(gamma(:,plotindex(ii)))*a), 20,'b');
        % plot(wrapToPi(real(gamma)*a),k*a)
        hold on
        scatter(k*a,imag(gamma(:,plotindex(ii)))*a, 20,'m');
        plot(k*a,k*a,'k')
        scatter(k*a,-wrapToPi(real(gamma(:,plotindex(ii)))*a), 20,'b');
        scatter(k*a,-imag(gamma(:,plotindex(ii)))*a, 20,'m');
    end
    plot(k*a,k*a,'k')
    xlabel('k_0 * a')
    ylabel('\beta * a')
    legend([legarray([2*(plotindex-1), 2*plotindex])'; {'Light Line'}],'location','northeast')
    set(gca, 'ytick', -pi:pi/4:pi)
    set(gca, 'xtick', 0:pi/4:2*pi)
    set(gca, 'yticklabel', {'-pi','-3pi/4', '-pi/2','-pi/4', '0','pi/4', 'pi/2','3pi/4', 'pi'})
    set(gca, 'xticklabel', {'0', 'pi/4', 'pi/2', '3pi/4', 'pi', '5pi/4', '3pi/2', '7pi/4', '2pi'})
    ylim([0 pi])
    title(titletext,'fontsize',12)
    
    figure;
    for ii = 1:length(plotindex)
        set(gca, 'fontSize', 12)
        scatter(freq,wrapToPi(real(gamma(:,plotindex(ii)))*a), 20,'b');
        hold on
        scatter(freq,imag(gamma(:,plotindex(ii))*a), 20,'m');
        scatter(freq,-wrapToPi(real(gamma(:,plotindex(ii)))*a), 20,'b');
        scatter(freq,-imag(gamma(:,plotindex(ii))*a), 20,'m');
    end
    plot(freq,k*a,'k')
    xlabel('Freq [MHz]')
    ylabel('\beta * a')
    legend([legarray([2*(plotindex-1), 2*plotindex])'; {'Light Line'}],'location','northeast')
    set(gca, 'ytick', -2*pi:pi/2:2*pi)
    set(gca, 'yticklabel', {'-pi','-3pi/4', '-pi/2','-pi/4', '0','pi/4', 'pi/2','3pi/4', 'pi'})
    set(gca, 'ytick', -pi:pi/4:pi)
    ylim([0 pi])
    title(titletext,'fontsize',12)
else
        figure;
    for ii = 1:length(plotindex)
        set(gca, 'fontSize', 12)
        scatter(wrapToPi(real(gamma(:,plotindex(ii)))*a), k*a,20);
        % plot(wrapToPi(real(gamma)*a),k*a)
        hold on
        scatter(imag(gamma(:,plotindex(ii)))*a, k*a,20);
    end
    plot(k*a,k*a,'k')
    for ii = 1:length(plotindex)
        scatter(-wrapToPi(real(gamma(:,plotindex(ii)))*a),k*a, 20);
        scatter(-imag(gamma(:,plotindex(ii)))*a, k*a,20);
    end
    plot(-k*a,k*a,'k')
    ylabel('k_0 * a')
    xlabel('\beta * a')
    legend([legarray([2*plotindex-1, 2*plotindex])'; {'Light Line'}],'location','northeast')
    set(gca, 'ytick', -pi:pi/8:pi)
    set(gca, 'yticklabel', {'0','pi/8','pi/4','3pi/8', 'pi/2','5pi/8','3pi/4','7pi/8', 'pi'})
        xlim([-pi pi])
    [hx, hy] = format_ticks(gca, {'$-\pi$', '$-3\pi/4$','$-\pi/2$', '$-\pi/4$','$0$', '$\pi/4$', '$\pi/2$', '$3\pi/4$', '$\pi$'},[],(-(pi):(pi/4):(pi)));

    title(titletext,'fontsize',12)
    
    figure;
    for ii = 1:length(plotindex)
        set(gca, 'fontSize', 12)
        scatter(wrapToPi(real(gamma(:,plotindex(ii)))*a), freq,20,'k','o');
        hold on
        scatter(imag(gamma(:,plotindex(ii))*a), freq,20,'k','+');
    end
    plot(k*a,freq,'k')
    for ii = 1:length(plotindex)
        scatter(-wrapToPi(real(gamma(:,plotindex(ii)))*a),freq, 20,'k','o');
        scatter(-imag(gamma(:,plotindex(ii)))*a, freq,20,'k','+');
    end
    plot(-k*a,freq,'k')
    ylabel('Frequency [MHz]')
    legend([legarray([2*plotindex-1, 2*plotindex])'; {'Light Line'}],'location','northeast')
        xlim([-pi pi])
    [hx, hy] = format_ticks(gca, {'$-\pi$', '$-3\pi/4$','$-\pi/2$', '$-\pi/4$','$0$', '$\pi/4$', '$\pi/2$', '$3\pi/4$', '$\pi$'},[],(-(pi):(pi/4):(pi)));
    xlabel('Normalized Propagation Constant')
    title(titletext,'fontsize',12)
     set(get(gca,'XLabel'),'Units','pixels')
     posLabel = get(get(gca,'XLabel'),'Position');
     set(get(gca, 'Xlabel'),'Position', posLabel+[0 -14 0])
end