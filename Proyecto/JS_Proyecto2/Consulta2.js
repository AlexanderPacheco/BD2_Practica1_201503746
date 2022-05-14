
function C2 (pais){
    console.log("Anio de Mundiales en los que gano el pais de " + pais);
    db.Posiciones_Finales.find(                             
        {
            $and:[
                {Posición:"1"},
                {Selección:pais}
            ]       
        }
    
    ).forEach(valor => console.log(valor.Mundial + " Campeon: "+ valor.Selección));
    
    console.log("Lista de Mundiales en los que participo el pais de " + pais);
    db.Posiciones_Finales.find(                             
        {
            Selección:pais
        }
    ).forEach(valor => console.log(valor.Mundial));

    console.log("Cantidad de Mundiales en los que participo " + pais);
    const va0 = db.Posiciones_Finales.find(                             
        {
            Selección:pais
        }
    
    ).count();
    console.log(va0);

    console.log("Lista de partidos en los que participo el pais de " + pais);
    db.TResultados_Partido.find(                             
        {
            $or:[
                {Equipo1:pais},
                {Equipo2:pais}
            ]
        }
    ).forEach(valor => console.log(valor.Mundia + " Etapa: "+ valor.Etapa + " Resultado: "+ valor.Resultado));
}












