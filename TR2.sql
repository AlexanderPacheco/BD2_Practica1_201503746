USE practica1;
GO
--CREATE PROCEDURE TR2
ALTER PROCEDURE TR2
    @email          VARCHAR(50),
    @codCourse      INTEGER
AS
    SELECT * FROM practica1.Course;
GO