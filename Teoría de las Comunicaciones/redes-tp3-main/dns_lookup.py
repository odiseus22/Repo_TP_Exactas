from scapy.all import *
from ipaddress import ip_address, IPv4Address

MX = 15
A = 1
typeDict = {'MX':MX, 'A':A}

def isIPV4(IP):
    return type(ip_address(IP)) is IPv4Address

def listToDictOfSet(l, ignoreC = False):
    d = dict()
    for a, b, c in l:
        if a not in d:
            d[a] = set()
        if ignoreC:
            d[a].add(b)
        else:
            d[a].add((b,c))
    return d

def dnsLookup(domainDst, DNSIP, type = "A"):
    
    # print(f"DNS Lookup in {DNSIP} for {domainDst} ------------------------------------------------------")
    
    dns = DNS(rd=1,qd=DNSQR(qname=domainDst, qtype=type))
    udp = UDP(sport=RandShort(), dport=53)
    ip = IP(dst=DNSIP)
    
    answer = sr1( ip / udp / dns , verbose=0, timeout=10)

    additionalRecords = {}
    nameServers = {}
    answers = {}
    denied = True
    reachedSOA = False
    if answer is not None:
        if answer.haslayer(DNS) and answer[DNS].qd.qtype == typeDict[type]:

            if answer[DNS].nscount > 0:
                for ns in answer[DNS].ns:
                    if ns.type == 6:
                        reachedSOA = True
            if not reachedSOA:
                additionalRecords = listToDictOfSet([(answer[DNS].ar[i].rrname, answer[DNS].ar[i].rdata, answer[DNS].ar[i].type) for i in range(answer[DNS].arcount) if isIPV4(answer[DNS].ar[i].rdata)], True)
                nameServers = listToDictOfSet([(answer[DNS].ns[i].rrname, answer[DNS].ns[i].rdata, answer[DNS].ns[i].type) for i in range(answer[DNS].nscount)], True)
                answers = listToDictOfSet([(answer[DNS].an[i].rrname, (answer[DNS].an[i].exchange if MX == answer[DNS].an[i].type else answer[DNS].an[i].rdata), answer[DNS].an[i].type) for i in range(answer[DNS].ancount)]) 
                denied = False
    else:
        pass #print("Timeout!")

    if False:
        print("Additional Records")
        printDictOfSets(additionalRecords)
        print("Name Servers")
        printDictOfSets(nameServers)
        print("Answers")
        printDictOfSets(answers)

    return additionalRecords, nameServers, answers, denied, reachedSOA

def printDictOfSets(d):
    for k, s in d.items():
        print(f"{k}")
        for e in s:
            print(f"\t{e}")

def recursiveMailLookup(domainDst, DNSDomain, DNSIP, type, info = {'depth':0, 'maxDepth':0, 'denies':set(), 'reachedSOAs':set(), 'answers':set(), 'answersPaths':dict()}):
    denies = info["denies"]
    reachedSOAs = info["reachedSOAs"]
    additionalRecords, nameServers, answers, denied, reachedSOA = dnsLookup(domainDst, DNSIP, type)

    tabs = '\t'*info["depth"]

    if reachedSOA:
        reachedSOAs.add((DNSDomain, DNSIP))
        print(f"{tabs}{DNSDomain} ({DNSIP}) reached SOA")
        return info

    if denied:
        denies.add((DNSDomain, DNSIP))
        print(f"{tabs}{DNSDomain} ({DNSIP}) timeout")
        return info

    if len(answers) > 0:
        for ds, s in answers.items():
            for dsr, type in s:
                info["answers"].add((dsr,dsr))

        info["maxDepth"] = max(info["maxDepth"],info["depth"] + 1)
        print(f"{tabs}{DNSDomain} ({DNSIP}) finish")
        return info
    
    print(f"{tabs}{DNSDomain} ({DNSIP}) ->")

    info["depth"] += 1
    for _, nextDNSDomainSet in nameServers.items():
        for nextDNSDomain in nextDNSDomainSet:
            if nextDNSDomain not in additionalRecords:
                continue
            for nextDNSIP in additionalRecords[nextDNSDomain]:
                recursiveMailLookup(domainDst, nextDNSDomain, nextDNSIP, type, info)
                #if len(info["answers"]) > 0:
                #    info["depth"] -= 1
                #    return info
 
    info["depth"] -= 1
    return info

domain = sys.argv[1]

result = {'depth':0, 'maxDepth':0, 'denies':set(), 'reachedSOAs':set(), 'answers':set(), 'answersPaths':dict()}
result = recursiveMailLookup(domain,"b.root-servers.net","199.9.14.201","MX", result)

print(f"Niveles de servidores DNS recorridos: {result['maxDepth']}")
print("Servidores DNS Autoritativos que no respondieron a las consultas realizadas:")
for serverDNS in result["denies"]:
    print(f"\t{serverDNS}")
print("Servidores DNS Autoritativos que respondieron con SOA a las consultas realizadas:")
for serverDNS in result["reachedSOAs"]:
    print(f"\t{serverDNS}")
print("Nombres de servidores de mail encontrados:")
for DNSDomain, DNSIP in result["answers"]:
    print(f"\t{DNSIP}\t{DNSDomain}")
