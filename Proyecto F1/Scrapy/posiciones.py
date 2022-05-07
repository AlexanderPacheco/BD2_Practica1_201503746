from bs4 import BeautifulSoup
import requests
import re

def clean(val):
    characters = ".\n\t\r"

    string = re.sub("\r|\n|\t|\.|\ ","",val)
    return string

def copiacion(mundial, link):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/2018_posiciones_finales.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)

    data = []
    table = soup.find('table', attrs={"class":"c0s5"})
    #print(table)
    rows = table.find_all('tr')
    rows.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados

    for row in rows:
        cols = row.find_all('td')
        if len(cols)>1 :
            Posicion = cols[0].get_text()
            Seleccion = cols[1].get_text()
            Etapa = cols[2].get_text()
            PTS = cols[3].get_text()
            PJ = cols[4].get_text()
            PG = cols[5].get_text()
            PE = cols[6].get_text()
            PP = cols[7].get_text()
            GF = cols[8].get_text()
            GC = cols[9].get_text()
            Dif = cols[10].get_text()
            data.append([mundial,clean(Posicion),clean(Seleccion),Etapa,PTS,PJ,PG,PE,PP,GF,GC,Dif])
    return data
    #print(data)

#copiacion()
