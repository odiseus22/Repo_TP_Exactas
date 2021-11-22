import statistics as stats
import math
from scipy.stats import t
import pandas as pd

def criticalStudentValue(n):
    df = n-2
    alpha = 0.05
    return t.ppf(1-alpha/2, df)

def thompson(n):
    t = criticalStudentValue(n)
    return (t*(n-1))/(math.sqrt(n)*math.sqrt(n-2+t**2))

def filterBiggestOutlier(data):
    if len(data) < 2:
        return None
        
    mean = stats.mean(data)
    S = stats.stdev(data)

    dataAbsDev = list(map( lambda x : (abs(x-mean),x), data))
    maxDevX = max(dataAbsDev)

    t = thompson(len(data))
    if maxDevX[0] > t*S:
        data.remove(maxDevX[1])
        return maxDevX[1]

    return None

def saveRTTDistributionTable(data):
    cols = ["RTT","VALUE"] 
    if len(data) < 2:
        dfTable = pd.DataFrame([], columns=cols)
        dfTable.to_csv("RTTDistributionTable.csv", index=False, header=True)
        return

    mean = stats.mean(data)
    S = stats.stdev(data)
    rows = list(map( lambda x : (x,(x-mean)/S), data))
    
    dfTable = pd.DataFrame(rows, columns=cols)
    dfTable.to_csv("RTTDistributionTable.csv", index=False, header=True)

def findPossibleInteroceanicsHops(hopAndRTTList):
    interoceanicsHops = []
    data = [rtt for hop, rtt in hopAndRTTList if rtt >= 0]
    dataLen = -1
    while dataLen != len(data):
        dataLen = len(data)
        outlier = filterBiggestOutlier(data)
        if outlier is not None:
            for hopAndRTT in hopAndRTTList:
                if hopAndRTT[1] == outlier:
                    interoceanicsHops.append(hopAndRTT)
                    hopAndRTTList.remove(hopAndRTT)
                    break
    return interoceanicsHops
