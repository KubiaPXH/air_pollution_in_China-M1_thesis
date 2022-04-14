# Call library
library(tidyverse)
library(lfe)
library(magrittr)
library(lmtest)
library(plm)
library(stargazer)
library(xtable)
library(ggplot2)
library(plotly)
library(data.table)

# Import data:
# - import with correct type
# - covert character to factor
# - choose lvl of reference
url <- paste("https://raw.githubusercontent.com/KubiaPXH/Memoire-M1/",
             "master/data/final_air_pollution_30cities.csv",  sep="")

df_sd <- read.csv(url)

df <- read_csv(url, col_types = cols(
  city = col_character(),
  year = col_character(),
  PM10 = col_double(),
  SO2 = col_double(),
  NOx = col_double(),
  pop_density = col_double(),
  GRP_pc = col_double(),
  second_industry = col_double(),
  green_coveraged = col_double(),
  post = col_character(),
  key_regions = col_character())
) %>% 
  mutate_if(is.character,as.factor) %>%
  mutate(
    post = relevel(post, ref = '0'),
    key_regions = relevel(key_regions, ref = '0'),
    city = relevel(city, ref = 'Kunming'),
    year = relevel(year, ref = '2013')
  ) 

# Make post forward
for (i in 1:nrow(df)) {
  if (df$year[i] == 2013) {
    df$post[i] <- 0
  }
}
for (i in 1:nrow(df_sd)) {
  if (df$year[i] == 2013) {
    df$post[i] <- 0
  }
}

summary(df)
str(df)
View(df)

year <- c(2008,2009,2010,2011,2012,2013,2014,2015,2016,2017)

# Graph of PM10 (all, key and nokey)
mean_PM10_all <- NULL
for (i in year) {
  subset_year <- subset(df, year == i)
  mean_PM10_all <- c(mean_PM10_all,mean(subset_year$PM10))
}
mean_PM10_key <- NULL
for (i in year) {
  subset_year <- subset(df, year == i & key_regions == 1)
  mean_PM10_key <- c(mean_PM10_key,mean(subset_year$PM10))
}
mean_PM10_nokey <- NULL
for (i in year) {
  subset_year <- subset(df, year == i & key_regions == 0)
  mean_PM10_nokey <- c(mean_PM10_nokey,mean(subset_year$PM10))
}
mean_PM10 <- data.frame(year,mean_PM10_all,mean_PM10_key,mean_PM10_nokey)
colors <- c("All cities" = "blue", "Key regions" = "red", "No key regions" = "green")
p1 <- ggplot(data = mean_PM10, aes(x = year)) +
          # draw line
          geom_line(aes(y = mean_PM10_all, color = "All cities"), size = 1.2) +
          geom_line(aes(y = mean_PM10_key, color = "Key regions"), size = 1.2) +
          geom_line(aes(y = mean_PM10_nokey, color = "No key regions"), size = 1.2) +
          # draw year point 
          geom_point(aes(x = year, y = mean_PM10_all, color = "All cities"), size = 2) +
          geom_point(aes(x = year, y = mean_PM10_key, color = "Key regions"), size = 2) +
          geom_point(aes(x = year, y = mean_PM10_nokey, color = "No key regions"), size = 2) +
          # scale and breaks
          scale_x_continuous(breaks = seq(2008,2017,1)) +
          scale_y_continuous(breaks = seq(70,150,10), limits = c(70,150)) +
           # modify xlab, y lab, legend
          scale_color_manual(values = colors) +
          labs(x = "Year",
               y = "(µg/m3)",
               color = "") +
          theme(axis.title = element_text(size = 16, family = "serif"),
                axis.text = element_text(size = 13, family = "serif"),
                axis.line = element_line(color = "black"),
                legend.text = element_text(size = 16, family = "serif"),
                legend.key = element_blank(),
                panel.grid.major.y = element_line(color = "black"),
                panel.grid.major.x = element_blank(),
                panel.background = element_blank())
print(p1)

# Graph of average PM10
mean_PM10_all <- NULL
for (i in year) {
  subset_year <- subset(df, year == i)
  mean_PM10_all <- c(mean_PM10_all,mean(subset_year$PM10))
}
avg_PM10 <- data.frame(year,mean_PM10_all)
p_PM10 <- ggplot(data = avg_PM10, aes(x = year)) +
  # draw line
  geom_line(aes(y = mean_PM10_all), color = "blue", size = 1.5) +
  # draw year point 
  geom_point(aes(x = year, y = mean_PM10_all), color = "blue", size = 3) +
  # scale and breaks
  scale_x_continuous(breaks = seq(2008,2017,1)) +
  scale_y_continuous(breaks = seq(70,150,10), limits = c(70,150)) +
  # modify xlab, y lab, legend
  labs(x = "Year",
       y = "(µg/m3)",
       color = "") +
  # parameter graph
  theme(axis.title = element_text(size = 16, family = "serif"),
        axis.text = element_text(size = 13, family = "serif"),
        axis.line = element_line(color = "black"),
        legend.position = "none",
        panel.grid.major.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank()) +
  # draw line showing the begining of policy
  geom_vline(xintercept = 2013.7, color = "red", size = 1.5)
