import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import math as mat

DisjointSetArray_same_K = pd.read_csv('../tests/benchmark_same_K/benchmark_functions_same_k.csv', sep=',')

ax1 = sns.lineplot(x="n", y="Array", data=DisjointSetArray_same_K)
plt.title("DisjointSet Array")
plt.ylim([2500,3300])
plt.ylabel("tiempo (ms)")
plt.xlabel("imagen")
plt.savefig("array_same_k.png")

plt.clf()

ax1 = sns.lineplot(x="n", y="Tree", data=DisjointSetArray_same_K)
plt.title("DisjointSet Tree")
plt.ylabel("tiempo (ms)")
plt.xlabel("imagen")
plt.savefig("tree_same_k.png")

plt.clf()

ax2 = sns.lineplot(x="n", y="Tree", data=DisjointSetArray_same_K)
ax2 = sns.lineplot(x="n", y="TreePath", data=DisjointSetArray_same_K)
ax2.legend(["DisjointSet Tree", "DisjointSet Tree PathCompression"])
plt.ylabel("tiempo (ms)")
plt.xlabel("imagen")
plt.savefig("tree_v_path_same_k.png")

plt.clf()

DisjointSetArray_diff_K = pd.read_csv('../tests/benchmark_diff_K/benchmark_functions_diff_k.csv', sep=',')

ax3 = sns.lineplot(x="n", y="Array", data=DisjointSetArray_diff_K)
plt.ylim([14000, 18000])
plt.ylabel("tiempo (ms)")
plt.title("Implementacion en un Array")
plt.xlabel("k")
plt.savefig("array_diff_k.png")

plt.clf()

ax4 = sns.lineplot(x="n", y="Tree", data=DisjointSetArray_diff_K);
plt.ylabel("tiempo (ms)")
plt.title("Implementacion en un Tree")
plt.xlabel("k")
plt.savefig("tree_diff_k.png")

plt.clf()

ax5 = sns.lineplot(x="n", y="TreePath", data=DisjointSetArray_diff_K)
plt.ylim([15, 35])
plt.ylabel("tiempo (ms)")
plt.xlabel("k")
plt.title("Implementacion en un Tree con Path Compression")
plt.savefig("path_diff_k.png")

plt.clf()

ax6 = sns.lineplot(x="n", y="Tree", data=DisjointSetArray_diff_K)
ax6 = sns.lineplot(x="n", y="TreePath", data=DisjointSetArray_diff_K)
ax6.legend(["DisjointSet Tree", "DisjointSet Tree PathCompression"])
plt.ylabel("tiempo (ms)")
plt.savefig("tree_v_path_diff_k.png")

plt.clf()

complexities = pd.read_csv('../tests/complexity/complexity.csv', sep=',')
df_array = complexities[['n','m','Array']].groupby(['n','m']).mean().reset_index()
df_tree = complexities[['n','m','Tree']].groupby(['n','m']).mean().reset_index()
df_path= complexities[['n','m','TreePath']].groupby(['n','m']).mean().reset_index()

df_array['cota'] = df_array['m'] + df_array['n']*df_array['n']
df_tree['cota'] = df_tree['m']*df_tree['n'] + df_tree['n']*df_tree['n']
df_path['cota'] = df_path['m'] + df_path['n']

ax1 = sns.lmplot(x='Array', y='cota', data=df_array)
r = np.corrcoef(df_array["Array"], df_array["cota"])[0, 1]
plt.title('Coeficiente:'+str(r))
plt.xlabel("T(n,m)")
plt.ylabel("cota(n,m)")
plt.savefig("compl_array.png")
print("El coeficiente de correlación de Pearson es: r="+str(r))

plt.clf()

ax1 = sns.lmplot(x='Tree', y='cota', data=df_tree)
r = np.corrcoef(df_tree["Tree"], df_tree["cota"])[0, 1]
plt.title('Coeficiente:'+str(r))
plt.xlabel("T(n,m)")
plt.ylabel("cota(n,m)")
plt.savefig("compl_tree")
print("El coeficiente de correlación de Pearson es: r="+str(r))

plt.clf()

ax1 = sns.lmplot(x='TreePath', y='cota', data=df_path)
r = np.corrcoef(df_path["TreePath"], df_path["cota"])[0, 1]
plt.title('Coeficiente:'+str(r))
plt.xlabel("T(n,m)")
plt.ylabel("cota(n,m)")
plt.savefig("compl_path.png")
print("El coeficiente de correlación de Pearson es: r="+str(r))

