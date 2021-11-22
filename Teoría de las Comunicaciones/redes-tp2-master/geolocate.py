import ipinfo
import random as rnd
import pandas as pd

access_token = 'cd4608c9d40d12'
handler = ipinfo.getHandler(access_token)


def findLatLongForIPsRoutesList(ipsRoutes):
    ipsLatLongRoutes = {}

    for ipsRoute in ipsRoutes.items():
        routeID = ipsRoute[0]
        ips = ipsRoute[1]
        ipLatLongList = []
        for ip in ips:
            try:
                details = handler.getDetails(ip)
                latLong = (details.latitude,details.longitude)
                ipLatLongList.append((ip,latLong))
                #latLong = (rnd.randint(-75,75),rnd.randint(-75,75))
                #ipLatLongList.append((ip,latLong))
            except ValueError:
                print(f"{ip} not found.")
        ipsLatLongRoutes[routeID] = ipLatLongList

    return ipsLatLongRoutes


def saveTableToCsv(ipsRoutes):
    cols = ["ROUTE ID","IP","LAT","LONG"]
    rows = []
    for routeID, ips in ipsRoutes.items():
        for ip,(lat,long) in ips:
          rows.append([routeID,ip,lat,long])  

    dfTable = pd.DataFrame(rows, columns=cols)
    dfTable.to_csv("ipsRoutesTable.csv", index=False, header=True)
