--Views
--1. FINANCIAL_REPORT 
--Zestawienie łącznych przychodów ze wszystkich źródeł: 
--webinarów, kursów i studiów. 
CREATE VIEW FINANCIAL_REPORT AS -- Zestawienie przychodów z webinarów 
SELECT w.WebinarID AS ID,  
       w.WebinarName AS Name,  
       'Webinar' AS Type,  
       w.WebinarPrice *  
       (SELECT COUNT(*)  
        FROM OrderedWebinars ow  
        JOIN OrderDetails od ON ow.WebinarsOrderDetailsID = od.OrderDetailsID  
        JOIN Orders o ON od.OrderID = o.OrderID  
        WHERE ow.WebinarID = w.WebinarID) AS TotalIncome 
FROM Webinars w 
 
UNION 
 -- Zestawienie przychodów z kursów 
SELECT c.CourseID AS ID,  
       c.CourseName AS Name,  
       'Course' AS Type,  
       c.CoursePrice *  
       (SELECT COUNT(*)  
        FROM OrderedCourses oc  
        JOIN OrderDetails od ON oc.CoursesOrderDetailsID = od.OrderDetailsID  
        JOIN Orders o ON od.OrderID = o.OrderID  
        WHERE oc.CourseID = c.CourseID) AS TotalIncome 
FROM Courses c 
 
UNION 
 -- Zestawienie przychodów ze studiów 
SELECT  
    s.StudiesID AS ID,  
    s.StudiesName AS Name,  
    'Study' AS Type,  
    COALESCE(s.StudiesFee, 0) *  
    COALESCE((SELECT COUNT(*)  
              FROM OrderedStudies os  
              JOIN OrderDetails od ON os.OrderDetailsID = od.OrderDetailsID  
              JOIN Orders o ON od.OrderID = o.OrderID  
              WHERE os.StudiesID = s.StudiesID), 0) +  
    COALESCE((SELECT SUM(sm.MeetingPrice)  
              FROM StudyMeeting sm  
              JOIN Subjects sb ON sm.SubjectID = sb.SubjectID  
              WHERE sb.StudiesID = s.StudiesID), 0) AS TotalIncome 
FROM  
    Studies s; 

--2. WEBINARS_FINANCIAL_REPORT 
--Raport finansowy pokazujący przychody tylko z webinarów. 
CREATE VIEW WEBINARS_FINANCIAL_REPORT AS 
SELECT ID AS 'Webinar ID', Name, TotalIncome 
FROM FINANCIAL_REPORT 
WHERE Type = 'Webinar'; 

--3. STUDIES_FINANCIAL_REPORT 
--Raport finansowy pokazujący przychody tylko ze studiów. 
CREATE VIEW STUDIES_FINANCIAL_REPORT AS 
SELECT ID AS 'Study ID', Name, TotalIncome 
FROM FINANCIAL_REPORT 
WHERE Type = 'Study'; 

--4. COURSES_FINANCIAL_REPORT 
--Raport finansowy pokazujący przychody tylko z kursów. 
CREATE VIEW COURSES_FINANCIAL_REPORT AS 
SELECT ID AS 'Course ID', Name, TotalIncome 
FROM FINANCIAL_REPORT 
WHERE Type = 'Course'; 

