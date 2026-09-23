## Scripts Overview and Objectives

*   **`boxplot_enzymatic.R`**: Visualizes the distribution of enzymatic activity (Pz ratios) for phospholipase and lipase across feline and human isolates.
*   **`pca_multivariate.py`**: Performs Principal Component Analysis (PCA) and K-means clustering to explore grouping patterns based on combined genetic and enzymatic phenotypic data.
*   **`pcoa_genetic.R`**: Conducts Principal Coordinates Analysis (PCoA) using the K80 evolutionary model to assess the genetic population structure of the isolates.
*   **`mann_whitney_test.py`**: Applies the non-parametric Mann-Whitney U test to statistically compare the enzymatic activity medians between human and feline isolates.

### Cloud Execution (Google Colab)
If you are running these scripts in cloud-based notebooks such as Google Colab, please note that the session storage is temporary. You must manually upload the corresponding data files to the cloud working directory (typically the `/content/` folder) before executing the scripts:

*   **For `boxplot_enzymatic.R`**: Upload the `BOXPLOT_IMPUT.xlsx` file.
*   **For `pcoa_genetic.R`**: Upload the `CONCATENED_MLST.fas` file.
*   **For `mann_whitney_test.py`**: Upload the `Mann_Whitney_Test.xlsx` file.

*(Note: The script `pca_multivariate.py` already includes an interactive prompt that will ask you to upload the data file during execution).*