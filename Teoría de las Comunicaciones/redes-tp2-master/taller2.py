#!/usr/bin/env python3
import sys
from scapy.all import *
from time import *
import pandas as pd

import geolocate
import cimbala

TIME_EXCEEDED = 11
ECHO_REPLY = 0

class MedicionesTP:

	def __init__(self, cant_ttl=0):

		self.cant_ttl = cant_ttl
		self.tiempos_de_respuesta_por_ttl = {}
		self.max_ttl_por_it = {}
		self.cant_saltos_sin_respuesta = {}
	
	def agregar_medicion_para_ttl(self, ttl, ip, medicion, iteracion):

		if iteracion not in self.tiempos_de_respuesta_por_ttl:
			self.tiempos_de_respuesta_por_ttl[iteracion] = {}
			
			for inner_ttl in range(1, self.cant_ttl + 1):
				self.tiempos_de_respuesta_por_ttl[iteracion][inner_ttl] = {}
		
		if ip not in self.tiempos_de_respuesta_por_ttl[iteracion][ttl]:
			self.tiempos_de_respuesta_por_ttl[iteracion][ttl][ip] = []

		self.tiempos_de_respuesta_por_ttl[iteracion][ttl][ip].append(medicion)

	def obtener_mediciones_para_ttl_segun_ip_por_iteracion(self, ttl, iteracion):
		return self.tiempos_de_respuesta_por_ttl[iteracion][ttl]

	def registrar_ttl_max_para_iteracion(self, ttl, iteracion):
		self.max_ttl_por_it[iteracion] = ttl

	def registrar_salto_sin_respuesta_para_iteracion(self, iteracion):
		
		if iteracion not in self.cant_saltos_sin_respuesta:
			self.cant_saltos_sin_respuesta[iteracion] = 0

		self.cant_saltos_sin_respuesta[iteracion] += 1

	def obtener_saltos_con_respuesta_para_iteracion(self, iteracion):
		cant = 0
		
		for ttl in self.tiempos_de_respuesta_por_ttl[iteracion]:
			if len(self.tiempos_de_respuesta_por_ttl[iteracion][ttl]) > 0:
				cant += 1
		
		return cant

	def obtener_saltos_sin_respuesta_para_iteracion(self, iteracion):
		return self.cant_saltos_sin_respuesta[iteracion]

	def obtener_max_ttl_para_iteracion(self, iteracion):
		if iteracion not in self.max_ttl_por_it:
			return self.cant_ttl
		else:
			return self.max_ttl_por_it[iteracion]

	def obtener_ips_para_iteracion(self, iteracion):
		resultado = []

		for ttl in self.tiempos_de_respuesta_por_ttl[iteracion]:
			for ip in self.tiempos_de_respuesta_por_ttl[iteracion][ttl]:
				resultado.append(ip)

		return resultado

	def obtener_caminos_calculados(self):
		resultado = []

		for iteracion in self.tiempos_de_respuesta_por_ttl:
			resultado.append({0:iteracion, 1:self.obtener_ips_para_iteracion(iteracion)})

		return resultado

	def mostrar_mediciones_para_ttl_en_iteracion(self, ttl, iteracion):
		print("Valores de RTT para ttl=", ttl, ": ")

		for ip in self.tiempos_de_respuesta_por_ttl[iteracion][ttl]:
			print("IP: ", ip)
			print("Valores de RTT: ", self.tiempos_de_respuesta_por_ttl[iteracion][ttl][ip])
	
	def promedio_de_rtt_para_ttl_segun_ip(self, ttl):

		ips_capturados = {}

		for iteracion in self.tiempos_de_respuesta_por_ttl:
			for ip in self.tiempos_de_respuesta_por_ttl[iteracion][ttl]:
				if ip not in ips_capturados:
					ips_capturados[ip] = {
						"cant":1,
						"tiempo_acum":self.tiempos_de_respuesta_por_ttl[iteracion][ttl][ip][0],
					}
				else:
					ips_capturados[ip]["cant"] += 1
					ips_capturados[ip]["tiempo_acum"] += self.tiempos_de_respuesta_por_ttl[iteracion][ttl][ip][0]

		max_ip = None
		max_ip_len = 0

		for ip in ips_capturados:
			if ips_capturados[ip]["cant"] > max_ip_len:
				max_ip_len = ips_capturados[ip]["cant"]
				max_ip = ip

		promedio = 0 if max_ip is None else ips_capturados[max_ip]["tiempo_acum"]/ips_capturados[max_ip]["cant"]

		#print("PROMEDIO PARA TTL:{} es {} con max_ip: {}".format(ttl, promedio, max_ip))

		return (promedio, max_ip)

	def obtener_camino_promediado(self):
		camino_prom = []
		camino_prom_l = ['host']
		rtt_prom_l = [0]
		for ttl in range(1, self.cant_ttl + 1):
			rtt_prom, ip_prom = self.promedio_de_rtt_para_ttl_segun_ip(ttl)
			
			if ip_prom is not None:
				camino_prom.append(ip_prom)
				camino_prom_l.append(ip_prom)
				rtt_prom_l.append(rtt_prom)

		return camino_prom, camino_prom_l, rtt_prom_l
	
	def obtener_rtt_entre_saltos_promediado(self):
		
		promedios = []
		for ttl in range(1, self.cant_ttl + 1):
			promedios.append(self.promedio_de_rtt_para_ttl_segun_ip(ttl))
		
		i = 0
		resultados = []
		while i < len(promedios):
			
			j = i + 1

			while j < len(promedios) and promedios[j][0] - promedios[i][0] < 0:
				j += 1

			if j < len(promedios):
				resultados.append(((promedios[i][1], promedios[j][1]),promedios[j][0] - promedios[i][0]))

			i = j
		
		return resultados


