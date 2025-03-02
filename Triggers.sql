--1. Dodawanie Studenta do webinaru po jego zakupieniu 
CREATE TRIGGER [dbo].[trg_AddStudentToWebinar] 
ON OrderedWebinars 
AFTER INSERT 
AS 
BEGIN 
    IF EXISTS ( 
        SELECT StudentID 
        FROM inserted 
        INNER JOIN OrderDetails ON inserted.OrderDetailsID = OrderDetails.OrderDetailsID 
        INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID 
        WHERE StudentID IN ( 
            SELECT DISTINCT StudentID 
            FROM inserted 
            INNER JOIN StudentWebinars ON inserted.WebinarID = StudentWebinars.WebinarID 
        ) 
    ) 
    BEGIN 
        THROW 51000, 'Student o podanym ID jest już zapisany na ten webinar.', 1; 
    END 
    ELSE 
    BEGIN 
        INSERT INTO StudentWebinars (StudentID, WebinarID) 
        SELECT Orders.StudentID, inserted.WebinarID 
        FROM inserted 
        INNER JOIN OrderDetails ON inserted.OrderDetailsID = OrderDetails.OrderDetailsID 
        INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID 
    END 
END; 
 
--2. Automatyczne dodawanie studenta do studiów i odpowiednich spotkań 
--studyjnych po jego zakupieniu 
 CREATE TRIGGER [dbo].[trg_AddStudentToStudy] 
ON OrderedStudies 
AFTER INSERT 
AS 
BEGIN 
    IF EXISTS ( 
        SELECT StudentID 
        FROM inserted 
        INNER JOIN OrderDetails ON inserted.OrderDetailsID = OrderDetails.OrderDetailsID 
        INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID 
        WHERE StudentID IN ( 
            SELECT DISTINCT StudentID 
            FROM inserted 
            INNER JOIN StudiesDetails ON inserted.StudiesID = StudiesDetails.StudiesID 
        ) 
    ) 
    BEGIN 
        THROW 51001, 'Student o podanym ID jest już zapisany na te studia.', 1; 
    END 
    ELSE IF EXISTS ( 
        SELECT StudentID 
        FROM inserted 
        INNER JOIN OrderDetails ON inserted.OrderDetailsID = OrderDetails.OrderDetailsID 
        INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID 
        WHERE dbo.IsStudentInAnyStudyMeeting(StudentID, inserted.StudiesID) = 1 
    ) 
    BEGIN 
        THROW 51002, 'Student o podanym ID jest zapisany na jedno ze spotkań tych studiów.', 1; 
    END 
    ELSE 
    BEGIN 
        DECLARE @StudentID int; 
         
        SELECT @StudentID = Orders.StudentID 
        FROM inserted 
        INNER JOIN OrderDetails ON inserted.OrderDetailsID = OrderDetails.OrderDetailsID 
        INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID; 
 
        INSERT INTO StudiesDetails ( 
            StudiesID,  
            StudentID,  
            StudiesGrade 
        ) 
        SELECT  
            inserted.StudiesID,  
            @StudentID,  
            2 
        FROM inserted; 
 
        INSERT INTO StudyMeetingDetails ( 
            StudyMeetingID,  
            StudentID,  
            Presence 
        ) 
        SELECT  
            StudyMeeting.StudyMeetingID,  
            @StudentID,  
            0 
        FROM inserted 
        INNER JOIN Subject ON inserted.StudiesID = Subject.StudiesID 
        INNER JOIN StudyMeeting ON Subject.SubjectID = StudyMeeting.SubjectID; 
    END 
END;