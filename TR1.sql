USE practica1;
GO
--CREATE PROCEDURE TR1
ALTER PROCEDURE TR1
    @firstname      VARCHAR(50),
    @lastname       VARCHAR(50),
    @email          VARCHAR(50),
    @password       VARCHAR(50),
    @credits        INTEGER
AS
BEGIN
    PRINT N'Validando email...'

    DECLARE @idRolStudent VARCHAR(50)

    IF (SELECT COUNT(*) FROM practica1.Usuarios WHERE Email=@email) < 1 BEGIN

        DECLARE @idUser VARCHAR(50) = NEWID()

        PRINT N'Guardando usuario...'
        INSERT INTO practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
            VALUES(@idUser, @firstname, @lastname, @email, GETDATE(), @password, GETDATE(), 0)

        PRINT N'Rol asignado con éxito...'
        SELECT @idRolStudent=Id FROM practica1.Roles WHERE RoleName='Student'
        INSERT INTO practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
            VALUES (@idRolStudent, @idUser, 1)

        PRINT N'Perfil creado con éxito...'
        INSERT INTO practica1.ProfileStudent(UserId, Credits)
            VALUES (@idUser, @credits)

        PRINT N'TFA aplicado...'
        INSERT INTO practica1.TFA(UserId, Status, LastUpdate)
            VALUES(@idUser, 1, GETDATE())

        PRINT N'Se realizo la notificación...'
        INSERT INTO practica1.Notification(UserId, Message, Date)
            VALUES(@idUser, 'Se creo el usuario', GETDATE())
    END
    ELSE BEGIN
        PRINT N'[Error] Email ya registrado...'
    END
END
        -- Usuarios
        -- Usuariorole  --Revisar IsLatestVersion
        -- SELECT * FROM practica1.ProfileStudent
        -- TFA
        -- Notification