print(p_PM10)
# Note:
## Annual average concentration of PM10 in all cities (µg/m3)

# Graph of average SO2
mean_SO2_all <- NULL
for (i in year) {
  subset_year <- subset(df, year == i)
  mean_SO2_all <- c(mean_SO2_all,mean(subset_year$SO2))
}
avg_SO2 <- data.frame(year,mean_SO2_all)
p_SO2 <- ggplot(data = avg_SO2, aes(x = year)) +
  # draw line
  geom_line(aes(y = mean_SO2_all), color = "blue", size = 1.5) +
  # draw year point 
  geom_point(aes(x = year, y = mean_SO2_all), color = "blue", size = 3) +
  # scale and breaks
  scale_x_continuous(breaks = seq(2008,2017,1)) +
  scale_y_continuous(breaks = seq(10,60,5), limits = c(10,60)) +
  # modify xlab, y lab, legend
  labs(x = "Year",
       y = "(µg/m3)",
       color = "") +
  # parameter graph
  theme(axis.title = element_text(size = 16, family = "serif"),
        axis.text = element_text(size = 13, family = "serif"),
        axis.line = element_line(color = "black"),
        legend.position = "none",
        panel.grid.major.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank()) +
  # draw line showing the begining of policy
  geom_vline(xintercept = 2013.7, color = "red", size = 1.5)
print(p_SO2)
# Note:
## Annual average concentration of SO2 in all cities (µg/m3)

# Graph of average NOx
mean_NOx_all <- NULL
for (i in year) {
  subset_year <- subset(df, year == i)
  mean_NOx_all <- c(mean_NOx_all,mean(subset_year$NOx))
}
avg_NOx <- data.frame(year,mean_NOx_all)
p_NOx <- ggplot(data = avg_NOx, aes(x = year)) +
  # draw line
  geom_line(aes(y = mean_NOx_all), color = "blue", size = 1.5) +
  # draw year point 
  geom_point(aes(x = year, y = mean_NOx_all), color = "blue", size = 3) +
  # scale and breaks
  scale_x_continuous(breaks = seq(2008,2017,1)) +
  scale_y_continuous(breaks = seq(35,55,5), limits = c(35,55)) +
  # modify xlab, y lab, legend
  labs(x = "Year",
       y = "(µg/m3)",
       color = "") +
  # parameter graph
  theme(axis.title = element_text(size = 16, family = "serif"),
        axis.text = element_text(size = 13, family = "serif"),
        axis.line = element_line(color = "black"),
        legend.position = "none",
        panel.grid.major.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank()) +
  # draw line showing the begining of policy
  geom_vline(xintercept = 2013.7, color = "red", size = 1.5)
print(p_NOx)
# Note:
## Annual average concentration of NOx in all cities (µg/m3)

# Statistics decriptive table
stargazer(df_sd, type = "text", 
          title = "Summary statistics of the variables", 
          digits = 2,
          omit = c("year","post","key_regions"),
          omit.summary.stat = c("p25","p75"))
stargazer(df_sd, 
          title = "Summary statistics of the variables", 
          digits = 2,
          omit = c("year","post","key_regions"),
          omit.summary.stat = c("p25","p75"),
          column.sep.width = "10pt")

# Calculate mean & diff-in-diff

# Create subset of year and key regions
df_key_2017 <- subset(df, key_regions == 1 & year == 2017)
df_key_2013 <- subset(df, key_regions == 1 & year == 2013)
df_nokey_2017 <- subset(df, key_regions == 0 & year == 2017)
df_nokey_2013 <- subset(df, key_regions == 0 & year == 2013)

# PM10: Ok
key_PM10_2017 <- mean(df_key_2017$PM10)
key_PM10_2013 <- mean(df_key_2013$PM10)
nokey_PM10_2017 <- mean(df_nokey_2017$PM10)
nokey_PM10_2013 <- mean(df_nokey_2013$PM10)
diff_PM10_key <- (key_PM10_2013 - key_PM10_2017)
diff_PM10_nokey <- (nokey_PM10_2013 - nokey_PM10_2017)
did_PM10 <- (diff_PM10_key - diff_PM10_nokey)
did_PM10

