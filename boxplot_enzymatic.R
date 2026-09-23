# ==========================================
# ENZYMATIC ACTIVITY ANALYSIS
# ==========================================


# ==========================================
# 0. INSTALL AND LOAD REQUIRED PACKAGES
# ==========================================

if (!require("ggplot2")) install.packages("ggplot2", quiet = TRUE)
if (!require("tidyr")) install.packages("tidyr", quiet = TRUE)
if (!require("dplyr")) install.packages("dplyr", quiet = TRUE)
if (!require("readxl")) install.packages("readxl", quiet = TRUE)
if (!require("janitor")) install.packages("janitor", quiet = TRUE)

# ==========================================
# 1. LOAD THE DATA
# ==========================================
dados_raw <- read_excel(
  "BOXPLOT_IMPUT.xlsx",
  col_names = TRUE
)

# Clean column names (converts to lowercase and underscores)
dados_clean_names <- dados_raw %>%
  clean_names()

# ==========================================
# 2. SELECT AND CONVERT ANALYZED ENZYMES
# ==========================================
dados_filtrados <- dados_clean_names %>%
  mutate(
    across(
      c(
        phospholipase_felin,
        phospholipase_human,
        lipase_felin,
        lipase_human
      ),
      as.numeric
    )
  ) %>%
  filter(
    !is.na(phospholipase_felin) |
    !is.na(phospholipase_human) |
    !is.na(lipase_felin) |
    !is.na(lipase_human)
  )

n_isolates <- nrow(dados_filtrados)

# ==========================================
# 3. CREATE LONG-FORM DATASET
# ==========================================
df_longo <- data.frame(
  Group = c(
    rep("Feline", n_isolates),
    rep("Human", n_isolates)
  ),
  Phospholipase = c(
    dados_filtrados$phospholipase_felin,
    dados_filtrados$phospholipase_human
  ),
  Lipase = c(
    dados_filtrados$lipase_felin,
    dados_filtrados$lipase_human
  )
) %>%
  mutate(
    across(c(Phospholipase, Lipase), as.numeric)
  ) %>%
  pivot_longer(
    cols = -Group,
    names_to = "Enzyme",
    values_to = "Pz"
  ) %>%
  filter(!is.na(Pz))

# ==========================================
# 4. CREATE GROUPING VARIABLE
# ==========================================
df_longo <- df_longo %>%
  mutate(
    Enzyme_Group = paste(Enzyme, Group, sep = "_")
  )

# ==========================================
# 5. DEFINE COLORS
# ==========================================
custom_colors <- c(
  "Phospholipase_Feline" = "#66C2A5",
  "Phospholipase_Human" = "#339966",
  "Lipase_Feline" = "#FC8D62",
  "Lipase_Human" = "#CC6633"
)

# ==========================================
# 6. GENERATE BOXPLOT
# ==========================================
ggplot(df_longo, aes(x = Enzyme, y = Pz, fill = Enzyme_Group)) +
  geom_boxplot(
    alpha = 0.6,
    outlier.shape = NA,
    width = 0.5,
    position = position_dodge(width = 0.8)
  ) +
  geom_jitter(
    alpha = 0.5,
    size = 2,
    position = position_jitterdodge(dodge.width = 0.8)
  ) +
  scale_y_reverse(
    limits = c(1.0, 0.1),
    breaks = seq(0.1, 1.0, 0.1)
  ) +
  scale_fill_manual(
    name = "Sample Origin",
    values = custom_colors
  ) +
  labs(
    title = "Enzymatic Activity of Sporothrix brasiliensis",
    subtitle = "Pz Ratio Analysis (Reversed Y-axis)",
    x = "Enzyme Analyzed",
    y = "Pz Ratio",
    caption = "Pz < 0.70: strong activity | 1.0: absent"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold")
  )