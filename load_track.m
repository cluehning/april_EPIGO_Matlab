function track = load_track(filename, step)
% LOAD_TRACK  Load epigenetic track from bedGraph-like file.
% Assumes columns: chr | start | end | value  (value in col 4)
% step: take every 'step'-th point (default 50)

    if nargin < 2 || isempty(step)
        step = 50;
    end

    % readmatrix is fine, but readtable is sometimes more robust for huge files.
    % We'll try readmatrix first, fallback to readtable.
    try
        data = readmatrix(filename, 'FileType','text', 'Delimiter','\t');
    catch
        T = readtable(filename, 'FileType','text', 'Delimiter','\t', 'ReadVariableNames',false);
        data = table2array(T);
    end

    % Downsample
    idx = 1:step:size(data,1);

    track.signal = data(idx, 4);

    % Optional: positions (midpoint of interval), if columns exist
    if size(data,2) >= 3
        startp = data(idx,2);
        endp   = data(idx,3);
        track.pos = (startp + endp) / 2;
    else
        track.pos = (1:numel(track.signal))';
    end

    [~, name, ~] = fileparts(filename);
    track.name = name;
    track.step = step;
    track.filename = filename;
end