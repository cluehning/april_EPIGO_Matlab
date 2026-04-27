function result = analyze_track_v2(track, opts)
% ANALYZE_TRACK_V2 (TOOLBOX-SAFE)
% Returns:
%   Old fields for your original visualize_track:
%     result.freq, result.spectrum, result.entropy
%   New fields for cool extension:
%     result.x, result.pos, result.psd, result.chgIdx, result.state, result.tf

    x = track.signal(:);

    % ---- defaults
    if nargin < 2, opts = struct(); end
    if ~isfield(opts,'nbins'),   opts.nbins = 50; end
    if ~isfield(opts,'maxN'),    opts.maxN = 200000; end
    if ~isfield(opts,'nChg'),    opts.nChg = 12; end
    if ~isfield(opts,'win'),     opts.win = 2000; end
    if ~isfield(opts,'hop'),     opts.hop = 500; end
    if ~isfield(opts,'kStates'), opts.kStates = 5; end
    if ~isfield(opts,'useCWT'),  opts.useCWT = true; end

    % ---- normalize (robust)
    x = x - mean(x,'omitnan');
    s = std(x,'omitnan');
    if s > 0, x = x ./ s; end

    % ---- Shannon entropy
    [counts, ~] = histcounts(x, opts.nbins, 'Normalization','probability');
    counts(counts==0) = [];
    entropy_val = -sum(counts .* log2(counts));

    % ---- truncate for heavy ops
    N = min(opts.maxN, numel(x));
    xN = x(1:N);

    % ---- positions (safe)
    if isfield(track,'pos') && ~isempty(track.pos)
        posN = track.pos(1:N);
    else
        posN = (1:N)';
    end

    % OLD OUTPUTS (existing FFT magnitude plots)
    Xmag = abs(fft(xN));
    freq = linspace(0, 1, numel(Xmag));

    % NEW OUTPUTS    
    % ---- PSD (toolbox-free): one-sided FFT power
    X = fft(xN);
    P2 = abs(X/N).^2;
    P1 = P2(1:floor(N/2)+1);
    if numel(P1) > 2
        P1(2:end-1) = 2*P1(2:end-1);
    end
    f_psd = (0:floor(N/2))'/N;

    % ---- Changepoints (if available)
    try
        chgIdx = findchangepts(xN, 'MaxNumChanges', opts.nChg, 'Statistic','mean');
    catch
        chgIdx = [];
    end

    % ---- State map (uses compute_state_map; it has kmeans fallback)
    [stateLbl, winCenters, winFeat] = compute_state_map(xN, posN, opts.win, opts.hop, opts.kStates);

    % ---- Time-frequency: try CWT if installed; else sliding FFT blocks
    tf = struct();
    if opts.useCWT
        try
            [cfs, f_cwt] = cwt(xN);   % Wavelet toolbox only
            tf.type = "cwt";
            tf.cfs  = cfs;
            tf.f    = f_cwt;
            tf.t    = posN;
        catch
            tf = fft_blocks_fallback(xN, posN);
        end
    else
        tf = fft_blocks_fallback(xN, posN);
    end

    % ---- pack results
    result.entropy  = entropy_val;

    % old fields
    result.freq     = freq;
    result.spectrum = Xmag;

    % cool fields
    result.x        = xN;
    result.pos      = posN;

    result.psd.f    = f_psd;
    result.psd.Pxx  = P1;

    result.chgIdx   = chgIdx;

    result.state.labels   = stateLbl;
    result.state.centers  = winCenters;
    result.state.features = winFeat;

    result.tf = tf;
end

function tf = fft_blocks_fallback(x, pos)
    % Toolbox-free TF map: sliding FFT energy map
    N = numel(x);
    block = 500;
    nB = floor(N/block);
    if nB < 1
        tf.type = "none";
        return;
    end

    tfMap = zeros(block/2, nB);
    for i = 1:nB
        seg = x((i-1)*block+1:i*block);
        Z = abs(fft(seg)).^2;
        tfMap(:,i) = Z(1:block/2);
    end

    tf.type = "fft_blocks";
    tf.map  = tfMap;
    tf.f    = (1:block/2)'/block;
    tf.t    = linspace(pos(1), pos(end), nB);
end