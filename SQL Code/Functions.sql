--1. Sprawdzanie, czy tłumacz może tłumaczyć w danym języku - używana w 
--procedurze do tworzenia zajęć w innym języku 
CREATE FUNCTION CheckTranslatorLanguage 
    (@TranslatorID int null, @LanguageID int null) 
RETURNS bit  
AS 
BEGIN 
    IF @TranslatorID IS NOT NULL AND NOT EXISTS ( 
        SELECT *  
        FROM Translators  
        WHERE TranslatorID = @TranslatorID 
    ) 
    BEGIN 
        RETURN CAST(0 AS bit) 
    END 
 
    IF @LanguageID IS NOT NULL AND NOT EXISTS ( 
        SELECT *  
        FROM Languages  
        WHERE LanguageID = @LanguageID 
    ) 
    BEGIN 
        RETURN CAST(0 AS bit) 
    END 
 
    IF @TranslatorID IS NULL AND @LanguageID IS NOT NULL 
    BEGIN 
        RETURN CAST(0 AS bit) 
    END 
 
    IF @TranslatorID IS NOT NULL AND @LanguageID IS NULL 
    BEGIN 
        RETURN CAST(0 AS bit) 
    END 
 
    IF @TranslatorID IS NOT NULL AND @LanguageID IS NOT NULL AND NOT EXISTS ( 
        SELECT *  
        FROM Translators  
        WHERE TranslatorID = @TranslatorID  
        AND LanguageID = @LanguageID 
    ) 
    BEGIN 
        RETURN CAST(0 AS bit) 
    END 
 
    RETURN CAST(1 AS bit) 
END; 
 
--2. Zliczanie frekwencji na kursie 
CREATE FUNCTION GetCourseAttendanceForStudent(@StudentID INT, @CourseID INT) 
RETURNS REAL 
AS 
BEGIN 
   -- Sprawdzenie, czy student istnieje 
   IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID) 
   BEGIN 
       RETURN 0.0; 
   END 
 
   -- Sprawdzenie, czy kurs istnieje 
   IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID) 
   BEGIN 
       RETURN 0.0; 
   END 
 
   -- Sprawdzenie, czy student jest zapisany na ten kurs 
   IF NOT EXISTS ( 
       SELECT 1 
       FROM StudentCourses 
       WHERE StudentID = @StudentID AND CourseID = @CourseID 
   ) 
   BEGIN 
       RETURN 0.0; 
   END 
 
   -- Deklaracje zmiennych 
   DECLARE @AttendanceCount INT; 
   DECLARE @ModulesCount INT; 
 
   -- Liczba obecności studenta na modułach kursu 
   SELECT @AttendanceCount = COUNT(*) 
   FROM StudentModulesAttendance AS sma 
   JOIN CourseModules AS cm ON sma.ModuleID = cm.ModuleID 
   WHERE sma.StudentID = @StudentID 
     AND cm.CourseID = @CourseID 
     AND sma.Attendance = 'Present'; 
 
   -- Liczba modułów w kursie 
   SELECT @ModulesCount = COUNT(*) 
   FROM CourseModules 
   WHERE CourseID = @CourseID; 
 
   -- Jeżeli brak modułów, zwróć 0 
   IF @ModulesCount = 0 
   BEGIN 
       RETURN 0.0; 
   END 
 
   -- Zwrócenie udziału obecności 
   RETURN CAST(@AttendanceCount AS REAL) / CAST(@ModulesCount AS REAL); 
END 
 
--3. Zliczanie frekwencji danego uczestnika na danym przedmiocie na studiach 
CREATE FUNCTION GetSubjectAttendanceForStudent 
   (@StudentID INT, @SubjectID INT) 
