#!/usr/bin/env python3

import sys
from scapy.all import *
import socket
import pandas as pd
import json

startTime = time.asctime( time.localtime(time.time()) ).replace(' ','-').replace(':','_')
portsToScan =  [i for i in range(1025)]
ip = sys.argv[1]
SYN_ACK = 0x12
ACK_RESET = 0x14
DEST_UNREACHABLE = 0x3

def getServiceOnPort(portNumber, protocol):
    try:
        serviceName = socket.getservbyport(portNumber, protocol)
    except:
        serviceName = "unknown"
    return serviceName

def udpPortscan(port, portToService):
    service = portToService(port, "udp")

    p = IP(dst=ip)/UDP(dport=port)
    print(f"UDP\t{port}\t{service}\t", end='')
    
    resp = sr1(p, verbose=False, timeout=1.0)
    if resp is None:
        status = "filtrado/abierto"
        print(status)
    elif resp.haslayer(ICMP) and resp.type == DEST_UNREACHABLE:
        status = "cerrado"
        print(status)
    else:
        status = "desconocido"
        print(status)

    return ["UDP", port, status, service]

def tcpPortscan(port, portToService):
    service = portToService(port, "tcp")

    p = IP(dst=ip)/TCP(dport=port, flags='S')
    print(f"TCP\t{port}\t{service}\t", end='')
    
    resp = sr1(p, verbose=False, timeout=1.0)
    if resp is None:
        status = "filtrado"
        print(status)
    elif resp.haslayer(TCP):
        tcp_layer = resp.getlayer(TCP)
        if tcp_layer.flags == SYN_ACK:
            status = "abierto"
            print(status, tcp_layer.flags)
            sr1(IP(dst=ip)/TCP(dport=port, flags='AR'), verbose=False, timeout=1)
        elif tcp_layer.flags == ACK_RESET:
            status = "cerrado"
            print(status, tcp_layer.flags)
        else:
            status = hex(tcp_layer.flags)
    else:
        status = "desconocido"
        print(status)
    return ["TCP", port, status, service]


def saveTableToCsv(portsScanList, fileName):
    cols = ["PROTOCOL","PORT","STATUS","SERVICE"]
    dfTable = pd.DataFrame(portsScanList, columns=cols)
    dfTable.to_csv(f"{fileName}-{startTime}.csv", index=False, header=True)

def printTableForStatus(portsScanList, status, textFile):
    rows = []
    for row in portsScanList:
        if row[3] != 'unknown':
            if row[2] == 'abierto':
                rows += [[row[1],row[3], 'abierto']]
            if row[2] == 'cerrado':
                rows += [[row[1],row[3], 'cerrado']]
            #print(f"{row[1]}\t{row[3]}", file=textFile)
    print("\\begin{tabular}{|c|c|c|}", file=textFile)
    print("\\hline", file=textFile)
    print("Puerto & Servicio & Estado \\\\\\hline", file=textFile)
    for row in rows:
        print(f"{row[0]} & {row[1]} & {row[2]} \\\\ \\hline", file=textFile)
    print("\\end{tabular}", file=textFile)

def printInfoForPortsScan(portsScanList, fileName):
    with open(fileName, "w") as textFile:
        print("filtered ports", len(list(filter(lambda row: row[2].find('filtrado') != -1,portsScanList))), file=textFile)
        print("closed ports", len(list(filter(lambda row: row[2].find('cerrado') != -1,portsScanList))), file=textFile)
        print("open ports", len(list(filter(lambda row: row[2].find('abierto') != -1,portsScanList))), file=textFile)
        printTableForStatus(portsScanList, "abierto",textFile)

def scanPortsForProtocol(ports, protocolScan, portToService):
    portsScanList = []
    counter = 1
    for port in ports:
        print(f"({counter}/{len(ports)})", end=' ')
        counter += 1
        portsScanList.append(protocolScan(port, portToService))
    return portsScanList

def runToPort1024():   
    tcpPortsScanList = scanPortsForProtocol(portsToScan, tcpPortscan, lambda port, protocol: getServiceOnPort(port, protocol))
    udpPortsScanList = scanPortsForProtocol(portsToScan, udpPortscan, lambda port, protocol: getServiceOnPort(port, protocol))
    printInfoForPortsScan(tcpPortsScanList, 'latex-table-TCP-0-1024')
    printInfoForPortsScan(udpPortsScanList, 'latex-table-UDP-0-1024')
    saveTableToCsv(tcpPortsScanList, 'scan-result-TCP-0-1024')
    saveTableToCsv(udpPortsScanList, 'scan-result-UDP-0-1024')

def runRemainingPorts():  
    tcpFile = open('TCP.json')
    tcpJson = json.load(tcpFile)
    tcpPortsToScan = [int(port) for [port,_] in tcpJson]
    tcpPortToService = {int(port):description for [port, description] in tcpJson}
    tcpPortsScanList = scanPortsForProtocol(tcpPortsToScan, tcpPortscan, lambda port, _: tcpPortToService[port])
    udpFile = open('UDP.json')
    udpJson = json.load(udpFile)
    udpPortsToScan = [int(port) for [port,_] in udpJson]
    udpPortToService = {int(port):description for [port, description] in udpJson}
    udpPortsScanList = scanPortsForProtocol(udpPortsToScan, udpPortscan, lambda port, _: udpPortToService[port])
    printInfoForPortsScan(tcpPortsScanList, 'latex-table-TCP-1025-50000')
    printInfoForPortsScan(udpPortsScanList, 'latex-table-UDP-1025-50000')
    saveTableToCsv(tcpPortsScanList, 'scan-result-TCP-1025-50000')
    saveTableToCsv(udpPortsScanList, 'scan-result-UDP-1025-50000')

runToPort1024()
runRemainingPorts()