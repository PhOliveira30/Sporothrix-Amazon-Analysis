# Sporothrix Amazon Analysis
*Repository containing the computational scripts and raw datasets for the phenotypic and genotypic analysis of Sporothrix brasiliensis isolates.*

## 🗂️ Scripts & Datasets Overview

Para facilitar a reprodutibilidade, a tabela abaixo mapeia cada script à sua respetiva base de dados e objetivo analítico:

| Script File | Language | Required Input File | Objective |
| :--- | :--- | :--- | :--- |
| **`boxplot_enzymatic1.R`** | R | `BOXPLOT_IMPUT1.xlsx` | Visualizes overall enzymatic activity (Pz ratios) comparing phospholipase and lipase (with Wilcoxon test). |
| **`boxplot_enzymatic2.R`** | R | `BOXPLOT_IMPUT2.xlsx` | Stratifies enzymatic activity (Pz ratios) to compare feline and human isolates. |
| **`pca_multivariate.py`** | Python | *Interactive prompt* PCA analisys.xlsx | Performs PCA and K-means clustering on combined genetic and phenotypic data. |
| **`pcoa_genetic.R`** | R | `CONCATENED_MLST.fas` | Conducts PCoA using the best-fit evolutionary model to assess genetic population structure. |
| **`mann_whitney_test.py`** | Python | `Mann_Whitney_Test.xlsx` | Applies the Mann-Whitney U test to compare enzymatic activity medians between host groups. |

## ☁️ Cloud Execution (Google Colab)
If you are running these scripts in cloud-based notebooks (such as Google Colab), session storage is temporary. 

**Important:** You must manually upload the corresponding input file (listed in the table above) to the cloud working directory (e.g., `/content/`) **before** executing the R or Python script. 

## 🛠️ Main Dependencies
* **R Packages:** `ggplot2`, `dplyr`, `tidyr`, `readxl`
* **Python Libraries:** `pandas`, `scipy`, `matplotlib`, `seaborn`, `scikit-learn`
