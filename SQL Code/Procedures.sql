--1. Dodawanie nowego webinaru 
CREATE PROCEDURE AddWebinar 
   @TeacherID INT, 
   @TranslatorID INT, 
   @WebinarName VARCHAR(50), 
   @WebinarPrice MONEY, 
   @LanguageID INT, 
   @WebinarVideoLink VARCHAR(50), 
   @WebinarDate DATE, 
   @DurationTime VARCHAR(50), 
   @AccessEndDate DATE 
AS 
BEGIN 
   BEGIN TRY 
       IF NOT EXISTS (SELECT * FROM Employees WHERE EmployeeID = @TeacherID) 
       BEGIN 
           THROW 50001, 'Nie znaleziono nauczyciela.', 1; 
       END; 
 
       IF dbo.CheckTranslatorLanguage(@TranslatorID, @LanguageID) = CAST(0 AS BIT) 
       BEGIN 
           THROW 50002, 'Podano nieprawidłową kombinację tłumacza i języka.', 1; 
       END; 
 
       INSERT INTO Webinars (TeacherID, TranslatorID, WebinarName, 
           WebinarPrice, LanguageID, WebinarVideoLink, WebinarDate, 
           DurationTime, AccessEndDate) 
       VALUES (@TeacherID, @TranslatorID, @WebinarName, 
           @WebinarPrice, @LanguageID, @WebinarVideoLink, @WebinarDate, 
           @DurationTime, @AccessEndDate); 
 
       PRINT 'Webinar dodany poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--2. Dodawanie nowego pracownika  
CREATE PROCEDURE AddEmployee 
   @FirstName VARCHAR(50), 
   @LastName VARCHAR(50), 
   @Phone VARCHAR(50), 
   @Email VARCHAR(15), 
   @EmployeeType INT 
AS 
BEGIN 
   BEGIN TRY 
       IF NOT EXISTS ( 
           SELECT 1 
           FROM EmployeeTypes 
           WHERE EmployeeType = @EmployeeType 
       ) 
       BEGIN 
           THROW 50004, 'Nieprawidłowy rodzaj pracownika.', 1; 
       END 
 
       INSERT INTO Employees (FirstName, LastName, Phone, Email, EmployeeType) 
       VALUES (@FirstName, @LastName, @Phone, @Email, @EmployeeType); 
 
       PRINT 'Pracownik został dodany pomyślnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--3. Dodawanie studenta 
CREATE PROCEDURE dbo.AddStudent 
   @FirstName VARCHAR(50), 
   @LastName VARCHAR(50), 
   @Address VARCHAR(50), 
   @PostalCode VARCHAR(15), 
   @Email VARCHAR(50), 
   @Phone VARCHAR(15) 
AS 
BEGIN 
   BEGIN TRY 
       INSERT INTO dbo.Students (FirstName, LastName, Address, PostalCode, Phone, Email) 
       VALUES (@FirstName, @LastName, @Address, @PostalCode, @Phone, @Email); 
 
       PRINT 'Student dodany poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW 50000, 'Wystąpił błąd podczas dodawania studenta.', 1; 
   END CATCH 
END; 
go 
 
--4. Dodawanie studiów 
CREATE PROCEDURE AddStudy 
   @StudiesName VARCHAR(50), 
   @StudiesCoordinator INT, 
   @StudiesFee MONEY, 
   @StudiesLimit INT 
AS 
BEGIN 
   BEGIN TRY 
       IF NOT EXISTS (SELECT 1 FROM Employees e 
                      JOIN dbo.EmployeeTypes et ON e.EmployeeType = et.EmployeeType 
                      WHERE EmployeeID = @StudiesCoordinator AND et.EmployeeTypeName LIKE 'Koordynator' 
       ) 
       BEGIN 
           THROW 50008, 'Koordynator o podanym ID nie istnieje.', 1; 
       END 
 
       IF @StudiesFee IS NULL 
       BEGIN 
           SET @StudiesFee = 1000; 
       END 
 
       INSERT INTO Studies (StudiesName, StudiesCoordinator, StudiesFee, StudiesLimit) 
       VALUES (@StudiesName, @StudiesCoordinator, @StudiesFee, @StudiesLimit); 
 
       PRINT 'Studia dodane poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--5. Dodawanie nowych kursów 