--5. STUDENT_DEBTORS 
--Widok prezentujący listę wszystkich studentów z nieuregulowanymi płatnościami wraz z kwotami. 
WITH OrderTotals AS ( 
   SELECT 
       o.OrderID, 
       o.StudentID, 
       s.FirstName, 
       s.LastName, 
       s.Email, 
       o.OrderDate, 
       o.OrderStatus, 
       COALESCE(SUM(c.CoursePrice), 0) AS TotalCourseCharges, 
       COALESCE(SUM(st.StudiesFee), 0) AS TotalStudiesFees, 
       COALESCE(SUM(w.WebinarPrice), 0) AS TotalWebinarCharges, 
       COALESCE(SUM(sm.MeetingPrice), 0) AS TotalMeetingCharges 
   FROM 
       dbo.Orders o 
   INNER JOIN 
       dbo.Students s ON o.StudentID = s.StudentID 
   LEFT JOIN 
       dbo.OrderedCourses oc ON oc.OrderDetailsID = o.OrderID 
   LEFT JOIN 
       dbo.Courses c ON c.CourseID = oc.CourseID 
   LEFT JOIN 
       dbo.OrderedStudies os ON os.OrderDetailsID = o.OrderID 
   LEFT JOIN 
       dbo.Studies st ON st.StudiesID = os.StudiesID 
   LEFT JOIN 
       dbo.OrderedWebinars ow ON ow.OrderDetailsID = o.OrderID 
   LEFT JOIN 
       dbo.Webinars w ON w.WebinarID = ow.WebinarID 
   LEFT JOIN 
       dbo.OrderedStudyMeetings osm ON osm.OrderDetailsID = o.OrderID 
   LEFT JOIN 
       dbo.StudyMeeting sm ON sm.MeetingID = osm.StudyMeetingID 
   WHERE 
       o.OrderStatus IS NULL OR o.OrderStatus = 'unpaid' 
   GROUP BY 
       o.OrderID, o.StudentID, s.FirstName, s.LastName, s.Email, o.OrderDate, o.OrderStatus 
) 
SELECT 
   StudentID, 
   FirstName, 
   LastName, 
   Email, 
   OrderID, 
   OrderDate, 
   OrderStatus, 
   (TotalCourseCharges + TotalStudiesFees + TotalWebinarCharges + TotalMeetingCharges) AS TotalUnpaidAmount 
FROM 
   OrderTotals 
WHERE 
   (TotalCourseCharges + TotalStudiesFees + TotalWebinarCharges + TotalMeetingCharges) > 0 

--6. FUTURE_MEETING_STATS 
--Szczegółowe statystyki dotyczące przyszłych spotkań, 
--zawierające informacje o prowadzących i liczbie dostępnych miejsc. 
CREATE VIEW FUTURE_MEETING_STATS AS 
SELECT 
    sm.MeetingID, 
    sm.MeetingName, 
    sm.Date AS MeetingDate, 
    l.LanguageName, 
    e.FirstName + ' ' + e.LastName AS TeacherName, 
    COUNT(DISTINCT sma.StudentID) AS RegisteredStudents, 
    sm.Limit AS MaxCapacity, 
    CASE 
        WHEN sm.Limit IS NULL THEN NULL 
        ELSE sm.Limit - COUNT(DISTINCT sma.StudentID) 
    END AS RemainingSpots 
FROM dbo.StudyMeeting sm 
LEFT JOIN dbo.StudentMeetingAttendance sma ON sm.MeetingID = sma.MeetingID 
INNER JOIN dbo.Languages l ON sm.LanguageID = l.LanguageID 
INNER JOIN dbo.Employees e ON sm.TeacherID = e.EmployeeID 
WHERE sm.Date > GETDATE() 
GROUP BY 
    sm.MeetingID, 
    sm.MeetingName, 
    sm.Date, 
    l.LanguageName, 
    e.FirstName + ' ' + e.LastName, 
    sm.Limit; 

--7. FUTURE_MODULE_STATS 
--Statystyki przyszłych modułów kursowych wraz z informacjami 
--o liczbie zapisanych uczestników i dostępnych miejscach. 
CREATE VIEW FUTURE_MODULE_STATS AS 
SELECT 
    md.ModuleDetailsID, 
    md.ModuleName, 
    md.CourseDate as ModuleDate, 
    c.CourseName, 
    l.LanguageName, 
    COUNT(DISTINCT sc.StudentID) as RegisteredStudents, 
    md.Limit as MaxCapacity, 
    CASE 
        WHEN md.Limit IS NULL THEN NULL 
        ELSE md.Limit - COUNT(DISTINCT sc.StudentID) 
    END as RemainingSpots 
FROM dbo.ModulesDetails md 
INNER JOIN dbo.CourseModules cm ON md.ModuleDetailsID = cm.ModuleID 
INNER JOIN dbo.Courses c ON cm.CourseID = c.CourseID 
INNER JOIN dbo.Languages l ON cm.LanguageID = l.LanguageID 
LEFT JOIN dbo.StudentCourses sc ON c.CourseID = sc.StudentCoursesID 
WHERE md.CourseDate > GETDATE() 
GROUP BY 
    md.ModuleDetailsID, 
    md.ModuleName, 
    md.CourseDate, 
    c.CourseName, 
    l.LanguageName, 
    md.Limit; 

