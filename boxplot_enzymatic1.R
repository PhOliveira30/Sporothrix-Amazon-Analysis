# ==========================================
# OVERALL ENZYMATIC ACTIVITY COMPARISON
# ==========================================

if (!require("readxl")) install.packages("readxl", quiet = TRUE)
if (!require("ggplot2")) install.packages("ggplot2", quiet = TRUE)
if (!require("dplyr")) install.packages("dplyr", quiet = TRUE)
if (!require("tidyr")) install.packages("tidyr", quiet = TRUE)

library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)

# ==========================================
# 1. READ DATA
# ==========================================
file_path <- "BOXPLOT_IMPUT1.xlsx"

df_raw <- read_excel(file_path, col_names = TRUE)

# ==========================================
# 2. DATA CLEANING
# ==========================================
df <- df_raw %>%
  # Renomeia as colunas originais do Excel para nomes simples
  rename(
    PHOSPHOLIPASE = `Phospholipase (Pz) 21 days`,
    LIPASE = `Lipase (Pz) 10 days`
  ) %>%
  # Seleciona apenas as duas enzimas presentes no arquivo
  select(PHOSPHOLIPASE, LIPASE) %>%
  mutate(across(everything(), as.numeric)) %>%
  filter(!is.na(PHOSPHOLIPASE) | !is.na(LIPASE))

# --- Structure Check ---
print(paste("Dimensions after cleaning:", dim(df)[1], "rows,", dim(df)[2], "columns"))
print(paste("Column names after cleaning:", paste(colnames(df), collapse = ", ")))

# ==========================================
# 3. PIVOT TO LONG FORMAT AND SET ORDER
# ==========================================
data_long <- df %>%
  pivot_longer(cols = everything(), 
               names_to = "Enzyme",
               values_to = "Pz") %>%
  filter(!is.na(Pz)) %>%
  # Força a ordem (Phospholipase na esquerda) e ajusta o texto para maiúscula/minúscula
  mutate(Enzyme = factor(Enzyme, 
                         levels = c("PHOSPHOLIPASE", "LIPASE"),
                         labels = c("Phospholipase", "Lipase")))
# ==========================================
# 4. GENERATE BOXPLOT
# ==========================================
ggplot(data_long, aes(x = Enzyme, y = Pz, fill = Enzyme)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.15, alpha = 0.5, size = 2) +
  scale_y_reverse(limits = c(1.05, 0.1), breaks = seq(0.1, 1.0, 0.1)) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Enzymatic Activity of Sporothrix brasiliensis",
    subtitle = "Pz Ratio Analysis (Reversed Y-axis)",
    x = "Analyzed Enzyme",
    y = "Pz Ratio",
    caption = "Pz < 0.64: Very strong activity | 1.0: Null activity"
  ) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 14),
        axis.title = element_text(face = "bold"))

# ==========================================
# 5. STATISTICAL ANALYSIS (WILCOXON TEST)
# ==========================================
# Applies the Wilcoxon test to compare Phospholipase and Lipase Pz values
wilcox_result <- wilcox.test(Pz ~ Enzyme, data = data_long, exact = FALSE)
print(wilcox_result)