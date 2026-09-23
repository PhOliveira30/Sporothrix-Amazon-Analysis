# ==========================================
# PCoA — GENETIC STRUCTURE
# ==========================================


# ==========================================
# 1. SETUP: INSTALL AND LOAD PACKAGES
# ==========================================

if (!require("ape"))
  install.packages(
    "ape",
    quiet = TRUE
  )

if (!require("ggplot2"))
  install.packages(
    "ggplot2",
    quiet = TRUE
  )

if (!require("vegan"))
  install.packages(
    "vegan",
    quiet = TRUE
  )


library(ape)
library(ggplot2)
library(vegan)


# ==========================================
# 2. LOAD GENETIC DATA
# ==========================================

# Make sure the file
# "CONCATENED_MLST.fas"
# is available in the working directory.

dna <- read.dna(
  "CONCATENED_MLST.fas",
  format = "fasta"
)


# ==========================================
# 3. DISTANCE CALCULATION AND PCoA
# ==========================================

message(
  "Calculating K80 genetic distances and PCoA..."
)

dist_k80 <- dist.dna(
  dna,
  model = "K80"
)

pcoa_res <- cmdscale(
  dist_k80,
  k = 2,
  eig = TRUE
)


# ==========================================
# 4. CLUSTERING (K = 3)
# ==========================================

set.seed(123)

clusters <- kmeans(
  pcoa_res$points,
  centers = 3
)


# Create the main data frame
pcoa_df <- data.frame(

  ID =
    rownames(
      pcoa_res$points
    ),

  PC1 =
    pcoa_res$points[, 1],

  PC2 =
    pcoa_res$points[, 2],

  Cluster =
    as.factor(
      clusters$cluster
    )
)


# ==========================================
# 5. STATISTICAL VALIDATION — PERMANOVA
# ==========================================

message(
  "Running PERMANOVA to validate genetic groups..."
)

permanova <- adonis2(
  dist_k80 ~ Cluster,
  data = pcoa_df,
  permutations = 999
)

p_value <-
  permanova$`Pr(>F)`[1]

r2_value <-
  round(
    permanova$R2[1],
    3
  )


# ==========================================
# 6. PUBLICATION-QUALITY PLOT
# ==========================================

eig_pos <-
  pcoa_res$eig[
    pcoa_res$eig > 0
  ]

var_exp <-
  round(
    eig_pos /
      sum(eig_pos) *
      100,
    1
  )


pcoa_plot <-

  ggplot(
    pcoa_df,
    aes(
      x = PC1,
      y = PC2,
      color = Cluster
    )
  ) +

  geom_point(
    size = 3.5,
    alpha = 0.8
  ) +

  stat_ellipse(
    level = 0.95,
    linetype = 2,
    alpha = 0.5
  ) +

  scale_color_brewer(
    palette = "Set1"
  ) +

  labs(

    title =
      "Population Structure of S. brasiliensis",

    subtitle =
      paste0(
        "PERMANOVA p = ",
        p_value,
        " | R² = ",
        r2_value
      ),

    x =
      paste0(
        "PC1 (",
        var_exp[1],
        "%)"
      ),

    y =
      paste0(
        "PC2 (",
        var_exp[2],
        "%)"
      )

  ) +

  theme_classic()


print(
  pcoa_plot
)


# ==========================================
# 7. CLUSTER MEMBERSHIP REPORT
# ==========================================

cat(
  "\n--- CLUSTER MEMBERSHIP REPORT ---\n"
)

for (
  i in sort(
    unique(
      clusters$cluster
    )
  )
) {

  membros <-
    pcoa_df$ID[
      pcoa_df$Cluster == i
    ]

  cat(
    paste0(
      "\nCLUSTER ",
      i,
      " (n=",
      length(membros),
      "):\n"
    )
  )

  cat(
    paste(
      membros,
      collapse = ", "
    ),
    "\n"
  )
}