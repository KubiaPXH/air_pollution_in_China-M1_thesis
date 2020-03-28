# Data Catalogue

Mains sources of the data:
- The data of air pollution (PM10, SO2, NOx) of 30 major cities are obtained from the China Statistical Yearbook (CSY) (http://data.stats.gov.cn/english/publish.htm?sort=1)
- The data of control variables are obtained from the China City Statistical Yeabook (CCSY)(http://data.cnki.net/yearbook/Single/N2019070173


In case you need it, here is the Python code to make the table below

```python
path = "https://raw.githubusercontent.com/KubiaPXH/Memoire-M1/" \
"master/data/final_air_pollution_30cities.csv"
pd.read_csv(path).dtypes.to_frame().assign(
    label = '',
    source = '',
comment = '').reset_index().rename(
columns = {'index':'variable', 0:'types'}).to_csv('data_pm_china_10_17.csv',
                                                  index = False)
```



## Data table

| variable        | types   | label | source | comment |
|-----------------|---------|-------|--------|---------|
| city            | object  |       |        |         |
| year            | int64   |       |        |         |
| PM10            | int64   |Annual Average Concentration of PM10 (µg/m3) | CSY  |         |
| SO2             | int64   |Annual Average Concentration of SO2 (µg/m3)  | CSY  |         |
| NOx             | int64   |Annual Average Concentration of NOx (µg/m3)  | CSY  |         |
| pop_density     | float64 |Population Density (number of persons/sq.km) | CCSY |         |
| GRP_pc          | int64   |Regional GDP Per Capita (yuan)               | CCSY |         |
| second_industry | float64 |Percentage of 2nd Industry in GDP (%)        | CCSY |         |
| gas_supply      | int64   |Total Gas Supply (10000 m3)                  | CCSY |         |
| green_coveraged | float64 |Green Covered Area as % of Completed Area (%)| CCSY |         |
| post            | int64   |Dummy Variable (1 if year >= 2013*)|      |         |
| key_regions     | int64   |Dummy Variable (1 if city is belong to 3 key regions**)|        |         |

(*) Air Pollution Control and Action Plan was first implemented in 2013

(**) 3 key regions of the Action Plan are Beijing-Tianjin-Hebei (BTH), Yangtze River Delta (YRD) and Pearl River Delta (PRD).
