# install required package

install.packages("haven")
library(haven)

install.packages("lmtest")
library(lmtest)

install.packages("AER")
library(AER)

install.packages('xtable')
library(xtable)

install.packages('texreg')
library("texreg")

install.packages('plm')
library(plm)

# Read Stata data file used for PS6
df <- read_dta("C:/Users/desta/Desktop/econ 815/yeni_tum_lag.dta") 

# Provide summary statistics
summary(df)
str(df)

# Define, estimate the baseline OLS models by adding different control variables at different model specifications and get the results
base <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1)
summary(base)

base2 <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1)
summary(base2)

base3 <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1)
summary(base3)

base4 <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1 + df$cfnai_lag1 + df$ipg_lag1 + df$cape_lag1 + df$minus_def_lag1 + df$minus_fin_crisis_lag1)
summary(base4)

# Printing the results for all baseline model specifications into TeX Studio file
print(texreg(list(base, base2, base3, base4), dcolumn = TRUE, booktabs = TRUE,
             use.packages = FALSE, custom.model.names = c('1', '2', '3', '4'),
             custom.coef.names = c('Intercept', 'Log_EPU_lag', 'Capital Adequacy', 'Asset Quality', 'Management Quality', 'Earnings', 'Liquidity', 'Sensitivity', 'Size', 'Age', 'HHI', 'Metropolitan', 'Branch', 'MandA', 'BHC', 'CFNAI', 'IPG', 'CAPE', 'Minus_DEF', 'Minus_Fin_crisis'),
             label = "tab:3", caption = "Baseline OLS Models",
             float.pos = "hb!"))

# Define, estimate the baseline OLS main model specification and get the results

baseOLS <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1 + df$cfnai_lag1 + df$ipg_lag1 + df$cape_lag1 + df$minus_def_lag1 + df$minus_fin_crisis_lag1)
summary(baseOLS)

# Endogeneity Concerns (IV - 2SLS Model)

# Stage 1: Read Stata file for the first step time-series regression

df2 <- read_dta("C:/Users/desta/Desktop/econ 815/endogeneity_.dta")

# IV - Step 1 regression

IV_Step1 <- lm(df2[['log_overall_pu_lag1']] ~ df2$log_polar_senate_lag1 + df2$cfnai_lag1 + df2$ipg_lag1 + df2$cape_lag1 + df2$minus_def_lag1 + df2$minus_fin_crisis_lag1)
summary(IV_Step1)

# IV - Step 2 regression (panel data)

predict(IV_Step1)

# Read Stata file for the second step panel regression with the estimated 'log_overall_pu_lag_hat' variable from the first step

df3 <- read_dta("C:/Users/desta/Desktop/econ 815/yeni_tum_winsorize.dta")

IV_Step2 <- lm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag_hat + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1 + df$cfnai_lag1 + df$ipg_lag1 + df$cape_lag1 + df$minus_def_lag1 + df$minus_fin_crisis_lag1)
summary(IV_Step2)

summary(IV_Step2, diagnostics = TRUE)

# Printing the results for all baseline OLS model and 2SLS model into TeX Studio file

print(texreg(list(baseOLS, IV_Step1, IV_Step2), dcolumn = TRUE, booktabs = TRUE,
             use.packages = FALSE, custom.model.names = c('OLS', 'IV-Step1', 'IV-Step2'),
             custom.coef.names = c('Intercept', 'Log_EPU_lag', 'Capital Adequacy', 'Asset Quality', 'Management Quality', 'Earnings', 'Liquidity', 'Sensitivity', 'Size', 'Age', 'HHI', 'Metropolitan', 'Branch', 'MandA', 'BHC', 'CFNAI', 'IPG', 'CAPE', 'Minus_DEF', 'Minus_Fin_crisis', 'log_POLAR_lag_hat', 'CFNAI', 'IPG', 'CAPE', 'Minus_DEF', 'Minus_Fin_crisis', 'log_EPU_lag_hat'),
             label = "tab:3", caption = "OLS and Two IV models",
             float.pos = "hb!"))

# Panel data within fixed effects for different model specifications by adding different control variables at each time

fixed <- plm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1, data=df, index=c("permco", "month_year"), model="within")
summary(fixed)

fixed2 <- plm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1, data=df, index=c("permco", "month_year"), model="within")
summary(fixed2)

fixed3 <- plm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1, data=df, index=c("permco", "month_year"), model="within")
summary(fixed3)

fixed4 <- plm(df[['month_nsrisk_new_new']] ~ df$log_overall_pu_lag1 + df$capital_adeq_lag1 + df$asset_quality_lag1 + df$man_quality_lag1 + df$earnings_lag1 + df$liquidity_lag1 + df$sensitivity_to_mkt_risk_lag1 + df$bank_size_lag1 + df$bank_age_lag1 + df$hhi_lag1 + df$metropolitan_lag1 + df$branch_lag1 + df$manda_lag1 + df$bhc_indicator_lag1 + df$cfnai_lag1 + df$ipg_lag1 + df$cape_lag1 + df$minus_def_lag1 + df$minus_fin_crisis_lag1, data=df, index=c("permco", "month_year"), model="within")
summary(fixed4)

# Printing the results for all within fixed effects model specifications into TeX Studio file

print(texreg(list(fixed, fixed2, fixed3, fixed4), dcolumn = TRUE, booktabs = TRUE,
             use.packages = FALSE, custom.model.names = c('1', '2', '3', '4'),
             custom.coef.names = c('Log_EPU_lag', 'Capital Adequacy', 'Asset Quality', 'Management Quality', 'Earnings', 'Liquidity', 'Sensitivity', 'Size', 'Age', 'HHI', 'Metropolitan', 'Branch', 'MandA', 'BHC', 'CFNAI', 'IPG', 'CAPE', 'Minus_DEF', 'Minus_Fin_crisis'),
             label = "tab:3", caption = "Within Fixed Effects Models",
             float.pos = "hb!"))
