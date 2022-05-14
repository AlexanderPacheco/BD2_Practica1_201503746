show databases      //mostrar todas las bd
db                  //mostrar la bd actual
use bd2             //usa la bd bd2
show collections    //mostrar todas las colecciones

var users = [
    {
        username: "user1",              //documento "user1"
        email : "user1@gmail.com",
        status : "active"
    },
    {
        username: "user2",              //documento "user2"
        email : "user2@gmail.com",
        status : "inactive"
    },
    {
        username: "user3",
        email : "user3@gmail.com",
        status : "active"
    },
    {
        username: "user4",
        email : "user4@gmail.com",
        status : "inactive"
    },
    {
        username: "user5",
        email : "user5@gmail.com",
        status : "active"
    }
]

db.users.insert(users);     //Inserta la coleccion anterior "users", solo debuelve el BuidWriteResult

db.users.find();            //Trae todos los documentos de la coleccion "users"

db.users.find(//Cursor
    {
        username:"user1"
    }

);


db.users.findOne(//Documento
    {
        username:"user1",
        email:"user"
    }
)


db.users.insertOne(     //Inserta pero devuelve el ID de la Incercion
    
        {
            username: "user90",
            email : "user90@gmail.com",
            status : "active"
        }
    
)

var users2 = [
    {
        username: "user6",
        email : "user6@gmail.com",
        status : "active"
    },
    {
        username: "user7",
        email : "user7@gmail.com",
        status : "inactive"
    },
    {
        username: "user8",
        email : "user8@gmail.com",
        status : "active"
    },
    {
        username: "user9",
        email : "user9@gmail.com",
        status : "inactive"
    },
    {
        username: "user10",
        email : "user10@gmail.com",
        status : "active"
    }
]



db.users.insertMany(users2);        //Incertar varios y devuelve el ID de incercion



db.users.save(              //Incerta pero verifica si el documento existe, si existe lo actualiza y si no existe lo crea
    {
        username: "user100",
        email : "user10@gmail.com",
        status : "active"
    }
)



var users3 = [
    {
        username: "user11",
        email : "user11@gmail.com",
        status : "active",
        age: 25
    },
    {
        username: "user12",
        email : "user12@gmail.com",
        status : "inactive",
        age: 41
    },
    {
        username: "user13",
        email : "user13@gmail.com",
        status : "active",
        age: 15
    },
    {
        username: "user14",
        email : "user14@gmail.com",
        status : "inactive",
        age:36
    },
    {
        username: "user15",
        email : "user15@gmail.com",
        status : "active",
        age:54
    }
]



/**
 * > : $gt 
 * >= : $gte
 * < : $lt
 * <= : $lte
 * != : ne
 */


db.users.find(
    {
        age:{$gt:25}
    }
);



db.users.find(
    {
        $or:[
            {age:15},
            {age:36},
            {age:54},
            
        ]
    }

);


db.users.find(
    {
        age:{$in:[15,36,54]}
    }
)


db.users.find(
    {
        age:{$in:[15,36,54]}
    }
).sort(
    {
        age:-1
    }
)


db.users.insert(
    [
    {  
        username: "yimmi",
        email : "yimmi@outlook.net",
        status : "active",
        age:24
    }      ]
)



db.users.find(
    {
        email : /^user/
    }
)

db.users.find(
    {
        age:{$exists:true}
    },
    {
        username: true,
        email: true
    }
)

/**
 * 624888e9262fb5480cfadfc1
 * 1. timestamp
 * 2. Identificador
 * 3: PID
 * 4: Autoincrement
 */





//UPDATE





db.users.update(
    {
       "_id": ObjectId("624888e9262fb5480cfadfc1")
    },
    {
        $set:{
            username:"cambio"
        }
    }
)


db.users.update(
    {

    },
    {
        $unset:{
            status:false
        }
    },
    {
        multi:true
    }

)


db.users.remove({
    username:"yimmi"
})


db.user.drop()
db.dropDatabase()


db.users.insert(
    [{
        username: "user160",
        email : "user160@gmail.com",
        status : "active",
        age: 26,
        location:{
            departamento:"Guatemala",
            municipio:"Mixco",
        }
    }]
)


db.users.find(
    {
        "location.municipio":"Mixco"
    }
)








var blog = {

    fecha:"26/08/22",
    contenido: "Lorem",
    user:{
        username:"yimmirp"
    },
    comments:[
        {},{},{}
    ]
}


var user = {
    username:"yimmirp",
    dob: "26/02",
    email: "yimmis@email.com"
}






























