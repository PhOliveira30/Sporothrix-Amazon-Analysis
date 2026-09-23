# Sporothrix Amazon Analysis
*Repository containing the computational scripts and raw datasets for the phenotypic and genotypic analysis of Sporothrix brasiliensis isolates.*

## 🗂️ Scripts & Datasets Overview

To facilitate full reproducibility, the table below maps each computational script to its required dataset and analytical objective:

| Script File | Language | Required Input File | Objective |
| :--- | :--- | :--- | :--- |
| **`boxplot_enzymatic1.R`** | R | `data/BOXPLOT_IMPUT1.xlsx` | Visualizes overall enzymatic activity (Pz ratios) comparing phospholipase and lipase (Wilcoxon test). |
| **`boxplot_enzymatic2.R`** | R | `data/BOXPLOT_IMPUT2.xlsx` | Stratifies enzymatic activity (Pz ratios) to compare feline and human isolates. |
| **`pca_multivariate.py`** | Python | *Interactive prompt* | Performs PCA and K-means clustering on combined genetic and phenotypic data. |
| **`pcoa_genetic.R`** | R | `data/CONCATENED_MLST.fas` | Conducts PCoA using the best-fit evolutionary model to assess genetic population structure. |
| **`mann_whitney_test.py`** | Python | `data/Mann_Whitney_Test.xlsx` | Applies the Mann-Whitney U test to compare enzymatic activity medians between host groups. |

## ⚠️ Important Note on Laboratory Data
The raw laboratory datasets provided in the `data/` folder are made available exclusively to ensure the transparency, reproducibility, and reliability of the analyses presented in our published study. We kindly request that you **do not use, reproduce, or publish these specific datasets for your own independent research** without explicit authorization from the authors. 

## 🔄 Using Your Own Data
While the study data is restricted, we strongly encourage other researchers to use and adapt these **computational scripts** for their own fungal epidemiology studies! To run the analyses with your own datasets, you have two simple options:

1. **Edit the script:** Open the `.R` or `.py` file in your editor and change the file name variable (e.g., `file_path <- "your_dataset.xlsx"`) to match your file.
2. **Rename your file:** Alternatively, simply rename your Excel or FASTA file to match the default names expected by the scripts (e.g., `BOXPLOT_IMPUT1.xlsx`).

*Note: Ensure your custom Excel files maintain the exact same column headers (e.g., `PHOSPHOLIPASE`, `LIPASE`) as our original datasets so the code can read and plot the variables correctly.*

## ☁️ Cloud Execution (Google Colab)
If you are running these scripts in cloud-based notebooks (such as Google Colab), session storage is temporary. 

**Important:** You must manually upload the corresponding input file (listed in the table above) to the cloud working directory (e.g., `/content/`) **before** executing the R or Python script. 

## 🛠️ Main Dependencies
* **R Packages:** `ggplot2`, `dplyr`, `tidyr`, `readxl`
* **Python Libraries:** `pandas`, `scipy`, `matplotlib`, `seaborn`, `scikit-learn`
