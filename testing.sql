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
    @email          = 'alekson@gmail.com',
    @password       = 'alex123',
    @credits        = 25;

DELETE FROM practica1.UsuarioRole
SELECT * FROM practica1.Usuarios
SELECT * FROM practica1.Usuariorole
SELECT * FROM practica1.ProfileStudent
SELECT * FROM practica1.TFA
SELECT * FROM practica1.Notification

SELECT * FROM practica1.Roles;

DESCRIBE practica1.Usuarios;

EXEC TR2
    @email          = 'alekson@gmail.com',
    @codCourse      = 970;  970 964 283 772

UPDATE practica1.Usuarios
SET EmailConfirmed=1
WHERE Email='alekson@gmail.com';

SELECT * FROM practica1.HistoryLog;

SELECT * FROM practica1.UsuarioRole
SELECT * FROM practica1.TutorProfile
SELECT * FROM practica1.CourseTutor
SELECT * FROM practica1.Notification
SELECT * FROM practica1.Course

EXEC TR3
    @email          = 'alekson@gmail.com',
    @codCourse      = 1;

SELECT * FROM practica1.CourseAssignment
SELECT * FROM practica1.Notification
SELECT * FROM  practica1.ProfileStudent
SELECT * FROM  practica1.CourseTutor
SELECT * FROM practica1.Course AS cur
    INNER JOIN practica1.CourseTutor AS tut ON cur.CodCourse=tut.CourseCodCourse WHERE cur.CodCourse=970;


SELECT COUNT(*) FROM practica1.CourseTutor WHERE TutorId=TutorId