import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import kurtosis
from scipy.stats import skew
import openpyxl

mypath=r"C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"
df = pd.read_excel (r'C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\rank_PPP.xls')
print (df)

df_2 = pd.read_excel (r'C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\rank_PPP_US.xls')
print (df_2)


df_new=df.groupby(df['country']).mean()
df_new2=df.groupby(df['countrycode']).mean()
x=df_new['lgd']
y=df_new['rank_1']
m, b = np.polyfit(x, y, 1)

sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.scatterplot(data=df_2,x=df_2['lgd'],y=df_2['rank_1'],color='green',label='US Time Series')
sns.scatterplot(data=df_new,x=df_new['lgd'],y=df_new['rank_1'],color='orange',label='Country Averages')
plt.plot(x, m*x+b,color='orange',linestyle='dashed',linewidth=1)
sns.lineplot(data=df_2,x=df_2['lgd'],y=df_2['rank_1'],color='green')
plt.xlabel("Ln (GDP per Capita)")
for i, txt in enumerate(df_2['year']):
    plt.annotate(txt, (df_2.lgd[i], df_2.rank_1[i]))
plt.ylabel("Upward mobility")
plt.savefig(mypath +'\Development_path.png',bbox_inches='tight')
plt.show()
