--Indexes
--1. Indeksy dla kluczy obcych  -- Indeksy dla kluczy obcych w tabeli Translators 
CREATE INDEX idx_translators_employee ON dbo.Translators(EmployeeID); 
CREATE INDEX idx_translators_language ON dbo.Translators(LanguageID); -- Indeksy dla kluczy obcych w tabeli StudentCourses 
CREATE INDEX idx_student_courses_student ON dbo.StudentCourses(StudentID); 
CREATE INDEX idx_student_courses_course ON dbo.StudentCourses(CourseID); -- Indeksy dla kluczy obcych w tabeli CourseModules 
CREATE INDEX idx_course_modules_course ON dbo.CourseModules(CourseID); 
CREATE INDEX idx_course_modules_language ON dbo.CourseModules(LanguageID); 
CREATE INDEX idx_course_modules_module ON dbo.CourseModules(ModuleID); -- Indeksy dla kluczy obcych w tabeli Courses 
CREATE INDEX idx_courses_coordinator ON dbo.Courses(CourseCoordinatorID); -- Indeksy dla kluczy obcych w tabeli Employees 
CREATE INDEX idx_employees_type ON dbo.Employees(EmployeeType); -- Indeksy dla kluczy obcych w tabeli OrderedCourses 
CREATE INDEX idx_ordered_courses_details ON dbo.OrderedCourses(OrderDetailsID); 
CREATE INDEX idx_ordered_courses_course ON dbo.OrderedCourses(CourseID); -- Indeksy dla kluczy obcych w tabeli OrderedStudies 
CREATE INDEX idx_ordered_studies_details ON dbo.OrderedStudies(OrderDetailsID); 
CREATE INDEX idx_ordered_studies_studies ON dbo.OrderedStudies(StudiesID); -- Indeksy dla kluczy obcych w tabeli OrderedStudyMeetings 
CREATE INDEX idx_ordered_meetings_details ON dbo.OrderedStudyMeetings(OrderDetailsID); 
CREATE INDEX idx_ordered_meetings_meeting ON dbo.OrderedStudyMeetings(StudyMeetingID); -- Indeksy dla kluczy obcych w tabeli OrderedWebinars 
CREATE INDEX idx_ordered_webinars_details ON dbo.OrderedWebinars(OrderDetailsID); 
CREATE INDEX idx_ordered_webinars_webinar ON dbo.OrderedWebinars(WebinarID); -- Indeksy dla kluczy obcych w tabeli Orders 
CREATE INDEX idx_orders_student ON dbo.Orders(StudentID); -- Indeksy dla kluczy obcych w tabeli StudiesFinalGrades 
CREATE INDEX idx_studies_grades_student ON dbo.StudiesFinalGrades(StudentID); 
CREATE INDEX idx_studies_grades_studies ON dbo.StudiesFinalGrades(StudiesGradeID); -- Indeksy dla kluczy obcych w tabeli Studies 
CREATE INDEX idx_studies_coordinator ON dbo.Studies(StudiesCoordinator); -- Indeksy dla kluczy obcych w tabeli StudyMeeting 
CREATE INDEX idx_study_meeting_teacher ON dbo.StudyMeeting(TeacherID); 
CREATE INDEX idx_study_meeting_language ON dbo.StudyMeeting(LanguageID); 
CREATE INDEX idx_study_meeting_translator ON dbo.StudyMeeting(TranslatorID); 
CREATE INDEX idx_study_meeting_subject ON dbo.StudyMeeting(SubjectID); 
CREATE INDEX idx_study_meeting_congress ON dbo.StudyMeeting(StudyCongressID); -- Indeksy dla kluczy obcych w tabeli Subjects 
CREATE INDEX idx_subjects_coordinator ON dbo.Subjects(CoordinatorID); 
CREATE INDEX idx_subjects_studies ON dbo.Subjects(StudiesID); -- Indeksy dla kluczy obcych w tabeli StudentWebinars 
CREATE INDEX idx_student_webinars_student ON dbo.StudentWebinars(StudentID); 
CREATE INDEX idx_student_webinars_webinar ON dbo.StudentWebinars(WebinarID); -- Indeksy dla kluczy obcych w tabeli Webinars 
CREATE INDEX idx_webinars_teacher ON dbo.Webinars(TeacherID); 
CREATE INDEX idx_webinars_translator ON dbo.Webinars(TranslatorID); 
CREATE INDEX idx_webinars_language ON dbo.Webinars(LanguageID); 