def realizar_medidas(contenedor_de_mediciones, direccion_destino, cantidad_maxima_de_ttl, cantidad_de_repeticiones_por_ttl):
	for iteracion in range(cantidad_de_repeticiones_por_ttl):
		print("ITERACION {}:".format(iteracion))

		for ttl in range(1, cantidad_maxima_de_ttl + 1):
			probe = IP(dst=direccion_destino, ttl=ttl) / ICMP()
			
			t_i = time()
			ans = sr1(probe, verbose=False, timeout=0.8)
			t_f = time()

			rtt = (t_f - t_i)*1000
			
			print("Tipo de respuesta:", ans.type if ans is not None else " Respuesta Nula")

			if ans is not None:
				contenedor_de_mediciones.agregar_medicion_para_ttl(ttl, ans.src, rtt, iteracion)
			
				contenedor_de_mediciones.mostrar_mediciones_para_ttl_en_iteracion(ttl, iteracion)

				if ans.src == direccion_destino:
					# Paso a proxima iteracion
					contenedor_de_mediciones.registrar_ttl_max_para_iteracion(ttl, iteracion)
					break
			else:
				contenedor_de_mediciones.registrar_salto_sin_respuesta_para_iteracion(iteracion)
	
	print("----------------------------------------")


def saveHopsLossRatioTable(resultados):
	cols = ['ID','LOSS']
	rows = []
	for iteracion in resultados.tiempos_de_respuesta_por_ttl:
		total = resultados.obtener_saltos_con_respuesta_para_iteracion(iteracion) + resultados.obtener_saltos_sin_respuesta_para_iteracion(iteracion)
		lost = resultados.obtener_saltos_sin_respuesta_para_iteracion(iteracion)
		rows.append([iteracion, lost/total])
	
	dfTable = pd.DataFrame(rows, columns=cols)
	dfTable.to_csv("hopsLossRatioTable.csv", index=False, header=True)