--8. FUTURE_WEBINAR_STATS 
--Statystyki przyszłych webinarów z informacjami o prowadzących i liczbie zarejestrowanych uczestników. 
CREATE VIEW FUTURE_WEBINAR_STATS AS 
SELECT 
w.WebinarID, 
w.WebinarName, 
w.WebinarDate, 
l.LanguageName, 
e.FirstName + ' ' + e.LastName as TeacherName, 
COUNT(DISTINCT sw.StudentID) as RegisteredStudents, 
NULL as MaxCapacity, 
NULL as RemainingSpots 
FROM dbo.Webinars w 
LEFT JOIN dbo.StudentWebinars sw ON w.WebinarID = sw.WebinarID 
INNER JOIN dbo.Languages l ON w.LanguageID = l.LanguageID 
INNER JOIN dbo.Employees e ON w.TeacherID = e.EmployeeID 
WHERE w.WebinarDate > GETDATE() 
GROUP BY 
w.WebinarID, 
w.WebinarName, 
w.WebinarDate, 
l.LanguageName, 
e.FirstName + ' ' + e.LastName; 

--9. FUTURE_EVENTS_STATS 
--Zestawienie zbiorcze informacji o wszystkich przyszłych 
--wydarzeniach, łączące dane ze spotkań, webinarów i modułów kursowych. 
CREATE VIEW FUTURE_EVENTS_STATS AS 
SELECT 
'Meeting' as EventType, 
MeetingName as EventName, 
MeetingDate as EventDate, 
LanguageName, 
TeacherName, 
RegisteredStudents, 
MaxCapacity, 
RemainingSpots 
FROM FUTURE_MEETING_STATS 
UNION ALL 
SELECT 
'Webinar' as EventType, 
WebinarName as EventName, 
WebinarDate as EventDate, 
LanguageName, 
TeacherName, 
RegisteredStudents, 
MaxCapacity, 
RemainingSpots 
FROM FUTURE_WEBINAR_STATS 
UNION ALL 
SELECT 
'Course Module' as EventType, 
ModuleName as EventName, 
ModuleDate as EventDate, 
LanguageName, 
NULL as TeacherName, 
RegisteredStudents, 
MaxCapacity, 
RemainingSpots 
FROM FUTURE_MODULE_STATS; 
 
--10. COMPLETED_EVENTS_ATTENDANCE 
--Zestawienie zbiorcze frekwencji na wszystkich zakończonych 
--wydarzeniach (spotkaniach, modułach kursowych i webinarach). 
CREATE VIEW COMPLETED_EVENTS_ATTENDANCE AS 
SELECT 
    'Study Meeting' AS EventType, 
    sm.MeetingID AS EventID, 
    sm.Date AS EventDate, 
    COUNT(DISTINCT sa.StudentID) AS TotalStudents, 
    SUM(CASE WHEN sa.Attendance = 'Present' THEN 1 ELSE 0 END) AS PresentStudents, 
    SUM(CASE WHEN sa.Attendance = 'Late' THEN 1 ELSE 0 END) AS LateStudents, 
    SUM(CASE WHEN sa.Attendance = 'Absent' THEN 1 ELSE 0 END) AS AbsentStudents, 
     
 
CASE 
        WHEN COUNT(DISTINCT sa.StudentID) = 0 THEN 0 
        ELSE CAST(SUM(CASE WHEN sa.Attendance = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT sa.StudentID) AS DECIMAL(5, 2)) 
    END AS AttendancePercentage 
FROM StudyMeeting sm 
JOIN StudentMeetingAttendance sa ON sm.MeetingID = sa.MeetingID 
WHERE sm.Date < GETDATE() 
GROUP BY sm.MeetingID, sm.Date 
 
UNION ALL 
 
