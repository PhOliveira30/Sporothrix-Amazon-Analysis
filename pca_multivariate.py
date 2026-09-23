# ==========================================
# PCA — GENETIC + ENZYMATIC PHENOTYPE
# ==========================================

# 1. Install required library
!pip install scikit-bio openpyxl -q

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from skbio.stats.distance import permanova, DistanceMatrix
from scipy.spatial.distance import pdist, squareform
from google.colab import files

# ==========================================
# 2. DATA LOADING AND CLEANING
# ==========================================
print("Select the spreadsheet:")
uploaded = files.upload()
file_name = list(uploaded.keys())[0]

# Lê o arquivo de forma segura sem dar erro de formato
if file_name.endswith('.csv'):
    df_raw = pd.read_csv(file_name, header=None, sep=None, engine='python')
else:
    df_raw = pd.read_excel(file_name, header=None, engine='openpyxl')

# Pega as 3 primeiras colunas e nomeia conforme o seu script original
df = df_raw.iloc[:, 0:3].copy()
df.columns = ["sequences", "phospholipase", "lipase"]

# Data cleaning and numeric conversion
df["sequences"] = df["sequences"].astype(str).str.strip().str.upper()

for col in ["phospholipase", "lipase"]:
    df[col] = df[col].astype(str).str.replace(",", ".", regex=False)
    df[col] = pd.to_numeric(df[col], errors="coerce")

df = df.dropna(subset=["sequences", "phospholipase", "lipase"]).reset_index(drop=True)

# Generate an ID for each isolate
df["id"] = [f"isolate_{i+1}" for i in range(len(df))]

# ==========================================
# 3. PROCESSING (DNA + PHENOTYPE)
# ==========================================
def sequence_to_matrix(sequences):
    seq_len = len(sequences[0])
    mapping = {'A': 0, 'C': 1, 'G': 2, 'T': 3}
    matrix = np.zeros((len(sequences), seq_len), dtype=int)
    for i, seq in enumerate(sequences):
        for j, nuc in enumerate(seq):
            matrix[i, j] = mapping.get(nuc, 4)
    return matrix

# Convert DNA sequences into a numerical matrix
alignment_matrix = sequence_to_matrix(df["sequences"].tolist())

# Enzymatic phenotype matrix
pheno_matrix = df[["phospholipase", "lipase"]].values

# Standardize genetic and phenotypic data
scaler = StandardScaler()
alignment_scaled = scaler.fit_transform(alignment_matrix)
pheno_scaled = scaler.fit_transform(pheno_matrix)

# Combine genetic and phenotypic data
combined_matrix = np.hstack([alignment_scaled, pheno_scaled])

# ==========================================
# 4. PCA AND CLUSTERING (K = 3)
# ==========================================
pca = PCA(n_components=2)
pca_coords = pca.fit_transform(combined_matrix)

df["PC1"] = pca_coords[:, 0]
df["PC2"] = pca_coords[:, 1]

# K-means clustering
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
df["Cluster"] = kmeans.fit_predict(pca_coords)

# ==========================================
# 5. VISUALIZATION
# ==========================================
plt.figure(figsize=(10, 7))

sns.scatterplot(
    data=df, x="PC1", y="PC2",
    hue="Cluster", style="Cluster",
    s=180, palette="Set1", alpha=0.9,
    edgecolor="black", linewidth=1
)

plt.title("PCA: Genetic–Enzymatic Clustering", fontsize=14, fontweight="bold")
plt.xlabel(f"PC1 ({pca.explained_variance_ratio_[0]*100:.1f}% variance)")
plt.ylabel(f"PC2 ({pca.explained_variance_ratio_[1]*100:.1f}% variance)")
plt.grid(True, alpha=0.2, linestyle="--")
plt.axhline(0, color="black", lw=1, alpha=0.1)
plt.axvline(0, color="black", lw=1, alpha=0.1)
plt.legend(title="Clusters", title_fontsize="12", loc="best")
plt.tight_layout()
plt.show()

# ==========================================
# 6. STATISTICAL REPORT
# ==========================================
print("\n" + "=" * 50)
print("STATISTICAL VALIDATION REPORT")
print("=" * 50)

dist_matrix = pdist(combined_matrix, metric="euclidean")
dm = DistanceMatrix(squareform(dist_matrix))
res_permanova = permanova(dm, grouping=df["Cluster"].tolist(), permutations=999)

print(f"PERMANOVA p-value: {res_permanova['p-value']:.4f}")
print(f"PERMANOVA pseudo-F statistic: {res_permanova['test statistic']:.4f}")

if "R2" in res_permanova:
    print(f"PERMANOVA R-squared: {res_permanova['R2']:.4f}")
else:
    print("PERMANOVA R-squared: Not available in the result object.")

print("\n" + "-" * 50)
print("CLUSTER SUMMARY: MEAN Pz VALUES")
print("-" * 50)

medias_pz = df.groupby("Cluster")[["phospholipase", "lipase"]].mean().round(3)
display(medias_pz)

print("\nInterpretation note: Lower Pz values indicate higher enzymatic activity.")