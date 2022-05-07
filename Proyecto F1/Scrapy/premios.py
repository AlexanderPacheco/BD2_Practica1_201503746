from bs4 import BeautifulSoup
import requests
import re

def clean(val):
    characters = ".\n\t\r"

    string = re.sub("\r|\n|\t|\.|\ ","",val)
    return string

def Premios(mundial, link):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/1982_premios.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)

    data = []
    contenedor = soup.find_all('div', attrs={"class":"rd-100-30"})
    #print(contenedor)
    #seccion = contenedor.find_all('div', attrs={"class":"a-center"})
    #seccion.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados
    #print(seccion)
    
    for secc in contenedor:
        cols = secc.find_all('p')
        #print(cols[0].get_text().strip())
        #print(cols[1].get_text().strip())
        
        Premio = cols[0].get_text().strip()
        Jugador = cols[1].get_text().strip()
        link = cols[1].find_all('a',href=True)
        if len(link)>0:
            link = link[0]['href']
        else:
            link = '-'
        Pais = "-"

        pais  = secc.find_all('img', alt=True)
        if len(pais) > 0:
            #print(pais[0]['alt'])
            Pais = pais[0]['alt']
        
        data.append([mundial,link,Premio,Jugador,Pais])
        #print('----------------------------------------------------------------')

    contenedor = soup.find_all('div', attrs={"class":"rd-100-45"})

    for secc in contenedor:
        cols = secc.find_all('p')
        #print(cols[0].get_text().strip())
        #print(cols[1].get_text().strip())
        
        Premio = cols[0].get_text().strip()
        Jugador = cols[1].get_text().strip()
        link = cols[1].find_all('a',href=True)
        if len(link)>0:
            link = link[0]['href']
        else:
            link = '-'
        Pais = "-"

        pais  = secc.find_all('img', alt=True)
        if len(pais) > 0:
            #print(pais[0]['alt'])
            Pais = pais[0]['alt']
        
        data.append([mundial,link,Premio,Jugador,Pais])
        #print('----------------------------------------------------------------')
    return data;
    #print(data)

#Premios('mundial','https://www.losmundialesdefutbol.com/mundiales/1998_premios.php')