-- Indeksy dla kluczy obcych w tabeli Internships 
CREATE INDEX idx_internships_student ON dbo.Internships(StudentID); 
CREATE INDEX idx_internships_studies ON dbo.Internships(StudiesID); -- Indeksy dla kluczy obcych w tabeli StudentMeetingAttendance 
CREATE INDEX idx_meeting_attendance_student ON dbo.StudentMeetingAttendance(StudentID); 
CREATE INDEX idx_meeting_attendance_meeting ON dbo.StudentMeetingAttendance(MeetingID); -- Indeksy dla kluczy obcych w tabeli StudentModulesAttendance 
CREATE INDEX idx_modules_attendance_student ON dbo.StudentModulesAttendance(StudentID); 
CREATE INDEX idx_modules_attendance_module ON dbo.StudentModulesAttendance(ModuleID); -- Indeksy dla kluczy obcych w tabeli StudentSubjectGrades 
CREATE INDEX idx_subject_grades_student ON dbo.StudentSubjectGrades(StudentID); 
CREATE INDEX idx_subject_grades_subject ON dbo.StudentSubjectGrades(SubjectID); -- Indeksy dla kluczy obcych w tabeli SubjectStudentAttendance 
CREATE INDEX idx_subject_attendance_student ON dbo.SubjectStudentAttendance(StudentID); 
CREATE INDEX idx_subject_attendance_subject ON dbo.SubjectStudentAttendance(SubjectID); -- Indeksy dla kluczy obcych w tabeli StudyCongress 
CREATE INDEX idx_study_congress_studies ON dbo.StudyCongress(StudiesID); 



--2. Indeksy ram czasowych i cen 
-- Ramy czasowe modułu  
CREATE INDEX StudyModule_Time ON ModuleDetails (CourseDate, DurationTime) 
-- Ramy czasowe webinaru  
CREATE INDEX Webinar_Time ON Webinars (WebinarDate, DurationTime) – Czas trwania zjazdu  
CREATE INDEX CongressDuration ON StudyCongress(StartDate,EndDate) – Cena za webinar 
CREATE INDEX WebinarPrice ON Webinars(WebinarPrice) – Cena za Meeting 
CREATE INDEX StudyMeetingPrice ON StudyMeeting(MeetingPrice) – Cena za studia 
CREATE INDEX StudiesPrice ON Studies(StudiesFee) – Cena za Kurs 
CREATE INDEX CoursePrice ON Courses(CoursePrice) 

-- Permissions
-- Gość (Użytkownik niezarejestrowany) 
CREATE ROLE guest; 
GRANT EXECUTE ON AddStudent TO guest; 
GRANT SELECT ON FUTURE_EVENTS_STATS TO guest; 
GRANT SELECT ON FUTURE_WEBINAR_STATS TO guest; 
GRANT SELECT ON FUTURE_MODULE_STATS TO guest;

 -- Uczestnik kursu (student, uczestnik kursu, uczestnik webinaru, uczestnik spotkania studyjnego) 