SELECT 
    'Course Module' AS EventType, 
    md.ModuleID AS EventID, 
    md.CourseDate AS EventDate, 
    COUNT(DISTINCT sma.StudentID) AS TotalStudents, 
    SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) AS PresentStudents, 
    SUM(CASE WHEN sma.Attendance = 'Late' THEN 1 ELSE 0 END) AS LateStudents, 
    SUM(CASE WHEN sma.Attendance = 'Absent' THEN 1 ELSE 0 END) AS AbsentStudents, 
    CASE 
        WHEN COUNT(DISTINCT sma.StudentID) = 0 THEN 0 
        ELSE CAST(SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT sma.StudentID) AS DECIMAL(5, 2)) 
    END AS AttendancePercentage 
FROM ModulesDetails md 
JOIN StudentModulesAttendance sma ON md.ModuleID = sma.ModuleID 
WHERE md.CourseDate < GETDATE() 
GROUP BY md.ModuleID, md.CourseDate 
 
UNION ALL 
 
SELECT 
    'Webinar' AS EventType, 
    w.WebinarID AS EventID, 
    w.WebinarDate AS EventDate, 
    COUNT(DISTINCT sw.StudentID) AS TotalStudents, 
    COUNT(DISTINCT sw.StudentID) AS PresentStudents, 
    0 AS LateStudents, 
    0 AS AbsentStudents, 
    100.00 AS AttendancePercentage 
FROM Webinars w 
JOIN StudentWebinars sw ON w.WebinarID = sw.WebinarID 
WHERE w.WebinarDate < GETDATE() 
GROUP BY w.WebinarID, w.WebinarDate; 
 
--11. CompletedModulesAttendance 
--Szczegółowe statystyki frekwencji dla zakończonych modułów kursowych. 
CREATE VIEW COMPLETED_MODULES_ATTENDANCE AS 
SELECT 
    md.ModuleName as EventName, 
    md.ModuleType as EventType, 
    md.CourseDate as EventDate, 
    COUNT(DISTINCT sma.StudentID) as TotalStudents, 
    SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) as PresentStudents, 
    SUM(CASE WHEN sma.Attendance = 'Late' THEN 1 ELSE 0 END) as LateStudents, 
    SUM(CASE WHEN sma.Attendance = 'Absent' THEN 1 ELSE 0 END) as AbsentStudents, 
    CASE  
        WHEN COUNT(DISTINCT sma.StudentID) = 0 THEN 0 
        ELSE CAST(SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT sma.StudentID) AS DECIMAL(5,2)) 
    END as AttendancePercentage 
FROM ModulesDetails md 
JOIN StudentModulesAttendance sma ON md.ModuleID = sma.ModuleID 
WHERE md.CourseDate < GETDATE() 
GROUP BY md.ModuleID, md.ModuleName, md.ModuleType, md.CourseDate; 

--12. CompletedStudyMeetingsAttendance 
--Szczegółowe statystyki frekwencji dla zakończonych spotkań 
--studyjnych, zawierające informacje o prowadzących i przedmiotach. 
CREATE VIEW COMPLETED_STUDY_MEETINGS_ATTENDANCE AS 
SELECT 
    sm.MeetingName AS EventName, 
    'Study Meeting' AS EventType, 
    sm.Date AS EventDate, 
    s.SubjectName AS SubjectName, 
    e.FirstName + ' ' + e.LastName AS TeacherName, 
    l.LanguageName AS LanguageName, 
    COUNT(DISTINCT sma.StudentID) AS TotalStudents, 
    SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) AS PresentStudents, 
    SUM(CASE WHEN sma.Attendance = 'Late' THEN 1 ELSE 0 END) AS LateStudents, 
    SUM(CASE WHEN sma.Attendance = 'Absent' THEN 1 ELSE 0 END) AS AbsentStudents, 
    CASE  
        WHEN COUNT(DISTINCT sma.StudentID) = 0 THEN 0 
        ELSE CAST( 
            SUM(CASE WHEN sma.Attendance = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT sma.StudentID) AS DECIMAL(5, 2) 
        ) 
    END AS AttendancePercentage 
FROM  
    StudyMeeting sm 
JOIN  
    Subjects s ON sm.SubjectID = s.SubjectID 
JOIN  
    Employees e ON sm.TeacherID = e.EmployeeID 
JOIN  
    Languages l ON sm.LanguageID = l.LanguageID 
JOIN  
    StudentMeetingAttendance sma ON sm.MeetingID = sma.MeetingID 
