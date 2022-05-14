from bs4 import BeautifulSoup
import requests
import re
from partido import Partido

def clean(val):
    characters = ".\n\t\r"

    string = re.sub("\r|\n|\t|\.|\ ","",val)
    return string

def Resultado(mundial, link):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/1982_premios.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)
    data = [[],[],[]]
    contenedor = soup.find_all('div', attrs={"class":"margen-t3 clearfix"})
    #print(contenedor)
    #seccion = contenedor.find_all('div', attrs={"class":"a-center"})
    #seccion.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados
    #print(seccion)
    for secc in contenedor:
        print(secc)
        a  = secc.find_all('a', href=True)
        if len(a)> 0:
            for links in a :
                link = re.sub("/mundiales","/"+links['href'],'https://www.losmundialesdefutbol.com/mundiales')
        # cols = secc.find_all('p')
                res = Partido(mundial, link)
                #print(res[0])
                # for item in res[0]:
                #     data[0].append(item)
                for item in res[1]:
                    data[1].append(item)
                for item in res[2]:
                    data[2].append(item)
    return data
    #print(data)

#Premios('mundial','https://www.losmundialesdefutbol.com/mundiales/1998_premios.php')