CREATE ROLE student; 
GRANT guest TO student; 
GRANT EXECUTE ON AddStudentWebinar TO student; 
GRANT EXECUTE ON AddStudentCourse TO student; 
GRANT EXECUTE ON GetStudentOrders TO student; 
GRANT EXECUTE ON GetCourseAttendanceForStudent TO student; 
GRANT EXECUTE ON GetSubjectAttendanceForStudent TO student; 
GRANT EXECUTE ON AddOrder TO student; 
GRANT EXECUTE ON AddStudent to student; 
GRANT SELECT ON FUTURE_MEETINGS_STATS TO student; 
GRANT SELECT ON FUTURE_MODULE_STATS TO student; 
GRANT SELECT ON FUTURE_WEBINAR_STATS TO student; 
GRANT EXECUTE ON GetSubjectAttendanceForStudent TO student; 
GRANT EXECUTE ON GetOrderValue TO student; 
GRANT EXECUTE ON GetStudentAttendanceSummary TO student; 
GRANT EXECUTE ON GetStudentTimetable TO student; 
GRANT EXECUTE ON GetStudentTimetableFromDate TO student; 
GRANT EXECUTE ON CancelOrder TO student; 
GRANT EXECUTE ON GetFutureMeetingStats TO student; 
GRANT EXECUTE ON PayOrder TO student;

 -- Administrator 
CREATE ROLE admin;
 --GRANT ALL PRIVILEGES ON u_mwisniew.dbo to admin 
GRANT ALL PRIVILEGES ON ALL TABLES TO admin; 
GRANT EXECUTE ON ALL FUNCTIONS TO admin; 
GRANT EXECUTE ON ALL PROCEDURES TO admin;

 -- Dyrektor szkoły 
CREATE ROLE director; 
GRANT EXECUTE ON GetFinancialReport TO director; 
GRANT EXECUTE ON GetDetailedFinancialReport TO director; 
GRANT SELECT ON ATTENDANCE_LIST TO director; 
GRANT SELECT ON COMPLETED_EVENTS_ATTENDANCE TO director; 
GRANT SELECT ON COMPLETED_MODULES_ATTENDANCE TO director; 
GRANT SELECT ON COMPLETED_WEBINARS_ATTENDANCE TO director; 
GRANT SELECT ON STUDENT_DEBTORS TO director; 
GRANT SELECT ON FINANCIAL_REPORT TO director; 
GRANT SELECT ON COURSES_FINANCIAL_REPORT TO director; 
GRANT SELECT ON STUDIES_FINANCIAL_REPORT TO director; 
GRANT SELECT ON WEBINARS_FINANCIAL_REPORT TO director; 
GRANT SELECT ON FUTURE_MEETINGS_STATS TO director; 
GRANT SELECT ON FUTURE_MODULE_STATS TO director; 
GRANT SELECT ON FUTURE_WEBINAR_STATS TO director; 
GRANT SELECT ON FUTURE_EVENTS_STATS TO director; 
GRANT SELECT ON BILOCATION_LIST TO director; 
GRANT SELECT ON ORDERS_SUMMARY TO director; 
GRANT SELECT ON STUDENTS_STRUCTURE_VIEW TO director; 
GRANT EXECUTE ON AddWebinar TO director; 
GRANT EXECUTE ON AddEmployee TO director; 
GRANT EXECUTE ON AddStudent TO director; 
GRANT EXECUTE ON AddStudy TO director; 
GRANT EXECUTE ON AddCourse TO director; 
GRANT EXECUTE ON AddCourseModuleWithDetails TO director; 
GRANT EXECUTE ON AddLanguage TO director; 
GRANT EXECUTE ON AddInternship TO director; 
GRANT EXECUTE ON AddStudentWebinar TO director; 
GRANT EXECUTE ON AddStudentCourse TO director; 
GRANT EXECUTE ON RemoveStudentFromCourseAndWebinars TO director; 
GRANT EXECUTE ON GetStudentTimetable TO director; 
GRANT EXECUTE ON GetStudentTimetableFromDate TO director; 
GRANT EXECUTE ON CancelOrder TO director; 
GRANT EXECUTE ON GetFutureMeetingStats TO director; 

