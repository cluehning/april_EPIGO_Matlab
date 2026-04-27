function visualize_track(track, analysis)
    x = track.signal(:);

    figure;
    subplot(3,1,1);
    plot(x, 'LineWidth', 1);
    title(['Signal: ' track.name], 'Interpreter','none');
    xlabel('Position'); ylabel('Value');

    subplot(3,1,2);
    plot(analysis.freq, analysis.spectrum, 'LineWidth', 1);
    title('Spectrum (FFT magnitude)');
    xlabel('Frequency'); ylabel('|X(f)|');

    subplot(3,1,3);
    idx_hm = round(linspace(1, numel(x), min(5000,numel(x))));
    heatmap(x(idx_hm));
    title('Signal Heatmap (sampled across genome)');

    %% ===== EXTENSION (SECOND FIGURE) =====
    hasCool = isfield(analysis,'psd') && isfield(analysis,'tf') && ...
              isfield(analysis,'state') && isfield(analysis,'x') && ...
              isfield(analysis,'pos');

    if hasCool
        xc  = analysis.x(:);
        pos = analysis.pos(:);

        figure('Color','w','Name',['EPIGO Cool: ' track.name]);
        tiledlayout(4,1,'TileSpacing','compact','Padding','compact');

        % (1) Signal + Changepoints
        ax1 = nexttile;
        plot(pos, xc, 'k-', 'LineWidth', 0.8); hold on;
        if isfield(analysis,'chgIdx') && ~isempty(analysis.chgIdx)
            idc = analysis.chgIdx(:);
            idc = idc(idc>=1 & idc<=numel(pos));
            xline(pos(idc),'Color',[0.85 0.2 0.2],'LineWidth',1);
            legend({'Signal','Changepoints'},'Location','best');
            legend boxoff;
        end
        title(sprintf('%s | Entropie: %.3f', track.name, analysis.entropy), ...
              'Interpreter','none');
        ylabel('z-score'); grid on; box off;

        % (2) State Map
        ax2 = nexttile;
        lbl  = analysis.state.labels(:);
        cpos = analysis.state.centers(:);
        imagesc([cpos(1) cpos(end)], [0 1], lbl'); axis tight;
        set(gca,'YTick',[]);
        colormap(ax2, turbo(max(lbl)));
        colorbar('Location','eastoutside','TickDirection','out');
        title('State Map');
        xlabel('Position');

        % (3) Time–Frequency
        ax3 = nexttile;
        tf = analysis.tf;
        if isfield(tf,'type') && tf.type == "cwt"
            imagesc(tf.t, tf.f, abs(tf.cfs)); axis xy;
            colormap(ax3, magma_like());
            colorbar('Location','eastoutside','TickDirection','out');
            title('Wavelet Scalogram');
            ylabel('Frequency');
        elseif isfield(tf,'type') && tf.type == "fft_blocks"
            imagesc(tf.t, tf.f, 10*log10(tf.map + eps)); axis xy;
            colormap(ax3, magma_like());
            colorbar('Location','eastoutside','TickDirection','out');
            title('Sliding FFT Energy');
            ylabel('Frequency');
        else
            text(0.5,0.5,'No TF map','HorizontalAlignment','center');
            axis off;
        end
        xlabel('Position');

        % (4) Power Spectrum
        ax4 = nexttile;
        maxF = 0.05;
        f = analysis.psd.f;
        P = analysis.psd.Pxx;
        idf = f <= maxF;
        semilogy(f(idf), P(idf) + eps);
        grid on; box off;
        title('Power Spectrum');
        xlabel('Frequency'); ylabel('Power');

        % Link axes
        try
            linkaxes([ax1 ax2 ax3],'x');
        catch
        end
    end
end


function cmap = magma_like()
    x = linspace(0,1,256)';
    r = interp1([0 0.25 0.5 0.75 1],[0.05 0.35 0.75 0.95 0.99],x,'pchip');
    g = interp1([0 0.25 0.5 0.75 1],[0.02 0.10 0.25 0.55 0.95],x,'pchip');
    b = interp1([0 0.25 0.5 0.75 1],[0.10 0.30 0.35 0.20 0.10],x,'pchip');
    cmap = [r g b];
end