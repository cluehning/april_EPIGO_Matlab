# Signal & Frequency Analysis of Histone Marks (E071)

This project explores large-scale genomic signal structure using **signal processing techniques** applied to histone modification tracks. By combining time-domain, frequency-domain, and entropy-based analyses, the goal is to better understand global patterns and local complexity in epigenomic signals.

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

## Status
April project – exploratory analysis and visualization.
