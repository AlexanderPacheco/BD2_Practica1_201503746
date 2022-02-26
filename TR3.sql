USE practica1;
GO
--CREATE PROCEDURE TR3
ALTER PROCEDURE TR3
    @email          VARCHAR(50),
    @codCourse      INTEGER
AS
    SELECT * FROM practica1.CourseAssignment;
GO