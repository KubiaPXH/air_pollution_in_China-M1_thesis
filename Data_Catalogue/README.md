# Data Catalogue

The main source of data is XX. 



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
| PM10            | int64   |       |        |         |
| SO2             | int64   |       |        |         |
| NOx             | int64   |       |        |         |
| pop_density     | float64 |       |        |         |
| GRP_pc          | int64   |       |        |         |
| second_industry | float64 |       |        |         |
| gas_supply      | int64   |       |        |         |
| green_coveraged | float64 |       |        |         |
| post            | int64   |       |        |         |
| key_regions     | int64   |       |        |         |

