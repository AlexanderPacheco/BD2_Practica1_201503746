USE practica1;
GO
--CREATE PROCEDURE Transaccion0
ALTER PROCEDURE Transaccion0
    @CodCourse int
AS
BEGIN
    SELECT * FROM practica1.Course where CodCourse=@CodCourse
    Print('Si funciono el print!!')
END