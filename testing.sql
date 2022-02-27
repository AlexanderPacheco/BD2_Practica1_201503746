USE practica1
SELECT * FROM practica1.Course;
SELECT * FROM practica1.CourseAssignment;
SELECT * FROM practica1.CourseTutor;
SELECT * FROM practica1.HistoryLog;
SELECT * FROM practica1.Notification;
SELECT * FROM practica1.ProfileStudent;
SELECT * FROM practica1.Roles;
SELECT * FROM practica1.TFA;
SELECT * FROM practica1.TutorProfile;
SELECT * FROM practica1.UsuarioRole;
SELECT * FROM practica1.Usuarios;

EXEC Transaccion0
    @CodCourse=775;

EXEC TR1
    @firstname      = 'Alex',
    @lastname       = 'Ixvalan',
    @email          = 'alex04@gmail.com',
    @password       = 'alex123',
    @credits        = 236;

DELETE FROM practica1.UsuarioRole
SELECT * FROM practica1.Usuarios
SELECT * FROM practica1.Usuariorole
SELECT * FROM practica1.ProfileStudent
SELECT * FROM practica1.TFA
SELECT * FROM practica1.Notification

SELECT * FROM practica1.Roles;

DESCRIBE practica1.Usuarios;

EXEC TR2
    @email          = 'alex6@gmail.com',
    @codCourse      = 1;

SELECT * FROM practica1.UsuarioRole
SELECT * FROM practica1.TutorProfile
SELECT * FROM practica1.CourseTutor
SELECT * FROM practica1.Notification

EXEC TR3
    @email          = 'alex@gmail.com',
    @codCourse      = 1;