#SO2: Ok
key_SO2_2017 <- mean(df_key_2017$SO2)
key_SO2_2013 <- mean(df_key_2013$SO2)
nokey_SO2_2017 <- mean(df_nokey_2017$SO2)
nokey_SO2_2013 <- mean(df_nokey_2013$SO2)
diff_SO2_key <- (key_SO2_2013 - key_SO2_2017)
diff_SO2_nokey <- (nokey_SO2_2013 - nokey_SO2_2017)
did_SO2 <- (diff_SO2_key - diff_SO2_nokey)
did_SO2

#NOx: Ok
key_NOx_2017 <- mean(df_key_2017$NOx)
key_NOx_2013 <- mean(df_key_2013$NOx)
nokey_NOx_2017 <- mean(df_nokey_2017$NOx)
nokey_NOx_2013 <- mean(df_nokey_2013$NOx)
diff_NOx_key <- (key_NOx_2013 - key_NOx_2017)
diff_NOx_nokey <- (nokey_NOx_2013 - nokey_NOx_2017)
did_NOx <- (diff_NOx_key - diff_NOx_nokey)
did_NOx

# Means table for DiD
diff_matrix <- matrix(c(diff_PM10_key,diff_SO2_key,diff_NOx_key,
                        diff_PM10_nokey,diff_SO2_nokey,diff_NOx_nokey),
                      ncol = 3,
                      byrow = TRUE,
                      dimnames = list(c("Key regions","No key regions"),
                                      c("PM10","SO2","NOx")))
print(xtable(diff_matrix, 
       caption = "Average Reduction of Pollutant Gas",
       digits = 2),
      caption.placement = "top")
      

# Benchmark Model:
model_did_PM10 <- felm(formula=log(PM10) ~ post *  key_regions + 
                  log(pop_density) + log(GRP_pc) + log(gas_supply)|
                  city + year| 0 |FALSE, data = df, exactDOF = TRUE)
summary(model_did_PM10)

## Model PM10:

### All control variables: push post forward
model_did_PM10_all <- plm(log(PM10) ~ post + key_regions + post*key_regions +
                            log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                          data = df,
                          index = c("city","year"),
                          model = "within",
                          effect = "twoways"
)
summary(model_did_PM10_all)

### All control variables: lag(post)
model_did_PM10_all <- plm(log(PM10) ~ lag(post) + key_regions + lag(post)*key_regions +
                        log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                      data = df,
                      index = c("city","year"),
                      model = "within",
                      effect = "twoways"
)
summary(model_did_PM10_all)

### 3 control variables: lag(post)
model_did_PM10 <- plm(log(PM10) ~ lag(post) + key_regions + lag(post)*key_regions +
                        log(pop_density) + log(GRP_pc) + second_industry,
                        data = df,
                        index = c("city","year"),
                        model = "within",
                        effect = "twoways"
                        )
summary(model_did_PM10)

## Model SO2:

### All control variables: push post forward
model_did_SO2_all <- plm(log(SO2) ~ post + key_regions + post*key_regions +
                           log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                         data = df,
                         index = c("city","year"),
                         model = "within",
                         effect = "twoways"
)
summary(model_did_SO2_all)

### All control variables: lag(post)
model_did_SO2_all <- plm(log(SO2) ~ lag(post) + key_regions + lag(post)*key_regions +
                           log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                     data = df,
                     index = c("city","year"),
                     model = "within",
                     effect = "twoways"
)
summary(model_did_SO2_all)

### 3 control variables: lag(post)
model_did_SO2 <- plm(log(SO2) ~ lag(post) + key_regions + lag(post)*key_regions +
                        log(pop_density) + log(GRP_pc) + second_industry,
                      data = df,
                      index = c("city","year"),
                      model = "within",
                      effect = "twoways"
                      )
summary(model_did_SO2)

## Model NOx:

### All control variables: push post forward
model_did_NOx_all <- plm(log(NOx) ~ post + key_regions + post*key_regions +
                           log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                         data = df,
                         index = c("city","year"),
                         model = "within",
                         effect = "twoways"
)
summary(model_did_NOx_all)

### All control variables: lag(post)
model_did_NOx_all <- plm(log(NOx) ~ lag(post) + key_regions + lag(post)*key_regions +
                           log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                         data = df,
                         index = c("city","year"),
                         model = "within",
                         effect = "twoways"
)
summary(model_did_NOx_all)

### 3 control variables: lag(post)
model_did_NOx <- plm(log(NOx) ~ lag(post) + key_regions + lag(post)*key_regions +
                       log(pop_density) + log(GRP_pc) + second_industry,
                     data = df,
                     index = c("city","year"),
                     model = "within",
                     effect = "twoways"
)
summary(model_did_NOx)