CREATE PROCEDURE [dbo].[AddCourse] 
   @CourseName VARCHAR(50), 
   @CoursePrice MONEY, 
   @CourseCoordinatorID INT, 
   @CourseType VARCHAR(50) 
AS 
BEGIN 
   IF NOT EXISTS ( 
       SELECT 1 
       FROM Employees e 
       JOIN dbo.EmployeeTypes et ON e.EmployeeType = et.EmployeeType 
       WHERE e.EmployeeID = @CourseCoordinatorID AND et.EmployeeTypeName LIKE 'Koordynator' 
   ) 
   BEGIN 
       THROW 50001, 'Koordynator o podanym ID nie istnieje.', 1; 
   END 
 
   INSERT INTO Courses (CourseName, CoursePrice, CourseCoordinatorID, CourseType) 
   VALUES (@CourseName, @CoursePrice, @CourseCoordinatorID, @CourseType); 
 
   PRINT 'Kurs dodany pomyślnie.'; 
END; 
go 

--6. Dodawanie modułu kursu (do CourseModules oraz ModuleDetails) 
CREATE PROCEDURE AddCourseModuleWithDetails 
   @CourseID INT, 
   @LanguageID INT, 
   @ModuleName VARCHAR(50), 
   @Room VARCHAR(50), 
   @Video VARCHAR(50), 
   @Link VARCHAR(50), 
   @DurationTime VARCHAR(50), 
   @AccessEndDate DATE, 
   @CourseDate DATE, 
   @ModuleType VARCHAR(50) 
AS 
BEGIN 
   BEGIN TRY 
       BEGIN TRANSACTION; 
 
       IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE CourseID = @CourseID) 
       BEGIN 
           THROW 50000, 'Kurs o podanym ID nie istnieje.', 1; 
       END 
 
       DECLARE @NewModuleID INT; 
 
       SELECT @NewModuleID = ISNULL(MAX(ModuleID), 0) + 1 
       FROM dbo.ModulesDetails WITH (UPDLOCK, HOLDLOCK); 
       INSERT INTO dbo.ModulesDetails ( 
           ModuleID, 
           ModuleName, 
           Room, 
           Video, 
           Link, 
           DurationTime, 
           AccessEndDate, 
           CourseDate, 
           ModuleType 
       ) 
       VALUES ( 
           @NewModuleID, 
           @ModuleName, 
           @Room, 
           @Video, 
           @Link, 
           @DurationTime, 
           @AccessEndDate, 
           @CourseDate, 
           @ModuleType 
       ); 
 
       INSERT INTO dbo.CourseModules (ModuleID, CourseID, LanguageID) 
       VALUES (@NewModuleID, @CourseID, @LanguageID); 
 
       COMMIT TRANSACTION; 
 
       PRINT 'Moduł kursu i jego szczegóły zostały dodane poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       ROLLBACK TRANSACTION; 
       THROW; 
   END CATCH 
END; 
go 
 
--7. Dodawanie języka do bazy 
CREATE PROCEDURE AddLanguage 
@LanguageName VARCHAR(50) 
AS 
BEGIN 
BEGIN TRY 
INSERT INTO dbo.Languages (LanguageName) 
VALUES (@LanguageName); 
PRINT 'Język dodany poprawnie.'; 
END TRY 
BEGIN CATCH 
THROW 50006, 'Wystąpił błąd podczas dodawania języka.', 1; 
END CATCH 
END; 
go 
8. Dodawanie praktyk 
CREATE PROCEDURE AddInternship 
@InternshipID INT, 
@StudiesID INT, 
@StudentID INT, 
@StartDate DATE, 
@EndDate DATE, 
@InternshipStatus VARCHAR(50) 
AS 
BEGIN 
BEGIN TRY 
INSERT INTO Internships (InternshipID, StudiesID, StudentID, StartDate, EndDate, InternshipStatus) 
VALUES (@InternshipID, @StudiesID, @StudentID, @StartDate, @EndDate, @InternshipStatus); 
PRINT 'Praktyki dodane poprawnie.'; 
END TRY 
BEGIN CATCH 
THROW 50003, 'Wystąpił błąd podczas dodawania praktyk.', 1; 
END CATCH 
END; 
go  
 