def main():

	ip_dest = sys.argv[1]
	max_ttl = int(sys.argv[2])
	cant_reps = int(sys.argv[3])
	ip_src = sys.argv[4]

	resultados = MedicionesTP(max_ttl)

	realizar_medidas(resultados, ip_dest, max_ttl, cant_reps)

	#print("----------------------------------------")

	#print("Saltos entre puntos: ")
	saltos_promedio = resultados.obtener_rtt_entre_saltos_promediado()

	camino_con_saltos = []

	for i in saltos_promedio:
		source = i[0][0] if i[0][0] is not None else "localhost"
		dest = i[0][1]
		tiempo_entre_saltos = i[1]

		if source not in camino_con_saltos:
			camino_con_saltos.append(source)
		
		if dest not in camino_con_saltos:
			camino_con_saltos.append(dest)

		#print("De:\t{}\ta:\t{}\ttiempo entre saltos: {}".format(source, dest, tiempo_entre_saltos))

	#print("----------------------------------------")

	caminos_calculados = resultados.obtener_caminos_calculados()

	#for camino in caminos_calculados:
	#	print("CAMINO {}: {}".format(camino[0], camino[1]))
	#print("----------------------------------------")
	
	camino_prom, camino_prom_l, rtt_prom_l = resultados.obtener_camino_promediado()
	
	hopAndRTTList = []
	print("CAMINO PROMEDIADO")
	print("Desde & Hasta & RTT \\\\\\hline")
	for i in range(len(camino_prom_l)-1):
		print(f"{camino_prom_l[i]} & {camino_prom_l[i+1]} & {rtt_prom_l[i+1]-rtt_prom_l[i]} \\\\ \\hline")
		hopAndRTTList.append(((camino_prom_l[i], camino_prom_l[i+1]),rtt_prom_l[i+1]-rtt_prom_l[i]))
	print("CAMINO PROMEDIADO FILTRADO")
	print("Desde & Hasta & RTT \\\\\\hline")
	for hop, rtt in saltos_promedio:
		print(f"{hop[0]} & {hop[1]} & {rtt} \\\\ \\hline")

	print("----------------------------------------")
	print("CAMINO PROMEDIADO")
	print("POTENTIAL INTEROCEANIC JUMPS FROM HIGHER TO LOWER CHANCE")
	data = [rtt for hop, rtt in hopAndRTTList if rtt >= 0]
	cimbala.saveRTTDistributionTable(data)
	for hop, rtt in cimbala.findPossibleInteroceanicsHops(hopAndRTTList):
		print(f"{hop[0]} -> {hop[1]} RTT: {rtt}")
	print("CAMINO PROMEDIADO FILTRADO")
	print("POTENTIAL INTEROCEANIC JUMPS FROM HIGHER TO LOWER CHANCE")
	for hop, rtt in cimbala.findPossibleInteroceanicsHops(saltos_promedio):
		print(f"{hop[0]} -> {hop[1]} RTT: {rtt}")
	#print("CAMINO PROMEDIADO: {}".format(camino_prom))
	#print("----------------------------------------")
	#print("CAMINO CON SALTOS: {}".format(camino_con_saltos))
	#print("----------------------------------------")

	caminos_calculados.append({0: cant_reps+1, 1:camino_prom})
	caminos_calculados.append({0: cant_reps+2, 1:camino_con_saltos})
	
	ipsRoutes = {}
	for ipsRoute in caminos_calculados:
		# ipsRoutes[ipsRoute[0]] = [ip_src]+(ipsRoute[1][1:] if len(ipsRoute[1])>0 else [])
		ipsRoutes[ipsRoute[0]] = [ip_src]+ [ip for ip in ipsRoute[1] if ip.find('192.168.') == -1 ]

	latLongIpsRoutes = geolocate.findLatLongForIPsRoutesList(ipsRoutes)
	geolocate.saveTableToCsv(latLongIpsRoutes)

	saveHopsLossRatioTable(resultados)

	#print("----------------------------------------")
	#print("CANTIDAD DE MENSAJES ENVIADOS CONTRA NULOS DE LAS ITERACIONES")
	#
	#for iteracion in resultados.tiempos_de_respuesta_por_ttl:
	#	print("ITERACION {}: Enviadas: {} Nulos: {}".format(
	#												iteracion, 
	#												resultados.obtener_saltos_con_respuesta_para_iteracion(iteracion), 
	#												resultados.obtener_saltos_sin_respuesta_para_iteracion(iteracion)))

if __name__ == "__main__":
	main()
