use Proyecto_Fase2;
db.TResultados_Partido.find();

db.TResultados_Partido.find();
db.TResultados_Partido.find().count();
db.TResultados_Partido.find().pretty();
db.TResultados_Partido.find().limit(5).pretty();        //tambien esta el sort

db.Posiciones_Finales.find().pretty();

function C1 (anio,pais){
    const nameM = "Mundial " + anio;

    console.log("#############################################################################");
    console.log("############## Cantidad de cambios realizados en " + nameM + " ##############");
    console.log("#############################################################################");
    const va0 = db.Cambios_Partido.find(                             
        {
            Mundial:nameM
        }
    
    ).count();
    console.log("Se realizaron "+va0+" cambios en todo el mundial");
    console.log("##########################################################");
    console.log("############## Goleadores del " + nameM + " ##############");
    console.log("##########################################################");
    db.Goleadores_Mundiales.find(                             
        {
            $and:[
                {Posicion:{$in:["1","2","3","4","5","6","1 ","2 ","3 ","4 ","5 ","6 "]}},
                {Mundial:nameM}
            ]       
        }
    
    ).forEach(valor => console.log(valor.Mundial + " Jugador " + valor.Posicion + ": "+ valor.Jugador + " hizo "+ valor.Goles + " goles y jugo "+valor.Partidos+" partidos, de la selección " + valor.Selección));

    console.log("###############################################################");
    console.log("############## Mejores equipos del " + nameM + " ##############");
    console.log("###############################################################");
    db.Posiciones_Finales.find(                             
        {
            $and:[
                {Posición:{$in:["1","2","3","4","5","1 ","2 ","3 ","4 ","5 "]}},
                {Mundial:nameM}
            ]       
        }
    
    ).forEach(valor => console.log(valor.Mundial + ": Equipo " + valor.Selección + " quedo en "+ valor.Posición + " lugar con " + valor.PTS + " puntos, " + valor.GF + " goles"));

    console.log("###############################################################");
    console.log("################## Premios del " + nameM + " #################");
    console.log("###############################################################");
    db.Premios_Mundiales.find(                             
        {
            $and:[
                {Mundial:nameM},
                {Pais:{$ne:"-"}} /* != : ne */
            ]       
        }
    
    ).forEach(valor => console.log(valor.Mundial + ": " + valor.Jugador + " gano el premio "+ valor.Premio + " ("+ valor.Pais +")" ));

    console.log("###########################################################################");
    console.log("################## "+ pais +": Partidos del " + nameM + " #################");
    console.log("###########################################################################");
    db.TResultados_Partido.find(                             
        {
            $and:[
                {Mundia:nameM},
                {$or:[
                    {Equipo1:pais},
                    {Equipo2:pais}
                ]}
            ]       
        }
    
    ).forEach(valor => console.log(valor.Mundia + ": " + valor.Equipo1 + " vs "+ valor.Equipo2 + " >>> ("+ valor.Resultado +")" ));

    console.log("###########################################################################");
    console.log("################## Tarjetas del " + nameM + " #################");
    console.log("###########################################################################");
    const cantAmarilla = db.Tarjetas_Partido.find(                             
        {
            $and:[
                {Mundia:nameM},
                {Tarjeta:"amarilla"}
            ]      
        }
    
    ).count();
    console.log(nameM + ": hubo " + cantAmarilla + " tarjetas amarillas ")

    const cantRoja = db.Tarjetas_Partido.find(                             
        {
            $and:[
                {Mundia:nameM},
                {Tarjeta:"Roja"}
            ]      
        }
    
    ).count();
    console.log(nameM + ": hubo " + cantRoja + " tarjetas rojas ")
}

/* CONSULTAS 
C1(2018);
C1(2010);
C1(2010,"España");
C1(2010,"Holanda");
*/