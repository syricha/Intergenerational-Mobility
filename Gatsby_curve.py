import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import kurtosis
from scipy.stats import skew
import openpyxl

mypath=r"C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"
df = pd.read_excel(r"C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\World_bank_data.xlsx")
print (df)

dfm=pd.melt(df, id_vars =['Country Name','Country Code', 'Indicator Name','Indicator Code'])
dfm = dfm.rename(columns={'variable':'Year'})

dfm2=(dfm.Year//10)*10

dfm['Decade']=dfm2

Average_Gini=dfm.groupby(["Country Name","Decade"])['value'].mean().reset_index()

df_2 = pd.read_excel (r'C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\rank_PPP.xls')
df_2['Decade'] = (df_2.year//10)*10
Average_mobility=df_2.groupby(["country","Decade"])['rank_1'].mean().reset_index()
Average_Gini = Average_Gini.rename(columns={'Country Name':'country'})
dm=pd.merge(Average_Gini,Average_mobility)


df3=dm[dm['Decade']==1960]
df4=dm[dm['Decade']==1970]
df5=dm[dm['Decade']==1980]
df6=dm[dm['Decade']==1990]
df7=dm[dm['Decade']==2000]
df8=dm[dm['Decade']==2010]

x=dm['value']
y=dm['rank_1']
idx = np.isfinite(x) & np.isfinite(y)
m, b= np.polyfit(x[idx], y[idx], 1)


sns.set()
sns.scatterplot(data=df3,x='value',y='rank_1',color='gray',label='1960')
sns.scatterplot(data=df4,x='value',y='rank_1',color='blue',label='1970')
sns.scatterplot(data=df5,x='value',y='rank_1',color='green',label='1980')
sns.scatterplot(data=df6,x='value',y='rank_1',color='yellow',label='1990')
sns.scatterplot(data=df7,x='value',y='rank_1',color='orange',label='2000')
sns.scatterplot(data=df8,x='value',y='rank_1',color='black',label='2010')
plt.plot(x, m*x+b,color='red',linestyle='dashed',linewidth=1)
plt.xlabel("Gini (Income)")
plt.ylabel("Upward Mobility")
plt.savefig(mypath + '\Gatsby_income.png', bbox_inches='tight')
plt.show()

x=df6['value']
y=df6['rank_1']
idx = np.isfinite(x) & np.isfinite(y)
m, b= np.polyfit(x[idx], y[idx], 1)

x1=df7['value']
y1=df7['rank_1']
idx = np.isfinite(x1) & np.isfinite(y1)
m1, b1= np.polyfit(x1[idx], y1[idx], 1)

x2=df8['value']
y2=df8['rank_1']
idx = np.isfinite(x2) & np.isfinite(y2)
m2, b2= np.polyfit(x2[idx], y2[idx], 1)


x0=df5['value']
y0=df5['rank_1']
idx = np.isfinite(x0) & np.isfinite(y0)
m0, b0= np.polyfit(x0[idx], y0[idx], 1)

sns.set()
plt.plot(x0, m0*x0+b0,color='green',linestyle='dashed',linewidth=1,label='1980')
plt.plot(x, m*x+b,color='yellow',linestyle='dashed',linewidth=1,label='1990')
plt.plot(x1, m1*x1+b1,color='orange',linestyle='dashed',linewidth=1,label='2000')
plt.plot(x2, m2*x2+b2,color='black',linestyle='dashed',linewidth=1,label='2010')
plt.xlabel("Gini (Income)")
plt.ylabel("Upward Mobility")
plt.title("Linear Fit over time")
plt.legend()
plt.savefig(mypath + '\Gatsby_income_fit_time.png', bbox_inches='tight')
plt.show()