-- Koordynator kursu 
CREATE ROLE course_coordinator; 
GRANT EXECUTE ON AddCourse TO course_coordinator; 
GRANT EXECUTE ON AddCourseModule TO course_coordinator; 
GRANT EXECUTE ON AddModuleDetail TO course_coordinator; 
GRANT SELECT ON COMPLETED_MODULES_ATTENDANCE TO course_coordinator; 
GRANT SELECT ON FUTURE_MODULE_STATS TO course_coordinator; 
GRANT EXECUTE ON GetCourseAttendanceForStudent TO course_coordinator; 
GRANT EXECUTE ON GetStudentAttendanceSummary TO course_coordinator;

 -- Koordynator studiów 
CREATE ROLE studies_coordinator; 
GRANT EXECUTE ON AddStudy TO studies_coordinator; 
GRANT EXECUTE ON AddStudyMeeting TO studies_coordinator; 
GRANT SELECT ON STUDIES_STRUCTURE_VIEW TO studies_coordinator; 
GRANT SELECT ON COMPLETED_STUDY_MEETINGS_ATTENDANCE TO studies_coordinator; 
GRANT SELECT ON FUTURE_MEETINGS_STATS TO studies_coordinator; 
GRANT EXECUTE GetSubjectAttendanceForStudent TO studies_coordinator; 
GRANT EXECUTE AddStudentMeetingAttendance TO studies_coordinator; 
GRANT EXECUTE AddStudentSubjectGrade TO studies_coordinator; 
GRANT EXECUTE AddStudyMeeting TO studies_coordinator;

 -- Wykładowca 
CREATE ROLE lecturer; 
GRANT EXECUTE ON AddWebinar TO lecturer; 
GRANT SELECT ON ATTENDANCE_LIST TO lecturer; 
GRANT SELECT ON COMPLETED_WEBINARS_ATTENDANCE TO lecturer; 
GRANT SELECT ON COMPLETED_MODULES_ATTENDANCE TO lecturer; 
GRANT EXECUTE ON AddStudentSubjectGrade TO lecturer; 
GRANT SELECT ON FUTURE_MEETINGS_STATS TO lecturer; 
GRANT SELECT ON FUTURE_WEBINAR_STATS TO lecturer; 
GRANT EXECUTE GetSubjectAttendanceForStudent TO lecturer; 
GRANT EXECUTE AddStudentMeetingAttendance TO lecturer; 
GRANT EXECUTE AddStudentSubjectGrade TO lecturer; 
GRANT EXECUTE ON GetFutureMeetingStats TO lecturer;

 -- Prowadzący praktyki 
CREATE ROLE internship_supervisor; 
GRANT EXECUTE ON AddInternship TO internship_supervisor; 
GRANT SELECT ON COMPLETED_MODULES_ATTENDANCE TO internship_supervisor; 
GRANT SELECT ON FUTURE_MODULE_STATS TO internship_supervisor;

 -- Księgowy 
CREATE ROLE accountant; 
GRANT SELECT ON FINANCIAL_REPORT TO accountant; 
GRANT SELECT ON COURSES_FINANCIAL_REPORT TO accountant; 
GRANT SELECT ON WEBINARS_FINANCIAL_REPORT TO accountant; 
GRANT SELECT ON STUDIES_FINANCIAL_REPORT TO accountant; 
GRANT SELECT ON FUTURE_EVENTS_STATS TO accountant; 
GRANT SELECT ON STUDENT_DEBTORS TO accountant; 
GRANT EXECUTE ON GetOrderValue TO accountant; 
GRANT EXECUTE ON GetFinancialReport TO accountant; 
GRANT EXECUTE ON GetDetailedFinancialReport TO accountant; 
GRANT EXECUTE ON GetDetailedFinancialReport TO accountant; 
GRANT SELECT ON ORDERS_SUMMARY TO accountant;

 -- Tłumacz 
CREATE ROLE translator; 
GRANT EXECUTE ON CheckTranslatorLanguage TO translator; 
GRANT SELECT ON BILOCATION_LIST TO translator; 
GRANT SELECT ON FUTURE_WEBINAR_STATS TO translator; 
GRANT SELECT ON FUTURE_MEETING_STATS TO translator;
































