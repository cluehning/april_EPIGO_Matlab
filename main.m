% --- H3K27ac
track_ac = load_track('data/E071-H3K27ac.bedGraph', 50);
analysis_ac = analyze_track_v2(track_ac);
visualize_track(track_ac, analysis_ac);

% --- H3K4me3
track_me3 = load_track('data/E071-H3K4me3.bedGraph', 50);
analysis_me3 = analyze_track_v2(track_me3);
visualize_track(track_me3, analysis_me3);