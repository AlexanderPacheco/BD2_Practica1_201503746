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

    DECLARE @existMail INTEGER
    --SELECT @existMail=COUNT(*) FROM practica1.Usuarios WHERE Email=@email;

    IF (SELECT COUNT(*) FROM practica1.Usuarios WHERE Email=@email) < 1 BEGIN
        DECLARE @idUser VARCHAR(50) = NEWID()
        PRINT N'Guardando usuario...'
        INSERT INTO practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
        VALUES(@idUser, @firstname, @lastname, @email, GETDATE(), @password, GETDATE(), 0)
        PRINT N'Guardando rol...'
        INSERT INTO practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
        VALUES ('F4E6D8FB-DF45-4C91-9794-38E043FD5ACD', @idUser, 1)
    END
    ELSE BEGIN
        PRINT N'[Error] Email ya registrado...'
    END
END
        -- Usuarios
        -- Usuariorole  --Revisar IsLatestVersion
        -- ProfileStudent
        -- TFA
        -- Notification


        --COMMIT TRANSACTION;
        --SAVE TRANSACTION ProcedureSave;
    --ELSE
    --    ROLLBACK TRANSACTION ProcedureSave;
    --    Print ('El email insertado ya existe...');