WHERE  
    sm.Date < GETDATE() 
GROUP BY  
    sm.MeetingID, sm.MeetingName, sm.Date, s.SubjectName, e.FirstName, e.LastName, l.LanguageName; 
  
--13. COMPLETED_WEBINARS_ATTENDANCE 
--Szczegółowe statystyki uczestnictwa w zakończonych 
--webinarach wraz z informacjami o cenach i czasie trwania. 
CREATE VIEW COMPLETED_WEBINARS_ATTENDANCE AS 
SELECT 
    w.WebinarName as EventName, 
    'Webinar' as EventType, 
    w.WebinarDate as EventDate, 
    COUNT(DISTINCT sw.StudentID) as TotalStudents, 
    COUNT(DISTINCT sw.StudentID) as PresentStudents, 
    0 as LateStudents,  
    0 as AbsentStudents,  
    100.00 as AttendancePercentage,  
    w.WebinarPrice as WebinarPrice,  
    w.DurationTime as DurationTime  
FROM Webinars w 
LEFT JOIN StudentWebinars sw ON w.WebinarID = sw.WebinarID 
WHERE w.WebinarDate < GETDATE() 
GROUP BY w.WebinarID, w.WebinarName, w.WebinarDate, w.WebinarPrice, w.DurationTime;
 
--14. ATTENDANCE_LIST 
--Pełna lista obecności dla wszystkich rodzajów wydarzeń, 
--zawierająca dane osobowe uczestników i status ich obecności. 
CREATE view ATTENDANCE_LIST as 
SELECT DISTINCT sm.MeetingID   as EventID, 
           sm.MeetingName as EventName, 
           sm.Date        as EventDate, 
           s.StudentID, 
           s.FirstName, 
           s.LastName, 
           CASE 
               WHEN ssa.Attendance = 'Present' THEN 'Obecny' 
               WHEN ssa.Attendance = 'Absent' THEN 'Nieobecny' 
               WHEN ssa.Attendance = 'Late' THEN N'Spóźniony' 
               ELSE 'Brak informacji' 
               END        AS AttendanceStatus 
    FROM StudyMeeting sm 
             JOIN 
         SubjectStudentAttendance ssa ON sm.SubjectID = ssa.SubjectID 
             JOIN 
         Students s ON ssa.StudentID = s.StudentID 
 
    UNION ALL 
 -- Course Modules Attendance 
    SELECT md.ModuleID   as EventID, 
           md.ModuleName as EventName, 
           md.CourseDate as EventDate, 
           s.StudentID, 
           s.FirstName, 
           s.LastName, 
           CASE 
               WHEN sma.Attendance = 'Present' THEN 'Obecny' 
               WHEN sma.Attendance = 'Absent' THEN 'Nieobecny' 
               WHEN sma.Attendance = 'Late' THEN N'Spóźniony' 
               ELSE 'Brak informacji' 
               END       AS AttendanceStatus 
    FROM ModulesDetails md 
             JOIN 
         StudentModulesAttendance sma ON md.ModuleID = sma.ModuleID 
             JOIN 
         Students s ON sma.StudentID = s.StudentID 
 
    UNION ALL 
 -- Webinars Attendance 
    SELECT w.WebinarID   as EventID, 
           w.WebinarName as EventName, 
           w.WebinarDate as EventDate, 
           s.StudentID, 
           s.FirstName, 
           s.LastName, 
           CASE 
               when w.WebinarDate > GETDATE() then 'Zapisany' 
                else 'Obecny' 
           END AS AttendanceStatus -- Wszyscy zarejestrowani traktowani jako obecni 
    FROM Webinars w 
             JOIN 
         StudentWebinars sw ON w.WebinarID = sw.WebinarID 
             JOIN 
         Students s ON sw.StudentID = s.StudentID 
 
    UNION ALL -- Subjects_Attendance 
    SELECT sba.SubjectID   as EventID, 
           s.SubjectName as EventName, 
           sba.Date as EventDate, 
           st.StudentID, 
           st.FirstName, 
           st.LastName, 
           CASE 
               when sba.Date > GETDATE() then 'Zapisany' 
               WHEN sba.Attendance = 'Present' THEN 'Obecny' 
               WHEN sba.Attendance = 'Absent' THEN 'Nieobecny' 
               WHEN sba.Attendance = 'Late' THEN N'Spóźniony' 
           END AS AttendanceStatus -- Wszyscy zarejestrowani traktowani jako obecni 
    FROM SubjectStudentAttendance sba 
             JOIN 
         Subjects s ON sba.SubjectID = s.SubjectID 
             JOIN 
         Students st ON sba.StudentID = st.StudentID 
             JOIN 
         Studies stu ON stu.StudiesID = s.StudiesID
 
 
