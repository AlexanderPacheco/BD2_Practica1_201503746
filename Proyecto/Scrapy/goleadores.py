from bs4 import BeautifulSoup
import requests
import re
from unicodedata import normalize

def clean(val):

    string = re.sub("\r|\n|\t|\.|\ ","",val)

    string = re.sub(
        r"([^n\u0300-\u036f]|n(?!\u0303(?![\u0300-\u036f])))[\u0300-\u036f]+", r"\1", 
        normalize( "NFD", string), 0, re.I
    )
    string = normalize('NFC', string)
    return string

def Goleadores(mundial, link):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/2018_posiciones_finales.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)

    data = []
    table = soup.find('table', attrs={"class":"c0s5"})
    #print(table)
    rows = table.find_all('tr')
    rows.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados
    Posicion = 0
    for row in rows:
        cols = row.find_all('td')
        
        if len(cols)>1 :
            link = cols[1].find_all('a', href=True)
            Jugador = cols[1].get_text().strip()
            Goles = cols[2].get_text()
            Partidos = cols[3].get_text()
            Promedio_de_Gol = cols[4].get_text()
            Seleccion = cols[5].get_text()
            data.append([mundial,link[0]['href'],Posicion,Jugador,Goles,Partidos,Promedio_de_Gol,clean(Seleccion)])
        Posicion += 1
    return data
    #print(data)

#copiacion()