--9.  Dodawanie zamówienia 
CREATE PROCEDURE AddOrder 
   @StudentID INT, 
   @OrderStatus VARCHAR(50), 
   @OrderDate DATE, 
   @PayingDate DATE, 
   @Details NVARCHAR(MAX) -- Format: 'w:webinarID1,webinarID2;c:courseID1,courseID2;m:meetingID1;s:studyID1,studyID2' 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 50001, 'Student nie istnieje.', 1; 
       END; 
 
       -- Dodanie zamówienia 
       INSERT INTO dbo.Orders (StudentID, OrderStatus, OrderDate) 
       VALUES (@StudentID, @OrderStatus, @OrderDate); 
 
       DECLARE @NewOrderID INT = SCOPE_IDENTITY(); 
       DECLARE @CurrentOrderDetailsID INT = (SELECT ISNULL(MAX(OrderDetailsID), 0) FROM dbo.OrderDetails); 
 
       -- Rozdzielenie szczegółów na części 
       IF (@Details IS NOT NULL AND @Details <> '') 
       BEGIN 
           -- Procesowanie webinarów 
           DECLARE @WebinarDetails NVARCHAR(MAX) = (SELECT value 
                                                    FROM STRING_SPLIT(@Details, ';') 
                                                    WHERE LEFT(value, 2) = 'w:'); 
           IF (@WebinarDetails IS NOT NULL) 
           BEGIN 
               EXEC ProcessOrderDetails @WebinarDetails, 'w', @NewOrderID, @PayingDate, @CurrentOrderDetailsID OUTPUT; 
           END; 
 
           -- Procesowanie kursów 
           DECLARE @CourseDetails NVARCHAR(MAX) = (SELECT value 
                                                   FROM STRING_SPLIT(@Details, ';') 
                                                   WHERE LEFT(value, 2) = 'c:'); 
           IF (@CourseDetails IS NOT NULL) 
           BEGIN 
               EXEC ProcessOrderDetails @CourseDetails, 'c', @NewOrderID, @PayingDate, @CurrentOrderDetailsID OUTPUT; 
           END; 
 
           -- Procesowanie spotkań 
           DECLARE @MeetingDetails NVARCHAR(MAX) = (SELECT value 
                                                    FROM STRING_SPLIT(@Details, ';') 
                                                    WHERE LEFT(value, 2) = 'm:'); 
           IF (@MeetingDetails IS NOT NULL) 
           BEGIN 
               EXEC ProcessOrderDetails @MeetingDetails, 'm', @NewOrderID, @PayingDate, @CurrentOrderDetailsID OUTPUT; 
           END; 
 
           -- Procesowanie studiów 
           DECLARE @StudyDetails NVARCHAR(MAX) = (SELECT value 
                                                  FROM STRING_SPLIT(@Details, ';') 
                                                  WHERE LEFT(value, 2) = 's:'); 
           IF (@StudyDetails IS NOT NULL) 
           BEGIN 
               EXEC ProcessOrderDetails @StudyDetails, 's', @NewOrderID, @PayingDate, @CurrentOrderDetailsID OUTPUT; 
           END; 
       END; 
 
       PRINT 'Zamówienie wraz z wpisami w szczegółach dodane poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 
 
