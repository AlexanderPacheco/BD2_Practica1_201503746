function C3 (jugador){
    const player = db.Jugador.findOne(                             
        {
            Nombre:jugador 
        }
    
    )
    console.log("%%%%%%%%%% "+jugador+" - "+player.seleccion+" %%%%%%%%%%%")

    console.log("********* Informacion general ***********")
    console.log("Fecha Nacimiento: "+player.FechaNac)
    console.log("Lugar nacimiento: "+player.LugarNac)
    console.log("Posicion: "+player.Posicion)
    console.log("Numero de Camisetas: "+player.NoCamiseta)
    console.log("Altura: "+player.altura)
    console.log("Apodo: "+player.apodo)
    console.log("Web: "+player.web)

    console.log(" ")
    console.log(" ")
    console.log(" $$$$$$$$$$ Historial de Goles $$$$$$$$$$")

    db.Goleadores_Mundiales.find(
        {
            link: player.Link
        }
    ).forEach(dato => {
        console.log(" "+dato.Mundial +" Goles: "+dato.Goles+" Partidos: "+dato.Partidos
            +" Promedio :"+dato.PromedioGol+" Posicion: "+dato.Posicion)
    })


    console.log(" ")
    console.log(" ")
    console.log(" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Premios Obtenidos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    db.Premios_Mundiales.find(
        {
            Link:  player.Link
        }
    ).forEach(dato => {
        console.log("  "+dato.Mundial+ ",  Premio: " +dato.Premio)
    })
    
    console.log(" ")
    console.log(" ")
    console.log(" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Historial de Tarjetas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    
    db.Tarjetas_Partido.find(
        {
            Jugador: player.Nombre
        }
    ).forEach(dato => {
        console.log(" "+dato.Mundia + ",  Tarjeta: "+dato.Tarjeta + ",  Minuto: "+dato.minuto
        + ", Partido: "+dato.local +" - "+dato.visitante)
    })

    console.log(" ")
    console.log(" ")
    console.log(" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Historico Partidos Jugados %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
   
    db.Jugadores_Partido.find(
        {
            linkJugador: player.Link
        }
    ).forEach(dato => {
        console.log(" "+dato.Mundial + " Partido: "+dato.local +" - "+dato.visitante + " Posicion: "+dato.Pos
        +" Estado: "+dato.Estado + " No. Camiseta: "+dato.Camiseta)
    })

    console.log(" ")
    console.log(" ")
    console.log(" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Historial de Cambios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
   
    db.Cambios_Partido.find(
        {
            $or:[
                {Sale:player.Nombre},
                {Entra:player.Nombre}
            ]  
        }
    ).forEach(dato => {
        console.log(" "+dato.Mundial + " Minuto: "+dato.Minuto.replace('Minuto','') + " Entro: "+dato.Entra
        +" Sale: "+dato.Sale + " Local: "+ dato.local +" Visitante: "+dato.visitante)
    })
}