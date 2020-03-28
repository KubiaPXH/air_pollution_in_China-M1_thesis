# Data Preprocessing

- The variable which are obtained directly from China Statistical Yearbook (CSY) and China City Statistical Yearbook (CCSY):
  - Annual Average Concentration of PM10 (µg/m3)
  -  Annual Average Concentration of SO2 (µg/m3)
  - Annual Average Concentration of NOx (µg/m3)
  - GRP per capita (yuan)
  - Percentage of 2nd Industry in GRP (%)
  - Total Gas Supply (10000 m3)
  - Green Covered Area as % of Completed Area (%)
- The variable Population Density (number of person/sq.km) is computed by 2 variables:
  - Population Density = Population at Year-end/Total Land Area
- There are some missing datas which are imputed by using interpolation, extrapolation and last obversation carried forward (LOCF)