--10.  Dodawanie studenta do kursu - Student Courses 
CREATE PROCEDURE AddStudentCourse 
   @CourseID INT, 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       IF NOT EXISTS (SELECT 1 FROM dbo.[Courses] WHERE CourseID = @CourseID) 
       BEGIN 
           THROW 50002, 'Kurs nie istnieje.', 1; 
       END; 
 
       IF NOT EXISTS (SELECT 1 FROM dbo.[Students] WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 50003, 'Student nie istnieje.', 1; 
       END; 
 
       INSERT INTO dbo.StudentCourses (CourseID, StudentID) 
       VALUES (@CourseID, @StudentID); 
 
       PRINT 'Student dodany do kursu poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go

--11. Dodawanie obecności do StudentMeetingAttendance 
CREATE PROCEDURE AddStudentMeetingAttendance 
   @MeetingID INT, 
   @StudentID INT, 
   @Attendance VARCHAR(10) 
AS 
BEGIN 
   BEGIN TRY 
       IF NOT EXISTS (SELECT 1 FROM dbo.StudyMeeting WHERE MeetingID = @MeetingID) 
       BEGIN 
           THROW 50004, 'Meeting nie istnieje.', 1; 
       END; 
 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 50005, 'Student nie istnieje.', 1; 
       END; 
 
       INSERT INTO dbo.StudentMeetingAttendance (MeetingID, StudentID, Attendance) 
       VALUES (@MeetingID, @StudentID, @Attendance); 
 
       PRINT 'Attendance record dodany poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--12. Dodawanie studentowi ocen ze studiów 
CREATE PROCEDURE AddStudentSubjectGrade 
   @SubjectID INT, 
   @Grade INT, 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy przedmiot istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Subjects WHERE SubjectID = @SubjectID) 
       BEGIN 
           THROW 50006, 'Subject nie istnieje.', 1; 
       END; 
 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 50007, 'Student nie istnieje.', 1; 
       END; 
 
       -- Dodanie oceny 
       INSERT INTO dbo.StudentSubjectGrades (SubjectID, Grade, StudentID) 
       VALUES (@SubjectID, @Grade, @StudentID); 
 
       PRINT 'Grade dodany poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--13. Dodawanie studenta do webinaru 
CREATE PROCEDURE AddStudentWebinar 
   @WebinarID INT, 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy webinar istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.StudyMeeting WHERE MeetingID = @WebinarID) 
       BEGIN 
           THROW 50008, 'Webinar nie istnieje.', 1; 
       END; 
 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 50009, 'Student nie istnieje.', 1; 
       END; 
 
       -- Dodanie studenta do webinaru 
       INSERT INTO dbo.StudentWebinars (WebinarID, StudentID) 
       VALUES (@WebinarID, @StudentID); 
 
       PRINT 'Student dodany do webinaru poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--14. Dodawanie spotkania do StudyMeeting 
CREATE PROCEDURE AddStudyMeeting 
   @SubjectID INT, 
   @TeacherID INT, 
   @LanguageID INT, 
   @MeetingName VARCHAR(50), 
   @MeetingPrice MONEY, 
   @Date DATE, 
   @TranslatorID INT, 
   @Limit INT, 
   @Room VARCHAR(50), 
   @Video VARCHAR(50), 
   @Link VARCHAR(50) 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy przedmiot istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Subjects WHERE SubjectID = @SubjectID) 
       BEGIN 
           THROW 50010, 'Subject nie istnieje.', 1; 
       END; 
 
       -- Sprawdzenie, czy nauczyciel istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmployeeID = @TeacherID) 
       BEGIN 
           THROW 50011, 'Teacher nie istnieje.', 1; 
       END; 
 
       -- Sprawdzenie, czy język istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Languages WHERE LanguageID = @LanguageID) 
       BEGIN 
           THROW 50012, 'Language nie istnieje.', 1; 
       END; 
 
       -- Dodanie spotkania 
       INSERT INTO dbo.StudyMeeting (SubjectID, TeacherID, LanguageID, MeetingName, MeetingPrice, Date, 
TranslatorID, Limit, Room, Video, Link) 
       VALUES ( @SubjectID, @TeacherID, @LanguageID, @MeetingName, @MeetingPrice, @Date, @TranslatorID, @Limit, 
@Room, @Video, @Link); 
 
       PRINT 'Study meeting dodany poprawnie.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--15. Raport zamówień dla studenta 
