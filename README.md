# Flint Water Crisis: Water Age Analysis

## Overview
This project examines water infrastructure conditions during the Flint Water Crisis using modeled water age as an outcome variable. The analysis evaluates whether water quality, using water age as proxy, meaningfully reflects variation associated with socioeconomic vulnerability and public health risk.

The focus of the project is on model validity, diagnostics, and the interpretability of regression-based results.

## Methods
- Ordinary Least Squares (OLS) regression
- Model diagnostics including tests for normality and heteroskedasticity
- Robust standard errors
- Sensitivity analysis of model specification

## Key Findings
- Water age shows limited explanatory power when used as a proxy for water quality. Variables more directly aligned with water quality (lead concentration, contaminant concentration, or other water safety index) are required to study public health and contamination risk.
  - Socioeconomic predictors explain only a small fraction of the variation in mean water age, indicating limited explanatory power when water age is treated as an outcome in social vulnerability models.
  - Results suggest that water age is driven primarily by physical distribution-system characteristics (e.g., network topology, pipe volume, and flow dynamics) rather than socioeconomic composition.
- Diagnostic tests indicate violations of standard regression assumptions that constrain inferential reliability.
- Aggregate regression results may obscure the hydraulic and network-driven determinants of water age.

## Limitations
This Results of this analysis are based on publicly available data and on modeled water age, which is a derived system output rather than a directly observed contaminant measure. Findings should be interpreted as exploratory and illustrative rather than predictive.

## Tools
R; dplyr, ggplot2, lmtest, sandwich, car