--15. BILOCATION_LIST 
--Raport bilokacji: lista osób, które są zapisane na co najmniej 
--dwa przyszłe szkolenia, które ze sobą kolidują czasowo. 
CREATE VIEW BILOCATION_LIST AS 
SELECT DISTINCT  
    s.StudentID, 
    s.FirstName, 
    s.LastName, 
    e1.EventName AS FirstEvent, 
    e1.EventDate AS FirstEventDate, 
    e2.EventName AS SecondEvent, 
    e2.EventDate AS SecondEventDate 
FROM  
    -- Lista przyszłych wydarzeń (zunionowana) 
    (SELECT sw.StudentID, 
            w.WebinarName AS EventName, 
            w.WebinarDate AS EventDate 
     FROM Webinars w 
              JOIN StudentWebinars sw ON w.WebinarID = sw.WebinarID 
     WHERE w.WebinarDate > GETDATE() 
      
     UNION ALL 
      
     SELECT sma.StudentID, 
            md.ModuleName AS EventName, 
            md.CourseDate AS EventDate 
     FROM ModulesDetails md 
              JOIN StudentModulesAttendance sma ON md.ModuleID = sma.ModuleID 
     WHERE md.CourseDate > GETDATE() 
      
     UNION ALL 
      
     SELECT ssa.StudentID, 
            sm.MeetingName AS EventName, 
            sm.Date AS EventDate 
     FROM StudyMeeting sm 
              JOIN SubjectStudentAttendance ssa ON sm.SubjectID = ssa.SubjectID 
     WHERE sm.Date > GETDATE()) e1 
 
JOIN  
    (SELECT sw.StudentID, 
            w.WebinarName AS EventName, 
            w.WebinarDate AS EventDate 
     FROM Webinars w 
              JOIN StudentWebinars sw ON w.WebinarID = sw.WebinarID 
     WHERE w.WebinarDate > GETDATE() 
      
     UNION ALL 
      
     SELECT sma.StudentID, 
            md.ModuleName AS EventName, 
            md.CourseDate AS EventDate 
     FROM ModulesDetails md 
              JOIN StudentModulesAttendance sma ON md.ModuleID = sma.ModuleID 
     WHERE md.CourseDate > GETDATE() 
      
     UNION ALL 
      
     SELECT ssa.StudentID, 
            sm.MeetingName AS EventName, 
            sm.Date AS EventDate 
     FROM StudyMeeting sm 
              JOIN SubjectStudentAttendance ssa ON sm.SubjectID = ssa.SubjectID 
     WHERE sm.Date > GETDATE()) e2  
 
ON e1.StudentID = e2.StudentID 
   AND CAST(e1.EventDate AS DATE) = CAST(e2.EventDate AS DATE) -- Wydarzenia tego samego dnia 
   AND e1.EventName <> e2.EventName -- Wykluczamy to samo wydarzenie 
   AND e1.EventName < e2.EventName 
JOIN Students s ON e1.StudentID = s.StudentID 

--16. STUDIES_STRUCTURE_VIEW 
--Wyświetla strukturę studiów, w tym zjazdy i przypisane spotkania. 
SELECT  
    s.StudiesID AS StudyID, 
    s.StudiesName AS StudyName, 
    sc.StudyCongressID AS CongressID, 
    sc.StartDate AS CongressStartDate, 
    sc.EndDate AS CongressEndDate, 
    sm.MeetingID AS MeetingID, 
    sm.MeetingName AS MeetingName, 
    sm.Date AS MeetingDate, 
    e.FirstName + ' ' + e.LastName AS Teacher, 
    l.LanguageName AS Language, 
    sm.Limit AS MaxCapacity, 
    (sm.Limit - COUNT(DISTINCT sma.StudentID)) AS RemainingSpots 
