from ast import arg
import threading
from unittest import result
from bs4 import BeautifulSoup
import requests
import re
import csv
from posiciones import copiacion
from premios import Premios
from goleadores import Goleadores
from resultado import Resultado
from jugador import JugadorFind
from tresultados import TResultados

from multiprocessing.pool import ThreadPool
from threading import Thread

r = requests.get('https://www.losmundialesdefutbol.com/mundiales.php')
r2 = requests.get('https://www.losmundialesdefutbol.com/jugadores.php')
soup = BeautifulSoup(r.text, 'lxml')

print(soup.title.text)

master_link = 'https://www.losmundialesdefutbol.com/mundiales'
master_link2 = 'https://www.losmundialesdefutbol.com/jugadores'

footer = soup.find(id='')

#Creando la lista de posiciones finales y le agrego sus encabezados de una
Dataset_Posiciones_Finales = [['Mundial','Posición','Selección','Etapa','PTS','PJ','PG','PE','PP','GF','GC','Dif']]
Dataset_Premios_Mundiales = [['Mundial','Link','Premio','Jugador','Pais']]
Dataset_Goleadores_Mundial =[['Mundial','link','Posicion','Jugador','Goles','Partidos', 'Promedio de Gol', 'Selección']]
Dataset_Jugadores_Partido = [['Mundial','local','visitante','Link','Pos','Camiseta', 'Estado', 'Jugador', 'linkJugador']]
Dataset_Tarjetas_Partido = [['Mundia','local','visitante','Link','Pais','Jugador','Tarjeta','minuto']]
Dataset_Cambios_Partido = [['Mundia','local','visitante','Link','Pais','Minuto','Sale','Entra']]
Dataset_Jugadores_Mundial = [['Link','FechaNac','Posicion','NumerosDeCamiseta','altura','Nombre','seleccion']]
Dataset_Jugador = [['Link','Nombre','FechaNac','LugarNac','Posicion','NoCamiseta','altura','apodo','web','seleccion']]
Dataset_TResultados_Partido = [['Mundia','link','Etapa','Resultado','Equipo1','Equipo2','Fecha']]

def generar_csv(name, dataset):
    with open(name+".csv", "w", encoding='utf-8', newline='') as csvfile:
        writer = csv.writer(csvfile)
        for data in dataset: #truncate to 150 rows
            writer.writerow(data)


def navegar2():
    content =   soup.find_all("div", attrs={"class":"a-left"})
    selecciones = content[0].find_all('a',href=True)
    for seleccion in selecciones:
        link = re.sub("/jugadores","/"+seleccion['href'],master_link2)
        print("\t\tMinando >> ",link)
        # pool = ThreadPool(processes=1)
        # async_result  = pool.apply_async(getJugadores, ( seleccion.get_text(),link))
        # return_val = async_result.get()
        # print(return_val)
       # Thread(target=getJugadores, args=( seleccion.get_text(),link)).start()
        getJugadores( seleccion.get_text(),link)
        


def getJugadores( seleccion, link):
    r2 = requests.get(link)
    soup2 = BeautifulSoup(r2.text, 'lxml')
    divs = soup2.find_all("div", attrs={"class":"rd-100-33 a-left"})
    print("*--------------"+seleccion+"--------------*")
    contador = 0
    for col in divs:
        ahref = col.find_all('a',href=True)
        for jugador in ahref:
            linkPlayer = re.sub("/jugadores","/"+jugador['href'],master_link2)

            res = JugadorFind("/jugadores/"+jugador['href'],linkPlayer, jugador.get_text(),seleccion)
            print(res[0])
           # print(t)
            Dataset_Jugador.extend(res)
           # print(Dataset_Jugador)
            contador+=1

    


    print('---------------------------------------------------------------------------------')
    
def navegar():
    table = soup.find("table", attrs={"class":"c0s5"})
    rows = table.find_all("tr", attrs={"class":"a-center"})

    #print(rows)
    contador= 0
    for row in rows:
        
        
        cols = row.find_all('td')
        if len(cols) > 0 :
            mundial = cols[0].get_text().strip()
            print("*",mundial,"*")
            linkitos  = cols[1].find_all('a', href=True)
            pos = 0
            
            if len(linkitos) == 4: #NOTA: En 1950 no trae fase final :v
                print('---------------------------------------------------------------------------------')
                for a in linkitos:
                    print ("Found the URL:", a['href'])
                    #print(master_link.replace('mundiales',""))
                    link = re.sub("/mundiales","/"+a['href'],master_link)
                    print("\t\tMinando >> ",link)
                    if pos == 0 :
                        if(link != 'https://www.losmundialesdefutbol.com/mundiales/2022_resultados.php'):
                            res = Resultado(mundial, link)
                            print(res[0])
                            Dataset_Jugadores_Partido.extend(res[0])
                            Dataset_Tarjetas_Partido.extend(res[1])
                            Dataset_Cambios_Partido.extend(res[2])
                    # if pos == 1: #Goleadores
                    #     res = Goleadores(mundial,link)
                    #     Dataset_Goleadores_Mundial.extend(res)
                    # if pos == 2: #Posiciones_Finales
                    #     res = copiacion(mundial,link)
                    #     Dataset_Posiciones_Finales.extend(res)
                    if pos == 3: #Premios
                        res = Premios(mundial, link)
                        Dataset_Premios_Mundiales.extend(res)
                    pos = pos + 1
                print('---------------------------------------------------------------------------------')
            else:
                print('---------------------------------------------------------------------------------')
                for a in linkitos:
                    #print(master_link.replace('mundiales',""))
                    link = re.sub("/mundiales","/"+a['href'],master_link)
                    if pos == 0 :
                        # if(link != 'https://www.losmundialesdefutbol.com/mundiales/2022_resultados.php'):
                        #     res = Resultado(mundial, link)
                        #    # Dataset_Jugadores_Partido.extend(res[0])
                        #     Dataset_Tarjetas_Partido.extend(res[1])
                        #     Dataset_Cambios_Partido.extend(res[2])
                        res = TResultados(mundial, link)
                        Dataset_TResultados_Partido.extend(res)
                    # if pos == 2 :
                    #     res = Goleadores(mundial, link)
                    #     Dataset_Goleadores_Mundial.extend(res)
                    # if pos == 3: #Posiciones_Finales
                    #     res = copiacion(mundial,link)
                    #     Dataset_Posiciones_Finales.extend(res)
                    if pos == 4: #Premios
                         res = Premios(mundial, link)
                         Dataset_Premios_Mundiales.extend(res)
                    pos = pos + 1
                print('---------------------------------------------------------------------------------')
navegar()
# generar_csv("Dataset_Jugador",Dataset_Jugador)
#generar_csv("Dataset_TResultados_Partido",Dataset_TResultados_Partido)
# generar_csv("Dataset_Posiciones_Finales",Dataset_Posiciones_Finales)
generar_csv("Dataset_Premios_Mundiales",Dataset_Premios_Mundiales)
# generar_csv("Dataset_Goleadores_Mundiales",Dataset_Goleadores_Mundial)

#generar_csv("Dataset_Jugadores_Partido",Dataset_Jugadores_Partido)
#generar_csv("Dataset_Tarjetas_Partido",Dataset_Tarjetas_Partido)
#generar_csv("Dataset_Cambios_Partido",Dataset_Cambios_Partido)
#print(Dataset_Posiciones_Finales)
#print(Dataset_Premios_Mundiales)


