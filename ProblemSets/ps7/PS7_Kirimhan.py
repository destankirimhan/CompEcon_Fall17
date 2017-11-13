#import required packages
import requests
import json
import ast
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.formula.api as sm

# request data from BEA for Gross Domestic Product in chained dollars
url = "https://www.bea.gov/api/data/?&UserID=6B316ADE-8CA7-4651-B854-4984EB39687D&method=GetData&DataSetName=NIPA&TableName=T10106&Frequency=A&Year=ALL&ResultFormat=JSON&"
response3 = requests.get(url)
ddf1 = response3.text
ddf1

#Gathering the data and defining as dataframe in Python
ddf2 = ast.literal_eval(ddf1)
ddf3 = ddf2['BEAAPI']['Results']['Data']
ddf4 = pd.DataFrame(ddf3)

# Changing the years into float variable
ddf4.new_time = ddf4['TimePeriod'].astype(float)

# Slicing the dataframe
ddf5 = ddf4[(ddf4.LineDescription == "Gross domestic product") & (ddf4.new_time > 1958)]

# request data from BEA for Personal Consumption Expenditures in current dollars
url = "https://www.bea.gov/api/data/?&UserID=6B316ADE-8CA7-4651-B854-4984EB39687D&method=GetData&DataSetName=NIUnderlyingDetail&TableName=U20305&Frequency=A&Year=ALL&ResultFormat=JSON&"
response1 = requests.get(url)
df1 = response1.text
df1

#Gathering the data and defining as dataframe in Python
df2 = ast.literal_eval(df1)
df3 = df2['BEAAPI']['Results']['Data']
df4 = pd.DataFrame(df3)

# Changing the years into float variable
df4.new_time = df4['TimePeriod'].astype(float)

# Slicing the dataframe
df5 = df4[(df4.LineDescription == "Personal consumption expenditures (PCE)")]

# Merging these two dataframes
merge1 = pd.merge(df5, ddf5, on='TimePeriod', how='left')

# Changing the types of datavalues to floats by defining them without commas
merge1['DataValue_x'] = (merge1['DataValue_x'].str.split()).apply(lambda x: float(x[0].replace(',', '')))
merge1['DataValue_y'] = (merge1['DataValue_y'].str.split()).apply(lambda x: float(x[0].replace(',', '')))

# request data from BEA for Fisher Index
url = "https://www.bea.gov/api/data/?&UserID=6B316ADE-8CA7-4651-B854-4984EB39687D&method=GetData&DataSetName=NIPA&TableName=T10104&Frequency=A&Year=ALL&ResultFormat=JSON&"
response4 = requests.get(url)
dfdf1 = response4.text
dfdf1

#Gathering the data and defining as dataframe in Python
dfdf2 = ast.literal_eval(dfdf1)
dfdf3 = dfdf2['BEAAPI']['Results']['Data']
dfdf4 = pd.DataFrame(dfdf3)

# Changing the years into float variable
dfdf4.new_time = dfdf4['TimePeriod'].astype(float)

# Slicing the dataframe
dfdf5 = dfdf4[(dfdf4.METRIC_NAME == "Fisher Price Index") & (dfdf4.LineDescription == "Gross domestic product") & (dfdf4.new_time > 1958)]

# Merging all dataframes
merge2 = pd.merge(merge1, dfdf5, on='TimePeriod', how='left')

# Changing the types of datavalues to floats by defining them without dots
merge2['DataValue'] = (merge2['DataValue'].str.split()).apply(lambda x: float(x[0].replace('.', '')))

# Changing the name of the variables and defining real personal consumption Expenditures
merge2['Real_PCE'] = (merge2['DataValue_x']/merge2['DataValue']) * 100000
merge2['Real_Income']  = merge2['DataValue_y']

# Drawing the scatterplot between income and consumption
# fit with np.polyfit
m, b = np.polyfit(merge2['Real_Income'], merge2['Real_PCE'], 1)

plt.plot(merge2['Real_Income'], merge2['Real_PCE'], '.')
plt.plot(merge2['Real_Income'], m*merge2['Real_Income'] + b, '-')
plt.ylabel('Consumption')
plt.xlabel('Income')
plt.title('Income and Consumption')
plt.show()

# Running the OLS regression of consumption on Income
A = merge2['Real_Income'].values
B = merge2['Real_PCE'].values
result = sm.ols(formula="B ~ A", data=merge1).fit()
result.summary()

# Saving the OLS regression as a pdf table
f = open('myreg.tex', 'w')
f.write(beginningtex)
f.write(result.summary().as_latex())
f.write(endtex)
f.close()

# Drawing the histogram of income 
sns.distplot(merge2['Real_Income'], kde=True, rug=False)
plt.title('Distribution of Income')
plt.show()
