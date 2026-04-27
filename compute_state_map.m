function [labels, centers, feat] = compute_state_map(x, pos, win, hop, k)
% COMPUTE_STATE_MAP
% Toolbox-free windowed state extraction.
% Features per window:
%  1 mean
%  2 std
%  3 skewness (manual)
%  4 kurtosis (manual)
%  5 high-frequency roughness
%  6 entropy proxy
%
% Clustering:
%  - uses kmeans if available
%  - otherwise uses simple_kmeans fallback

    N = numel(x);
    if N < win
        labels  = 1;
        centers = pos(round(end/2));
        feat    = zeros(1,6);
        return;
    end

    starts  = 1:hop:(N-win+1);
    nW      = numel(starts);
    feat    = zeros(nW,6);
    centers = zeros(nW,1);

    for i = 1:nW
        seg = x(starts(i):starts(i)+win-1);
        seg = seg(:);

        centers(i) = pos(starts(i) + floor(win/2));

        m  = mean(seg,'omitnan');
        sd = std(seg,'omitnan');
        if sd == 0, sd = eps; end

        skew = mean(((seg - m)/sd).^3, 'omitnan');
        kurt = mean(((seg - m)/sd).^4, 'omitnan');

        d = diff(seg);
        hfRatio = mean(d.^2,'omitnan') / (mean(seg.^2,'omitnan') + eps);

        nb = 30;
        c = histcounts(seg, nb, 'Normalization','probability');
        c(c==0) = [];
        H = -sum(c .* log2(c));

        feat(i,:) = [m, sd, skew, kurt, hfRatio, H];
    end

    featZ = (feat - mean(feat,1,'omitnan')) ./ (std(feat,[],1,'omitnan') + eps);

    % Cluster
    if exist('kmeans','file') == 2
        try
            labels = kmeans(featZ, k, 'Replicates', 10, 'MaxIter', 200);
            return;
        catch
            % fall through to simple kmeans
        end
    end

    labels = simple_kmeans(featZ, k, 200, 5);
end

function labels = simple_kmeans(X, k, maxIter, reps)
% SIMPLE_KMEANS - minimal k-means implementation (squared Euclidean)
% X: n x d
    [n,d] = size(X);
    bestLabels = ones(n,1);
    bestInertia = inf;

    for r = 1:reps
        % init centroids: random rows
        idx = randperm(n, min(k,n));
        C = X(idx, :);
        if size(C,1) < k
            % pad if n<k
            C = [C; X(randi(n, k-size(C,1), 1), :)];
        end

        labels = ones(n,1);
        for it = 1:maxIter
            % assign
            D2 = zeros(n,k);
            for j = 1:k
                diff = X - C(j,:);
                D2(:,j) = sum(diff.^2,2);
            end
            [~, newLabels] = min(D2,[],2);

            if all(newLabels == labels)
                break;
            end
            labels = newLabels;

            % update
            for j = 1:k
                mask = (labels==j);
                if any(mask)
                    C(j,:) = mean(X(mask,:),1);
                else
                    % empty cluster: reinit to random point
                    C(j,:) = X(randi(n),:);
                end
            end
        end

        % inertia
        inertia = 0;
        for j = 1:k
            mask = (labels==j);
            if any(mask)
                diff = X(mask,:) - C(j,:);
                inertia = inertia + sum(sum(diff.^2,2));
            end
        end

        if inertia < bestInertia
            bestInertia = inertia;
            bestLabels = labels;
        end
    end

    labels = bestLabels;
end