RETURNS REAL 
AS 
BEGIN 
   -- Sprawdzenie, czy student istnieje 
   IF NOT EXISTS ( 
       SELECT 1 
       FROM Students 
       WHERE StudentID = @StudentID 
   ) 
   BEGIN 
       -- Jeżeli nie znaleziono studenta 
       RETURN 0.0; 
   END; 
 
   -- Sprawdzenie, czy przedmiot istnieje 
   IF NOT EXISTS ( 
       SELECT 1 
       FROM Subjects 
       WHERE SubjectID = @SubjectID 
   ) 
   BEGIN 
       -- Jeżeli nie znaleziono przedmiotu 
       RETURN 0.0; 
   END; 
 
   -- Sprawdzenie, czy student jest zapisany na przedmiot 
   IF NOT EXISTS ( 
       SELECT 1 
       FROM StudentSubjectGrades AS ssg 
       WHERE ssg.StudentID = @StudentID 
         AND ssg.SubjectID = @SubjectID 
   ) 
   BEGIN 
       -- Jeżeli student nie jest zapisany na przedmiot 
       RETURN 0.0; 
   END; 
 
   -- Deklaracje zmiennych 
   DECLARE @AttendanceCount INT; 
   DECLARE @MeetingsCount INT; 
 
   -- Obliczenie liczby obecności 
   SELECT @AttendanceCount = COUNT(*) 
   FROM StudentMeetingAttendance AS sma 
   JOIN StudyMeeting AS sm ON sma.MeetingID = sm.MeetingID 
   WHERE sma.StudentID = @StudentID 
     AND sma.Attendance = 'Present' 
     AND sm.SubjectID = @SubjectID; 
 
   -- Obliczenie liczby wszystkich spotkań dla przedmiotu 
   SELECT @MeetingsCount = COUNT(*) 
   FROM StudyMeeting AS sm 
   WHERE sm.SubjectID = @SubjectID; 
 
   -- Zabezpieczenie przed dzieleniem przez 0 
   IF @MeetingsCount = 0 
   BEGIN 
       RETURN 0.0; 
   END; 
 
   -- Obliczenie procentu obecności 
   RETURN CAST(@AttendanceCount AS REAL) / CAST(@MeetingsCount AS REAL); 
END 
 
--4. Łączna wartość zamówienia  
CREATE FUNCTION GetOrderValue(@OrderID int) 
RETURNS money 
AS 
BEGIN 
    DECLARE @StudiesSum money 
    DECLARE @StudyMeetingsSum money 
    DECLARE @CoursesSum money 
    DECLARE @WebinarsSum money 
 
    SELECT @StudiesSum = ISNULL(SUM(s.StudiesFee), 0) 
    FROM Studies AS s 
    JOIN OrderedStudies AS os ON s.StudiesID = os.StudiesID 
    JOIN OrderDetails AS od ON os.OrderDetailsID = od.OrderDetailsID 
    WHERE od.OrderID = @OrderID 
 
    SELECT @StudyMeetingsSum = ISNULL(SUM(sm.MeetingPrice), 0) 
    FROM Studies AS s 
    JOIN Subjects AS su ON s.StudiesID = su.StudiesID 
    JOIN StudyMeeting AS sm ON su.SubjectID = sm.SubjectID 
    JOIN OrderedStudies AS os ON s.StudiesID = os.StudiesID 
    JOIN OrderDetails AS od ON os.OrderDetailsID = od.OrderDetailsID 
    WHERE od.OrderID = @OrderID 
 
    SELECT @CoursesSum = ISNULL(SUM(c.CoursePrice), 0) 
    FROM Courses AS c 
    JOIN OrderedCourses AS oc ON c.CourseID = oc.CourseID 
    JOIN OrderDetails AS od ON oc.OrderDetailsID = od.OrderDetailsID 
    WHERE od.OrderID = @OrderID 
 
    SELECT @WebinarsSum = ISNULL(SUM(w.WebinarPrice), 0) 
    FROM Webinars AS w 
    JOIN OrderedWebinars AS ow ON w.WebinarID = ow.WebinarID 
    JOIN OrderDetails AS od ON ow.OrderDetailsID = od.OrderDetailsID 
    WHERE od.OrderID = @OrderID 
 
    RETURN @StudiesSum + @CoursesSum + @WebinarsSum + @StudyMeetingsSum 
END 
 
--5. Raport finansowy w przedziale czasowym 
CREATE FUNCTION dbo.GetFinancialReport 
( 
   @StartDate date, 
   @EndDate date 
) 
RETURNS TABLE 
AS 
RETURN 
( 
   SELECT 
       fr.* 
   FROM FINANCIAL_REPORT fr 
   JOIN OrderDetails od ON fr.ID = od.OrderID 
   WHERE od.PayingDate BETWEEN @StartDate AND @EndDate 
) 
 
 
--6. Raport Finansowy w przedziale czasowym z wybranego typu zajęć  
(Webinar, Studia, Kursy) 
CREATE FUNCTION dbo.GetDetailedFinancialReport 
( 
   @StartDate date, 
   @EndDate date, 
   @Type varchar(50) 
) 
RETURNS TABLE 
AS 
RETURN 
( 
   SELECT 
       fr.* 
   FROM FINANCIAL_REPORT fr 
   JOIN OrderDetails od ON fr.ID = od.OrderID 
   WHERE od.PayingDate BETWEEN @StartDate AND @EndDate 
   AND @Type IN ('Webinar', 'Course', 'Study') 
   AND fr.Type = @Type 
) 
 