CREATE PROCEDURE GetStudentOrders 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 60002, 'Student nie istnieje.', 1; 
       END; 
 
       -- Pobranie raportu zamówień z widoku ORDER_SUMMARY 
       SELECT * 
       FROM ORDER_SUMMARY 
       WHERE StudentID = @StudentID 
       ORDER BY OrderID; 
 
   END TRY 
   BEGIN CATCH 
       -- Obsługa błędów 
       THROW; 
   END CATCH 
END; 
go 

--16. Usuwanie studenta z webinarów i kursów  
CREATE PROCEDURE RemoveStudentFromCourseAndWebinars 
   @StudentID INT, 
   @CourseID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy student jest zapisany na kurs 
       IF NOT EXISTS (SELECT 1 FROM dbo.StudentCourses WHERE StudentID = @StudentID AND CourseID = @CourseID) 
       BEGIN 
           THROW 60004, 'Student nie jest zapisany na ten kurs.', 1; 
       END; 
 
       -- Usunięcie studenta z kursu 
       DELETE FROM dbo.StudentCourses WHERE StudentID = @StudentID AND CourseID = @CourseID; 
 
       -- Usunięcie studenta z webinarów powiązanych z kursem 
       DELETE sw 
       FROM dbo.StudentWebinars sw 
       INNER JOIN dbo.StudyMeeting sm ON sw.WebinarID = sm.MeetingID 
       WHERE sm.SubjectID IN (SELECT SubjectID FROM dbo.Subjects WHERE StudiesID IN 
                              (SELECT StudiesID FROM dbo.Courses WHERE CourseID = @CourseID)) 
         AND sw.StudentID = @StudentID; 
 
       PRINT 'Student usunięty z kursu i powiązanych webinarów.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--17. Podsumowanie obecności na kursach i modułach 
CREATE PROCEDURE GetStudentAttendanceSummary 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 60005, 'Student nie istnieje.', 1; 
       END; 
 
       SELECT 
           c.CourseName, 
           md.ModuleName, 
           sma.Attendance AS ModuleAttendance, 
           sm.Attendance AS MeetingAttendance 
       FROM 
           dbo.StudentModulesAttendance sma 
       INNER JOIN 
           dbo.ModulesDetails md ON sma.ModuleID = md.ModuleID 
       INNER JOIN 
           dbo.CourseModules cm ON md.ModuleID = cm.ModuleID 
       INNER JOIN 
           dbo.Courses c ON cm.CourseID = c.CourseID 
       LEFT JOIN 
           dbo.StudentMeetingAttendance sm ON sm.MeetingID = md.ModuleID 
       WHERE 
           sma.StudentID = @StudentID; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 

--18. Raport zamówień dla danego studenta 
CREATE PROCEDURE GetStudentOrders 
   @StudentID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 60002, 'Student nie istnieje.', 1; 
       END; 
 
       -- Pobranie raportu zamówień z widoku ORDER_SUMMARY 
       SELECT * 
       FROM ORDER_SUMMARY 
       WHERE StudentID = @StudentID 
       ORDER BY OrderID; 
 
   END TRY 
   BEGIN CATCH 
       -- Obsługa błędów 
       THROW; 
   END CATCH 
END; 
go 

--19. Plan zajęć dla danego studenta 
CREATE PROCEDURE GetStudentTimetable 
   @StudentID INT 
