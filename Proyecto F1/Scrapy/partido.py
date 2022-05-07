from bs4 import BeautifulSoup
import requests
import re
from jugador import JugadorFind

def clean(val):
    characters = ".\n\t\r"
    string = re.sub("\r|\n|\t|\.|\ ","",val)
    return string
def clean2(val):
    string = re.sub("\r|\n|\t|\.","",val)
    return string

def changeName(val):
    if (len(val) == 1):
        return val[0]
    return val[1]+'_'+val[0]

def Partido(mundial, link):
    #r = requests.get('https://www.losmundialesdefutbol.com/mundiales/1982_premios.php')
    r = requests.get(link)
    soup = BeautifulSoup(r.text, 'lxml')

    print(soup.title.text)
    alineaciones =[]
    tarjetas = []
    cambios = []
    tables = soup.find_all('table', attrs={"class":"a-center"})

    paises = []
    contador2 = 0
    for table in tables:
        rows = table.find_all('tr')
        for row in rows:
            cols = row.find_all('td')
            if contador2 == 0 :
                paises.append(clean(cols[0].get_text()))
                break

    # for table in tables:
    #     rows = table.find_all('tr')
    #     contador = 0
    #     estado = ''
    #     for row in rows:
    #         cols = row.find_all('td')
    #         if contador == 2:
    #             if row["class"][0] == "bt" :
    #                     estado = cols[2].get_text()
    #                     continue
    #         if len(cols)>1 and contador != 0 and contador != 1 and contador!=2 :
    #             try:
    #                 if row["class"][0] == "bt" :
    #                     estado = cols[2].get_text()
    #                     continue
    #                 Pos  = cols[0].get_text()
    #                 Camiseta  = cols[1].get_text()
    #                 JugadorO = cols[2]
    #                 Nombre = JugadorO.find_all('a', href=True)
    #                # print(Nombre[0].get_text() + " -> "+estado + " -> "+Nombre[0]['href'])
    #                 alineaciones.append([mundial,paises[0], paises[1], link, clean(Pos), clean(Camiseta),  clean(estado), Nombre[0].get_text().strip(),Nombre[0]['href'],])

    #                 #linkJugador = re.sub("/jugadores","/"+Nombre[0]['href'],'https://www.losmundialesdefutbol.com/jugadores')
                    
    #               #  print("\t\tMinando >> ",linkJugador)
    #                 #resJug = JugadorFind(mundial, linkJugador,  Nombre[0].get_text(), pais)
    #               #  print(resJug)
    #             except:
    #                 continue
    #         contador += 1
    

    tables = soup.find_all('table', attrs={"class":"a-left bb-2"})
    contadorTabla = 0
    
    for table in tables:
        rows = table.find_all('tr')

        pais  =''
        if contadorTabla == 0  and len(tables) == 2:
            rows.pop(0) #Eliminamos el primer item que contiene los nombres de los encabezados
            for row in rows:
                cols = row.find_all('td')
                
                if len(cols)>1 :
                    try:
                        # if row["class"][0] == "bt" :
                        #     estado = cols[2].get_text()
                        #     continue
                        Pais = cols[0].get_text()
                        Jugador = changeName(cols[1].get_text().strip().split(' '))
                        MinutoTarjeta =  clean2(cols[2].get_text()).split(' ')
                        tarjetas.append([mundial,paises[0], paises[1], link, clean(Pais), Jugador, MinutoTarjeta[2], MinutoTarjeta[1]])
                        #print(Pais +" "+clean(Jugador)+" "+clean(Tarjeta))
                    except:
                        print("ENTRENADOR X")
                    #data.append([mundial,clean(Posicion),clean(Seleccion),Etapa,PTS,PJ,PG,PE,PP,GF,GC,Dif])
        else:
            for row in rows:
                cols = row.find_all('td')
                if row["class"][0] == "bt-2" :
                    pais = cols[0].get_text()
                    #print(pais)
                    continue
                if len(cols)>1 :
                    try:
                        Minuto = cols[0].get_text()
                        Ingreso = changeName(cols[2].get_text().strip().split(' '))
                        Salio = changeName(cols[4].get_text().strip().split(' '))
                    # print(clean(Minuto) +" "+Ingreso+" -> "+Salio)
                    
                        cambios.append([mundial,paises[0], paises[1],link,clean(pais),clean(Minuto),Ingreso,Salio])
                    except:
                        Pais = cols[0].get_text()
                        Jugador = changeName(cols[1].get_text().strip().split(' '))
                        MinutoTarjeta =  clean2(cols[2].get_text()).split(' ')
                        tarjetas.append([mundial,paises[0], paises[1], link, clean(Pais), Jugador, MinutoTarjeta[2], MinutoTarjeta[1]])

        contadorTabla +=1

    data = []
    data.append(alineaciones)
    data.append(tarjetas)
    data.append(cambios)
    return data
    #print(data)

#Premios('mundial','https://www.losmundialesdefutbol.com/mundiales/1998_premios.php')
