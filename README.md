# EPIGO | Signal & Frequency Analysis of Histone Marks (E071)
**Epigenetic Information Geometry Observatory**  
*(or: Epigenetics, built like LEGO)*

This project explores large-scale genomic signal structure using **signal processing techniques** applied to histone modification tracks. By combining time-domain, frequency-domain, and entropy-based analyses, the goal is to better understand global patterns and local complexity in epigenomic signals.

## Project Lineage & Inspiration

This project builds directly on ideas and visual frameworks developed in
[march_EPIGO](https://github.com/cluehning/march_EPIGO).

EPIGO approaches epigenetic tracks not as anonymous arrays of numbers, but as
**structured signals** whose properties can be studied using information‑theoretic
and spectral tools (entropy, FFTs, global vs. local structure). The core idea is to
treat epigenomic data as something closer to a *composable object* than a flat dataset
— an intuition often described in EPIGO as thinking in terms of LEGO bricks rather
than raw values.

### How this project builds on EPIGO

While EPIGO provides the original conceptual framework and mathematical tools, this
project focuses on:
- applying those ideas **end‑to‑end to concrete histone mark tracks (E071)**
- producing **clean, publication‑style visual summaries** rather than a general‑purpose codebase
- emphasizing **signal‑processing viewpoints** (sliding FFT energy, global spectra,
  entropy comparisons) as interpretive tools rather than abstractions

In short:
- **EPIGO** asks *how should we think about epigenetic signals?*
- **This project** asks *what do those ideas reveal when we actually look at real
  tracks in detail?*

This work should therefore be read as an **extension and application** of the EPIGO
idea framework, not a replacement or independent re‑implementation.

## Implementation Notes & Extensions (MATLAB)

The EPIGO.pdf document describes the conceptual and mathematical framework
underlying this work (entropy, spectral structure, and signal-centric views
of epigenomic tracks). The MATLAB analyses in this repository go beyond that
formal description in several practical and exploratory ways.

In particular, the MATLAB workflow:
- explores multiple visualization strategies (state maps, sliding-window FFT
  energy, large-scale heatmaps) that are not formalized in the EPIGO write‑up
- experiments with windowed and local frequency summaries to probe spatial
  heterogeneity along the genome
- emphasizes empirical comparison between histone marks via signal behavior,
  rather than defining a fixed comparison metric

As a result, the figures here should be understood as **exploratory signal
analyses built on the EPIGO framework**, rather than as a direct or complete
implementation of the EPIGO pipeline described in the PDF.

## Data
The analysis focuses on two histone modifications from the E071 cell type:
- **H3K4me3** – commonly associated with promoters
- **H3K27ac** – associated with active enhancers

Signals span the genome and are treated as long one-dimensional sequences.

## Methods
For each signal, the following analyses were performed:
- **Z-score normalization** to standardize signal amplitude
- **Entropy estimation** to quantify overall signal complexity
- **State map construction** to visualize discrete signal regimes across genomic positions
- **Sliding-window FFT energy analysis** to capture local frequency content
- **Global FFT / power spectrum analysis** to assess dominant frequency components
- **Signal heatmaps** to visualize large-scale signal distribution

## Key Observations
- H3K27ac exhibits slightly higher entropy than H3K4me3, suggesting increased variability and complexity.
- Frequency-domain analyses indicate that both signals are dominated by low-frequency components, with subtle differences in spectral decay.
- State maps and sliding FFT energy reveal spatial heterogeneity along the genome, particularly pronounced for H3K27ac.

## Outputs
- `E071-H3K4me3.pdf`: Entropy, state map, sliding FFT energy, and power spectrum
- `E071-H3K27ac.pdf`: Same analyses for H3K27ac
- `Figure_1.pdf`: Time-domain signal, FFT magnitude, and heatmap for H3K27ac
- `Figure_3.pdf`: Time-domain signal, FFT magnitude, and heatmap for H3K4me3

## Motivation
This project treats epigenomic data as a **signal processing problem**, offering an alternative perspective to classical peak-based or annotation-driven analyses.