# Table for regression
stargazer(model_did_PM10_all, model_did_SO2_all, model_did_NOx_all, 
          title = "Difference-in-Differences model with city and year fixed effects",
          type = "text",
          align = TRUE,
          # set covariate variable name
          covariate.labels = c("post*key\\_regions","log(pop\\_density)","log(GRP\\_pc)","log(gas\\_supply)","second\\_industry","green\\_coveraged"),
          # set covariate variable order
          order = c(6,1,2,3,4,5),
          omit.stat = c("f","adj.rsq"))

# Parallel trend assumption (Robust test)

robust_PM10 <- plm(log(PM10) ~ year + key_regions + year*key_regions +
                     log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                      data = df,
                      index = c("city","year"),
                      model = "within",
                      effect = "twoways"
)
summary(robust_PM10)

robust_SO2 <- plm(log(SO2) ~ year + key_regions + year*key_regions +
                    log(pop_density) + log(GRP_pc) + log(gas_supply) + second_industry + green_coveraged,
                   data = df,
                   index = c("city","year"),
                   model = "within",
                   effect = "twoways"
)
summary(robust_SO2)

# Graph robust test

key_year <- c("key_2008","key_2009","key_2010","key_2011","key_2012","key_2013","key_2014","key_2015","key_2016","key_2017")

## PM10

### Get confidence interval and coef of key_year
confint_PM10 <- confint(robust_PM10, level = 0.9)
for (i in 1:5){
  confint_PM10 <- confint_PM10[-1,]
}
confint_PM10 

coef_robust_PM10 <- NULL
for (i in 2008:2016){
  coef_robust_PM10 <- c(coef_robust_PM10,robust_PM10$coefficients[i-2002])
}
coef_robust_PM10 <- data.frame(coef_robust_PM10)
coef_robust_PM10

df_robust_PM10 <- data.frame(confint_PM10,coef_robust_PM10)
dt_robust_PM10 <- data.table(df_robust_PM10)
dt_robust_PM10 <- rbindlist(list(dt_robust_PM10[1:5, ], as.list(c(NA,NA,NA)), dt_robust_PM10[6:9, ]))
df_robust_PM10 <- data.frame(key_year,dt_robust_PM10)
colnames(df_robust_PM10) <- c("key_year","x5","x95","coef")
df_robust_PM10

### Draw robust test graph
ggplot(df_robust_PM10, aes(x = key_year, y = coef)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = x5, ymax = x95), width = 0.25) +
  scale_y_continuous(breaks = seq(-0.5,0.5,0.1), limits = c(-0.5,0.5)) +
  labs(x = "",
       y = "") +
  # parameter graph
  theme(axis.text.x = element_text(size = 13, family = "serif", angle = 45, hjust = 1),
        axis.text.y = element_text(size = 13, family = "serif"),
        axis.line = element_line(color = "black"),
        legend.position = "none",
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank()) +
  # draw line showing the begining of policy
  geom_hline(yintercept = 0, color = "red", size = 1)

## SO2

### Get confidence interval and coef of key_year
confint_SO2 <- confint(robust_SO2, level = 0.9)
for (i in 1:5){
  confint_SO2 <- confint_SO2[-1,]
}
confint_SO2 

coef_robust_SO2 <- NULL
for (i in 2008:2016){
  coef_robust_SO2 <- c(coef_robust_SO2,robust_SO2$coefficients[i-2002])
}
coef_robust_SO2 <- data.frame(coef_robust_SO2)
coef_robust_SO2

df_robust_SO2 <- data.frame(confint_SO2,coef_robust_SO2)
dt_robust_SO2 <- data.table(df_robust_SO2)
dt_robust_SO2 <- rbindlist(list(dt_robust_SO2[1:5, ], as.list(c(NA,NA,NA)), dt_robust_SO2[6:9, ]))
df_robust_SO2 <- data.frame(key_year,dt_robust_SO2)
colnames(df_robust_SO2) <- c("key_year","x5","x95","coef")
df_robust_SO2

### Draw robust test graph
ggplot(df_robust_SO2, aes(x = key_year, y = coef)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = x5, ymax = x95), width = 0.25) +
  scale_y_continuous(breaks = seq(-1,0.5,0.1), limits = c(-1,0.5)) +
  labs(x = "",
       y = "") +
  # parameter graph
  theme(axis.text.x = element_text(size = 13, family = "serif", angle = 45, hjust = 1),
        axis.text.y = element_text(size = 13, family = "serif"),
        axis.line = element_line(color = "black"),
        legend.position = "none",
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank()) +
  # draw line showing the begining of policy
  geom_hline(yintercept = 0, color = "red", size = 1)
