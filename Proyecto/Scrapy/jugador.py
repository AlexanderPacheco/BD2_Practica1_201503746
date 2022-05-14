from cmath import infj
from bs4 import BeautifulSoup
import requests
import re
from unicodedata import normalize


def clean(val):

    string = re.sub("\r|\n|\t|\.|\ ","",val)

    string = re.sub(",","_",string)
    string = re.sub(
        r"([^n\u0300-\u036f]|n(?!\u0303(?![\u0300-\u036f])))[\u0300-\u036f]+", r"\1", 
        normalize( "NFD", string), 0, re.I
    )
    string = normalize('NFC', string)
    return string

def JugadorFind(mundial, link, nombre, pais):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/2018_posiciones_finales.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')
    data = []
    table = soup.find('table', attrs={"class":"w-auto margen-xauto"})
    #print(table)
    rows = table.find_all('tr')
    #rows.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados

    infJugador = [mundial,clean(nombre),'','','','','','','']
    
    for row in rows:
        cols = row.find_all('td')
        if len(cols)>1 :
            Detalle = cols[1].get_text()
            if cols[0].get_text() == ' Nombre completo:' :
                infJugador[1] = clean(Detalle)
            elif(cols[0].get_text() == ' Fecha de Nacimiento:'):
                infJugador[2] = clean(Detalle)
                
            elif(cols[0].get_text() == 'Lugar de nacimiento:'):
                infJugador[3] = clean(Detalle)
            elif(cols[0].get_text() == 'Posición:'):
                infJugador[4] = clean(Detalle)
            elif(cols[0].get_text() == 'Números de camiseta:'):
                infJugador[5] = clean(Detalle)
            elif(cols[0].get_text() == 'Altura:' ):
                infJugador[6] = clean(Detalle)
            elif(cols[0].get_text() == 'Apodo:'):
                infJugador[7] = clean(Detalle)
            elif(cols[0].get_text() == 'Sitio Web Oficial:'):
                infJugador[8] = clean(Detalle)
    infJugador.append(pais)
    data.append(infJugador)
    return data
    #print(data)

#copiacion()