FROM Studies s 
JOIN StudyCongress sc ON s.StudiesID = sc.StudiesID 
JOIN StudyMeeting sm ON sc.StudyCongressID = sm.StudyCongressID 
LEFT JOIN StudentMeetingAttendance sma ON sm.MeetingID = sma.MeetingID 
JOIN Employees e ON sm.TeacherID = e.EmployeeID 
JOIN Languages l ON sm.LanguageID = l.LanguageID 
GROUP BY  
    s.StudiesID, s.StudiesName, sc.StudyCongressID, sc.StartDate, sc.EndDate, 
    sm.MeetingID, sm.MeetingName, sm.Date, e.FirstName, e.LastName, l.LanguageName, sm.Limit 
  
--17. ORDERS_SUMMARY 
--Wyświetla szczegóły zamówień, w tym typy zakupionych zasobów, ceny i status. 
SELECT o.OrderID, 
           s.StudentID, 
           s.FirstName + ' ' + s.LastName AS StudentName, 
           'Webinar'                      AS ResourceType, 
           w.WebinarName                  AS ResourceName, 
           ow.Price                       AS Price, 
           o.OrderStatus 
    FROM Orders o 
             JOIN Students s ON o.StudentID = s.StudentID 
             LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
             LEFT JOIN OrderedWebinars ow ON od.OrderDetailsID = ow.OrderDetailsID 
             LEFT JOIN Webinars w ON ow.WebinarID = w.WebinarID 
    WHERE w.WebinarID IS NOT NULL 
 
    UNION ALL 
 
    SELECT o.OrderID, 
           s.StudentID, 
           s.FirstName + ' ' + s.LastName AS StudentName, 
           'Course'                       AS ResourceType, 
           c.CourseName                   AS ResourceName, 
           oc.Price                       AS Price, 
           o.OrderStatus 
    FROM Orders o 
             JOIN Students s ON o.StudentID = s.StudentID 
             LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
             LEFT JOIN OrderedCourses oc ON od.OrderDetailsID = oc.OrderDetailsID 
             LEFT JOIN Courses c ON oc.CourseID = c.CourseID 
    WHERE c.CourseID IS NOT NULL 
 
    UNION ALL 
 
    SELECT o.OrderID, 
           s.StudentID, 
           s.FirstName + ' ' + s.LastName AS StudentName, 
           'Study'                        AS ResourceType, 
           st.StudiesName                 AS ResourceName, 
           os.Price                       AS Price, 
           o.OrderStatus 
    FROM Orders o 
             JOIN Students s ON o.StudentID = s.StudentID 
             LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
             LEFT JOIN OrderedStudies os ON od.OrderDetailsID = os.OrderDetailsID 
             LEFT JOIN Studies st ON os.StudiesID = st.StudiesID 
    WHERE st.StudiesID IS NOT NULL 
 
    UNION ALL 
 
    SELECT o.OrderID, 
           s.StudentID, 
           s.FirstName + ' ' + s.LastName AS StudentName, 
           'Study Meeting'                AS ResourceType, 
           sm.MeetingName                 AS ResourceName, 
           osm.Price                      AS Price, 
           o.OrderStatus 
    FROM Orders o 
             JOIN Students s ON o.StudentID = s.StudentID 
             LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
             LEFT JOIN OrderedStudyMeetings osm ON od.OrderDetailsID = osm.OrderDetailsID 
             LEFT JOIN StudyMeeting sm ON osm.StudyMeetingID = sm.MeetingID 
    WHERE sm.MeetingID IS NOT NULL 
 
    UNION ALL 
 -- Unpaid i canceled - nie mają order details 
    SELECT o.OrderID, 
           s.StudentID, 
           s.FirstName + ' ' + s.LastName AS StudentName, 
           'No details'                   AS ResourceType, 
           'No details'                   AS ResourceName, 
           0                              AS Price, 
           o.OrderStatus 
    FROM Orders o 
             JOIN Students s ON o.StudentID = s.StudentID 
             LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
    WHERE o.OrderStatus IN ('unpaid', 'canceled') 
      AND od.OrderDetailsID IS NULL 