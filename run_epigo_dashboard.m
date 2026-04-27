% RUN_EPIGO_DASHBOARD
% Loads all *.bedGraph in data/, makes per-track dashboard,
% plus a global similarity matrix across tracks.

files = dir(fullfile('data','*.bedGraph'));
assert(~isempty(files), 'Keine *.bedGraph Dateien in data/ gefunden.');

opts = struct('maxN',200000,'nChg',12,'win',2000,'hop',500,'kStates',5,'useCWT',true);

tracks = cell(numel(files),1);
featAll = [];
names = strings(numel(files),1);

for i = 1:numel(files)
    fn = fullfile(files(i).folder, files(i).name);
    track = load_track(fn, 50);
    res = analyze_track_v2(track, opts);

    visualize_track_cool(track, res);

    % Global feature vector (simple + robust)
    psd = res.psd.Pxx; f = res.psd.f;
    % Summaries: entropy, PSD band energies
    b1 = bandpower(psd, f, [0.00 0.05], 'psd');
    b2 = bandpower(psd, f, [0.05 0.15], 'psd');
    b3 = bandpower(psd, f, [0.15 0.30], 'psd');
    b4 = bandpower(psd, f, [0.30 0.50], 'psd');

    feat = [res.entropy, log10([b1 b2 b3 b4] + eps)];
    featAll = [featAll; feat];

    tracks{i} = track;
    names(i) = string(track.name);
end

% Similarity matrix (correlation in feature space)
Z = (featAll - mean(featAll,1)) ./ (std(featAll,[],1) + eps);
S = corr(Z'); % track-by-track similarity

figure('Color','w','Name','Track Similarity (Feature Correlation)');
imagesc(S); axis square; colorbar;
title('Ähnlichkeit der Tracks (Korrelation der Feature-Vektoren)');
set(gca,'XTick',1:numel(names),'XTickLabel',names,'XTickLabelRotation',45);
set(gca,'YTick',1:numel(names),'YTickLabel',names);