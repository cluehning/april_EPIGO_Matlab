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

## How to Run

This repository primarily contains analysis outputs (PDF figures) generated
via exploratory MATLAB workflows. The code is not organized as a standalone
package or command‑line tool, but as a collection of scripts used for signal
processing and visualization experiments.

### Requirements
- MATLAB (tested with recent versions; toolboxes used are standard FFT and
  signal-processing functionality)
- Preprocessed epigenomic signal tracks (genome‑indexed vectors derived from
  bedGraph / bigWig data)

### General Workflow
At a high level, the MATLAB analysis follows these steps:
1. Load a genome‑wide signal track into MATLAB as a one‑dimensional vector
2. Apply normalization (e.g. z‑scoring)
3. Compute entropy after probability normalization with ε‑smoothing
4. Compute global FFT / power spectrum from centered signals
5. Perform sliding‑window FFT energy analysis to probe local structure
6. Generate summary visualizations (state maps, spectra, heatmaps)
7. Export figures as PDFs

The exact scripts reflect exploratory development and may require adaptation
(e.g. paths, bin sizes, window lengths) depending on the input data format.

### Notes on Reproducibility
- This repo emphasizes **conceptual exploration and visualization**, not a
  frozen or parameter‑stable pipeline.
- Results depend on modeling choices such as bin width, window size, and
  smoothing parameters.
- For a more formal and modular implementation of the underlying framework,
  see the original EPIGO codebase:
  https://github.com/cluehning/march_EPIGO
  
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
- These signal-level differences are consistent with known biological roles of the marks (e.g., promoter-associated H3K4me3 versus enhancer-associated H3K27ac), though no genomic annotations are used directly in the analysis.

## Outputs
- `E071-H3K4me3.pdf`: Entropy, state map, sliding FFT energy, and power spectrum
- `E071-H3K27ac.pdf`: Same analyses for H3K27ac
- `Figure_1.pdf`: Time-domain signal, FFT magnitude, and heatmap for H3K27ac
- `Figure_3.pdf`: Time-domain signal, FFT magnitude, and heatmap for H3K4me3

## Motivation
This project treats epigenomic data as a **signal processing problem**, offering an alternative perspective to classical peak-based or annotation-driven analyses.

