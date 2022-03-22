USE practica1;
GO
--CREATE PROCEDURE TR3
ALTER PROCEDURE TR3
    @email          VARCHAR(50),
    @codCourse      INTEGER
AS
BEGIN
    DECLARE @idStudent VARCHAR(50)
    DECLARE @activo bit = 0
    DECLARE @creditsStudent INTEGER = 0
    DECLARE @creditsCourse INTEGER = 0
    DECLARE @idTutor VARCHAR(50)

    BEGIN TRY

        BEGIN TRANSACTION
            PRINT N'Verificando que exista el usuario...'
            SELECT @idStudent=Id, @activo=EmailConfirmed FROM practica1.Usuarios WHERE Email=@email

            IF @idStudent IS NOT NULL BEGIN
                IF @activo = 1 BEGIN

                    PRINT N'Verificando creditos estudiante...'
                    --SELECT @creditsStudent=Credits FROM practica1.ProfileStudent WHERE UserId=@idStudent
                    SELECT @creditsStudent=pf.Credits FROM practica1.ProfileStudent AS pf WHERE pf.UserId=@idStudent

                    SELECT @creditsCourse=cur.CreditsRequired, @idTutor=tut.TutorId FROM practica1.Course AS cur
                        INNER JOIN practica1.CourseTutor AS tut
                            ON cur.CodCourse=tut.CourseCodCourse
                        WHERE cur.CodCourse=@codCourse

                    IF @creditsStudent >= @creditsCourse BEGIN

                        PRINT N'El estudiante si cumple con la contidad de creditos...'
                        INSERT INTO practica1.CourseAssignment(StudentId, CourseCodCourse)
                            VALUES (@idStudent, @codCourse)

                        PRINT N'Se notifico al estudiante...'
                        INSERT INTO practica1.Notification(UserId, Message, Date)
                            VALUES(@idStudent, 'Se asigno al curso exitosamente.', GETDATE())

                        PRINT N'Se notifico al tutor...'
                        INSERT INTO practica1.Notification(UserId, Message, Date)
                            VALUES(@idTutor, 'Se asigno un nuevo usuario a su curso.', GETDATE())

                    END
                    ELSE BEGIN
                        PRINT N'[Error] El estudiante no cumple con la cantidad de creditos...'
                    END


                END
                ELSE BEGIN
                    PRINT N'[Error] Usuario no activo...'
                END
            END
            ELSE BEGIN
                PRINT N'[Error] Usuario no existe...'
            END

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        PRINT N'[Error] Transacción falló...'
        ROLLBACK TRANSACTION

    END CATCH
END

--CourseAssignment
--Notification