# Dataset

The dataset is provided in CSV format and can be found in this folder under the file name "MODEL_CT_RESULTS.csv".

## Source
This project uses a subset of data from:

**Scenario Analysis of Drinking Water Infrastructure Rightsizing in Flint, Michigan: Model Census Tract Results**  
Wayne State University DigitalCommons Open Data Repository  
DOI: https://doi.org/10.22237/waynestaterepo/data/1729036800/b

The original dataset contains hydraulic simulation outputs and socioeconomic indicators at the census tract level for multiple modeled infrastructure scenarios.

## Scope of Data Used
Only a **subset of variables** from the original dataset is used in this project. The analysis focuses exclusively on **baseline system conditions** and excludes all rightsizing scenarios.

Specifically:
- Observations are restricted to `Scenario == 0` (the current conditions of the pipes and water age)
- Rightsizing and alternative infrastructure scenarios are **not used**

## Variables Used in This Project

### Outcome Variable
- **`Ag50`**  
  Mean modeled water age (hours), used as the dependent variable in all
  regression analyses.

### Predictor Variables
- **`AvgP`**  
  Average modeled water pressure.

- **`Distress`**  
  Socioeconomic distress indicator at the census tract level.

- **`PercVacant`**  
  Percentage of vacant housing units in the census tract.

- **`PrcNW`**  
  Percentage of non-White population in the census tract.

- **`WhiteDominant`**  
  Binary indicator constructed in analysis code:
  - `1` if `PrcNW < 50`
  - `0` otherwise

### Interaction Term
- **`AvgP × Distress`**  
  Interaction between average pressure and socioeconomic distress,
  included to test whether hydraulic conditions moderate socioeconomic
  associations with water age.

## Notes
- The dataset does **not include personally identifiable information**; all spatial units are census tracts.
- Users of the data should cite the DOI above when referencing this dataset.
