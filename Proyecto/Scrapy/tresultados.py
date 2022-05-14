from bs4 import BeautifulSoup
import requests
import re

def clean(val):
    characters = ".\n\t\r"

    string = re.sub("\r|\n|\t|\.|\ ","",val)
    string2 = re.sub(",","_",string)
    return string2

def TResultados(mundial, link):
  #  r = requests.get('https://www.losmundialesdefutbol.com/mundiales/1974_resultados.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)

    data = []
    contenedor = soup.find_all('div', attrs={"class":"max-1 margen-b8 bb-2"})
    #print(contenedor)
    #seccion = contenedor.find_all('div', attrs={"class":"a-center"})
    #seccion.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados
    #print(seccion)
    
    for secc in contenedor:
        contenedor2 = secc.find_all('h3')
        Fecha = clean(contenedor2[0].get_text().strip())

        newContenedor = secc.find_all('div', attrs={"class":"margen-t3 clearfix"})

        for b in newContenedor:


            contenedor3 = b.find_all('div', attrs={"class":"left a-left wpx-170"})
            Etapa = clean(contenedor3[0].get_text().strip())

            contenedor4 = b.find_all('div', attrs={"class":"left margen-b2 clearfix"})
            Equipo1 = clean(contenedor4[0].get_text().strip())

            contenedor5 = b.find_all('div', attrs={"class":"left a-center margen-b3 clearfix"})
            Resultado = clean(contenedor5[0].get_text().strip())
            
            contenedor6 = b.find_all('div', attrs={"class":"left a-left margen-b2 clearfix"})
            Equipo2 = clean(contenedor6[0].get_text().strip())
            
            aux = contenedor5[0].find_all('div', attrs={'class':'left'})
            for i in aux:
                a  = i.find_all('a', href=True)
                if len(a)> 0:
                    for links in a :
                        link2 = re.sub("/mundiales","/"+links['href'],'https://www.losmundialesdefutbol.com/mundiales')
                        data.append([mundial,link2,Etapa,Resultado,Equipo1,Equipo2,Fecha])


        

    return data
    #print(data)

#TResultados('mundial','https://www.losmundialesdefutbol.com/mundiales/1974_resultados.php')