AS 
BEGIN 
   -- Sprawdzanie dla bezpieczeństwa: jeśli brak ID, zwraca brak wyników 
   IF @StudentID IS NULL 
   BEGIN 
       PRINT 'StudentID cannot be NULL'; 
       RETURN; 
   END; 
 
   -- Pobranie danych dla danego studenta 
   SELECT 
          StudentID, 
          FirstName, 
          LastName, 
          EventID, 
          EventName, 
          EventDate, 
          AttendanceStatus 
   FROM ATTENDANCE_LIST 
   WHERE StudentID = @StudentID 
   ORDER BY EventDate; 
END; 
go
 
--20. Plan zajęć dla danego studenta od podanej daty 
CREATE PROCEDURE GetStudentTimetableFromDate 
   @StudentID INT, 
   @StartDate DATE 
AS 
BEGIN 
   BEGIN TRY 
       -- Sprawdzenie, czy StudentID i StartDate są niepuste 
       IF @StudentID IS NULL 
       BEGIN 
           THROW 60001, 'StudentID nie może być NULL.', 1; 
       END; 
 
       IF @StartDate IS NULL 
       BEGIN 
           THROW 60002, 'StartDate nie może być NULL.', 1; 
       END; 
 
       -- Sprawdzenie, czy student istnieje 
       IF NOT EXISTS (SELECT 1 FROM dbo.Students WHERE StudentID = @StudentID) 
       BEGIN 
           THROW 60003, 'Student o podanym ID nie istnieje.', 1; 
       END; 
 
       -- Pobranie danych dla danego studenta od podanej daty 
       SELECT 
              StudentID, 
              FirstName, 
              LastName, 
              EventID, 
              EventName, 
              EventDate, 
              AttendanceStatus 
       FROM ATTENDANCE_LIST 
       WHERE StudentID = @StudentID 
         AND EventDate >= @StartDate 
       ORDER BY EventDate; 
 
   END TRY 
   BEGIN CATCH 
       THROW ; 
   END CATCH 
END; 
go 

--21. Anulowanie zamówienia  
CREATE PROCEDURE CancelOrder 
   @OrderID INT 
AS 
BEGIN 
   BEGIN TRY 
       -- Usuwanie powiązanych wpisów w pokrewnych tabelach na podstawie OrderDetailsID 
       DELETE FROM dbo.OrderedWebinars 
       WHERE OrderDetailsID IN (SELECT OrderDetailsID FROM dbo.OrderDetails WHERE OrderID = @OrderID); 
 
       DELETE FROM dbo.OrderedCourses 
       WHERE OrderDetailsID IN (SELECT OrderDetailsID FROM dbo.OrderDetails WHERE OrderID = @OrderID); 
 
       DELETE FROM dbo.OrderedStudyMeetings 
       WHERE OrderDetailsID IN (SELECT OrderDetailsID FROM dbo.OrderDetails WHERE OrderID = @OrderID); 
 
       DELETE FROM dbo.OrderedStudies 
       WHERE OrderDetailsID IN (SELECT OrderDetailsID FROM dbo.OrderDetails WHERE OrderID = @OrderID); 
 
       -- Usuwanie wpisów w OrderDetails 
       DELETE FROM dbo.OrderDetails 
       WHERE OrderID = @OrderID; 
 
       -- Aktualizacja statusu w tabeli Orders 
       UPDATE dbo.Orders 
       SET OrderStatus = 'Canceled' 
       WHERE OrderID = @OrderID; 
 
       PRINT 'Zamówienie i powiązane szczegóły zostały anulowane.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 
 
--22. Pobieranie statystyk przyszłych spotkań w danym czasie 
CREATE PROCEDURE dbo.GetFutureMeetingStats 
   @StartDate date, 
   @EndDate date 
AS 
BEGIN 
   SELECT * 
   FROM FUTURE_MEETING_STATS 
   WHERE MeetingDate BETWEEN @StartDate AND @EndDate 
   ORDER BY MeetingDate; 
END; 
go 

--23. Opłacanie zamówienia 
 
CREATE PROCEDURE PayOrder 
   @OrderID INT, 
   @PayDate DATE 
