-- DDL Code
-- Table: CourseModules 
CREATE TABLE dbo.CourseModules ( 
    ModuleID int  NOT NULL IDENTITY(1, 1), 
    CourseID int  NOT NULL, 
    LanguageID int  NOT NULL, 
    CONSTRAINT PK_CourseModules PRIMARY KEY CLUSTERED (ModuleID,CourseID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.CourseModules ADD CONSTRAINT FK_CourseModules_Courses 
    FOREIGN KEY (CourseID) 
    REFERENCES dbo.Courses (CourseID); 
 
ALTER TABLE dbo.CourseModules ADD CONSTRAINT FK_CourseModules_Languages 
    FOREIGN KEY (LanguageID) 
    REFERENCES dbo.Languages (LanguageID); 
 
ALTER TABLE dbo.CourseModules ADD CONSTRAINT FK_CourseModules_ModulesTypes 
    FOREIGN KEY (ModuleID) 
    REFERENCES dbo.ModulesDetails (ModuleID); 
-- Table: Courses 
CREATE TABLE dbo.Courses ( 
    CourseID int  NOT NULL IDENTITY(1, 1), 
    CourseName varchar(50)  NOT NULL, 
    CoursePrice money  NOT NULL CHECK (CoursePrice > 0), 
    CourseCoordinatorID int  NOT NULL, 
    CourseType varchar(50)  NOT NULL, 
    Limit varchar(50)  NULL, 
    CONSTRAINT CHK_Limit CHECK (Limit > 0), 
    CONSTRAINT CHK_CoursePrice CHECK (CoursePrice > 0), 
    CONSTRAINT CHK_CourseType CHECK (CourseType IN ('online-sync', 'hybrid', 'in-person', 'online-async')), 
    CONSTRAINT PK_Courses PRIMARY KEY CLUSTERED (CourseID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Courses ADD CONSTRAINT FK_Courses_Employees 
    FOREIGN KEY (CourseCoordinatorID) 
    REFERENCES dbo.Employees (EmployeeID); 
-- Table: EmployeeTypes 
CREATE TABLE dbo.EmployeeTypes ( 
    EmployeeType int  NOT NULL IDENTITY(1, 1), 
    EmployeeTypeName varchar(50)  NULL, 
    CONSTRAINT PK_EmployeeTypes PRIMARY KEY CLUSTERED (EmployeeType) 
) 
ON PRIMARY; 
-- Table: Employees 
CREATE TABLE dbo.Employees ( 
    EmployeeID int  NOT NULL IDENTITY(1, 1), 
    FirstName varchar(50)  NULL, 
    LastName varchar(50)  NULL, 
    Email varchar(50)  NULL, 
    Phone varchar(15)  NULL, 
    EmployeeType int  NOT NULL, 
    CONSTRAINT CHK_Email CHECK (Email LIKE '%_@_%._%'), 
    CONSTRAINT CHK_Phone CHECK (Phone LIKE '+[0-9]%' OR Phone LIKE '[0-9]%'), 
    CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED (EmployeeID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Employees ADD CONSTRAINT FK_Employees_EmployeeTypes 
    FOREIGN KEY (EmployeeType) 
    REFERENCES dbo.EmployeeTypes (EmployeeType); 
-- Table: Internships 
CREATE TABLE Internships ( 
    InternshipID int  NOT NULL, 
    StudiesID int  NOT NULL, 
    StudentID int  NOT NULL, 
    StartDate date  NOT NULL, 
    EndDate date  NOT NULL, 
    InternshipStatus varchar(50)  NOT NULL, 
    CONSTRAINT CHK_StartDateEndDate CHECK (StartDate < EndDate), 
    CONSTRAINT CHK_InternshipStatus CHECK (InternshipStatus IN ('in_progress', 'passed', 'failed', 'pending')), 
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID,StudentID) 
); 
 
ALTER TABLE Internships ADD CONSTRAINT Students_Internships 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
 
ALTER TABLE Internships ADD CONSTRAINT Studies_Internships 
    FOREIGN KEY (StudiesID) 
    REFERENCES dbo.Studies (StudiesID); 
-- Table: Languages 
CREATE TABLE dbo.Languages ( 
    LanguageID int  NOT NULL IDENTITY(1, 1), 
    LanguageName varchar(50)  NULL, 
    CONSTRAINT UC_LanguageName UNIQUE (LanguageName), 
    CONSTRAINT PK_Languages PRIMARY KEY CLUSTERED (LanguageID) 
) 
ON PRIMARY; 
-- Table: ModulesDetails 
CREATE TABLE dbo.ModulesDetails ( 
    ModuleID int  NOT NULL IDENTITY(1, 1), 
    ModuleName varchar(50)  NOT NULL, 
    Room varchar(50)  NULL, 
    Video varchar(50)  NULL, 
    Link varchar(50)  NULL, 
    DurationTime varchar(50)  NULL, 
    AccessEndDate date  NULL, 
    CourseDate date  NOT NULL, 
    ModuleType varchar(50)  NOT NULL, 
    CONSTRAINT CHK_CourseTypeModuleDetails CHECK (ModuleType IN ('online-async', 'in-person', 'hybrid', 'online-sync'), 
    CONSTRAINT UC_VideoModule UNIQUE (Video), 
    CONSTRAINT UC_LinkModule UNIQUE (Link), 
    CONSTRAINT PK_ModulesTypes PRIMARY KEY CLUSTERED (ModuleID) 
) 
ON PRIMARY; 
-- Table: OrderDetails 
CREATE TABLE dbo.OrderDetails ( 
    OrderDetailsID int  NOT NULL, 
    OrderID int  NOT NULL, 
    PayingDate date NULL, 
    CONSTRAINT PK_OrderDetails PRIMARY KEY CLUSTERED (OrderDetailsID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.OrderDetails ADD CONSTRAINT OrderDetails_Orders 
    FOREIGN KEY (OrderID) 
    REFERENCES dbo.Orders (OrderID); 
-- Table: OrderedCourses 
CREATE TABLE dbo.OrderedCourses ( 
    OrderDetailsID int  NOT NULL, 
    CourseID int  NOT NULL, 
    Price money  NOT NULL CHECK (Price >= 0), 
    CONSTRAINT CHK_Price CHECK (Price >= 0), 
    CONSTRAINT PK_OrderedCourses PRIMARY KEY CLUSTERED (OrderDetailsID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.OrderedCourses ADD CONSTRAINT FK_OrderDetails_OrderedCourses 
    FOREIGN KEY (OrderDetailsID) 
    REFERENCES dbo.OrderDetails (OrderDetailsID); 
 
ALTER TABLE dbo.OrderedCourses ADD CONSTRAINT FK_OrderedCourses_Courses 
    FOREIGN KEY (CourseID) 
    REFERENCES dbo.Courses (CourseID); 
-- Table: OrderedStudies 
CREATE TABLE dbo.OrderedStudies ( 
    OrderDetailsID int  NOT NULL, 
    StudiesID int  NOT NULL, 
    Price money  NOT NULL CHECK (Price >= 0), 
    CONSTRAINT CHK_Price CHECK (Price >= 0), 
    CONSTRAINT PK_OrderedStudies PRIMARY KEY CLUSTERED (OrderDetailsID) 
) 
 
ON PRIMARY; 
 
ALTER TABLE dbo.OrderedStudies ADD CONSTRAINT FK_OrderDetails_OrderedStudies 
    FOREIGN KEY (OrderDetailsID) 
    REFERENCES dbo.OrderDetails (OrderDetailsID); 
 
ALTER TABLE dbo.OrderedStudies ADD CONSTRAINT OrderedStudies_Studies 
    FOREIGN KEY (StudiesID) 
    REFERENCES dbo.Studies (StudiesID); 
-- Table: OrderedStudyMeetings 
CREATE TABLE dbo.OrderedStudyMeetings ( 
    OrderDetailsID int  NOT NULL, 
    StudyMeetingID int  NOT NULL, 
    Price money  NOT NULL CHECK (Price >= 0), 
    CONSTRAINT CHK_Price CHECK (Price >= 0), 
    CONSTRAINT PK_OrderedStudyMeetings PRIMARY KEY CLUSTERED (OrderDetailsID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.OrderedStudyMeetings ADD CONSTRAINT FK_OrderDetails_OrderedStudyMeetings 
    FOREIGN KEY (OrderDetailsID) 
    REFERENCES dbo.OrderDetails (OrderDetailsID); 
 
ALTER TABLE dbo.OrderedStudyMeetings ADD CONSTRAINT OrderedStudyMeetings_StudyMeeting 
    FOREIGN KEY (StudyMeetingID) 
    REFERENCES dbo.StudyMeeting (MeetingID); 
-- Table: OrderedWebinars 
CREATE TABLE dbo.OrderedWebinars ( 
    OrderDetailsID int  NOT NULL, 
    WebinarID int  NOT NULL, 
    Price money  NOT NULL CHECK (Price >= 0), 
    CONSTRAINT CHK_Price CHECK (Price >= 0), 
    CONSTRAINT PK_OrderedWebinars PRIMARY KEY CLUSTERED (OrderDetailsID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.OrderedWebinars ADD CONSTRAINT FK_OrderedWebinars_OrderDetails 
    FOREIGN KEY (OrderDetailsID) 
    REFERENCES dbo.OrderDetails (OrderDetailsID); 
 
ALTER TABLE dbo.OrderedWebinars ADD CONSTRAINT OrderedWebinars_Webinars 
    FOREIGN KEY (WebinarID) 
    REFERENCES dbo.Webinars (WebinarID); 
-- Table: Orders 
CREATE TABLE dbo.Orders ( 
    OrderID int  NOT NULL IDENTITY(1, 1), 
    StudentID int  NOT NULL, 
    OrderStatus varchar(50)  NULL, 
    OrderDate date  NOT NULL, 
    CONSTRAINT CHK_OrderStatus CHECK (OrderStatus IN ('paid', 'unpaid', 'canceled')), 
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Orders ADD CONSTRAINT FK_Orders_Students 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
-- Table: StudentCourses 
CREATE TABLE dbo.StudentCourses ( 
    CourseID int  NOT NULL, 
    StudentID int  NOT NULL, 
    CONSTRAINT PK_CourseDetails PRIMARY KEY CLUSTERED (CourseID,StudentID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.StudentCourses ADD CONSTRAINT FK_CourseDetails_Courses 
    FOREIGN KEY (CourseID) 
    REFERENCES dbo.Courses (CourseID); 
 
ALTER TABLE dbo.StudentCourses ADD CONSTRAINT FK_CourseDetails_Students 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
-- Table: StudentMeetingAttendance 
CREATE TABLE dbo.StudentMeetingAttendance ( 
    MeetingID int  NOT NULL, 
    StudentID int  NOT NULL, 
    Attendance varchar(10)  NULL, 
    CONSTRAINT CHK_Attendance CHECK (Attendance IN ('Present', 'Absent', 'Late', 'Signed')), 
    CONSTRAINT PK_MeetingDetails PRIMARY KEY CLUSTERED (MeetingID,StudentID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.StudentMeetingAttendance ADD CONSTRAINT FK_StudyMeeting_MeetingDetails 
    FOREIGN KEY (MeetingID) 
    REFERENCES dbo.StudyMeeting (MeetingID); 
 
ALTER TABLE dbo.StudentMeetingAttendance ADD CONSTRAINT Students_MeetingDetails 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
-- Table: StudentModulesAttendance 
CREATE TABLE dbo.StudentModulesAttendance ( 
    ModuleID int  NOT NULL, 
    StudentID int  NOT NULL, 
    Attendance varchar(10)  NULL, 
    CONSTRAINT CHK_Attendance CHECK (Attendance IN ('Present', 'Absent', 'Late', 'Signed')), 
    CONSTRAINT PK_ModulesDetails PRIMARY KEY CLUSTERED (ModuleID,StudentID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.StudentModulesAttendance ADD CONSTRAINT ModulesDetails_StudentModulesAttendance 
    FOREIGN KEY (ModuleID) 
    REFERENCES dbo.ModulesDetails (ModuleID); 
 
ALTER TABLE dbo.StudentModulesAttendance ADD CONSTRAINT StudentModulesAttendance_Students 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
-- Table: StudentSubjectGrades 
CREATE TABLE dbo.StudentSubjectGrades ( 
    SubjectID int  NOT NULL, 
    Grade int  NULL, 
    StudentID int  NOT NULL, 
    CONSTRAINT PK_SubjectDetails PRIMARY KEY CLUSTERED (SubjectID,StudentID) 
) 
ON PRIMARY; 
ALTER TABLE dbo.StudentSubjectGrades ADD CONSTRAINT StudentSubjectGrades_Subjects 
    FOREIGN KEY (SubjectID) 
    REFERENCES dbo.Subjects (SubjectID); 
 
ALTER TABLE dbo.StudentSubjectGrades ADD CONSTRAINT Students_StudentSubjectGrades 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
-- Table: StudentWebinars 
CREATE TABLE dbo.StudentWebinars ( 
    WebinarID int  NOT NULL, 
    StudentID int  NOT NULL, 
    CONSTRAINT PK_WebinarList PRIMARY KEY CLUSTERED (WebinarID,StudentID) 
) 
ON PRIMARY; 
ALTER TABLE dbo.StudentWebinars ADD CONSTRAINT FK_WebinarList_Students 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
 
ALTER TABLE dbo.StudentWebinars ADD CONSTRAINT FK_Webinars_WebinarList 
    FOREIGN KEY (WebinarID) 
    REFERENCES dbo.Webinars (WebinarID); 
-- Table: Students 
CREATE TABLE dbo.Students ( 
    StudentID int  NOT NULL IDENTITY(1, 1), 
    FirstName varchar(50)  NULL, 
    LastName varchar(50)  NULL, 
    Address varchar(50)  NULL, 
    PostalCode varchar(15)  NULL, 
    Email varchar(50)  NULL, 
    Phone varchar(15)  NULL, 
    CONSTRAINT CHK_Email CHECK (Email LIKE '%_@_%._%'), 
    CONSTRAINT CHK_Phone CHECK (Phone LIKE '+[0-9]%' OR Phone LIKE '[0-9]%'), 
    CONSTRAINT CHK_PostalCode CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'), 
    CONSTRAINT PK_Students PRIMARY KEY CLUSTERED (StudentID) 
) 
ON PRIMARY;  
-- Table: Studies 
CREATE TABLE dbo.Studies ( 
    StudiesID int  NOT NULL IDENTITY(1, 1), 
    StudiesName varchar(50)  NOT NULL, 
    StudiesCoordinator int  NOT NULL, 
    StudiesFee money  NULL CHECK (StudiesFee > 0), 
    StudiesLimit int  NOT NULL, 
    CONSTRAINT CHK_StudiesFee CHECK (StudiesFee >= 0), 
    CONSTRAINT CHK_StudiesLimit CHECK (StudiesLimit > 0), 
    CONSTRAINT PK_Studies PRIMARY KEY CLUSTERED (StudiesID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Studies ADD CONSTRAINT FK_Studies_Employees 
    FOREIGN KEY (StudiesCoordinator) 
    REFERENCES dbo.Employees (EmployeeID); 
-- Table: StudiesFinalGrades 
CREATE TABLE dbo.StudiesFinalGrades ( 
    StudiesGradeID int  NOT NULL, 
    StudentID int  NOT NULL, 
    FinalGrade int  NULL, 
    FinalGradeDate date  NULL, 
    CONSTRAINT PK_StudiesDetails PRIMARY KEY CLUSTERED (StudiesGradeID,StudentID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.StudiesFinalGrades ADD CONSTRAINT FK_StudiesDetails_Students 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
 
ALTER TABLE dbo.StudiesFinalGrades ADD CONSTRAINT FK_Studies_StudiesDetails 
    FOREIGN KEY (StudiesGradeID) 
    REFERENCES dbo.Studies (StudiesID); 
-- Table: StudyCongress 
CREATE TABLE StudyCongress ( 
    StudyCongressID int  NOT NULL IDENTITY(1, 1), 
    StudiesID int  NOT NULL, 
    StartDate date  NOT NULL, 
    EndDate date  NOT NULL, 
    CONSTRAINT CHK_StartDateEndDate CHECK (StartDate < EndDate), 
    CONSTRAINT StudyCongressID PRIMARY KEY  (StudyCongressID) 
); 
 
ALTER TABLE StudyCongress ADD CONSTRAINT StudyCongressID_Studies 
    FOREIGN KEY (StudiesID) 
    REFERENCES dbo.Studies (StudiesID); 
-- Table: StudyMeeting 
CREATE TABLE dbo.StudyMeeting ( 
    MeetingID int  NOT NULL IDENTITY(1, 1), 
    SubjectID int  NOT NULL, 
    TeacherID int  NOT NULL, 
    StudyCongressID int  NOT NULL, 
    MeetingName varchar(50)  NULL, 
    MeetingPrice money  NULL CHECK (MeetingPrice > 0), 
    Date date  NULL, 
    LanguageID int  NOT NULL, 
    TranslatorID int  NULL, 
    Limit int  NULL, 
    Room varchar(50)  NULL, 
    Video varchar(50)  NULL, 
    Link varchar(50)  NULL, 
    CONSTRAINT UC_Video UNIQUE (Video), 
    CONSTRAINT UC_Link UNIQUE (Link), 
    CONSTRAINT CHK_MeetingPrice CHECK (MeetingPrice >= 0), 
    CONSTRAINT CHK_Limit CHECK (Limit > 0), 
    CONSTRAINT PK_StudyMeeting PRIMARY KEY CLUSTERED (MeetingID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.StudyMeeting ADD CONSTRAINT FK_StudyMeeting_Employees 
    FOREIGN KEY (TeacherID) 
    REFERENCES dbo.Employees (EmployeeID); 
 
ALTER TABLE dbo.StudyMeeting ADD CONSTRAINT FK_StudyMeeting_Languages 
    FOREIGN KEY (LanguageID) 
    REFERENCES dbo.Languages (LanguageID); 
 
ALTER TABLE dbo.StudyMeeting ADD CONSTRAINT FK_StudyMeeting_Subjects 
    FOREIGN KEY (SubjectID) 
    REFERENCES dbo.Subjects (SubjectID); 
 
ALTER TABLE dbo.StudyMeeting ADD CONSTRAINT FK_StudyMeeting_Tranlators 
    FOREIGN KEY (TranslatorID) 
    REFERENCES dbo.Translators (TranslatorID); 
 
ALTER TABLE dbo.StudyMeeting ADD CONSTRAINT StudyCongressID_StudyMeeting 
    FOREIGN KEY (StudyCongressID) 
    REFERENCES StudyCongress (StudyCongressID); 
-- Table: SubjectStudentAttendance 
CREATE TABLE SubjectStudentAttendance ( 
    StudentID int  NOT NULL, 
    SubjectID int  NOT NULL, 
    Date date  NOT NULL, 
    Attendance varchar(10)  NOT NULL, 
    CONSTRAINT CHK_Attendance CHECK (Attendance IN ('Present', 'Absent', 'Late', 'Signed')), 
    CONSTRAINT SubjectStudentAttendance_pk PRIMARY KEY  (StudentID,SubjectID,Date) 
); 
 
ALTER TABLE SubjectStudentAttendance ADD CONSTRAINT Students_SubjectStudentAttendance 
    FOREIGN KEY (StudentID) 
    REFERENCES dbo.Students (StudentID); 
 
ALTER TABLE SubjectStudentAttendance ADD CONSTRAINT Subjects_SubjectStudentAttendance 
    FOREIGN KEY (SubjectID) 
    REFERENCES dbo.Subjects (SubjectID); 
-- Table: Subjects 
CREATE TABLE dbo.Subjects ( 
    SubjectID int  NOT NULL IDENTITY(1, 1), 
    StudiesID int  NOT NULL, 
    CoordinatorID int  NOT NULL, 
    SubjectName varchar(50)  NULL, 
    CONSTRAINT PK_Subjects PRIMARY KEY CLUSTERED (SubjectID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Subjects ADD CONSTRAINT FK_Subjects_Employees 
    FOREIGN KEY (CoordinatorID) 
    REFERENCES dbo.Employees (EmployeeID); 
 
ALTER TABLE dbo.Subjects ADD CONSTRAINT FK_Subjects_Studies 
    FOREIGN KEY (StudiesID) 
    REFERENCES dbo.Studies (StudiesID); 
-- Table: Translators 
CREATE TABLE dbo.Translators ( 
    TranslatorID int  NOT NULL IDENTITY(1, 1), 
    LanguageID int  NOT NULL, 
    EmployeeID int  NOT NULL, 
    CONSTRAINT PK_Tranlators PRIMARY KEY CLUSTERED (TranslatorID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Translators ADD CONSTRAINT Employees_Tranlators 
    FOREIGN KEY (EmployeeID) 
    REFERENCES dbo.Employees (EmployeeID); 
 
ALTER TABLE dbo.Translators ADD CONSTRAINT FK_Tranlators_Languages 
    FOREIGN KEY (LanguageID) 
    REFERENCES dbo.Languages (LanguageID); 
-- Table: Webinars 
CREATE TABLE dbo.Webinars ( 
    WebinarID int  NOT NULL IDENTITY(1, 1), 
    TeacherID int  NOT NULL, 
    TranslatorID int  NULL, 
    WebinarName varchar(50)  NULL, 
    WebinarPrice money  NULL CHECK (WebinarPrice >= 0), 
    LanguageID int  NOT NULL, 
    WebinarVideoLink varchar(50)  NULL, 
    WebinarDate date  NULL, 
    DurationTime varchar(50)  NULL, 
    AccessEndDate date  NULL, 
    CONSTRAINT UC_WebinarVideoLink UNIQUE (WebinarVideoLink), 
    CONSTRAINT CHK_WebinarPrice CHECK (WebinarPrice >= 0), 
    CONSTRAINT CHK_WebinarDate CHECK (WebinarDate <= AccessEndDate), 
    CONSTRAINT PK_Webinars PRIMARY KEY CLUSTERED (WebinarID) 
) 
ON PRIMARY; 
 
ALTER TABLE dbo.Webinars ADD CONSTRAINT FK_Webinars_Employees 
    FOREIGN KEY (TeacherID) 
    REFERENCES dbo.Employees (EmployeeID); 
 
ALTER TABLE dbo.Webinars ADD CONSTRAINT FK_Webinars_Languages 
    FOREIGN KEY (LanguageID) 
    REFERENCES dbo.Languages (LanguageID); 
 
ALTER TABLE dbo.Webinars ADD CONSTRAINT FK_Webinars_Tranlators 
    FOREIGN KEY (TranslatorID) 
    REFERENCES dbo.Translators (TranslatorID); 