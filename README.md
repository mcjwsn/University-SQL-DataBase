# University-MSSQL-DataBase

## SQL DataBase Project implemented in team:

Maciej Wiśniewski [mcjwsn](https://github.com/mcjwsn)

Konrad Szymański [Konradajew](https://github.com/Konradajew)

Kajetan Frątczak [KajetanFratczak](https://github.com/KajetanFratczak)

Task description:

Database Systems 2024/2025 - Project

Introduction

You have been tasked with designing a database system for a company offering various courses and training programs. Initially, services were provided only in-person, but due to the COVID-19 pandemic, they were digitized to varying degrees. Currently, the service delivery model is hybrid but highly inconsistent across different services.

The offered services are divided into:

1. Webinars

Conducted live on one of the popular cloud platforms and recorded for participants, who can access them for 30 days.

Binary data is not stored in the database system – recordings are stored externally.

Each webinar can be free or paid. Paid webinars require purchasing access (also for 30 days). Free webinars are publicly available. All webinars are stored indefinitely (but can be deleted by an administrator).

Access to a webinar requires an account and payment confirmation (for paid webinars).

2. Courses

Short training programs lasting several days, only available as paid courses. Completion requires passing at least 80% of the modules. Modules can be:

In-person – conducted synchronously in an assigned classroom, attendance-based completion.

Online synchronous – conducted live on the webinar platform, participation required. Like webinars, sessions are recorded and stored externally. Completion is attendance-based.

Online asynchronous – completion based on watching the provided recording (automatic verification).

Hybrid – combining online and in-person approaches (e.g., two recordings and two in-person days).

3. Studies

Long-term (several years) education programs consisting of both online and in-person sessions (similar to courses). Additionally, they require internships twice a year and conclude with a final exam.

The curriculum (syllabus) must be defined before the start and cannot be modified.

The schedule for each semester must be known before the semester begins but should allow for changes due to unforeseen circumstances.

Attendance of at least 80% is required. Absences can be made up by attending a similar class or commercial course.

Internships last 14 days and require 100% attendance.

Sessions can be in-person, online, or hybrid.

It is possible to enroll in individual study sessions without committing to the full program. The price for external participants differs from regular students.

Integration with the Payment System

The payment system is provided by an external company – its implementation should be omitted.

Participants can add products to their cart (one or more). A payment link is generated for each order. Upon payment completion, the system receives a success/failure notification.

Webinar access is granted upon payment (even just before the session starts).

Course enrollment requires a deposit at registration and full payment at least three days before the course starts. Full payment upfront is also possible.

Study enrollment requires a registration fee (varies per study program) and payment for each session at least three days before it starts.

Exceptions to rules 3-5 may be granted by the School Director (e.g., deferred payment for regular customers).

Reporting

The system should support frequently used reports via predefined views:

Financial reports – revenue breakdown per webinar/course/study program.

Debtors list – individuals who used services but did not pay.

General enrollment report – number of enrolled participants for future events (including in-person vs. online).

Attendance report for past events.

Attendance list for each training session, including date, name, surname, and presence status.

Conflict report – participants enrolled in at least two overlapping future training sessions.

Additional Information

All educational formats are conducted by an assigned instructor in a specified language (most commonly Polish).

Some educational formats are live-translated into Polish – in such cases, translator details must be provided.

Webinars and online courses have no attendance limits. Hybrid and in-person courses have variable attendance limits.

Studies also have a participant limit (which may be lower than the limit for individual study sessions – some sessions may allow more external attendees, while others may not allow any). The overall study program limit cannot exceed the smallest session limit.

Upon completion of each course and study program, participants receive a diploma (if they attended). The diploma must be sent via postal mail to the provided correspondence address.

Required Project Elements

Proposal of system functions and user roles with permissions (short list).

Database design.

Database definition.

Data generation.

Integrity constraints: default values, valid ranges, uniqueness, nullable fields, complex constraints.

Proposal and definition of views for data access – views should present relevant information for users and various reports.

Proposal and definition of data operations (stored procedures, triggers, functions) – stored procedures should handle data entry (including configuration changes), functions should return key quantitative information, and triggers should ensure consistency and meet specific client requirements.

Proposal and definition of indexes.

Proposal and definition of data access permissions – roles and their privileges for operations, views, and procedures.

Project Report Requirements

Description of system functions and user roles.

Database schema (diagram) + table descriptions (field names, data types, meaning, integrity constraints, and table creation code).

List of views with their creation code and descriptions.

List of stored procedures, triggers, functions with code and descriptions.

Information on generated data.

Definition of data access permissions – roles and their access rights.

List of indexed fields.

Implementation Requirements

The project must be implemented using MS SQL Server.

Grading Criteria

The task is graded on a 0-10 point scale:

4 points for the database schema.

1 point for integrity constraints.

4 points for stored procedures, triggers, and views.

1 point for other aspects (indexes, permissions, etc.).

The final score is converted into a grade based on the AGH grading scale.

Graded 9.5/10
