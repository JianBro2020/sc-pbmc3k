# sc-pbmc3k — Single-cell PBMC 3k analysis (Scanpy)

End-to-end scRNA-seq analysis of the **10x Genomics PBMC 3k** dataset using **Scanpy**, including:
- QC + filtering (cells and genes)
- Ambient RNA correction (SoupX via `soupx-python`)
- Doublet detection (Scrublet)
- Normalisation (shifted log)
- Feature selection (HVGs)
- Dimensionality reduction (PCA, UMAP / t-SNE)
- Clustering (Leiden)
- Marker gene ranking (Wilcoxon)

---

## Data Acquisition 
The raw data can be obtained from [10x Genomics](https://www.10xgenomics.com/datasets/3-k-pbm-cs-from-a-healthy-donor-1-standard-1-0-0).

---

## Environment Setup
Create the virtual environment and install dependencies:
```bash
python -m venv sc_env
source sc_env/bin/activate  # On Windows use `sc_env\Scripts\activate`
pip install -r sc_env/requirements.txt