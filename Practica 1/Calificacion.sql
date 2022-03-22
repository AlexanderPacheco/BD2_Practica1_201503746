
EXEC TR1 'Yimmi','Pernillo','yimmiss305@gmail.com','!Admin123','50'
EXEC TR1 'Andrea','Rojas','arojas@gmail.com','!Admin123','20'

EXEC TR2 'yimmiss305@gmail.com','964'

EXEC TR3 'arojas@gmail.com','964'
EXEC TR3 'arojas@gmail.com','775'


UPDATE practica1.Usuarios set EmailConfirmed=1 where Email='arojas@gmail.com'
UPDATE practica1.Usuarios set EmailConfirmed=1 where Email='yimmiss305@gmail.com'

select * from practica1.Usuarios;
select * from practica1.TFA;
select (select Email from practica1.Usuarios where Id=RU.UserId) as Email,
	   (select RoleName from practica1.Roles where Id=RU.RoleId) as Role from practica1.UsuarioRole as RU;
select * from practica1.ProfileStudent;
select * from practica1.TutorProfile;
select * from practica1.Notification;
select * from practica1.CourseTutor;
select (select Email from practica1.Usuarios where Id=CA.StudentId) as Email,
		(select Name from practica1.Course where CodCourse=CA.CourseCodCourse) as Curso
		from practica1.CourseAssignment as CA;
select * from practica1.Course order by CreditsRequired
select * from practica1.HistoryLog
