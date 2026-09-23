# ==========================================
# MANN–WHITNEY U TEST (BYPASSING COLUMN NAMES)
# ==========================================

import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu

# ==========================================
# 1. DATA LOADING (POSITIONAL APPROACH)
# ==========================================
file_path = "Mann_Whitney_Test.xlsx"
df_raw = pd.read_excel(file_path)

# Remove entirely empty columns (e.g., the blank column in the middle of the Excel file)
df = df_raw.dropna(axis=1, how='all')

# Extract data strictly by column position, ignoring header names:
# 0 = 1st column (Feline Phospholipase)
# 1 = 2nd column (Human Phospholipase)
# 2 = 3rd valid column (Feline Lipase)
# 3 = 4th valid column (Human Lipase)

phos_f = df.iloc[:, 0].astype(str).str.replace(",", ".", regex=False)
phos_h = df.iloc[:, 1].astype(str).str.replace(",", ".", regex=False)
lip_f = df.iloc[:, 2].astype(str).str.replace(",", ".", regex=False)
lip_h = df.iloc[:, 3].astype(str).str.replace(",", ".", regex=False)

# Convert to numeric values and drop trailing empty rows
group_phos_f = pd.to_numeric(phos_f, errors='coerce').dropna().values
group_phos_h = pd.to_numeric(phos_h, errors='coerce').dropna().values
group_lip_f = pd.to_numeric(lip_f, errors='coerce').dropna().values
group_lip_h = pd.to_numeric(lip_h, errors='coerce').dropna().values

# ==========================================
# 2. STATISTICAL TEST COMPUTATION
# ==========================================
results = []

# Test for Phospholipase
if len(group_phos_f) > 0 and len(group_phos_h) > 0:
    u1, p1 = mannwhitneyu(group_phos_f, group_phos_h, use_continuity=True, alternative="two-sided")
    results.append({
        "Enzyme": "Phospholipase",
        "N_Feline": len(group_phos_f),
        "N_Human": len(group_phos_h),
        "Median_Feline": np.median(group_phos_f),
        "Median_Human": np.median(group_phos_h),
        "U_statistic": u1,
        "p_value": p1
    })

# Test for Lipase
if len(group_lip_f) > 0 and len(group_lip_h) > 0:
    u2, p2 = mannwhitneyu(group_lip_f, group_lip_h, use_continuity=True, alternative="two-sided")
    results.append({
        "Enzyme": "Lipase",
        "N_Feline": len(group_lip_f),
        "N_Human": len(group_lip_h),
        "Median_Feline": np.median(group_lip_f),
        "Median_Human": np.median(group_lip_h),
        "U_statistic": u2,
        "p_value": p2
    })

# ==========================================
# 3. FINAL RESULTS TABLE
# ==========================================
df_final = pd.DataFrame(results)

print("\n=== FINAL STATISTICAL RESULTS (MANN–WHITNEY U TEST) ===\n")
print(
    df_final.to_string(
        index=False,
        formatters={
            "p_value": "{:,.4f}".format,
            "Median_Feline": "{:,.3f}".format,
            "Median_Human": "{:,.3f}".format
        }
    )
)