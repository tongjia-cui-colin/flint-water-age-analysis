# ======================================================
# Flint Water Crisis: Water Age Analysis
# ======================================================



# ======================================================
# 1. Libraries
# ======================================================

library(tidyverse)
library(psych)
library(mice)
library(car)
library(ggplot2)


# ======================================================
# 2. Data Loading
# ======================================================

# NOTE: replace with local relative path if needed
data <- read.csv("data/MODEL_CT_RESULTS.csv")


# ======================================================
# 3. Baseline Filtering
# ======================================================

baseline_data <- data %>%
  filter(Scenario == 0)


# ======================================================
# 4. Variable Construction
# ======================================================

baseline_data$WhiteDominant <- ifelse(
  baseline_data$PrcNW < 50, 1, 0
)


# ======================================================
# 5. Descriptive Statistics
# ======================================================

analysis_vars <- baseline_data %>%
  select(
    AvgP,
    Ag50,
    Distress,
    PercVacant,
    PrcNW,
    WhiteDominant
  )

desc_stats <- describe(analysis_vars) %>%
  select(n, mean, sd, min, max)

desc_stats

# Distribution of WhiteDominant
freq_WhiteDominant <- table(baseline_data$WhiteDominant)
prop_WhiteDominant <- prop.table(freq_WhiteDominant)

freq_WhiteDominant
prop_WhiteDominant


# ======================================================
# 6. Multiple Imputation (PMM)
# ======================================================

impute_data <- baseline_data[, c(
  "Ag50",
  "Distress",
  "PercVacant",
  "PrcNW",
  "AvgP",
  "WhiteDominant"
)]

# Define imputation methods and predictors
meth <- make.method(impute_data)
meth["WhiteDominant"] <- "~I(PrcNW < 50)"

pred <- make.predictorMatrix(impute_data)

imp <- mice(
  impute_data,
  m = 10,
  method = meth,
  predictorMatrix = pred,
  maxit = 10,
  seed = 123,
  print = FALSE
)


# ======================================================
# 7. Imputation Diagnostics
# ======================================================

plot(imp)
densityplot(imp)

imp_list <- complete(imp, action = "all")

means_PercVacant <- sapply(imp_list, function(x) mean(x$PercVacant, na.rm = TRUE))
means_PrcNW      <- sapply(imp_list, function(x) mean(x$PrcNW, na.rm = TRUE))

means_PercVacant
means_PrcNW

diff(range(means_PercVacant))
diff(range(means_PrcNW))


# ======================================================
# 8. Model Estimation (Pooled)
# ======================================================

# Full model with interaction
fit <- with(
  imp,
  {
    WhiteDominant <- ifelse(PrcNW < 50, 1, 0)
    lm(Ag50 ~ AvgP + Distress + AvgP:Distress + PercVacant + WhiteDominant)
  }
)

# Reduced model
fit_reduced <- with(
  imp,
  {
    WhiteDominant <- ifelse(PrcNW < 50, 1, 0)
    lm(Ag50 ~ AvgP + Distress + PercVacant + WhiteDominant)
  }
)


# ======================================================
# 9. Pooled Results
# ======================================================

summary(pool(fit))
summary(pool(fit_reduced))

pool.r.squared(fit)
pool.r.squared(fit, adjusted = TRUE)

pool.r.squared(fit_reduced)
pool.r.squared(fit_reduced, adjusted = TRUE)


# ======================================================
# 10. Model Comparison
# ======================================================

D1(fit, fit_reduced)


# ======================================================
# 11. Collinearity Check
# ======================================================

data_complete <- complete(imp, 1)

vif(
  lm(
    Ag50 ~ AvgP + Distress + PercVacant + PrcNW,
    data = data_complete
  )
)


# ======================================================
# 12. Visualization Settings (APA)
# ======================================================

theme_set(
  theme_classic(base_family = "Arial") +
    theme(
      axis.title = element_text(size = 11),
      axis.text  = element_text(size = 11)
    )
)


# ======================================================
# 13. Diagnostics Plots
# ======================================================

model_vis <- lm(
  Ag50 ~ AvgP + Distress + PercVacant + WhiteDominant,
  data = data_complete
)

data_complete$fitted    <- fitted(model_vis)
data_complete$residuals <- resid(model_vis)

# Observed vs Fitted
obs_fit <- ggplot(data_complete, aes(x = fitted, y = Ag50)) +
  geom_point(alpha = 0.4, color = "gray40") +
  geom_abline(intercept = 0, slope = 1) +
  labs(
    x = "Fitted values",
    y = "Observed mean water age (hours)"
  )

obs_fit

ggsave(
  "figures/figure1_observed_vs_fitted.png",
  obs_fit,
  width = 7,
  height = 5,
  dpi = 300
)

# Residuals vs Fitted
res_fit <- ggplot(data_complete, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.4, color = "gray40") +
  geom_hline(yintercept = 0) +
  labs(
    x = "Fitted values",
    y = "Residuals (hours)"
  )

res_fit

ggsave(
  "figures/figure2_residuals.png",
  res_fit,
  width = 7,
  height = 5,
  dpi = 300
)
