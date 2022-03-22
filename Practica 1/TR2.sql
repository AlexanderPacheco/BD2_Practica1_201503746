USE practica1;
GO
--CREATE PROCEDURE TR2
ALTER PROCEDURE TR2
    @email          VARCHAR(50),
    @codCourse      INTEGER
AS
BEGIN
    --PRINT 'MENSAJE'+CAST(ERROR_LINE() AS VARCHAR(10))
    DECLARE @idUser VARCHAR(50)
    DECLARE @activo bit = 0
    DECLARE @idRolTutor VARCHAR(50)
    DECLARE @tutorCode VARCHAR(50)

    BEGIN TRY

        BEGIN TRANSACTION
            PRINT N'Verificando que exista el usuario...'
            SELECT @idUser=Id, @activo=EmailConfirmed FROM practica1.Usuarios WHERE Email=@email

            IF @idUser IS NOT NULL BEGIN
                IF @activo = 1 BEGIN

                    PRINT N'Rol de tutor asignado...'
                    SELECT @idRolTutor=Id FROM practica1.Roles WHERE RoleName='Tutor'
                    INSERT INTO practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
                        VALUES (@idRolTutor, @idUser, 1)

                    PRINT N'Perfil de tutor creado...'
                    SELECT @tutorCode=Id FROM practica1.UsuarioRole WHERE RoleId=@idRolTutor AND UserId=@idUser
                    INSERT INTO practica1.TutorProfile(UserId, TutorCode)
                        VALUES (@idUser, @tutorCode)

                    PRINT N'Asignando su curso...'

                    IF (SELECT COUNT(*) FROM practica1.CourseTutor WHERE TutorId=@idUser) < 1 BEGIN
                        PRINT N'Se asigno el tutor al curso...'
                        INSERT INTO practica1.CourseTutor(TutorId, CourseCodCourse)
                        VALUES (@idUser, @codCourse)
                    END
                    ELSE BEGIN
                        PRINT N'Actualmente ya tiene asignado este curso...'
                    END

                    PRINT N'Se realizo la notificación...'
                    INSERT INTO practica1.Notification(UserId, Message, Date)
                        VALUES(@idUser, 'Se asigno el perfil tutor al usuario.', GETDATE())

                    PRINT N'Creando registro log...'
                    INSERT INTO practica1.HistoryLog(Date, Description)
                        VALUES (GETDATE(), 'Transaccion TR2() finalizo con exito')
                END
                ELSE BEGIN
                    PRINT N'[Error] Usuario no activo...'
                    INSERT INTO practica1.HistoryLog(Date, Description)
                        VALUES (GETDATE(), 'Transaccion TR2() fallo, usuario no activo')
                END
            END
            ELSE BEGIN
                PRINT N'[Error] Usuario no existe...'
                INSERT INTO practica1.HistoryLog(Date, Description)
                        VALUES (GETDATE(), 'Transaccion TR2() fallo, usuario no existe')
            END

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        PRINT N'[Error] Transacción falló...'
        --INSERT INTO practica1.HistoryLog(Date, Description)
        --        VALUES (GETDATE(), 'Transaccion TR2( ' + @email + ',' + @codCourse + ') fallo')
        ROLLBACK TRANSACTION

    END CATCH
END