AS 
BEGIN 
   BEGIN TRY 
       -- Aktualizacja statusu zamówienia na "Paid" 
       UPDATE dbo.Orders 
       SET OrderStatus = 'Paid' 
       WHERE OrderID = @OrderID; 
 
       -- Ustawianie daty płatności w OrderDetails 
       UPDATE dbo.OrderDetails 
       SET PayingDate = @PayDate 
       WHERE OrderID = @OrderID; 
 
       PRINT 'Zamówienie zostało oznaczone jako opłacone.'; 
   END TRY 
   BEGIN CATCH 
       THROW; 
   END CATCH 
END; 
go 
 
--24. Przetwarzanie detali zamówienia 
CREATE PROCEDURE ProcessOrderDetails 
   @Details NVARCHAR(MAX), 
   @DetailType NVARCHAR(1), 
   @OrderID INT, 
   @PayingDate DATE, 
   @CurrentOrderDetailsID INT OUTPUT 
AS 
BEGIN 
   DECLARE @ID NVARCHAR(50); 
   DECLARE @IDs NVARCHAR(MAX); 
 
   -- Wyciągnięcie ID 
   SET @IDs = SUBSTRING(@Details, CHARINDEX(':', @Details) + 1, LEN(@Details)); 
 
   -- Iteracja przez ID 
   DECLARE @SplitIDs TABLE (ID NVARCHAR(50)); 
   INSERT INTO @SplitIDs (ID) 
   SELECT value FROM STRING_SPLIT(@IDs, ','); 
 
   DECLARE IDCursor CURSOR FOR 
   SELECT ID FROM @SplitIDs; 
 
   OPEN IDCursor; 
   FETCH NEXT FROM IDCursor INTO @ID; 
 
   WHILE @@FETCH_STATUS = 0 
   BEGIN 
       SET @CurrentOrderDetailsID = @CurrentOrderDetailsID + 1; 
 
       -- Dodanie wpisu w OrderDetails 
       INSERT INTO dbo.OrderDetails (OrderDetailsID, OrderID, PayingDate) 
       VALUES (@CurrentOrderDetailsID, @OrderID, @PayingDate); 
 
       -- Dodanie do odpowiednich tabel na podstawie typu szczegółów 
       IF @DetailType = 'w' 
       BEGIN 
           INSERT INTO dbo.OrderedWebinars (OrderDetailsID, WebinarID, Price) 
           SELECT @CurrentOrderDetailsID, CAST(@ID AS INT), WebinarPrice 
           FROM dbo.Webinars 
           WHERE WebinarID = CAST(@ID AS INT); 
       END 
       ELSE IF @DetailType = 'c' 
       BEGIN 
           INSERT INTO dbo.OrderedCourses (OrderDetailsID, CourseID, Price) 
           SELECT @CurrentOrderDetailsID, CAST(@ID AS INT), CoursePrice 
           FROM dbo.Courses 
           WHERE CourseID = CAST(@ID AS INT); 
       END 
       ELSE IF @DetailType = 'm' 
       BEGIN 
           INSERT INTO dbo.OrderedStudyMeetings (OrderDetailsID, StudyMeetingID, Price) 
           SELECT @CurrentOrderDetailsID, CAST(@ID AS INT), MeetingPrice 
           FROM dbo.StudyMeeting 
           WHERE MeetingID = CAST(@ID AS INT); 
       END 
       ELSE IF @DetailType = 's' 
       BEGIN 
           INSERT INTO dbo.OrderedStudies (OrderDetailsID, StudiesID, Price) 
           SELECT @CurrentOrderDetailsID, CAST(@ID AS INT), StudiesFee 
           FROM dbo.Studies 
           WHERE StudiesID = CAST(@ID AS INT); 
       END; 
 
       FETCH NEXT FROM IDCursor INTO @ID; 
   END 
 
   CLOSE IDCursor; 
   DEALLOCATE IDCursor; 
END; 
go 