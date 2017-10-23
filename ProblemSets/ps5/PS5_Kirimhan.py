# Import needed packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Read in data
df = pd.read_stata('yeni_tum_lag.dta')
# Look at data
df.describe()
# Scatter plot between EPU and NSRISK
plt.scatter(df['overall_pu_lag1'], df['month_nsrisk_new_new'], alpha=0.15, marker='o', color='blue')
plt.plot(np.unique(df['overall_pu_lag1']),
         np.poly1d(np.polyfit(df['overall_pu_lag1'],
                              df['month_nsrisk_new_new'], 0.1))(np.unique(df['overall_pu_lag1'])),
         color='red', linestyle="--", linewidth=2)
plt.ylabel('month_nsrisk_new_new')
plt.xlabel('overall_pu_lag1')
plt.yticks(np.arange(min(df['month_nsrisk_new_new']), max(df['month_nsrisk_new_new']), 5.0))
plt.title('NSRISK and Lagged EPU')

plt.savefig('NSRISK_EPU.png')

plt.show()
# Scatter plot between Log of EPU and NSRISK
plt.scatter(df['log_overall_pu_lag1'], df['month_nsrisk_new_new'], alpha=0.15, marker='o', color='blue')
plt.plot(np.unique(df['log_overall_pu_lag1']),
         np.poly1d(np.polyfit(df['log_overall_pu_lag1'],
                              df['month_nsrisk_new_new'], 0.1))(np.unique(df['log_overall_pu_lag1'])),
         color='red', linestyle="--", linewidth=2)
plt.ylabel('month_nsrisk_new_new')
plt.xlabel('log_overall_pu_lag1')
plt.yticks(np.arange(min(df['month_nsrisk_new_new']), max(df['month_nsrisk_new_new']), 5.0))
plt.title('NSRISK and Log Lagged EPU')

plt.savefig('NSRISK_logEPU.png')

plt.show()

# Histogram of NSRISK
import seaborn as sns
sns.distplot(df['month_nsrisk_new_new'], kde=True, rug=False)
plt.title('Distribution of NSRISK')

plt.show()

filename = 'C:/Users/desta/Desktop/econ 815/DistNsrisk.png'
fig.savefig(filename, transparent=False, dpi=80, bbox_inches='tight')

# Scatter plot between Capital Adeqaucy and NSRISK
plt.scatter(df['capital_adeq'], df['month_nsrisk_new_new'], alpha=0.15, marker='o', color='blue')
plt.plot(np.unique(df['capital_adeq']),
         np.poly1d(np.polyfit(df['capital_adeq'],
                              df['month_nsrisk_new_new'], 0.1))(np.unique(df['capital_adeq'])),
         color='red', linestyle="--", linewidth=2)
plt.ylabel('month_nsrisk_new_new')
plt.xlabel('capital_adequacy')
plt.yticks(np.arange(min(df['month_nsrisk_new_new']), max(df['month_nsrisk_new_new']), 5))
plt.title('NSRISK and Capital Adequacy')

plt.savefig('NSRISK_Capital_Adequacy_Scatter.png')

plt.show()
# Bar Chart between Capital Adeqaucy and NSRISK
# Line plot by centile
# range 1 to 100 for centile
x = np.arange(len(df['capital_adeq']))
# Formatting options
plt.style.use('fivethirtyeight') # select a style (theme) for plot
fig, ax = plt.subplots() # make figure and axes separate objects
plt.plot(x, df['month_nsrisk_new_new'], axes=ax)
ax.set_xlim([0, 60000]) # set axis range
ax.set(title='NSRISK by Capital Adequacy', xlabel='Capital Adequacy',
       ylabel="NSRISK") # plot title, axis labels

plt.savefig('NSRISK_CapitalAdequacy.png')

plt.show()
