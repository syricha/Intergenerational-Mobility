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



df3=df[df['country']=="Benin"]
df4=df[df['country']=="Brazil"]
df5=df[df['country']=="Costa Rica"]
df6=df[df['country']=="India"]
df7=df[df['country']=="China"]
df8=df[df['country']=="Argentina"]
df9=df[df['country']=="Indonesia"]
df10=df[df['country']=="Malaysia"]
df11=df[df['country']=="Cambodia"]
df12=df[df['country']=="Mali"]
df13=df[df['country']=="South Africa"]
df14=df[df['country']=="Zambia"]
df15=df[df['country']=="Ethiopia"]
df16=df[df['country']=="Ghana"]
df17=df[df['country']=="Chile"]
df18=df[df['country']=="Guatemala"]
df19=df[df['country']=="Colombia"]

sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df3,x=df['lgd'],y=df3['rank_1'],color='green',label='Benin')
sns.lineplot(data=df4,x=df['lgd'],y=df4['rank_1'],color='blue',label='Brazil')
sns.lineplot(data=df5,x=df['lgd'],y=df5['rank_1'],color='red',label='Costa Rica')
sns.lineplot(data=df6,x=df['lgd'],y=df6['rank_1'],color='yellow',label='India')
sns.lineplot(data=df7,x=df['lgd'],y=df7['rank_1'],color='orange',label='China')
sns.lineplot(data=df8,x=df['lgd'],y=df8['rank_1'],color='brown',label='Argentina')
sns.lineplot(data=df9,x=df['lgd'],y=df9['rank_1'],color='black',label='Indonesia')
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.savefig(mypath + '\Development_path_selected_countries.png', bbox_inches='tight')
plt.show()


sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df6,x=df['lgd'],y=df6['rank_1'],color='yellow',label='India')
sns.lineplot(data=df7,x=df['lgd'],y=df7['rank_1'],color='orange',label='China')
sns.lineplot(data=df9,x=df['lgd'],y=df9['rank_1'],color='black',label='Indonesia')
sns.lineplot(data=df10,x=df['lgd'],y=df10['rank_1'],color='blue',label='Malaysia')
sns.lineplot(data=df11,x=df['lgd'],y=df11['rank_1'],color='red',label='Cambodia')
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.title('Asia')
plt.savefig(mypath + '\Development_path_Asian.png', bbox_inches='tight')
plt.show()


sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df3,x=df3['lgd'],y=df3['rank_1'],color='green',label='Benin')
sns.lineplot(data=df12,x=df['lgd'],y=df12['rank_1'],color='yellow',label='Mali')
sns.lineplot(data=df13,x=df['lgd'],y=df13['rank_1'],color='orange',label='South Africa')
sns.lineplot(data=df14,x=df['lgd'],y=df14['rank_1'],color='blue',label='Zambia')
sns.lineplot(data=df15,x=df['lgd'],y=df15['rank_1'],color='red',label='Ethiopia')
sns.lineplot(data=df16,x=df['lgd'],y=df16['rank_1'],color='black',label='Ghana')
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.title('Africa')
plt.savefig(mypath + '\Development_path_Africa.png', bbox_inches='tight')
plt.show()


sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df8,x=df['lgd'],y=df8['rank_1'],color='brown',label='Argentina')
sns.lineplot(data=df4,x=df['lgd'],y=df4['rank_1'],color='blue',label='Brazil')
sns.lineplot(data=df5,x=df['lgd'],y=df5['rank_1'],color='red',label='Costa Rica')
sns.lineplot(data=df17,x=df['lgd'],y=df17['rank_1'],color='yellow',label='Chile')
sns.lineplot(data=df18,x=df['lgd'],y=df18['rank_1'],color='orange',label='Guatemala')
sns.lineplot(data=df19,x=df['lgd'],y=df19['rank_1'],color='green',label='Colombia')
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.title('Latin America')
plt.savefig(mypath + '\Development_path_Latin_America.png', bbox_inches='tight')
plt.show()






sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df3,x=df['lgd'],y=df3['rank_1'],color='green',label='Benin')
sns.lineplot(data=df4,x=df['lgd'],y=df4['rank_1'],color='blue',label='Brazil')
sns.lineplot(data=df5,x=df['lgd'],y=df5['rank_1'],color='red',label='Costa Rica')
for i, txt in enumerate(df3['year']):
    plt.annotate(txt, (df3.lgd.iloc[i], df3.rank_1.iloc[i]))
for i, txt in enumerate(df4['year']):
    plt.annotate(txt, (df4.lgd.iloc[i], df4.rank_1.iloc[i]))
for i, txt in enumerate(df5['year']):
    plt.annotate(txt, (df5.lgd.iloc[i], df5.rank_1.iloc[i]))
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.savefig(mypath + '\Development_path_selected_countries_years2.png', bbox_inches='tight')
plt.show()


sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df6,x=df['lgd'],y=df6['rank_1'],color='yellow',label='India')
sns.lineplot(data=df7,x=df['lgd'],y=df7['rank_1'],color='orange',label='China')
sns.lineplot(data=df8,x=df['lgd'],y=df8['rank_1'],color='brown',label='Argentina')
for i, txt in enumerate(df6['year']):
    plt.annotate(txt, (df6.lgd.iloc[i], df6.rank_1.iloc[i]))
for i, txt in enumerate(df7['year']):
    plt.annotate(txt, (df7.lgd.iloc[i], df7.rank_1.iloc[i]))
for i, txt in enumerate(df8['year']):
    plt.annotate(txt, (df8.lgd.iloc[i], df8.rank_1.iloc[i]))
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.savefig(mypath + '\Development_path_selected_countries_years1.png', bbox_inches='tight')
plt.show()

sns.set()
sns.scatterplot(data=df,x=df['lgd'],y=df['rank_1'],alpha=0.15)
sns.lineplot(data=df9,x=df['lgd'],y=df9['rank_1'],color='black',label='Indonesia')
for i, txt in enumerate(df9['year']):
    plt.annotate(txt, (df9.lgd.iloc[i], df9.rank_1.iloc[i]))
plt.xlabel("Ln (GDP per Capita)")
plt.ylabel("Upward mobility")
plt.savefig(mypath + '\Development_path_selected_countries_indonesia.png', bbox_inches='tight')
plt.show()
