CREATE DATABASE soLienLac2;
GO

USE soLienLac2;
GO

select * from Users where UserId=43
select * from Classes where 
select * from Teacher
select * from Students where UserId=43
select * from Students where ClassId=65
select * from LeaveRequests where TeacherId=5


CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY, 
    Username NVARCHAR(50) NOT NULL,
    Password NVARCHAR(50) NOT NULL,
    UserType INT NOT NULL
);

CREATE TABLE Staff (
    StaffId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    Name NVARCHAR(100) NULL,
    Position NVARCHAR(50) NULL,
    Email NVARCHAR(100) NULL, 
    Phone NVARCHAR(20) NULL
);

CREATE TABLE Parents (
    ParentId INT IDENTITY(9,1) PRIMARY KEY,
    UserId INT,
	Name NVARCHAR(50),
    Email NVARCHAR(100) NULL
);

CREATE TABLE Teacher (
    TeacherId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    Name NVARCHAR(50),
    SubjectTC NVARCHAR(50),
    SDT NVARCHAR(20)
);

CREATE TABLE Subject (
    SubjectId INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(50) NOT NULL
);

CREATE TABLE SubjectTeacher (
    SubjectTeacherId INT IDENTITY(1,1) PRIMARY KEY,
    TeacherId INT,
    SubjectId INT,
    
);

CREATE TABLE Grades(
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    Grade INT,
    AcademicYear INT
);

CREATE TABLE Classes (
    ClassId INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(50),
    TeacherId INT,
    AcademicYear INT,
    GradeId INT
);

CREATE TABLE Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    Name NVARCHAR(100),
    DateOfBirth DATE,
    ClassId INT,
    SDTPH NVARCHAR(20)
);

CREATE TABLE Timetable (
    TimetableId INT IDENTITY(1,1) PRIMARY KEY,
    ClassId INT,
    Weekdays INT,
    Times NVARCHAR(50),
    Date DATE, 
    TeacherId INT
);

CREATE TABLE Score (
    ScoreId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT,
    ClassId INT,
    TeacherId INT,
    Scores NVARCHAR(MAX), 
	Score15 DECIMAL(18, 0),
	Score60 DECIMAL(18, 0),
	GiuaKi DECIMAL(18, 0),
	CuoiKi DECIMAL(18, 0),
	TongKet DECIMAL(18, 0),
    SubjectTC NVARCHAR(50),
    Semester INT,
    Status NVARCHAR(50) NULL
);

CREATE TABLE LeaveRequests (
    RequestId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT,
    TeacherId INT,
    Reason NVARCHAR(MAX),
    RequestDate DATETIME,
    ApprovalStatus NVARCHAR(50)

);

--bảng giáo viên chủ nhiệm 
CREATE TABLE TeacherClassAssignment (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    TeacherId INT,
    ClassId INT,
    IsHeadTeacher INT
    
);

--liên kết giữa học sinh và phụ huynh
CREATE TABLE ParentStudentRelationship (
    RelationshipId INT IDENTITY(1,1) PRIMARY KEY,
    ParentId INT,
    StudentId INT
    
);

CREATE TABLE Messages (
    MessageId INT IDENTITY(1,1) PRIMARY KEY,
    SenderId INT,
    ReceiverId INT,
    Content NVARCHAR(MAX),
    Timestamp DATETIME,
    SenderType INT NOT NULL,
    ReceiverType INT NOT NULL
);

CREATE TABLE Chats (
    ChatId INT IDENTITY(1,1) PRIMARY KEY,
    UserId1 INT,
    UserId2 INT,
    Timestamp DATETIME,
    UserType1 INT NOT NULL,
    UserType2 INT NOT NULL,
    Content NVARCHAR(MAX)
);

CREATE TABLE Notifications (
    NotificationId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    SenderId INT,
    NameContent NVARCHAR(MAX),
    Content NVARCHAR(MAX),
    Timestamp DATETIME
);

CREATE TABLE OtpRecords (
    Id INT PRIMARY KEY IDENTITY,
    PhoneNumber NVARCHAR(50),
    Otp NVARCHAR(10),
    CreatedAt DATETIME
);

ALTER TABLE Staff
ADD CONSTRAINT FK_Staff_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE Parents
ADD CONSTRAINT FK_Parents_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE Teacher
ADD CONSTRAINT FK_Teacher_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE Classes
ADD CONSTRAINT FK_Classes_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId),
    CONSTRAINT FK_Classes_GradeId FOREIGN KEY (GradeId) REFERENCES Grades(GradeID);

ALTER TABLE Students
ADD CONSTRAINT FK_Students_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Students_ClassId FOREIGN KEY (ClassId) REFERENCES Classes(ClassId);

ALTER TABLE Timetable
ADD CONSTRAINT FK_Timetable_ClassId FOREIGN KEY (ClassId) REFERENCES Classes(ClassId),
    CONSTRAINT FK_Timetable_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId);

ALTER TABLE Score
ADD CONSTRAINT FK_Score_StudentId FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_Score_ClassId FOREIGN KEY (ClassId) REFERENCES Classes(ClassId),
    CONSTRAINT FK_Score_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId);

ALTER TABLE Messages
ADD CONSTRAINT FK_Messages_SenderId FOREIGN KEY (SenderId) REFERENCES Users(UserId),
    CONSTRAINT FK_Messages_ReceiverId FOREIGN KEY (ReceiverId) REFERENCES Users(UserId);

ALTER TABLE Chats
ADD CONSTRAINT FK_Chats_UserId1 FOREIGN KEY (UserId1) REFERENCES Users(UserId),
    CONSTRAINT FK_Chats_UserId2 FOREIGN KEY (UserId2) REFERENCES Users(UserId);

ALTER TABLE Notifications
ADD CONSTRAINT FK_Notifications_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Notifications_SenderId FOREIGN KEY (SenderId) REFERENCES Users(UserId);

ALTER TABLE	SubjectTeacher
add	CONSTRAINT FK_SubjectTeacher_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId),
    CONSTRAINT FK_SubjectTeacher_SubjectId FOREIGN KEY (SubjectId) REFERENCES Subject(SubjectId);

ALTER TABLE LeaveRequests
add    CONSTRAINT FK_LeaveRequests_StudentId FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_LeaveRequests_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId);

	ALTER TABLE TeacherClassAssignment
add	CONSTRAINT FK_TeacherClassAssignment_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId),
    CONSTRAINT FK_TeacherClassAssignment_ClassId FOREIGN KEY (ClassId) REFERENCES Classes(ClassId);

ALTER TABLE ParentStudentRelationship
add CONSTRAINT FK_ParentStudentRelationship_ParentId FOREIGN KEY (ParentId) REFERENCES Parents(ParentId),
    CONSTRAINT FK_ParentStudentRelationship_StudentId FOREIGN KEY (StudentId) REFERENCES Students(StudentId);


INSERT INTO Users (Username, Password, UserType) VALUES
('us1', 'e08013363fa73566cefd0bd6c6988ed7', 0), -- phòng Đào Tạo
('us2', 'e08013363fa73566cefd0bd6c6988ed7', 0), 
('us3', 'e08013363fa73566cefd0bd6c6988ed7', 0), 
('us4', 'e08013363fa73566cefd0bd6c6988ed7', 0), 
('us5', 'e08013363fa73566cefd0bd6c6988ed7', 0),
('us6', 'e08013363fa73566cefd0bd6c6988ed7', 0),
('us7', 'e08013363fa73566cefd0bd6c6988ed7', 0),
('us8', 'e08013363fa73566cefd0bd6c6988ed7', 0);
INSERT INTO Users (Username, Password, UserType) VALUES
('PHnam', 'e08013363fa73566cefd0bd6c6988ed7', 1), -- Phụ huynh
('PHcuong', 'e08013363fa73566cefd0bd6c6988ed7', 1), 
('PHloc', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang', 'e08013363fa73566cefd0bd6c6988ed7', 1), 
('PHthuan', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong', 'e08013363fa73566cefd0bd6c6988ed7', 1), 
('PHloc', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang', 'e08013363fa73566cefd0bd6c6988ed7', 1), 
('PHthuan', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam3', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam4', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong5', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc5', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang5', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan5', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien5', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh2', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh6', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien7', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam8', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam9', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh10', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien11', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam12', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam13', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh14', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien15', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam16', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam17', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh18', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien19', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam20', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam21', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhuy22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduong22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhanh22', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien23', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam24', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnam25', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcuong26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHloc26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHquang26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuan26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtien26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngoc26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbinh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlam26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphuc26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHphat26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtam26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhoang26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHminh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHtrung26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhanh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHnhan26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHkhoa26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdung26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthao26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHviet26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHdao26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHvinh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHbao26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHha26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHanh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHchau26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHcam26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHhieu26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHthuy26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHduy26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHngan26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlinh26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlong26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHlan26', 'e08013363fa73566cefd0bd6c6988ed7', 1),
('PHgiang26', 'e08013363fa73566cefd0bd6c6988ed7', 1);
INSERT INTO Users (Username, Password, UserType) VALUES
('hau', 'e08013363fa73566cefd0bd6c6988ed7', 2), -- Giáo viên       
('cuong', 'e08013363fa73566cefd0bd6c6988ed7', 2),     
('nam', 'e08013363fa73566cefd0bd6c6988ed7', 2),
('tuan', 'e08013363fa73566cefd0bd6c6988ed7', 2),  
('thuan', 'e08013363fa73566cefd0bd6c6988ed7', 2), 
('tien', 'e08013363fa73566cefd0bd6c6988ed7', 2), 
('thinh', 'e08013363fa73566cefd0bd6c6988ed7', 2), 
('han', 'e08013363fa73566cefd0bd6c6988ed7', 2),         
('thanh', 'e08013363fa73566cefd0bd6c6988ed7', 2),
('quang', 'e08013363fa73566cefd0bd6c6988ed7', 2), 
('loc', 'e08013363fa73566cefd0bd6c6988ed7', 2),         
('quan', 'e08013363fa73566cefd0bd6c6988ed7', 2),
('hau', 'e08013363fa73566cefd0bd6c6988ed7', 2), 
('cu', 'e08013363fa73566cefd0bd6c6988ed7', 2),         
('phuong', 'e08013363fa73566cefd0bd6c6988ed7', 2);
INSERT INTO Staff (UserId, Name, Position, Email, Phone)
VALUES
    (1, N'Thậu', N'phục vụ', 'haudang2212@gmail.com', '123456789'),
    (2, N'Tcường', N'lao công', 'cuong12@gmail.com', '987654321'),
    (3, N'Tnam', N'phụ bếp', 'cuong12@gmail.com', '987654321'),
    (4, N'Nguyễn Văn D', N'Quản lý học vụ', 'nguyenvand@gmail.com', '0123456789'),
    (5, N'Trần Thị E', N'Nhân viên văn phòng', 'tranthie@gmail.com', '0987654321'),
    (6, N'Lê Văn F', N'Nhân viên hành chính', 'levanf@gmail.com', '0369852147'),
    (7, N'Phạm Thị G', N'Nhân viên tài chính', 'phamthig@gmail.com', '0246813579'),
    (8, N'Hoàng Văn H', N'Kế toán trưởng', 'hoangvanh@gmail.com', '0932147856');
INSERT INTO Parents (UserId, Name, Email)
VALUES 
    (9, 'PHnam', 'PHnam@gmail.com'),
    (10, 'PHcuong', 'PHcuong@gmail.com'),
    (11, 'PHloc', 'PHloc@gmail.com'),
    (12, 'PHquang', 'PHquang@gmail.com'),
    (13, 'PHthuan', 'PHthuan@gmail.com'),
    (14, 'PHtien', 'PHtien@gmail.com'),
    (15, 'PHcuong', 'PHcuong@gmail.com'),
    (16, 'PHloc', 'PHloc@gmail.com'),
    (17, 'PHquang', 'PHquang@gmail.com'),
    (18, 'PHthuan', 'PHthuan@gmail.com'),
    (19, 'PHtien', 'PHtien@gmail.com'),
    (20, 'PHtien', 'PHtien@gmail.com'),
    (21, 'PHngoc', 'PHngoc@gmail.com'),
    (22, 'PHbinh', 'PHbinh@gmail.com'),
    (23, 'PHlam', 'PHlam@gmail.com'),
    (24, 'PHphuc', 'PHphuc@gmail.com'),
    (25, 'PHphat', 'PHphat@gmail.com'),
    (26, 'PHtam', 'PHtam@gmail.com'),
    (27, 'PHhoang', 'PHhoang@gmail.com'),
    (28, 'PHminh', 'PHminh@gmail.com'),
    (29, 'PHtrung', 'PHtrung@gmail.com'),
    (30, 'PHkhanh', 'PHkhanh@gmail.com'),
    (31, 'PHnhan', 'PHnhan@gmail.com'),
    (32, 'PHkhoa', 'PHkhoa@gmail.com'),
    (33, 'PHdung', 'PHdung@gmail.com'),
    (34, 'PHthao', 'PHthao@gmail.com'),
    (35, 'PHviet', 'PHviet@gmail.com'),
    (36, 'PHdao', 'PHdao@gmail.com'),
    (37, 'PHvinh', 'PHvinh@gmail.com'),
    (38, 'PHbao', 'PHbao@gmail.com'),
    (39, 'PHha', 'PHha@gmail.com'),
    (40, 'PHanh', 'PHanh@gmail.com'),
    (41, 'PHchau', 'PHchau@gmail.com'),
    (42, 'PHcam', 'PHcam@gmail.com'),
    (43, 'PHhieu', 'PHhieu@gmail.com'),
    (44, 'PHthuy', 'PHthuy@gmail.com'),
    (45, 'PHduy', 'PHduy@gmail.com'),
    (46, 'PHngan', 'PHngan@gmail.com'),
    (47, 'PHlinh', 'PHlinh@gmail.com'),
    (48, 'PHlong', 'PHlong@gmail.com'),
    (49, 'PHlan', 'PHlan@gmail.com'),
    (50, 'PHgiang', 'PHgiang@gmail.com'),
    (51, 'PHhuy', 'PHhuy@gmail.com'),
    (52, 'PHduong', 'PHduong@gmail.com'),
    (53, 'PHhanh', 'PHhanh@gmail.com'),
    (54, 'PHnam2', 'PHnam2@gmail.com'),
    (55, 'PHcuong2', 'PHcuong2@gmail.com'),
    (56, 'PHloc2', 'PHloc2@gmail.com'),
    (57, 'PHquang2', 'PHquang2@gmail.com'),
    (58, 'PHthuan2', 'PHthuan2@gmail.com'),
    (59, 'PHtien2', 'PHtien2@gmail.com'),
    (60, 'PHcuong3', 'PHcuong3@gmail.com'),
    (61, 'PHloc3', 'PHloc3@gmail.com'),
    (62, 'PHquang3', 'PHquang3@gmail.com'),
    (63, 'PHthuan3', 'PHthuan3@gmail.com'),
    (64, 'PHtien3', 'PHtien3@gmail.com'),
    (65, 'PHnam3', 'PHnam3@gmail.com'),
    (66, 'PHcuong4', 'PHcuong4@gmail.com'),
    (67, 'PHloc4', 'PHloc4@gmail.com'),
    (68, 'PHquang4', 'PHquang4@gmail.com'),
    (69, 'PHthuan4', 'PHthuan4@gmail.com'),
    (70, 'PHtien4', 'PHtien4@gmail.com'),
    (71, 'PHnam4', 'PHnam4@gmail.com'),
    (72, 'PHcuong5', 'PHcuong5@gmail.com'),
    (73, 'PHloc5', 'PHloc5@gmail.com'),
    (74, 'PHquang5', 'PHquang5@gmail.com'),
    (75, 'PHthuan5', 'PHthuan5@gmail.com'),
    (76, 'PHtien5', 'PHtien5@gmail.com'),
    (77, 'PHngoc2', 'PHngoc2@gmail.com'),
    (78, 'PHbinh2', 'PHbinh2@gmail.com'),
    (79, 'PHlam2', 'PHlam2@gmail.com'),
    (80, 'PHphuc2', 'PHphuc2@gmail.com'),
    (81, 'PHphat2', 'PHphat2@gmail.com'),
    (82, 'PHtam2', 'PHtam2@gmail.com'),
    (83, 'PHhoang2', 'PHhoang2@gmail.com'),
    (84, 'PHminh2', 'PHminh2@gmail.com'),
    (85, 'PHtrung2', 'PHtrung2@gmail.com'),
    (86, 'PHkhanh2', 'PHkhanh2@gmail.com'),
    (87, 'PHnhan2', 'PHnhan2@gmail.com'),
    (88, 'PHkhoa2', 'PHkhoa2@gmail.com'),
    (89, 'PHdung2', 'PHdung2@gmail.com'),
    (90, 'PHthao2', 'PHthao2@gmail.com'),
    (91, 'PHviet2', 'PHviet2@gmail.com'),
    (92, 'PHdao2', 'PHdao2@gmail.com'),
    (93, 'PHvinh2', 'PHvinh2@gmail.com'),
    (94, 'PHbao2', 'PHbao2@gmail.com'),
    (95, 'PHha2', 'PHha2@gmail.com'),
    (96, 'PHanh2', 'PHanh2@gmail.com'),
    (97, 'PHchau2', 'PHchau2@gmail.com'),
    (98, 'PHcam2', 'PHcam2@gmail.com'),
    (99, 'PHhieu2', 'PHhieu2@gmail.com'),
    (100, 'PHthuy2', 'PHthuy2@gmail.com'),
    (101, 'PHduy2', 'PHduy2@gmail.com'),
    (102, 'PHngan2', 'PHngan2@gmail.com'),
    (103, 'PHlinh2', 'PHlinh2@gmail.com'),
    (104, 'PHlong2', 'PHlong2@gmail.com'),
    (105, 'PHlan2', 'PHlan2@gmail.com'),
    (106, 'PHgiang2', 'PHgiang2@gmail.com'),
    (107, 'PHhuy2', 'PHhuy2@gmail.com'),
    (108, 'PHduong2', 'PHduong2@gmail.com'),
    (109, 'PHhanh2', 'PHhanh2@gmail.com'),
    (110, 'PHnam6', 'PHnam6@gmail.com'),
    (111, 'PHcuong6', 'PHcuong6@gmail.com'),
    (112, 'PHloc6', 'PHloc6@gmail.com'),
    (113, 'PHquang6', 'PHquang6@gmail.com'),
    (114, 'PHthuan6', 'PHthuan6@gmail.com'),
    (115, 'PHtien6', 'PHtien6@gmail.com'),
    (116, 'PHngoc6', 'PHngoc6@gmail.com'),
    (117, 'PHbinh6', 'PHbinh6@gmail.com'),
    (118, 'PHlam6', 'PHlam6@gmail.com'),
    (119, 'PHphuc6', 'PHphuc6@gmail.com'),
    (120, 'PHphat6', 'PHphat6@gmail.com'),
    (121, 'PHtam6', 'PHtam6@gmail.com'),
    (122, 'PHhoang6', 'PHhoang6@gmail.com'),
    (123, 'PHminh6', 'PHminh6@gmail.com'),
    (124, 'PHtrung6', 'PHtrung6@gmail.com'),
    (125, 'PHkhanh6', 'PHkhanh6@gmail.com'),
    (126, 'PHnhan6', 'PHnhan6@gmail.com'),
    (127, 'PHkhoa6', 'PHkhoa6@gmail.com'),
    (128, 'PHdung6', 'PHdung6@gmail.com'),
    (129, 'PHthao6', 'PHthao6@gmail.com'),
    (130, 'PHviet6', 'PHviet6@gmail.com'),
    (131, 'PHdao6', 'PHdao6@gmail.com'),
    (132, 'PHvinh6', 'PHvinh6@gmail.com'),
    (133, 'PHbao6', 'PHbao6@gmail.com'),
    (134, 'PHha6', 'PHha6@gmail.com'),
    (135, 'PHanh6', 'PHanh6@gmail.com'),
    (136, 'PHchau6', 'PHchau6@gmail.com'),
    (137, 'PHcam6', 'PHcam6@gmail.com'),
    (138, 'PHhieu6', 'PHhieu6@gmail.com'),
    (139, 'PHthuy6', 'PHthuy6@gmail.com'),
    (140, 'PHduy6', 'PHduy6@gmail.com'),
    (141, 'PHngan6', 'PHngan6@gmail.com'),
    (142, 'PHlinh6', 'PHlinh6@gmail.com'),
    (143, 'PHlong6', 'PHlong6@gmail.com'),
    (144, 'PHlan6', 'PHlan6@gmail.com'),
    (145, 'PHgiang6', 'PHgiang6@gmail.com'),
    (146, 'PHhuy6', 'PHhuy6@gmail.com'),
    (147, 'PHduong6', 'PHduong6@gmail.com'),
    (148, 'PHhanh6', 'PHhanh6@gmail.com'),
    (149, 'PHnam7', 'PHnam7@gmail.com'),
    (150, 'PHcuong7', 'PHcuong7@gmail.com'),
    (151, 'PHloc7', 'PHloc7@gmail.com'),
    (152, 'PHquang7', 'PHquang7@gmail.com'),
    (153, 'PHthuan7', 'PHthuan7@gmail.com'),
    (154, 'PHtien7', 'PHtien7@gmail.com'),
    (155, 'PHcuong8', 'PHcuong8@gmail.com'),
    (156, 'PHloc8', 'PHloc8@gmail.com'),
    (157, 'PHquang8', 'PHquang8@gmail.com'),
    (158, 'PHthuan8', 'PHthuan8@gmail.com'),
    (159, 'PHtien8', 'PHtien8@gmail.com'),
    (160, 'PHnam8', 'PHnam8@gmail.com'),
    (161, 'PHcuong9', 'PHcuong9@gmail.com'),
    (162, 'PHloc9', 'PHloc9@gmail.com'),
    (163, 'PHquang9', 'PHquang9@gmail.com'),
    (164, 'PHthuan9', 'PHthuan9@gmail.com'),
    (165, 'PHtien9', 'PHtien9@gmail.com'),
    (166, 'PHnam9', 'PHnam9@gmail.com'),
    (167, 'PHcuong10', 'PHcuong10@gmail.com'),
    (168, 'PHloc10', 'PHloc10@gmail.com'),
    (169, 'PHquang10', 'PHquang10@gmail.com'),
    (170, 'PHthuan10', 'PHthuan10@gmail.com'),
    (171, 'PHtien10', 'PHtien10@gmail.com'),
    (172, 'PHngoc10', 'PHngoc10@gmail.com'),
    (173, 'PHbinh10', 'PHbinh10@gmail.com'),
    (174, 'PHlam10', 'PHlam10@gmail.com'),
    (175, 'PHphuc10', 'PHphuc10@gmail.com'),
    (176, 'PHphat10', 'PHphat10@gmail.com'),
    (177, 'PHtam10', 'PHtam10@gmail.com'),
    (178, 'PHhoang10', 'PHhoang10@gmail.com'),
    (179, 'PHminh10', 'PHminh10@gmail.com'),
    (180, 'PHtrung10', 'PHtrung10@gmail.com'),
    (181, 'PHkhanh10', 'PHkhanh10@gmail.com'),
    (182, 'PHnhan10', 'PHnhan10@gmail.com'),
    (183, 'PHkhoa10', 'PHkhoa10@gmail.com'),
    (184, 'PHdung10', 'PHdung10@gmail.com'),
    (185, 'PHthao10', 'PHthao10@gmail.com'),
    (186, 'PHviet10', 'PHviet10@gmail.com'),
    (187, 'PHdao10', 'PHdao10@gmail.com'),
    (188, 'PHvinh10', 'PHvinh10@gmail.com'),
    (189, 'PHbao10', 'PHbao10@gmail.com'),
    (190, 'PHha10', 'PHha10@gmail.com'),
    (191, 'PHanh10', 'PHanh10@gmail.com'),
    (192, 'PHchau10', 'PHchau10@gmail.com'),
    (193, 'PHcam10', 'PHcam10@gmail.com'),
    (194, 'PHhieu10', 'PHhieu10@gmail.com'),
    (195, 'PHthuy10', 'PHthuy10@gmail.com'),
    (196, 'PHduy10', 'PHduy10@gmail.com'),
    (197, 'PHngan10', 'PHngan10@gmail.com'),
    (198, 'PHlinh10', 'PHlinh10@gmail.com'),
    (199, 'PHlong10', 'PHlong10@gmail.com'),
    (200, 'PHlan10', 'PHlan10@gmail.com'),
    (201, 'PHgiang10', 'PHgiang10@gmail.com'),
    (202, 'PHhuy10', 'PHhuy10@gmail.com'),
    (203, 'PHduong10', 'PHduong10@gmail.com'),
    (204, 'PHhanh10', 'PHhanh10@gmail.com'),
    (205, 'PHnam11', 'PHnam11@gmail.com'),
    (206, 'PHcuong11', 'PHcuong11@gmail.com'),
    (207, 'PHloc11', 'PHloc11@gmail.com'),
    (208, 'PHquang11', 'PHquang11@gmail.com'),
    (209, 'PHthuan11', 'PHthuan11@gmail.com'),
    (210, 'PHtien11', 'PHtien11@gmail.com'),
    (211, 'PHcuong12', 'PHcuong12@gmail.com'),
    (212, 'PHloc12', 'PHloc12@gmail.com'),
    (213, 'PHquang12', 'PHquang12@gmail.com'),
    (214, 'PHthuan12', 'PHthuan12@gmail.com'),
    (215, 'PHtien12', 'PHtien12@gmail.com'),
    (216, 'PHnam12', 'PHnam12@gmail.com'),
    (217, 'PHcuong13', 'PHcuong13@gmail.com'),
    (218, 'PHloc13', 'PHloc13@gmail.com'),
    (219, 'PHquang13', 'PHquang13@gmail.com'),
    (220, 'PHthuan13', 'PHthuan13@gmail.com'),
    (221, 'PHtien13', 'PHtien13@gmail.com'),
    (222, 'PHnam13', 'PHnam13@gmail.com'),
    (223, 'PHcuong14', 'PHcuong14@gmail.com'),
    (224, 'PHloc14', 'PHloc14@gmail.com'),
    (225, 'PHquang14', 'PHquang14@gmail.com'),
    (226, 'PHthuan14', 'PHthuan14@gmail.com'),
    (227, 'PHtien14', 'PHtien14@gmail.com'),
    (228, 'PHngoc14', 'PHngoc14@gmail.com'),
    (229, 'PHbinh14', 'PHbinh14@gmail.com'),
    (230, 'PHlam14', 'PHlam14@gmail.com'),
    (231, 'PHphuc14', 'PHphuc14@gmail.com'),
    (232, 'PHphat14', 'PHphat14@gmail.com'),
    (233, 'PHtam14', 'PHtam14@gmail.com'),
    (234, 'PHhoang14', 'PHhoang14@gmail.com'),
    (235, 'PHminh14', 'PHminh14@gmail.com'),
    (236, 'PHtrung14', 'PHtrung14@gmail.com'),
    (237, 'PHkhanh14', 'PHkhanh14@gmail.com'),
    (238, 'PHnhan14', 'PHnhan14@gmail.com'),
    (239, 'PHkhoa14', 'PHkhoa14@gmail.com'),
    (240, 'PHdung14', 'PHdung14@gmail.com'),
    (241, 'PHthao14', 'PHthao14@gmail.com'),
    (242, 'PHviet14', 'PHviet14@gmail.com'),
    (243, 'PHdao14', 'PHdao14@gmail.com'),
    (244, 'PHvinh14', 'PHvinh14@gmail.com'),
    (245, 'PHbao14', 'PHbao14@gmail.com'),
    (246, 'PHha14', 'PHha14@gmail.com'),
    (247, 'PHanh14', 'PHanh14@gmail.com'),
    (248, 'PHchau14', 'PHchau14@gmail.com'),
    (249, 'PHcam14', 'PHcam14@gmail.com'),
    (250, 'PHhieu14', 'PHhieu14@gmail.com'),
    (251, 'PHthuy14', 'PHthuy14@gmail.com'),
    (252, 'PHduy14', 'PHduy14@gmail.com'),
    (253, 'PHngan14', 'PHngan14@gmail.com'),
    (254, 'PHlinh14', 'PHlinh14@gmail.com'),
    (255, 'PHlong14', 'PHlong14@gmail.com'),
    (256, 'PHlan14', 'PHlan14@gmail.com'),
    (257, 'PHgiang14', 'PHgiang14@gmail.com'),
    (258, 'PHhuy14', 'PHhuy14@gmail.com'),
    (259, 'PHduong14', 'PHduong14@gmail.com'),
    (260, 'PHhanh14', 'PHhanh14@gmail.com'),
    (261, 'PHnam15', 'PHnam15@gmail.com'),
    (262, 'PHcuong15', 'PHcuong15@gmail.com'),
    (263, 'PHloc15', 'PHloc15@gmail.com'),
    (264, 'PHquang15', 'PHquang15@gmail.com'),
    (265, 'PHthuan15', 'PHthuan15@gmail.com'),
    (266, 'PHtien15', 'PHtien15@gmail.com'),
    (267, 'PHcuong16', 'PHcuong16@gmail.com'),
    (268, 'PHloc16', 'PHloc16@gmail.com'),
    (269, 'PHquang16', 'PHquang16@gmail.com'),
    (270, 'PHthuan16', 'PHthuan16@gmail.com'),
    (271, 'PHtien16', 'PHtien16@gmail.com'),
    (272, 'PHnam16', 'PHnam16@gmail.com'),
    (273, 'PHcuong17', 'PHcuong17@gmail.com'),
    (274, 'PHloc17', 'PHloc17@gmail.com'),
    (275, 'PHquang17', 'PHquang17@gmail.com'),
    (276, 'PHthuan17', 'PHthuan17@gmail.com'),
    (277, 'PHtien17', 'PHtien17@gmail.com'),
    (278, 'PHnam17', 'PHnam17@gmail.com'),
    (279, 'PHcuong18', 'PHcuong18@gmail.com'),
    (280, 'PHloc18', 'PHloc18@gmail.com'),
    (281, 'PHquang18', 'PHquang18@gmail.com'),
    (282, 'PHthuan18', 'PHthuan18@gmail.com'),
    (283, 'PHtien18', 'PHtien18@gmail.com'),
    (284, 'PHngoc18', 'PHngoc18@gmail.com'),
    (285, 'PHbinh18', 'PHbinh18@gmail.com'),
    (286, 'PHlam18', 'PHlam18@gmail.com'),
    (287, 'PHphuc18', 'PHphuc18@gmail.com'),
    (288, 'PHphat18', 'PHphat18@gmail.com'),
    (289, 'PHtam18', 'PHtam18@gmail.com'),
    (290, 'PHhoang18', 'PHhoang18@gmail.com'),
    (291, 'PHminh18', 'PHminh18@gmail.com'),
    (292, 'PHtrung18', 'PHtrung18@gmail.com'),
    (293, 'PHkhanh18', 'PHkhanh18@gmail.com'),
    (294, 'PHnhan18', 'PHnhan18@gmail.com'),
    (295, 'PHkhoa18', 'PHkhoa18@gmail.com'),
    (296, 'PHdung18', 'PHdung18@gmail.com'),
    (297, 'PHthao18', 'PHthao18@gmail.com'),
    (298, 'PHviet18', 'PHviet18@gmail.com'),
    (299, 'PHdao18', 'PHdao18@gmail.com'),
    (300, 'PHvinh18', 'PHvinh18@gmail.com'),
    (301, 'PHbao18', 'PHbao18@gmail.com'),
    (302, 'PHha18', 'PHha18@gmail.com'),
    (303, 'PHanh18', 'PHanh18@gmail.com'),
    (304, 'PHchau18', 'PHchau18@gmail.com'),
    (305, 'PHcam18', 'PHcam18@gmail.com'),
    (306, 'PHhieu18', 'PHhieu18@gmail.com'),
    (307, 'PHthuy18', 'PHthuy18@gmail.com'),
    (308, 'PHduy18', 'PHduy18@gmail.com'),
    (309, 'PHngan18', 'PHngan18@gmail.com'),
    (310, 'PHlinh18', 'PHlinh18@gmail.com'),
    (311, 'PHlong18', 'PHlong18@gmail.com'),
    (312, 'PHlan18', 'PHlan18@gmail.com'),
    (313, 'PHgiang18', 'PHgiang18@gmail.com'),
    (314, 'PHhuy18', 'PHhuy18@gmail.com'),
    (315, 'PHduong18', 'PHduong18@gmail.com'),
    (316, 'PHhanh18', 'PHhanh18@gmail.com'),
    (317, 'PHnam19', 'PHnam19@gmail.com'),
    (318, 'PHcuong19', 'PHcuong19@gmail.com'),
    (319, 'PHloc19', 'PHloc19@gmail.com'),
    (320, 'PHquang19', 'PHquang19@gmail.com'),
    (321, 'PHthuan19', 'PHthuan19@gmail.com'),
    (322, 'PHtien19', 'PHtien19@gmail.com'),
    (323, 'PHcuong20', 'PHcuong20@gmail.com'),
    (324, 'PHloc20', 'PHloc20@gmail.com'),
    (325, 'PHquang20', 'PHquang20@gmail.com'),
    (326, 'PHthuan20', 'PHthuan20@gmail.com'),
    (327, 'PHtien20', 'PHtien20@gmail.com'),
    (328, 'PHnam20', 'PHnam20@gmail.com'),
    (329, 'PHcuong21', 'PHcuong21@gmail.com'),
    (330, 'PHloc21', 'PHloc21@gmail.com'),
    (331, 'PHquang21', 'PHquang21@gmail.com'),
    (332, 'PHthuan21', 'PHthuan21@gmail.com'),
    (333, 'PHtien21', 'PHtien21@gmail.com'),
    (334, 'PHnam21', 'PHnam21@gmail.com'),
    (335, 'PHcuong22', 'PHcuong22@gmail.com'),
    (336, 'PHloc22', 'PHloc22@gmail.com'),
    (337, 'PHquang22', 'PHquang22@gmail.com'),
    (338, 'PHthuan22', 'PHthuan22@gmail.com'),
    (339, 'PHtien22', 'PHtien22@gmail.com'),
    (340, 'PHngoc22', 'PHngoc22@gmail.com'),
    (341, 'PHbinh22', 'PHbinh22@gmail.com'),
    (342, 'PHlam22', 'PHlam22@gmail.com'),
    (343, 'PHphuc22', 'PHphuc22@gmail.com'),
    (344, 'PHphat22', 'PHphat22@gmail.com'),
    (345, 'PHtam22', 'PHtam22@gmail.com'),
    (346, 'PHhoang22', 'PHhoang22@gmail.com'),
    (347, 'PHminh22', 'PHminh22@gmail.com'),
    (348, 'PHtrung22', 'PHtrung22@gmail.com'),
    (349, 'PHkhanh22', 'PHkhanh22@gmail.com'),
    (350, 'PHnhan22', 'PHnhan22@gmail.com'),
    (351, 'PHkhoa22', 'PHkhoa22@gmail.com'),
    (352, 'PHdung22', 'PHdung22@gmail.com'),
    (353, 'PHthao22', 'PHthao22@gmail.com'),
    (354, 'PHviet22', 'PHviet22@gmail.com'),
    (355, 'PHdao22', 'PHdao22@gmail.com'),
    (356, 'PHvinh22', 'PHvinh22@gmail.com'),
    (357, 'PHbao22', 'PHbao22@gmail.com'),
    (358, 'PHha22', 'PHha22@gmail.com'),
    (359, 'PHanh22', 'PHanh22@gmail.com'),
    (360, 'PHchau22', 'PHchau22@gmail.com'),
    (361, 'PHcam22', 'PHcam22@gmail.com'),
    (362, 'PHhieu22', 'PHhieu22@gmail.com'),
    (363, 'PHthuy22', 'PHthuy22@gmail.com'),
    (364, 'PHduy22', 'PHduy22@gmail.com'),
    (365, 'PHngan22', 'PHngan22@gmail.com'),
    (366, 'PHlinh22', 'PHlinh22@gmail.com'),
    (367, 'PHlong22', 'PHlong22@gmail.com'),
    (368, 'PHlan22', 'PHlan22@gmail.com'),
    (369, 'PHgiang22', 'PHgiang22@gmail.com'),
    (370, 'PHhuy22', 'PHhuy22@gmail.com'),
    (371, 'PHduong22', 'PHduong22@gmail.com'),
    (372, 'PHhanh22', 'PHhanh22@gmail.com'),
    (373, 'PHnam23', 'PHnam23@gmail.com'),
    (374, 'PHcuong23', 'PHcuong23@gmail.com'),
    (375, 'PHloc23', 'PHloc23@gmail.com'),
    (376, 'PHquang23', 'PHquang23@gmail.com'),
    (377, 'PHthuan23', 'PHthuan23@gmail.com'),
    (378, 'PHtien23', 'PHtien23@gmail.com'),
    (379, 'PHcuong24', 'PHcuong24@gmail.com'),
    (380, 'PHloc24', 'PHloc24@gmail.com'),
    (381, 'PHquang24', 'PHquang24@gmail.com'),
    (382, 'PHthuan24', 'PHthuan24@gmail.com'),
    (383, 'PHtien24', 'PHtien24@gmail.com'),
    (384, 'PHnam24', 'PHnam24@gmail.com'),
    (385, 'PHcuong25', 'PHcuong25@gmail.com'),
    (386, 'PHloc25', 'PHloc25@gmail.com'),
    (387, 'PHquang25', 'PHquang25@gmail.com'),
    (388, 'PHthuan25', 'PHthuan25@gmail.com'),
    (389, 'PHtien25', 'PHtien25@gmail.com'),
    (390, 'PHnam25', 'PHnam25@gmail.com'),
    (391, 'PHcuong26', 'PHcuong26@gmail.com'),
    (392, 'PHloc26', 'PHloc26@gmail.com'),
    (393, 'PHquang26', 'PHquang26@gmail.com'),
    (394, 'PHthuan26', 'PHthuan26@gmail.com'),
    (395, 'PHtien26', 'PHtien26@gmail.com'),
    (396, 'PHngoc26', 'PHngoc26@gmail.com'),
    (397, 'PHbinh26', 'PHbinh26@gmail.com'),
    (398, 'PHlam26', 'PHlam26@gmail.com'),
    (399, 'PHphuc26', 'PHphuc26@gmail.com'),
    (400, 'PHphat26', 'PHphat26@gmail.com'),
    (401, 'PHtam26', 'PHtam26@gmail.com'),
    (402, 'PHhoang26', 'PHhoang26@gmail.com'),
    (403, 'PHminh26', 'PHminh26@gmail.com'),
    (404, 'PHtrung26', 'PHtrung26@gmail.com'),
    (405, 'PHkhanh26', 'PHkhanh26@gmail.com'),
    (406, 'PHnhan26', 'PHnhan26@gmail.com'),
    (407, 'PHkhoa26', 'PHkhoa26@gmail.com'),
    (408, 'PHdung26', 'PHdung26@gmail.com'),
    (409, 'PHthao26', 'PHthao26@gmail.com'),
    (410, 'PHviet26', 'PHviet26@gmail.com'),
    (411, 'PHdao26', 'PHdao26@gmail.com'),
    (412, 'PHvinh26', 'PHvinh26@gmail.com'),
    (413, 'PHbao26', 'PHbao26@gmail.com'),
    (414, 'PHha26', 'PHha26@gmail.com'),
    (415, 'PHanh26', 'PHanh26@gmail.com'),
    (416, 'PHchau26', 'PHchau26@gmail.com'),
    (417, 'PHcam26', 'PHcam26@gmail.com'),
    (418, 'PHhieu26', 'PHhieu26@gmail.com'),
    (419, 'PHthuy26', 'PHthuy26@gmail.com'),
    (420, 'PHduy26', 'PHduy26@gmail.com'),
    (421, 'PHngan26', 'PHngan26@gmail.com'),
    (422, 'PHlinh26', 'PHlinh26@gmail.com'),
    (423, 'PHlong26', 'PHlong26@gmail.com'),
    (424, 'PHlan26', 'PHlan26@gmail.com'),
    (425, 'PHgiang26', 'PHgiang26@gmail.com');

INSERT INTO Teacher (UserId, Name, SubjectTC, SDT) VALUES
    (426, N'Nguyễn Hoàng Hậu', N'Văn', '0788045380'),
    (427, N'Nguyễn Thị Cường', N'Toán', '0788045380'),
    (428, N'Hậu nè Nam', N'Anh', '0788045380'),
    (429, N'Huỳnh Văn Tứn', N'Lịch sử', '0788045380'),
    (430, N'THuận theo ý chời', N'Địa lí', '0788045380'),
    (431, N'Vũ Hoàng Tiên', N'Hóa học', '0788045380'),
    (432, N'Vũ Đức Thịnh', N'Sinh học', '0788045380'),
    (433, N'Nguyễn Thị Bích Hân', N'Công nghệ', '0788045380'),
    (434, N'Nguyễn Ngọc Đan THanh', N'Văn', '0788045380'),
    (435, N'Đặng Xuân Quang', N'Anh', '0788045380'),
    (436, N'Phát Lộc', N'Toán', '0788045380'),
    (437, N'Nguyễn Hoang Quân', N'Lịch sử', '0788045380'),
    (438, N'Đặng Nguyễn Hoang Hậu', N'Địa lí', '0788045380'),
    (439, N'Nguyễn Quốc Cu', N'Hóa học', '0788045380'),
    (440, N'Nguyễn Công Phượng', N'Sinh học', '0788045380');
INSERT INTO Grades(Grade, AcademicYear)VALUES
    (11,2020),
    (12,2020),
    (10,2020),
    (10,2021),
    (11,2021),
    (12,2021),
    (10,2022),
    (11,2022),
    (12,2022),
    (10,2023),
    (11,2023),
    (12,2023),
    (10,2024),
    (11,2024),
    (12,2024);	
	INSERT INTO Classes (ClassName, TeacherId, AcademicYear, GradeId) VALUES
    ('10A1', 1, 2020, 10),
    ('10A2', 2, 2020, 10),
    ('10A3', 3, 2020, 10),
    ('10A4', 4, 2020, 10),
    ('10A5', 5, 2020, 10),
    ('11A1', 6, 2020, 11),
    ('11A2', 7, 2020, 11),
    ('11A3', 8, 2020, 11),
    ('11A4', 9, 2020, 11),
    ('11A5', 10, 2020, 11),
    ('12A1', 11, 2020, 12),
    ('12A3', 12, 2020, 12),
    ('12A3', 13, 2020, 12),
	('12A4', 14, 2020, 12),
    ('12A5', 15, 2020, 12);
	INSERT INTO Classes (ClassName, TeacherId, AcademicYear, GradeId) VALUES
    ('10A1', 1, 2021, 10),
    ('10A2', 2, 2021, 10),
    ('10A3', 3, 2021, 10),
    ('10A4', 4, 2021, 10),
    ('10A5', 5, 2021, 10),
    ('11A1', 6, 2021, 11),
    ('11A2', 7, 2021, 11),
    ('11A3', 8, 2021, 11),
    ('11A4', 9, 2021, 11),
    ('11A5', 10, 2021, 11),
    ('12A1', 11, 2021, 12),
    ('12A3', 12, 2021, 12),
    ('12A3', 13, 2021, 12),
	('12A4', 14, 2021, 12),
    ('12A5', 15, 2021, 12);	
	INSERT INTO Classes (ClassName, TeacherId, AcademicYear, GradeId) VALUES
    ('10A1', 1, 2022, 10),
    ('10A2', 2, 2022, 10),
    ('10A3', 3, 2022, 10),
    ('10A4', 4, 2022, 10),
    ('10A5', 5, 2022, 10),
    ('11A1', 6, 2022, 11),
    ('11A2', 7, 2022, 11),
    ('11A3', 8, 2022, 11),
    ('11A4', 9, 2022, 11),
    ('11A5', 10, 2022, 11),
    ('12A1', 11, 2022, 12),
    ('12A3', 12, 2022, 12),
    ('12A3', 13, 2022, 12),
	('12A4', 14, 2022, 12),
    ('12A5', 15, 2022, 12);
		INSERT INTO Classes (ClassName, TeacherId, AcademicYear, GradeId) VALUES
    ('10A1', 1, 2023, 10),
    ('10A2', 2, 2023, 10),
    ('10A3', 3, 2023, 10),
    ('10A4', 4, 2023, 10),
    ('10A5', 5, 2023, 10),
    ('11A1', 6, 2023, 11),
    ('11A2', 7, 2023, 11),
    ('11A3', 8, 2023, 11),
    ('11A4', 9, 2023, 11),
    ('11A5', 10, 2023, 11),
    ('12A1', 11, 2023, 12),
    ('12A3', 12, 2023, 12),
    ('12A3', 13, 2023, 12),
	('12A4', 14, 2023, 12),
    ('12A5', 15, 2023, 12);
	INSERT INTO Classes (ClassName, TeacherId, AcademicYear, GradeId) VALUES
    ('10A1', 1, 2024, 10),
    ('10A2', 2, 2024, 10),
    ('10A3', 3, 2024, 10),
    ('10A4', 4, 2024, 10),
    ('10A5', 5, 2024, 10),
    ('11A1', 6, 2024, 11),
    ('11A2', 7, 2024, 11),
    ('11A3', 8, 2024, 11),
    ('11A4', 9, 2024, 11),
    ('11A5', 10, 2024, 11),
    ('12A1', 11, 2024, 12),
    ('12A3', 12, 2024, 12),
    ('12A3', 13, 2024, 12),
	('12A4', 14, 2024, 12),
    ('12A5', 15, 2024, 12);

	INSERT INTO TeacherClassAssignment (TeacherId, ClassId, IsHeadTeacher)
VALUES
    (1, 1, 0), 
    (2, 2, 0), 
    (3, 3, 0), 
    (4, 4, 0), 
    (5, 5, 0), 
    (6, 6, 0), 
    (7, 7, 0), 
    (8, 8, 0), 
    (9, 9, 0), 
    (10, 10, 0), 
    (11, 11, 0), 
    (12, 12, 0), 
    (13, 13, 0), 
    (14, 14, 0), 
    (15, 15, 0),

    (1, 16, 0), 
    (2, 17, 0), 
    (3, 18, 0), 
    (4, 19, 0), 
    (5, 20, 0), 
    (6, 21, 0), 
    (7, 22, 0), 
    (8, 23, 0), 
    (9, 24, 0), 
    (10, 25,0), 
    (11, 26, 0), 
    (12, 27, 0), 
    (13, 28, 0), 
    (14, 29, 0), 
    (15, 30, 0),

    (1, 31, 0), 
    (2, 32, 0), 
    (3, 33, 0), 
    (4, 34, 0), 
    (5, 35, 0), 
    (6, 36, 0), 
    (7, 37, 0), 
    (8, 38, 0), 
    (9, 39, 0), 
    (10, 40, 0), 
    (11, 41, 0), 
    (12, 42, 0), 
    (13, 43, 0), 
    (14, 44, 0), 
    (15, 45, 0),

    (1, 46, 0), 
    (2, 47, 0), 
    (3, 48, 0), 
    (4, 49, 0), 
    (5, 50, 0), 
    (6, 51, 0), 
    (7, 52, 0), 
    (8, 53, 0), 
    (9, 54, 0), 
    (10, 55, 0), 
    (11, 56, 0), 
    (12, 57, 0), 
    (13, 58, 0), 
    (14, 59, 0), 
    (15, 60, 0),

    (1, 61, 1), 
    (2, 62, 1), 
    (3, 63, 1), 
    (4, 64, 1), 
    (5, 65, 1), 
    (6, 66, 1), 
    (7, 67, 1), 
    (8, 68, 1), 
    (9, 69, 1), 
    (10, 70, 1), 
    (11, 71, 1), 
    (12, 72, 1), 
    (13, 73, 1), 
    (14, 74, 1), 
    (15, 75, 1);

	INSERT INTO Subject (SubjectName) VALUES
    (N'Văn'),
    (N'Toán'),
    (N'Anh'),
    (N'Lịch sử'),
    (N'Địa lí'),
    (N'Hóa học'),
    (N'Sinh học'),
    (N'Công nghệ');

	INSERT INTO SubjectTeacher (TeacherId, SubjectId)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 1),
    (10, 3),
    (11, 2),
    (12, 4),
    (13, 5),
    (14, 6),
    (15, 7);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 2, '7:30 - 8:15', '2024-05-05', 1),
    (61, 2, '8:15 - 9:00', '2024-05-05', 2),
    (61, 2, '9:15 - 10:00', '2024-05-05', 3),
    (61, 2, '10:00 - 10:45', '2024-05-05', 4),

    (61, 2, '1:00 - 1:45', '2024-05-05', 5),
    (61, 2, '1:45 - 2:30', '2024-05-05', 6),
    (61, 2, '2:45 - 3:30', '2024-05-05', 7),
    (61, 2, '3:30 - 4:15', '2024-05-05', 8);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 3, '7:30 - 8:15', '2024-05-06', 1),
    (61, 3, '8:15 - 9:00', '2024-05-06', 2),
    (61, 3, '9:15 - 10:00', '2024-05-06', 3),
    (61, 3, '10:00 - 10:45', '2024-05-06', 4),

    (61, 3, '1:00 - 1:45', '2024-05-06', 5),
    (61, 3, '1:45 - 2:30', '2024-05-06', 6),
    (61, 3, '2:45 - 3:30', '2024-05-06', 7),
    (61, 3, '3:30 - 4:15', '2024-05-06', 8);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 4, '7:30 - 8:15', '2024-05-07', 1),
    (61, 4, '8:15 - 9:00', '2024-05-07', 2),
    (61, 4, '9:15 - 10:00', '2024-05-07', 3),
    (61, 4, '10:00 - 10:45', '2024-05-07', 4),

    (61, 4, '1:00 - 1:45', '2024-05-07', 5),
    (61, 4, '1:45 - 2:30', '2024-05-07', 6),
    (61, 4, '2:45 - 3:30', '2024-05-07', 7),
    (61, 4, '3:30 - 4:15', '2024-05-07', 8);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 5, '7:30 - 8:15', '2024-05-08', 1),
    (61, 5, '8:15 - 9:00', '2024-05-08', 2),
    (61, 5, '9:15 - 10:00', '2024-05-08', 3),
    (61, 5, '10:00 - 10:45', '2024-05-08', 4),

    (61, 5, '1:00 - 1:45', '2024-05-08', 5),
    (61, 5, '1:45 - 2:30', '2024-05-08', 6),
    (61, 5, '2:45 - 3:30', '2024-05-08', 7),
    (61, 5, '3:30 - 4:15', '2024-05-08', 8);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 6, '7:30 - 8:15', '2024-05-09', 1),
    (61, 6, '8:15 - 9:00', '2024-05-09', 2),
    (61, 6, '9:15 - 10:00', '2024-05-09', 3),
    (61, 6, '10:00 - 10:45', '2024-05-09', 4),

    (61, 6, '1:00 - 1:45', '2024-05-09', 5),
    (61, 6, '1:45 - 2:30', '2024-05-09', 6),
    (61, 6, '2:45 - 3:30', '2024-05-09', 7),
    (61, 6, '3:30 - 4:15', '2024-05-09', 8);
	INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 2, '7:30 - 8:15', '2024-06-03', 1),
    (61, 2, '8:15 - 9:00', '2024-06-03', 2),
    (61, 2, '9:15 - 10:00', '2024-06-03', 3),
    (61, 2, '10:00 - 10:45', '2024-06-03', 4),

    (61, 2, '1:00 - 1:45', '2024-06-03', 5),
    (61, 2, '1:45 - 2:30', '2024-06-03', 6),
    (61, 2, '2:45 - 3:30', '2024-06-03', 7),
    (61, 2, '3:30 - 4:15', '2024-06-03', 8),

    (61, 3, '7:30 - 8:15', '2024-06-04', 1),
    (61, 3, '8:15 - 9:00', '2024-06-04', 2),
    (61, 3, '9:15 - 10:00', '2024-06-04', 3),
    (61, 3, '10:00 - 10:45', '2024-06-04', 4),

    (61, 3, '1:00 - 1:45', '2024-06-04', 5),
    (61, 3, '1:45 - 2:30', '2024-06-04', 6),
    (61, 3, '2:45 - 3:30', '2024-06-04', 7),
    (61, 3, '3:30 - 4:15', '2024-06-04', 8),

    (61, 4, '7:30 - 8:15', '2024-06-05', 1),
    (61, 4, '8:15 - 9:00', '2024-06-05', 2),
    (61, 4, '9:15 - 10:00', '2024-06-05', 3),
    (61, 4, '10:00 - 10:45', '2024-06-05', 4),

    (61, 4, '1:00 - 1:45', '2024-06-05', 5),
    (61, 4, '1:45 - 2:30', '2024-06-05', 6),
    (61, 4, '2:45 - 3:30', '2024-06-05', 7),
    (61, 4, '3:30 - 4:15', '2024-06-05', 8),

    (61, 5, '7:30 - 8:15', '2024-06-06', 1),
    (61, 5, '8:15 - 9:00', '2024-06-06', 2),
    (61, 5, '9:15 - 10:00', '2024-06-06', 3),
    (61, 5, '10:00 - 10:45', '2024-06-06', 4),

    (61, 5, '1:00 - 1:45', '2024-06-06', 5),
    (61, 5, '1:45 - 2:30', '2024-06-06', 6),
    (61, 5, '2:45 - 3:30', '2024-06-06', 7),
    (61, 5, '3:30 - 4:15', '2024-06-06', 8),

    (61, 6, '7:30 - 8:15', '2024-06-07', 1),
    (61, 6, '8:15 - 9:00', '2024-06-07', 2),
    (61, 6, '9:15 - 10:00', '2024-06-07', 3),
    (61, 6, '10:00 - 10:45', '2024-06-07', 4),

    (61, 6, '1:00 - 1:45', '2024-06-07', 5),
    (61, 6, '1:45 - 2:30', '2024-06-07', 6),
    (61, 6, '2:45 - 3:30', '2024-06-07', 7),
    (61, 6, '3:30 - 4:15', '2024-06-07', 8);

	INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 2, '7:30 - 8:15', '2024-06-10', 1),
    (61, 2, '8:15 - 9:00', '2024-05-10', 2),
    (61, 2, '9:15 - 10:00', '2024-06-10', 3),
    (61, 2, '10:00 - 10:45', '2024-06-10', 4),

    (61, 2, '1:00 - 1:45', '2024-06-10', 5),
    (61, 2, '1:45 - 2:30', '2024-06-10', 6),
    (61, 2, '2:45 - 3:30', '2024-06-10', 7),
    (61, 2, '3:30 - 4:15', '2024-06-10', 8),

    (61, 3, '7:30 - 8:15', '2024-06-11', 1),
    (61, 3, '8:15 - 9:00', '2024-06-11', 2),
    (61, 3, '9:15 - 10:00', '2024-06-11', 3),
    (61, 3, '10:00 - 10:45', '2024-06-11', 4),

    (61, 3, '1:00 - 1:45', '2024-06-11', 5),
    (61, 3, '1:45 - 2:30', '2024-06-11', 6),
    (61, 3, '2:45 - 3:30', '2024-06-11', 7),
    (61, 3, '3:30 - 4:15', '2024-06-11', 8),

    (61, 4, '7:30 - 8:15', '2024-06-12', 1),
    (61, 4, '8:15 - 9:00', '2024-06-12', 2),
    (61, 4, '9:15 - 10:00', '2024-06-12', 3),
    (61, 4, '10:00 - 10:45', '2024-06-12', 4),

    (61, 4, '1:00 - 1:45', '2024-06-12', 5),
    (61, 4, '1:45 - 2:30', '2024-06-12', 6),
    (61, 4, '2:45 - 3:30', '2024-06-12', 7),
    (61, 4, '3:30 - 4:15', '2024-06-12', 8),

    (61, 5, '7:30 - 8:15', '2024-06-13', 1),
    (61, 5, '8:15 - 9:00', '2024-06-13', 2),
    (61, 5, '9:15 - 10:00', '2024-06-13', 3),
    (61, 5, '10:00 - 10:45', '2024-06-13', 4),

    (61, 5, '1:00 - 1:45', '2024-06-13', 5),
    (61, 5, '1:45 - 2:30', '2024-06-13', 6),
    (61, 5, '2:45 - 3:30', '2024-06-13', 7),
    (61, 5, '3:30 - 4:15', '2024-06-13', 8),

    (61, 6, '7:30 - 8:15', '2024-06-14', 1),
    (61, 6, '8:15 - 9:00', '2024-06-14', 2),
    (61, 6, '9:15 - 10:00', '2024-06-14', 3),
    (61, 6, '10:00 - 10:45', '2024-06-14', 4),

    (61, 6, '1:00 - 1:45', '2024-06-14', 5),
    (61, 6, '1:45 - 2:30', '2024-06-14', 6),
    (61, 6, '2:45 - 3:30', '2024-06-14', 7),
    (61, 6, '3:30 - 4:15', '2024-06-14', 8);

	INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (61, 2, '7:30 - 8:15', '2024-06-17', 1),
    (61, 2, '8:15 - 9:00', '2024-06-17', 2),
    (61, 2, '9:15 - 10:00', '2024-06-17', 3),
    (61, 2, '10:00 - 10:45', '2024-06-17', 4),

    (61, 2, '1:00 - 1:45', '2024-06-17', 5),
    (61, 2, '1:45 - 2:30', '2024-06-17', 6),
    (61, 2, '2:45 - 3:30', '2024-06-17', 7),
    (61, 2, '3:30 - 4:15', '2024-06-17', 8),

    (61, 3, '7:30 - 8:15', '2024-06-18', 1),
    (61, 3, '8:15 - 9:00', '2024-06-18', 2),
    (61, 3, '9:15 - 10:00', '2024-06-18', 3),
    (61, 3, '10:00 - 10:45', '2024-06-18', 4),

    (61, 3, '1:00 - 1:45', '2024-06-18', 5),
    (61, 3, '1:45 - 2:30', '2024-06-18', 6),
    (61, 3, '2:45 - 3:30', '2024-06-18', 7),
    (61, 3, '3:30 - 4:15', '2024-06-18', 8),

    (61, 4, '7:30 - 8:15', '2024-06-19', 1),
    (61, 4, '8:15 - 9:00', '2024-06-19', 2),
    (61, 4, '9:15 - 10:00', '2024-06-19', 3),
    (61, 4, '10:00 - 10:45', '2024-06-19', 4),

    (61, 4, '1:00 - 1:45', '2024-06-19', 5),
    (61, 4, '1:45 - 2:30', '2024-06-19', 6),
    (61, 4, '2:45 - 3:30', '2024-06-19', 7),
    (61, 4, '3:30 - 4:15', '2024-06-19', 8),

    (61, 5, '7:30 - 8:15', '2024-06-20', 1),
    (61, 5, '8:15 - 9:00', '2024-06-20', 2),
    (61, 5, '9:15 - 10:00', '2024-06-20', 3),
    (61, 5, '10:00 - 10:45', '2024-06-20', 4),

    (61, 5, '1:00 - 1:45', '2024-06-20', 5),
    (61, 5, '1:45 - 2:30', '2024-06-20', 6),
    (61, 5, '2:45 - 3:30', '2024-06-20', 7),
    (61, 5, '3:30 - 4:15', '2024-06-20', 8),

    (61, 6, '7:30 - 8:15', '2024-06-21', 1),
    (61, 6, '8:15 - 9:00', '2024-06-21', 2),
    (61, 6, '9:15 - 10:00', '2024-06-21', 3),
    (61, 6, '10:00 - 10:45', '2024-06-21', 4),

    (61, 6, '1:00 - 1:45', '2024-06-21', 5),
    (61, 6, '1:45 - 2:30', '2024-06-21', 6),
    (61, 6, '2:45 - 3:30', '2024-06-21', 7),
    (61, 6, '3:30 - 4:15', '2024-06-21', 8);


INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (62, 2, '7:30 - 8:15', '2024-05-05', 5),
    (62, 2, '8:15 - 9:00', '2024-05-05', 6),
    (62, 2, '9:15 - 10:00', '2024-05-05', 7),
    (62, 2, '10:00 - 10:45', '2024-05-05', 8),
    (62, 2, '1:00 - 1:45', '2024-05-05', 1),
    (62, 2, '1:45 - 2:30', '2024-05-05', 2),
    (62, 2, '2:45 - 3:30', '2024-05-05', 3),
    (62, 2, '3:30 - 4:15', '2024-05-05', 4);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (62, 3, '7:30 - 8:15', '2024-05-06', 5),
    (62, 3, '8:15 - 9:00', '2024-05-06', 6),
    (62, 3, '9:15 - 10:00', '2024-05-06', 7),
    (62, 3, '10:00 - 10:45', '2024-05-06', 8),
    (62, 3, '1:00 - 1:45', '2024-05-06', 1),
    (62, 3, '1:45 - 2:30', '2024-05-06', 2),
    (62, 3, '2:45 - 3:30', '2024-05-06', 3),
    (62, 3, '3:30 - 4:15', '2024-05-06', 4);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (62, 4, '7:30 - 8:15', '2024-05-07', 5),
    (62, 4, '8:15 - 9:00', '2024-05-07', 6),
    (62, 4, '9:15 - 10:00', '2024-05-07', 7),
    (62, 4, '10:00 - 10:45', '2024-05-07', 8),
    (62, 4, '1:00 - 1:45', '2024-05-07', 1),
    (62, 4, '1:45 - 2:30', '2024-05-07', 2),
    (62, 4, '2:45 - 3:30', '2024-05-07', 3),
    (62, 4, '3:30 - 4:15', '2024-05-07', 4);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (62, 5, '7:30 - 8:15', '2024-05-08', 5),
    (62, 5, '8:15 - 9:00', '2024-05-08', 6),
    (62, 5, '9:15 - 10:00', '2024-05-08', 7),
    (62, 5, '10:00 - 10:45', '2024-05-08', 8),
    (62, 5, '1:00 - 1:45', '2024-05-08', 1),
    (62, 5, '1:45 - 2:30', '2024-05-08', 2),
    (62, 5, '2:45 - 3:30', '2024-05-08', 3),
    (62, 5, '3:30 - 4:15', '2024-05-08', 4);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (62, 6, '7:30 - 8:15', '2024-05-09', 5),
    (62, 6, '8:15 - 9:00', '2024-05-09', 6),
    (62, 6, '9:15 - 10:00', '2024-05-09', 7),
    (62, 6, '10:00 - 10:45', '2024-05-09', 8),
    (62, 6, '1:00 - 1:45', '2024-05-09', 1),
    (62, 6, '1:45 - 2:30', '2024-05-09', 2),
    (62, 6, '2:45 - 3:30', '2024-05-09', 3),
    (62, 6, '3:30 - 4:15', '2024-05-09', 4);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (63, 2, '7:30 - 8:15', '2024-05-05', 3),
    (63, 2, '8:15 - 9:00', '2024-05-05', 4),
    (63, 2, '9:15 - 10:00', '2024-05-05', 1),
    (63, 2, '10:00 - 10:45', '2024-05-05', 2),
    (63, 2, '1:00 - 1:45', '2024-05-05', 7),
    (63, 2, '1:45 - 2:30', '2024-05-05', 8),
    (63, 2, '2:45 - 3:30', '2024-05-05', 5),
    (63, 2, '3:30 - 4:15', '2024-05-05', 6);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (63, 3, '7:30 - 8:15', '2024-05-06', 3),
    (63, 3, '8:15 - 9:00', '2024-05-06', 4),
    (63, 3, '9:15 - 10:00', '2024-05-06', 1),
    (63, 3, '10:00 - 10:45', '2024-05-06', 2),
    (63, 3, '1:00 - 1:45', '2024-05-06', 7),
    (63, 3, '1:45 - 2:30', '2024-05-06', 8),
    (63, 3, '2:45 - 3:30', '2024-05-06', 5),
    (63, 3, '3:30 - 4:15', '2024-05-06', 6);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (63, 4, '7:30 - 8:15', '2024-05-07', 3),
    (63, 4, '8:15 - 9:00', '2024-05-07', 4),
    (63, 4, '9:15 - 10:00', '2024-05-07', 1),
    (63, 4, '10:00 - 10:45', '2024-05-07', 2),
    (63, 4, '1:00 - 1:45', '2024-05-07', 7),
    (63, 4, '1:45 - 2:30', '2024-05-07', 8),
    (63, 4, '2:45 - 3:30', '2024-05-07', 5),
    (63, 4, '3:30 - 4:15', '2024-05-07', 6);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (63, 5, '7:30 - 8:15', '2024-05-08', 3),
    (63, 5, '8:15 - 9:00', '2024-05-08', 4),
    (63, 5, '9:15 - 10:00', '2024-05-08', 1),
    (63, 5, '10:00 - 10:45', '2024-05-08', 2),
    (63, 5, '1:00 - 1:45', '2024-05-08', 7),
    (63, 5, '1:45 - 2:30', '2024-05-08', 8),
    (63, 5, '2:45 - 3:30', '2024-05-08', 5),
    (63, 5, '3:30 - 4:15', '2024-05-08', 6);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (63, 6, '7:30 - 8:15', '2024-05-09', 3),
    (63, 6, '8:15 - 9:00', '2024-05-09', 4),
    (63, 6, '9:15 - 10:00', '2024-05-09', 1),
    (63, 6, '10:00 - 10:45', '2024-05-09', 2),
    (63, 6, '1:00 - 1:45', '2024-05-09', 7),
    (63, 6, '1:45 - 2:30', '2024-05-09', 8),
    (63, 6, '2:45 - 3:30', '2024-05-09', 5),
    (63, 6, '3:30 - 4:15', '2024-05-09', 6);


INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (64, 2, '7:30 - 8:15', '2024-05-05', 6),
    (64, 2, '8:15 - 9:00', '2024-05-05', 7),
    (64, 2, '9:15 - 10:00', '2024-05-05', 8),
    (64, 2, '10:00 - 10:45', '2024-05-05', 5),
    (64, 2, '1:00 - 1:45', '2024-05-05', 2),
    (64, 2, '1:45 - 2:30', '2024-05-05', 3),
    (64, 2, '2:45 - 3:30', '2024-05-05', 4),
    (64, 2, '3:30 - 4:15', '2024-05-05', 1);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (64, 3, '7:30 - 8:15', '2024-05-06', 6),
    (64, 3, '8:15 - 9:00', '2024-05-06', 7),
    (64, 3, '9:15 - 10:00', '2024-05-06', 8),
    (64, 3, '10:00 - 10:45', '2024-05-06', 5),
    (64, 3, '1:00 - 1:45', '2024-05-06', 2),
    (64, 3, '1:45 - 2:30', '2024-05-06', 3),
    (64, 3, '2:45 - 3:30', '2024-05-06', 4),
    (64, 3, '3:30 - 4:15', '2024-05-06', 1);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (64, 4, '7:30 - 8:15', '2024-05-07', 6),
    (64, 4, '8:15 - 9:00', '2024-05-07', 7),
    (64, 4, '9:15 - 10:00', '2024-05-07', 8),
    (64, 4, '10:00 - 10:45', '2024-05-07', 5),
    (64, 4, '1:00 - 1:45', '2024-05-07', 2),
    (64, 4, '1:45 - 2:30', '2024-05-07', 3),
    (64, 4, '2:45 - 3:30', '2024-05-07', 4),
    (64, 4, '3:30 - 4:15', '2024-05-07', 1);


INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (64, 5, '7:30 - 8:15', '2024-05-08', 6),
    (64, 5, '8:15 - 9:00', '2024-05-08', 7),
    (64, 5, '9:15 - 10:00', '2024-05-08', 8),
    (64, 5, '10:00 - 10:45', '2024-05-08', 5),
    (64, 5, '1:00 - 1:45', '2024-05-08', 2),
    (64, 5, '1:45 - 2:30', '2024-05-08', 3),
    (64, 5, '2:45 - 3:30', '2024-05-08', 4),
    (64, 5, '3:30 - 4:15', '2024-05-08', 1);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (64, 6, '7:30 - 8:15', '2024-05-09', 6),
    (64, 6, '8:15 - 9:00', '2024-05-09', 7),
    (64, 6, '9:15 - 10:00', '2024-05-09', 8),
    (64, 6, '10:00 - 10:45', '2024-05-09', 5),
    (64, 6, '1:00 - 1:45', '2024-05-09', 2),
    (64, 6, '1:45 - 2:30', '2024-05-09', 3),
    (64, 6, '2:45 - 3:30', '2024-05-09', 4),
    (64, 6, '3:30 - 4:15', '2024-05-09', 1);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (65, 2, '7:30 - 8:15', '2024-05-05', 4),
    (65, 2, '8:15 - 9:00', '2024-05-05', 3),
    (65, 2, '9:15 - 10:00', '2024-05-05', 2),
    (65, 2, '10:00 - 10:45', '2024-05-05', 1),
    (65, 2, '1:00 - 1:45', '2024-05-05', 8),
    (65, 2, '1:45 - 2:30', '2024-05-05', 7),
    (65, 2, '2:45 - 3:30', '2024-05-05', 6),
    (65, 2, '3:30 - 4:15', '2024-05-05', 5);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (65, 3, '7:30 - 8:15', '2024-05-06', 4),
    (65, 3, '8:15 - 9:00', '2024-05-06', 3),
    (65, 3, '9:15 - 10:00', '2024-05-06', 2),
    (65, 3, '10:00 - 10:45', '2024-05-06', 1),
    (65, 3, '1:00 - 1:45', '2024-05-06', 8),
    (65, 3, '1:45 - 2:30', '2024-05-06', 7),
    (65, 3, '2:45 - 3:30', '2024-05-06', 6),
    (65, 3, '3:30 - 4:15', '2024-05-06', 5);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (65, 4, '7:30 - 8:15', '2024-05-07', 4),
    (65, 4, '8:15 - 9:00', '2024-05-07', 3),
    (65, 4, '9:15 - 10:00', '2024-05-07', 2),
    (65, 4, '10:00 - 10:45', '2024-05-07', 1),
    (65, 4, '1:00 - 1:45', '2024-05-07', 8),
    (65, 4, '1:45 - 2:30', '2024-05-07', 7),
    (65, 4, '2:45 - 3:30', '2024-05-07', 6),
    (65, 4, '3:30 - 4:15', '2024-05-07', 5);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (65, 5, '7:30 - 8:15', '2024-05-08', 4),
    (65, 5, '8:15 - 9:00', '2024-05-08', 3),
    (65, 5, '9:15 - 10:00', '2024-05-08', 2),
    (65, 5, '10:00 - 10:45', '2024-05-08', 1),
    (65, 5, '1:00 - 1:45', '2024-05-08', 8),
    (65, 5, '1:45 - 2:30', '2024-05-08', 7),
    (65, 5, '2:45 - 3:30', '2024-05-08', 6),
    (65, 5, '3:30 - 4:15', '2024-05-08', 5);

INSERT INTO Timetable (ClassId, Weekdays, Times, Date, TeacherId)
VALUES
    (65, 6, '7:30 - 8:15', '2024-05-09', 4),
    (65, 6, '8:15 - 9:00', '2024-05-09', 3),
    (65, 6, '9:15 - 10:00', '2024-05-09', 2),
    (65, 6, '10:00 - 10:45', '2024-05-09', 1),
    (65, 6, '1:00 - 1:45', '2024-05-09', 8),
    (65, 6, '1:45 - 2:30', '2024-05-09', 7),
    (65, 6, '2:45 - 3:30', '2024-05-09', 6),
    (65, 6, '3:30 - 4:15', '2024-05-09', 5);


--10a1 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (352, N'Nguyễn Thị Mai', '2009-01-01', 1, '0769123456'),
    (353, N'Trần Văn Minh', '2008-02-15', 1, '0789694567'),
    (354, N'Phạm Thị Lan', '2009-03-20', 1, '0789345669'),
    (355, N'Lê Văn Hùng', '2008-04-10', 1, '0789456989'),
    (356, N'Nguyễn Văn An', '2008-05-25', 1, '0789569890');
--10a2 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (357, N'Phạm Thị Bích', '2009-06-15', 2, '0786878901'),
    (358, N'Lê Văn Bình', '2008-07-30', 2, '0789789682'),
    (359, N'Nguyễn Thị Cúc', '2008-08-05', 2, '0768890123'),
    (360, N'Trần Văn Dũng', '2008-09-10', 2, '0789681234'),
    (361, N'Phạm Văn Đại', '2009-10-25', 2, '0789068345');
--10a3 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (362, N'Lê Thị Đào', '2009-11-15', 3, '0789673456'),
    (363, N'Nguyễn Văn Đức', '2008-12-20', 3, '0767234567'),
    (364, N'Trần Thị Hằng', '2008-01-10', 3, '0789367678'),
    (365, N'Phạm Văn Hùng', '2008-02-25', 3, '0789676789'),
    (366, N'Lê Văn Hiếu', '2009-03-15', 3, '0789567670');
--10a4 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (367, N'Nguyễn Thị Hoa', '2008-04-20', 4, '0765778901'),
    (368, N'Trần Văn Huy', '2008-05-05', 4, '0789766012'),
    (369, N'Phạm Thị Lan', '2009-06-10', 4, '07898656123'),
    (370, N'Lê Văn Long', '2008-07-25', 4, '07899065434'),
    (371, N'Nguyễn Thị Mai', '2009-08-15', 4, '07650172345');
--10a5 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (372, N'Trần Văn Nam', '2008-09-20', 5, '0786523456'),
    (373, N'Phạm Thị Nga', '2008-10-05', 5, '0789654567'),
    (374, N'Lê Thị Ngọc', '2009-11-10', 5, '0789346578'),
    (375, N'Nguyễn Văn Phú', '2008-12-25', 5, '0789456589'),
    (376, N'Trần Văn Quang', '2009-01-15', 5, '0789567865');
--11a1 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (377, N'Nguyễn Thị Quyên', '2008-02-20', 6, '0649678901'),
    (378, N'Phạm Văn Sơn', '2008-03-05', 6, '0764789012'),
    (379, N'Lê Thị Thu', '2009-04-10', 6, '0789864123'),
    (380, N'Trần Văn Tùng', '2008-05-25', 6, '0789641234'),
    (381, N'Nguyễn Văn Tiến', '2009-06-15', 6, '0786412345');
--11a2 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (382, N'Trần Thị Tuyết', '2008-07-20', 7, '0786323456'),
    (383, N'Phạm Văn Tú', '2008-08-05', 7, '0789634567'),
    (384, N'Lê Thị Tâm', '2009-09-10', 7, '0789346378'),
    (385, N'Nguyễn Văn Tân', '2008-10-25', 7, '0789463789'),
    (386, N'Trần Văn Tài', '2009-11-15', 7, '0789567863');
--11a3 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (387, N'Nguyễn Thị Uyển', '2008-12-20', 8, '0789678962'),
    (388, N'Trần Văn Vinh', '2008-01-10', 8, '0789789622'),
    (389, N'Phạm Thị Vân', '2009-02-25', 8, '0789890162'),
    (390, N'Lê Văn Vũ', '2008-03-15', 8, '0789901624'),
    (391, N'Nguyễn Thị Xuân', '2009-04-20', 8, '0786212345');
--11a4 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (392, N'Trần Văn Yên', '2008-05-05', 9, '0786123456'),
    (393, N'Phạm Văn Yến', '2008-06-10', 9, '0789261567'),
    (394, N'Lê Thị Yến', '2009-07-25', 9, '0789345661'),
    (395, N'Nguyễn Văn Bình', '2008-08-15', 9, '0789461789'),
    (396, N'Trần Văn Chi', '2009-09-20', 9, '0789567861');
--11a5 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (397, N'Nguyễn Thị Dương', '2008-10-05', 10, '0789676001'),
    (398, N'Trần Văn Duy', '2009-11-10', 10, '0789760012'),
    (399, N'Phạm Thị Diệp', '2008-12-25', 10, '0789600123'),
    (400, N'Lê Văn Đạt', '2009-01-15', 10, '0789901604'),
    (401, N'Nguyễn Văn Đan', '2008-02-20', 10, '0786012345');
--12a1 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (402, N'Trần Thị Đào', '2008-03-05', 11, '0759123456'),
    (403, N'Phạm Văn Điền', '2009-04-10', 11, '0759234567'),
    (404, N'Lê Văn Định', '2008-05-25', 11, '0789359578'),
    (405, N'Nguyễn Thị Đan', '2009-06-15', 11, '0789596789'),
    (406, N'Trần Văn Đạt', '2008-07-20', 11, '0789567590');
--12a2 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (407, N'Nguyễn Thị Đường', '2008-08-05', 12, '0785878901'),
    (408, N'Phạm Văn Đồng', '2009-09-10', 12, '0789589012'),
    (409, N'Lê Văn Đức', '2008-10-25', 12, '0789895823'),
    (410, N'Nguyễn Thị Nam','2009-09-10', 12, '0785889012'),
    (411, N'Lê Văn Đức', '2008-10-25', 12, '0789890158');
--12a3 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (411, N'Trần Văn Đức', '2008-11-15', 13, '0579901234'),
    (412, N'Phạm Thị Dương', '2009-12-20', 13, '0757012345'),
    (413, N'Lê Văn Duy', '2009-01-10', 13, '0789125756'),
    (414, N'Nguyễn Thị Hà', '2008-02-25', 13, '0787534567'),
    (415, N'Trần Văn Hải', '2009-03-15', 13, '0789357678');
--12a4 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (416, N'Phạm Thị Hằng', '2008-04-20', 14, '0789456756'),
    (417, N'Lê Văn Hòa', '2009-05-05', 14, '0756567890'),
    (418, N'Nguyễn Thị Hoa', '2009-06-10', 14, '0785678901'),
    (419, N'Trần Văn Hòa', '2008-07-25', 14, '0789756012'),
    (420, N'Phạm Thị Hồng', '2009-08-15', 14, '0789856123');
--12a5 2020
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (421, N'Lê Văn Hùng', '2008-09-20', 15, '0789901554'),
    (422, N'Nguyễn Thị Hương', '2009-10-25', 15, '0785512345'),
    (423, N'Trần Văn Hùng', '2008-11-15', 15, '0785523456'),
    (424, N'Phạm Thị Hương', '2009-12-20', 15, '0789554567'),
    (425, N'Lê Văn Hưng', '2009-01-10', 15, '0789345578');
	--10a1 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (278, N'Nguyễn Văn Hải', '2008-05-15', 16, '07894593456'),
    (279, N'Trần Thị Hương', '2009-09-20', 16, '0789245567'),
    (280, N'Phạm Văn Hùng', '2009-03-10', 16, '0789345458'),
    (281, N'Lê Văn Khoa', '2008-11-25', 16, '0789456745'),
    (282, N'Nguyễn Thị Kim', '2008-08-12', 16, '07895547890');
--10a2 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (283, N'Phạm Văn Hưng', '2009-01-05', 17, '0789653901'),
    (284, N'Lê Thị Lan', '2008-10-30', 17, '0789789053'),
    (285, N'Hoàng Văn Long', '2008-06-15', 17, '0789853123'),
    (286, N'Phan Thị Lý', '2009-07-20', 17, '0789901534'),
    (287, N'Bùi Văn Mạnh', '2009-04-10', 17, '0789015345');
--10a3 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (288, N'Trần Văn Nam', '2008-12-25', 18, '0789123526'),
    (289, N'Nguyễn Thị Nga', '2008-09-12', 18, '0789252567'),
    (290, N'Phạm Văn Nghĩa', '2009-02-05', 18, '0789345652'),
    (291, N'Lê Thị Ngọc', '2008-11-30', 18, '0789455289'),
    (292, N'Nguyễn Văn Phúc', '2008-07-15', 18, '0789567520');
--10a4 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (293, N'Trần Thị Phương', '2009-08-20', 19, '0789675101'),
    (294, N'Phạm Văn Quang', '2009-05-10', 19, '0789781552'),
    (295, N'Lê Văn Quyết', '2008-12-25', 19, '0789851123'),
    (296, N'Nguyễn Thị Thanh', '2008-10-12', 19, '0751901234'),
    (297, N'Phạm Văn Thành', '2009-03-05', 19, '0789512345');
--10a5 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (298, N'Lê Thị Thu', '2008-09-30', 20, '0789123450'),
    (299, N'Hoàng Văn Thắng', '2008-08-15', 20, '0750234567'),
    (300, N'Phan Thị Thủy', '2009-11-20', 20, '0750345678'),
    (301, N'Bùi Văn Tiến', '2009-06-10', 20, '0789450789'),
    (302, N'Trần Văn Toàn', '2008-11-25', 20, '0789550890');
--11a1 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (303, N'Nguyễn Thị Trang', '2008-12-12', 21, '0498789901'),
    (304, N'Phạm Văn Trường', '2008-08-30', 21, '0499789012'),
    (305, N'Lê Văn Tú', '2009-10-15', 21, '0789890493'),
    (306, N'Trần Thị Tâm', '2009-07-20', 21, '0789904934'),
    (307, N'Nguyễn Văn Tân', '2009-04-10', 21, '0789012495');
--11a2 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (308, N'Trần Văn Tuấn', '2008-11-25', 22, '0789483456'),
    (309, N'Lê Thị Uyên', '2008-08-12', 22, '0789234487'),
    (310, N'Nguyễn Văn Vinh', '2009-01-05', 22, '0748345678'),
    (311, N'Phạm Thị Vân', '2008-10-30', 22, '0789448789'),
    (312, N'Lê Văn Vũ', '2008-06-15', 22, '0789564890');
--11a3 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (313, N'Nguyễn Thị Xuân', '2009-07-20', 23, '0784758901'),
    (314, N'Trần Văn Yên', '2009-04-10', 23, '0789784712'),
    (315, N'Phạm Văn Yến', '2008-12-25', 23, '0784790123'),
    (316, N'Lê Thị Yến', '2008-09-12', 23, '0789904734'),
    (317, N'Nguyễn Văn Bình', '2009-02-05', 23, '0789047345');
--11a4 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (318, N'Trần Văn Chi', '2008-11-30', 24, '0789124656'),
    (319, N'Nguyễn Thị Dương', '2008-07-15', 24, '0789234546'),
    (320, N'Phạm Văn Duy', '2009-08-20', 24, '07893456746'),
    (321, N'Lê Thị Diệp', '2009-05-10', 24, '0789456746'),
    (322, N'Trần Văn Đạt', '2008-12-25', 24, '0789546890');
--11a5 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (323, N'Nguyễn Văn Đức', '2008-10-12', 25, '0784578901'),
    (324, N'Trần Thị Đào', '2009-03-05', 25, '0789789452'),
    (325, N'Phạm Văn Điền', '2008-09-30', 25, '0789845123'),
    (326, N'Lê Văn Định', '2008-08-15', 25, '0789904534'),
    (327, N'Nguyễn Thị Đan', '2009-11-20', 25, '0789012455');
--12a1 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (328, N'Trần Văn Đạt', '2009-06-10', 26, '0789123444'),
    (329, N'Nguyễn Thị Đường', '2008-11-25', 26, '0744234567'),
    (330, N'Phạm Văn Đồng', '2008-12-12', 26, '0784445678'),
    (331, N'Lê Văn Đức', '2008-08-30', 26, '0789454489'),
    (332, N'Nguyễn Thị Hà', '2009-10-15', 26, '0789447890');
--12a2 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (333, N'Trần Thị Hằng', '2009-07-20', 27, '0789643901'),
    (334, N'Phạm Văn Hiếu', '2009-04-10', 27, '0789784312'),
    (335, N'Lê Thị Hoa', '2008-12-25', 27, '0789890433'),
    (336, N'Nguyễn Văn Hòa', '2008-09-12', 27, '0789943234'),
    (337, N'Trần Văn Hùng', '2009-02-05', 27, '0789012343');
--12a3 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (338, N'Nguyễn Thị Hạnh', '2008-11-30', 28, '0429123456'),
    (339, N'Trần Văn Hậu', '2008-07-15', 28, '0789242567'),
    (340, N'Phạm Thị Hiền', '2009-08-20', 28, '0789425678'),
    (341, N'Lê Văn Hiếu', '2009-05-10', 28, '078945429'),
    (342, N'Nguyễn Thị Hoàn', '2008-12-25', 28, '0789427890');
--12a4 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (343, N'Trần Văn Huy', '2008-10-12', 29, '0789678411'),
    (344, N'Phạm Thị Khánh', '2009-03-05', 29, '0789419012'),
    (345, N'Lê Văn Khải', '2008-09-30', 29, '0789894143'),
    (346, N'Nguyễn Thị Kiều', '2008-08-15', 29, '0784101234'),
    (347, N'Trần Thị Kim', '2009-11-20', 29, '0789012341');
--12a5 2021
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (348, N'Nguyễn Văn Khanh', '2009-06-10', 30, '0789403456'),
    (349, N'Trần Văn Khoa', '2008-11-25', 30, '0789234540'),
    (350, N'Phạm Thị Kiều', '2008-12-12', 30, '0789340678'),
    (351, N'Lê Văn Khiêm', '2008-08-30', 30, '0789440789'),
    (352, N'Nguyễn Thị Liên', '2009-10-15', 30, '0789407890');
	--10a1 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (204, N'Nguyễn Văn An', '2008-05-15', 31, '0789139456'),
    (205, N'Trần Thị Bình', '2009-09-20', 31, '0783934567'),
    (206, N'Phạm Văn Chính', '2009-03-10', 31, '0739345678'),
    (207, N'Lê Văn Đạo', '2008-11-25', 31, '0789456739'),
    (208, N'Nguyễn Thị Dung', '2008-08-12', 31, '0739567890');
--10a2 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (209, N'Phạm Văn Duy', '2009-01-05', 32, '0789673801'),
    (210, N'Lê Thị Hạnh', '2008-10-30', 32, '0789389012'),
    (211, N'Hoàng Văn Hiếu', '2008-06-15', 32, '0789890138'),
    (212, N'Phan Thị Hoa', '2009-07-20', 32, '0789903834'),
    (213, N'Bùi Văn Hùng', '2009-04-10', 32, '0789033345');
	--10a3 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (214, N'Trần Văn Hưng', '2008-12-25', 33, '0789123376'),
    (215, N'Nguyễn Thị Khoa', '2008-09-12', 33, '0789374567'),
    (216, N'Phạm Văn Khôi', '2009-02-05', 33, '0789375678'),
    (217, N'Lê Thị Lan', '2008-11-30', 33, '0789437789'),
    (218, N'Nguyễn Văn Lộc', '2008-07-15', 33, '0789567837');
--10a4 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (219, N'Trần Thị Ly', '2009-08-20', 34, '0789673601'),
    (220, N'Phạm Văn Minh', '2009-05-10', 34, '0789789036'),
    (221, N'Lê Văn Nam', '2008-12-25', 34, '0789890136'),
    (222, N'Nguyễn Thị Nga', '2008-10-12', 34, '0789901236'),
    (223, N'Phạm Văn Nghĩa', '2009-03-05', 34, '0789012365');
--10a5 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (224, N'Lê Thị Ngọc', '2008-09-30', 35, '0789123356'),
    (225, N'Hoàng Văn Phúc', '2008-08-15', 35, '0789354567'),
    (226, N'Phan Thị Quỳnh', '2009-11-20', 35, '0783545678'),
    (227, N'Bùi Văn Sơn', '2009-06-10', 35, '0789453589'),
    (228, N'Trần Văn Tài', '2008-11-25', 35, '0789357890');
--11a1 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (229, N'Nguyễn Thị Thanh', '2008-12-12', 36, '0783478901'),
    (230, N'Phạm Văn Thiện', '2008-08-30', 36, '0789734012'),
    (231, N'Lê Văn Thịnh', '2009-10-15', 36, '0789890343'),
    (232, N'Trần Thị Thúy', '2009-07-20', 36, '0789341234'),
    (233, N'Nguyễn Văn Toàn', '2009-04-10', 36, '0734012345');
--11a2 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (234, N'Trần Văn Trang', '2008-11-25', 37, '0733123456'),
    (235, N'Lê Thị Trinh', '2008-08-12', 37, '0789234337'),
    (236, N'Nguyễn Văn Trọng', '2009-01-05', 37, '0789343378'),
    (237, N'Phạm Thị Tùng', '2008-10-30', 37, '0789453389'),
    (238, N'Lê Văn Tường', '2008-06-15', 37, '0789337890');
--11a3 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (239, N'Nguyễn Thị Vân', '2009-07-20', 38, '0783278901'),
    (240, N'Trần Văn Việt', '2009-04-10', 38, '0789329012'),
    (241, N'Phạm Văn Vinh', '2008-12-25', 38, '0789320123'),
    (242, N'Lê Thị Xuân', '2008-09-12', 38, '0789901234'),
    (243, N'Nguyễn Văn Yên', '2009-02-05', 38, '0723202345');
--11a4 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (244, N'Trần Văn Bình', '2008-11-30', 39, '0731123456'),
    (245, N'Nguyễn Thị Chi', '2008-07-15', 39, '0789314567'),
    (246, N'Phạm Văn Cơ', '2009-08-20', 39, '0789315678'),
    (247, N'Lê Thị Cúc', '2009-05-10', 39, '0789456319'),
    (248, N'Trần Văn Dân', '2008-12-25', 39, '0789317890');
--11a5 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (249, N'Nguyễn Văn Đăng', '2008-10-12', 40, '0783078901'),
    (250, N'Trần Thị Diệu', '2009-03-05', 40, '0789780392'),
    (251, N'Phạm Văn Điệp', '2008-09-30', 40, '0789830123'),
    (252, N'Lê Văn Đông', '2008-08-15', 40, '0789901304'),
    (253, N'Nguyễn Thị Dung', '2009-11-20', 40, '0789012305');
--12a1 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (254, N'Trần Văn Hùng', '2009-06-10', 41, '0789293456'),
    (255, N'Nguyễn Thị Huệ', '2008-11-25', 41, '0782934567'),
    (256, N'Phạm Văn Kiên', '2008-12-12', 41, '0789295678'),
    (257, N'Lê Văn Long', '2008-08-30', 41, '0789429789'),
    (258, N'Nguyễn Thị Mai', '2009-10-15', 41, '0789297890');
--12a2 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (259, N'Trần Thị Nga', '2009-07-20', 42, '0789628901'),
    (260, N'Phạm Văn Quang', '2009-04-10', 42, '0782889012'),
    (261, N'Lê Thị Tuyết', '2008-12-25', 42, '0789892823'),
    (262, N'Nguyễn Văn Thái', '2008-09-12', 42, '0789281234'),
    (263, N'Trần Văn Tuấn', '2009-02-05', 42, '0782812345');
--12a3 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (264, N'Nguyễn Thị Uyên', '2008-11-30', 43, '0789273456'),
    (265, N'Phạm Văn Vũ', '2008-07-15', 43, '0789234277'),
    (266, N'Lê Thị Xuân', '2009-08-20', 43, '0789342778'),
    (267, N'Trần Văn Xương', '2009-05-10', 43, '0727456789'),
    (268, N'Nguyễn Văn Yên', '2008-12-25', 43, '0279567890');
--12a4 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (269, N'Trần Văn Yến', '2008-10-12', 44, '0789268901'),
    (270, N'Phạm Thị Yến', '2009-03-05', 44, '0269789012'),
    (271, N'Lê Văn Khoa', '2008-09-30', 44, '0782680123'),
    (272, N'Trần Văn Khang', '2008-08-15', 44, '0269901234'),
    (273, N'Nguyễn Thị Kim', '2009-11-20', 44, '0789262345');
--12a5 2022
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (274, N'Trần Văn Kiên', '2009-06-10', 45, '0782523456'),
    (275, N'Nguyễn Thị Kiều', '2008-11-25', 45, '0259234567'),
    (276, N'Phạm Văn Lực', '2008-12-12', 45, '0782545678'),
    (277, N'Lê Văn Lộc', '2008-08-30', 45, '0789425789'),
    (278, N'Nguyễn Thị Lý', '2009-10-15', 45, '0789562590');
	--10a1 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (114, N'Nguyễn Văn Hậu', '2008-05-15', 46, '0789122456'),
    (115, N'Trần Thị Nam', '2009-09-20', 46, '0789244567'),
    (116, N'Phạm Văn Cường', '2009-03-10', 46, '0782445678'),
    (117, N'Lê Văn Hậu', '2008-11-25', 46, '0789424789'),
    (118, N'Nguyễn Thị Nam', '2008-08-12', 46, '0789247890'),
    (119, N'Phạm Văn Cường', '2009-01-05', 46, '0789248901');
--lop 10a2 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (120, N'Lê Thị Hậu', '2008-10-30', 47, '0789723012'),
    (121, N'Hoàng Văn Nam', '2008-06-15', 47, '0789890233'),
    (122, N'Phan Thị Cường', '2009-07-20', 47, '0789923234'),
    (123, N'Bùi Văn Hậu', '2009-04-10', 47, '0789023345'),
    (124, N'Trần Văn Nam', '2008-12-25', 47, '0789123423'),
    (125, N'Nguyễn Thị Cường', '2008-09-12', 47, '0782334567');
--10a3 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (126, N'Phạm Văn Hậu', '2009-02-05', 48, '0789345622'),
    (127, N'Lê Thị Nam', '2008-11-30', 48, '0789452289'),
    (128, N'Nguyễn Văn Cường', '2008-07-15', 48, '0782267890'),
    (129, N'Trần Thị Hậu', '2009-08-20', 48, '0789228901'),
    (130, N'Phạm Văn Nam', '2009-05-10', 48, '0789722012'),
    (131, N'Lê Văn Cường', '2008-12-25', 48, '0789822123');
--10a4 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (132, N'Nguyễn Thị Hậu', '2008-10-12', 49, '0789921234'),
    (133, N'Phạm Văn Nam', '2009-03-05', 49, '0721012345'),
    (134, N'Lê Thị Cường', '2008-09-30', 49, '0789123421'),
    (135, N'Hoàng Văn Hậu', '2008-08-15', 49, '0789221567'),
    (136, N'Phan Thị Nam', '2009-11-20', 49, '0789321678'),
    (137, N'Bùi Văn Cường', '2009-06-10', 49, '0789421789');
--10a5 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (138, N'Trần Văn Hậu', '2008-11-25', 50, '0782067890'),
    (139, N'Nguyễn Thị Nam', '2008-12-12', 50, '0720678901'),
    (140, N'Phạm Văn Cường', '2009-04-05', 50, '0782089012'),
    (141, N'Lê Thị Hậu', '2008-08-30', 50, '0789820123'),
    (142, N'Nguyễn Văn Nam', '2008-10-15', 50, '0782001234'),
    (143, N'Trần Thị Cường', '2009-07-20', 50, '0789202345');
--11a1 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (144, N'Phạm Văn Hậu', '2009-03-10', 51, '0789121956'),
    (145, N'Lê Văn Nam', '2008-11-25', 51, '0789234197'),
    (146, N'Nguyễn Thị Cường', '2008-08-12', 51, '0781945678'),
    (147, N'Phạm Văn Hậu', '2009-01-05', 51, '0789451989'),
    (148, N'Lê Thị Nam', '2008-10-30', 51, '0789567190'),
    (149, N'Nguyễn Văn Cường', '2008-05-15', 51, '0199678901');
--11a2 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (150, N'Hoàng Văn Nam', '2009-09-20', 52, '0789781812'),
    (151, N'Phan Thị Cường', '2009-03-10', 52, '0781890123'),
    (152, N'Bùi Văn Hậu', '2008-11-25', 52, '0789918234'),
    (153, N'Trần Văn Nam', '2008-08-12', 52, '0789018345'),
    (154, N'Nguyễn Thị Cường', '2009-01-05', 52, '0789183456'),
    (155, N'Phạm Văn Hậu', '2008-10-30', 52, '0789218567');
--11a3 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (156, N'Lê Thị Nam', '2008-06-15', 53, '0789317678'),
    (157, N'Nguyễn Văn Hậu', '2009-07-20', 53, '0789176789'),
    (158, N'Trần Thị Nam', '2009-04-10', 53, '0789567170'),
    (159, N'Phạm Văn Cường', '2008-12-25', 53, '0781778901'),
    (160, N'Lê Văn Hậu', '2008-09-12', 53, '0789781712'),
    (161, N'Nguyễn Thị Nam', '2009-02-05', 53, '0789817123');
--11a4 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (162, N'Phạm Văn Cường', '2008-11-30', 54, '0789916234'),
    (163, N'Lê Thị Hậu', '2008-07-15', 54, '0789011645'),
    (164, N'Nguyễn Văn Cường', '2009-08-20', 54, '0169123456'),
    (165, N'Trần Thị Hậu', '2009-05-10', 54, '0789216567'),
    (166, N'Phạm Văn Nam', '2008-12-25', 54, '0789165678'),
    (167, N'Lê Văn Cường', '2008-10-12', 54, '0789166789');
--11a5 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (168, N'Nguyễn Thị Hậu', '2009-03-05', 55, '0789561590'),
    (169, N'Phạm Văn Nam', '2008-09-30', 55, '0789671501'),
    (170, N'Lê Thị Cường', '2008-08-15', 55, '0781589012'),
    (171, N'Hoàng Văn Hậu', '2009-11-20', 55, '0781590123'),
    (172, N'Phan Thị Nam', '2009-06-10', 55, '0789915234'),
    (173, N'Bùi Văn Cường', '2008-11-25', 55, '0789015345');
--12a1 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (174, N'Trần Văn Hậu', '2008-12-12', 56, '0781423456'),
    (175, N'Nguyễn Thị Nam', '2008-08-30', 56, '0781434567'),
    (176, N'Phạm Văn Cường', '2009-10-15', 56, '0789314678'),
    (177, N'Lê Thị Hậu', '2009-07-20', 56, '0789456149'),
    (178, N'Nguyễn Văn Nam', '2009-04-10', 56, '0714567890'),
    (179, N'Trần Thị Cường', '2008-11-25', 56, '0714678901');
--12a2 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (180, N'Phạm Văn Hậu', '2008-08-12', 57, '0789139012'),
    (181, N'Lê Văn Nam', '2009-01-05', 57, '0789890133'),
    (182, N'Nguyễn Thị Cường', '2008-10-30', 57, '0781301234'),
    (183, N'Phạm Văn Hậu', '2008-05-15', 57, '0789012135'),
    (184, N'Lê Thị Nam', '2009-09-20', 57, '0781323456'),
    (185, N'Nguyễn Văn Cường', '2009-03-10', 57, '0713234567');
--12a3 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (186, N'Trần Thị Hậu', '2008-11-25', 58, '0789124678'),
    (187, N'Phạm Văn Nam', '2008-08-12', 58, '0789456712'),
    (188, N'Lê Văn Hậu', '2009-01-05', 58, '0789567120'),
    (189, N'Nguyễn Thị Nam', '2008-10-30', 58, '0712678901'),
    (190, N'Phạm Văn Cường', '2009-07-15', 58, '0781289012'),
    (191, N'Lê Thị Hậu', '2009-05-10', 58, '0789890112');
--12a4 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (192, N'Nguyễn Văn Hậu', '2008-12-25', 59, '0789911234'),
    (193, N'Trần Thị Nam', '2009-09-12', 59, '0781112345'),
    (194, N'Phạm Văn Cường', '2008-02-05', 59, '0789113456'),
    (195, N'Lê Văn Hậu', '2009-11-30', 59, '0789234511'),
    (196, N'Nguyễn Thị Nam', '2008-07-15', 59, '0789341178'),
    (197, N'Phạm Văn Cường', '2009-08-20', 59, '0789411789');
--12a5 2023
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (198, N'Lê Thị Hậu', '2009-05-10', 60, '0789107890'),
    (199, N'Hoàng Văn Nam', '2008-12-25', 60, '0789610901'),
    (200, N'Phan Thị Cường', '2008-10-12', 60, '0789781012'),
    (201, N'Bùi Văn Hậu', '2009-03-05', 60, '0789891023'),
    (202, N'Trần Văn Nam', '2008-09-30', 60, '0789101234'),
    (203, N'Nguyễn Thị Cường', '2009-08-15', 60, '0710012345');
	--lop 10A1 2024
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (9, N'Nguyễn Văn Hậu', '2008-05-15', 61, '0788045380'),
    (10, N'Trần Thị Nam', '2009-09-20', 61, '0789234567'),
    (11, N'Phạm Văn Cường', '2009-03-10', 61, '0789756558'),
    (12, N'Lê Văn Hậu', '2008-11-25', 61, '0789450789'),
    (13, N'Nguyễn Thị Nam', '2008-08-12', 61, '0789547890'),
    (14, N'Phạm Văn Cường', '2009-01-05', 61, '0789478901'),
    (15, N'Lê Thị Hậu', '2008-10-30', 61, '0789780012');
--lop 10A2
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (16, N'Hoàng Văn Nam', '2008-06-15', 62, '0789890723'),
    (17, N'Phan Thị Cường', '2009-07-20', 62, '0789901734'),
    (18, N'Bùi Văn Hậu', '2009-04-10', 62, '0789012745'),
    (19, N'Trần Văn Nam', '2008-12-25', 62, '0789127456'),
    (20, N'Nguyễn Thị Cường', '2008-09-12', 62, '0789734567'),
    (21, N'Phạm Văn Hậu', '2009-02-05', 62, '0789345778'),
    (22, N'Lê Thị Nam', '2008-11-30', 62, '0789456779');
--lop 10A3
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (23, N'Nguyễn Văn Cường', '2008-07-15', 63, '0788567890'),
    (24, N'Trần Thị Hậu', '2009-08-20', 63, '0788688901'),
    (25, N'Phạm Văn Nam', '2009-05-10', 63, '0789789812'),
    (26, N'Lê Văn Cường', '2008-12-25', 63, '0789890128'),
    (27, N'Nguyễn Thị Hậu', '2008-10-12', 63, '0789981234'),
    (28, N'Phạm Văn Nam', '2009-03-05', 63, '0789012845'),
    (29, N'Lê Thị Cường', '2008-09-30', 63, '0789123856');
--lop 10A4
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (30, N'Hoàng Văn Hậu', '2008-08-15', 64, '0789239567'),
    (31, N'Phan Thị Nam', '2009-11-20', 64, '0789345698'),
    (32, N'Bùi Văn Cường', '2009-06-10', 64, '0789956789'),
    (33, N'Trần Văn Hậu', '2008-11-25', 64, '0789569890'),
    (34, N'Nguyễn Thị Nam', '2008-12-12', 64, '0789678901'),
    (35, N'Phạm Văn Cường', '2009-04-05', 64, '0789799012'),
    (36, N'Lê Thị Hậu', '2008-08-30', 64, '0789890923');
--lop 10A5
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (37, N'Nguyễn Văn Nam', '2008-10-15', 65, '0789401234'),
    (38, N'Trần Thị Cường', '2009-07-20', 65, '0789412345'),
    (39, N'Phạm Văn Hậu', '2009-03-10', 65, '0789124456'),
    (40, N'Lê Văn Nam', '2008-11-25', 65, '0789234564'),
    (41, N'Nguyễn Thị Cường', '2008-08-12', 65, '0784345678'),
    (42, N'Phạm Văn Hậu', '2009-01-05', 65, '0489456789'),
    (43, N'Lê Thị Nam', '2008-10-30', 65, '0789564890');
--lop 11A1
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (43, N'Hoàng Văn Cường', '2008-05-15', 66, '0589678901'),
    (45, N'Phan Thị Hậu', '2009-09-20', 66, '0759789012'),
    (46, N'Bùi Văn Nam', '2009-03-10', 66, '0785890123'),
    (47, N'Trần Văn Cường', '2008-11-25', 66, '0759901234'),
    (48, N'Nguyễn Thị Hậu', '2008-08-12', 66, '0785012345'),
    (49, N'Phạm Văn Nam', '2009-01-05', 66, '0789123556'),
    (50, N'Lê Thị Cường', '2008-10-30', 66, '0789234557');
--lop 11A2
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (51, N'Nguyễn Văn Hậu', '2008-06-15', 67, '0789345668'),
    (52, N'Trần Thị Nam', '2009-07-20', 67, '0789456769'),
    (53, N'Phạm Văn Cường', '2009-04-10', 67, '0789567690'),
    (54, N'Lê Văn Hậu', '2008-12-25', 67, '0789678961'),
    (55, N'Nguyễn Thị Nam', '2008-09-12', 67, '0789789062'),
    (56, N'Phạm Văn Cường', '2009-02-05', 67, '0789890623'),
    (57, N'Lê Thị Hậu', '2008-11-30', 67, '0789901236');
--lop 11A3
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (58, N'Nguyễn Văn Nam', '2008-07-15', 68, '0789012341'),
    (59, N'Trần Thị Cường', '2009-08-20', 68, '0789123416'),
    (60, N'Phạm Văn Hậu', '2009-05-10', 68, '0789234517'),
    (61, N'Lê Văn Nam', '2008-12-25', 68, '0789345671'),
    (62, N'Nguyễn Thị Cường', '2008-10-12', 68, '0789456189'),
    (63, N'Phạm Văn Hậu', '2009-03-05', 68, '0789567810'),
    (64, N'Lê Thị Nam', '2008-09-30', 68, '0789178101');
--lop 11A4
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (65, N'Hoàng Văn Cường', '2008-08-15', 69, '0789289012'),
    (66, N'Phan Thị Hậu', '2009-11-20', 69, '0789892123'),
    (67, N'Bùi Văn Nam', '2009-06-10', 69, '0789901224'),
    (68, N'Trần Văn Cường', '2008-11-25', 69, '0729022345'),
    (69, N'Nguyễn Thị Hậu', '2008-12-12', 69, '2789123456'),
    (70, N'Phạm Văn Nam', '2009-04-05', 69, '0789222567'),
    (71, N'Lê Thị Cường', '2008-08-30', 69, '0789345278');
--lop 11A5
iNSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (72, N'Nguyễn Văn Hậu', '2008-10-15', 70, '0739456789'),
    (73, N'Trần Thị Nam', '2009-07-20', 70, '0789537890'),
    (74, N'Phạm Văn Cường', '2009-03-10', 70, '0789638901'),
    (75, N'Lê Văn Hậu', '2008-11-25', 70, '0789789032'),
    (76, N'Nguyễn Thị Nam', '2008-08-12', 70, '0789890323'),
    (77, N'Phạm Văn Cường', '2009-01-05', 70, '0739901234'),
    (78, N'Lê Thị Hậu', '2008-10-30', 70, '0789013345');
--lop 12A1
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (79, N'Hoàng Văn Nam', '2008-05-15', 71, '0789103456'),
    (80, N'Phan Thị Cường', '2009-09-20', 71, '0089234567'),
    (81, N'Bùi Văn Hậu', '2009-03-10', 71, '0789045678'),
    (82, N'Trần Văn Nam', '2008-11-25', 71, '0789406789'),
    (83, N'Nguyễn Thị Cường', '2008-08-12', 71, '0789067890'),
    (84, N'Phạm Văn Hậu', '2009-01-05', 71, '0789670901'),
    (85, N'Lê Thị Nam', '2008-10-30', 71, '0789789002');
--lop 12A2
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (86, N'Nguyễn Văn Cường', '2008-06-15', 72, '0719890123'),
    (87, N'Trần Thị Hậu', '2009-07-20', 72, '0789901211'),
    (88, N'Phạm Văn Nam', '2009-04-10', 72, '0789012245'),
    (89, N'Lê Văn Cường', '2008-12-25', 72, '0789123156'),
    (90, N'Nguyễn Thị Hậu', '2008-09-12', 72, '0189234567'),
    (91, N'Phạm Văn Nam', '2009-02-05', 72, '0189345678'),
    (92, N'Lê Thị Cường', '2008-11-30', 72, '0189456789');
--lop 12A3
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (93, N'Hoàng Văn Hậu', '2008-07-15', 73, '0189567890'),
    (94, N'Phan Thị Nam', '2009-08-20', 73, '0189678901'),
    (95, N'Bùi Văn Cường', '2009-05-10', 73, '0789189012'),
    (96, N'Trần Văn Hậu', '2008-12-25', 73, '0789190123'),
    (97, N'Nguyễn Thị Nam', '2008-10-12', 73, '0789901134'),
    (98, N'Phạm Văn Cường', '2009-03-05', 73, '0189012345'),
    (99, N'Lê Thị Hậu', '2008-09-30', 73, '0781123456');
--lop 12A4
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (100, N'Nguyễn Văn Nam', '2008-08-15', 74, '0789224567'),
    (101, N'Trần Thị Cường', '2009-11-20', 74, '0789325678'),
    (102, N'Phạm Văn Hậu', '2009-06-10', 74, '0789256789'),
    (103, N'Lê Văn Nam', '2008-11-25', 74, '0789567820'),
    (104, N'Nguyễn Thị Cường', '2008-12-12', 74, '0289678901'),
    (105, N'Phạm Văn Hậu', '2009-04-05', 74, '0789782012'),
    (106, N'Lê Thị Nam', '2008-08-30', 74, '0789290123');
--lop 12A5
INSERT INTO Students(UserId, Name, DateOfBirth, ClassId, SDTPH)
VALUES
    (107, N'Nguyễn Văn Cường', '2008-10-15', 75, '0739901234'),
    (108, N'Trần Thị Hậu', '2009-07-20', 75, '0789032345'),
    (109, N'Phạm Văn Nam', '2009-03-10', 75, '0789133456'),
    (110, N'Lê Văn Cường', '2008-11-25', 75, '0789234367'),
    (111, N'Nguyễn Thị Hậu', '2008-08-12', 75, '0789335678'),
    (112, N'Phạm Văn Nam', '2009-01-05', 75, '0789453789'),
    (113, N'Lê Thị Cường', '2008-10-30', 75, '0789537890');

DECLARE @ParentId INT = 9;
DECLARE @StudentId INT = 9;

-- Gán mỗi phụ huynh ít nhất một học sinh
WHILE @ParentId <= 417 AND @StudentId <= 421
BEGIN
    INSERT INTO ParentStudentRelationship (ParentId, StudentId)
    VALUES (@ParentId, @StudentId);
    SET @ParentId = @ParentId + 1;
    SET @StudentId = @StudentId + 1;
END


SET @ParentId = 9;

WHILE @StudentId <= 420
BEGIN
    INSERT INTO ParentStudentRelationship (ParentId, StudentId)
    VALUES (@ParentId, @StudentId);
    SET @ParentId = @ParentId + 1;
    SET @StudentId = @StudentId + 1;

    IF @ParentId > 417
    BEGIN
        SET @ParentId = 9;
    END
END



	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(316, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(316, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(316, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(316, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(316, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(316, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(316, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(316, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(316, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(316, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(316, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(316, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(316, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(316, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(316, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(316, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(317, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(317, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(317, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(317, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(317, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(317, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(317, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(317, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(317, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(317, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(317, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(317, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(317, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(317, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(317, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(317, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(318, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(318, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(318, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(318, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(318, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(318, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(318, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(318, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');

				INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(318, 61, 1, '8,7,9', 8, 9, 8, 9, 1, N'Văn', 2, 'Pass'),
		(318, 61, 2, '4,2,3', 3, 4, 2, 2, 1, N'Toán', 2, ' Not Pass'),
		(318, 61, 3, '8,8,9',8, 9, 8, 2, 1, N'Anh', 2, 'Pass'),
		(318, 61, 4, '5,7,8',5, 9, 8, 2, 1, N'Lịch sử', 2, 'Pass'),
		(318, 61, 5, '4,6,3',4, 3, 5, 2, 1, N'Địa lí', 2, 'Not Pass'),
		(318, 61, 6, '8,8,8',6, 6, 7, 7, 1, N'Hóa học', 2, 'Pass'),
		(318, 61, 7, '9,9,9',7, 9, 8, 9, 1, N'Sinh học', 2, 'Pass'),
		(318, 61, 8, '6,6,6',6, 6, 6, 6, 1, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(319, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(319, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(319, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(319, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(319, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(319, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(319, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(319, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(319, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(319, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(319, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(319, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(319, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(319, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(319, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học',2, 'Pass'),
		(319, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ',2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(320, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(320, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(320, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(320, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(320, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(320, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(320, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(320, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
				INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(320, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(320, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(320, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(320, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(320, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(320, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(320, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học',2, 'Pass'),
		(320, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(321, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(321, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(321, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(321, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(321, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(321, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(321, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(321, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
				INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(321, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(321, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(321, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(321, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(321, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(321, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(321, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(321, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(322, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(322, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(322, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(322, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(322, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(322, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(322, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(322, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(322, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(322, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(322, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(322, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(322, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(322, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(322, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(322, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(323, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(323, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(323, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(323, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(323, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(323, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(323, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(323, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(323, 61, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(323, 61, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(323, 61, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(323, 61, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(323, 61, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(323, 61, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(323, 61, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(323, 61, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(324, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(324, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(324, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(324, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(324, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(324, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(324, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(324, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
				INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(324, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 2, 'Pass'),
		(324, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 2, ' Not Pass'),
		(324, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 2, 'Pass'),
		(324, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 2, 'Pass'),
		(324, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 2, 'Not Pass'),
		(324, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 2, 'Pass'),
		(324, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 2, 'Pass'),
		(324, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 2, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(325, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(325, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(325, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(325, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(325, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(325, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(325, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(325, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(326, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(326, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(326, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(326, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(326, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(326, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(326, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(326, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(327, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(327, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(327, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(327, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(327, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(327, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(327, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(327, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(328, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(328, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(328, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(328, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(328, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(328, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(328, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(328, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(329, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(329, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(329, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(329, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(329, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(329, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(329, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(329, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
		(330, 62, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
		(330, 62, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, ' Not Pass'),
		(330, 62, 3, '8,8,9',8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
		(330, 62, 4, '5,7,8',5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
		(330, 62, 5, '4,6,3',4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
		(330, 62, 6, '8,8,8',6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
		(330, 62, 7, '9,9,9',7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
		(330, 62, 8, '6,6,6',6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
		INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (331, 63, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (331, 63, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (331, 63, 3, '6,7,8',6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (331, 63, 4, '4,5,6',4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (331, 63, 5, '5,6,7',5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (331, 63, 6, '7,8,9',7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (331, 63, 7, '8,9,9',8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (331, 63, 8, '6,7,7',6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (332, 63, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (332, 63, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (332, 63, 3, '6,7,8',6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (332, 63, 4, '4,5,6',4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (332, 63, 5, '5,6,7',5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (332, 63, 6, '7,8,9',7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (332, 63, 7, '8,9,9',8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (332, 63, 8, '6,7,7',6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (333, 63, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (333, 63, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (333, 63, 3, '6,7,8',6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (333, 63, 4, '4,5,6',4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (333, 63, 5, '5,6,7',5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (333, 63, 6, '7,8,9',7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (333, 63, 7, '8,9,9',8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (333, 63, 8, '6,7,7',6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (334, 63, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (334, 63, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (334, 63, 3, '6,7,8',6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (334, 63, 4, '4,5,6',4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (334, 63, 5, '5,6,7',5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (334, 63, 6, '7,8,9',7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (334, 63, 7, '8,9,9',8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (334, 63, 8, '6,7,7',6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (335, 63, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (335, 63, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (335, 63, 3, '6,7,8',6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (335, 63, 4, '4,5,6',4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (335, 63, 5, '5,6,7',5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (335, 63, 6, '7,8,9',7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (335, 63, 7, '8,9,9',8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (335, 63, 8, '6,7,7',6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (336, 63, 1, '5,8,7', 5, 7, 6, 7, 6, N'Văn', 1, 'Pass'),
    (336, 63, 2, '3,4,7', 4, 6, 3, 5, 4, N'Toán', 1, 'Pass'),
    (336, 63, 3, '6,7,8', 7, 8, 6, 7, 7, N'Anh', 1, 'Pass'),
    (336, 63, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (336, 63, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (336, 63, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (336, 63, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (336, 63, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (337, 63, 1, '4,6,7', 4, 7, 5, 6, 5, N'Văn', 1, 'Pass'),
    (337, 63, 2, '2,5,8', 5, 8, 2, 5, 4, N'Toán', 1, 'Pass'),
    (337, 63, 3, '5,8,9', 8, 9, 5, 8, 7, N'Anh', 1, 'Pass'),
    (337, 63, 4, '3,5,7', 3, 7, 3, 5, 4, N'Lịch sử', 1, 'Pass'),
    (337, 63, 5, '4,6,8', 6, 8, 4, 6, 5, N'Địa lí', 1, 'Pass'),
    (337, 63, 6, '6,7,8', 6, 8, 6, 7, 6, N'Hóa học', 1, 'Pass'),
    (337, 63, 7, '7,8,9', 7, 9, 7, 8, 7, N'Sinh học', 1, 'Pass'),
    (337, 63, 8, '5,7,7', 5, 7, 5, 7, 5, N'Công nghệ', 1, 'Pass');
	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (338, 64, 1, '6,8,7', 6, 7, 6, 7, 6, N'Văn', 1, 'Pass'),
    (338, 64, 2, '3,6,8', 3, 8, 3, 6, 4, N'Toán', 1, 'Pass'),
    (338, 64, 3, '7,8,9', 7, 9, 7, 8, 7, N'Anh', 1, 'Pass'),
    (338, 64, 4, '4,5,7', 4, 7, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (338, 64, 5, '5,7,8', 5, 8, 5, 7, 5, N'Địa lí', 1, 'Pass'),
    (338, 64, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (338, 64, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (338, 64, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),
    (339, 64, 1, '5,8,7', 5, 7, 6, 7, 6, N'Văn', 1, 'Pass'),
    (339, 64, 2, '3,4,7', 4, 6, 3, 5, 4, N'Toán', 1, 'Pass'),
    (339, 64, 3, '6,7,8', 7, 8, 6, 7, 7, N'Anh', 1, 'Pass'),
    (339, 64, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (339, 64, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (339, 64, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (339, 64, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (339, 64, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),
    (340, 64, 8, '6,7,7', 6, 7, 6, 7, 6, N'Toán', 1, 'Pass'),
    (342, 64, 3, '6,7,8', 7, 8, 6, 7, 7, N'Anh', 1, 'Pass'),
    (342, 64, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (342, 64, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (342, 64, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (342, 64, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (342, 64, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),
    (343, 64, 1, '4,6,7', 4, 7, 5, 6, 5, N'Văn', 1, 'Pass'),
    (343, 64, 2, '2,5,8', 5, 8, 2, 5, 4, N'Toán', 1, 'Pass'),
    (343, 64, 3, '5,8,9', 8, 9, 5, 8, 7, N'Anh', 1, 'Pass'),
    (343, 64, 4, '3,5,7', 3, 7, 3, 5, 4, N'Lịch sử', 1, 'Pass'),
    (343, 64, 5, '4,6,8', 6, 8, 4, 6, 5, N'Địa lí', 1, 'Pass'),
    (343, 64, 6, '6,7,8', 6, 8, 6, 7, 6, N'Hóa học', 1, 'Pass'),
    (343, 64, 7, '7,8,9', 7, 9, 7, 8, 7, N'Sinh học', 1, 'Pass'),
    (343, 64, 8, '5,7,7', 5, 7, 5, 7, 5, N'Công nghệ', 1, 'Pass'),
    (344, 64, 1, '6,8,7', 6, 7, 6, 7, 6, N'Văn', 1, 'Pass'),
    (344, 64, 2, '3,6,8', 3, 8, 3, 6, 4, N'Toán', 1, 'Pass'),
    (344, 64, 3, '7,8,9', 7, 9, 7, 8, 7, N'Anh', 1, 'Pass'),
    (344, 64, 4, '4,5,7', 4, 7, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (344, 64, 5, '5,7,8', 5, 8, 5, 7, 5, N'Địa lí', 1, 'Pass'),
    (344, 64, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (344, 64, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (344, 64, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
	VALUES 
    (345, 65, 1, '7,8,9', 7, 9, 7, 8, 7, N'Văn', 1, 'Pass'),
    (345, 65, 2, '5,6,7', 5, 7, 5, 6, 5, N'Toán', 1, 'Pass'),
    (345, 65, 3, '8,9,9', 8, 9, 8, 9, 8, N'Anh', 1, 'Pass'),
    (345, 65, 4, '6,7,7', 6, 7, 6, 7, 6, N'Lịch sử', 1, 'Pass'),
    (345, 65, 5, '7,8,9', 7, 9, 7, 8, 7, N'Địa lí', 1, 'Pass'),
    (345, 65, 6, '8,9,9', 8, 9, 8, 9, 8, N'Hóa học', 1, 'Pass'),
    (345, 65, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (345, 65, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),
    (346, 65, 1, '6,7,8', 6, 8, 6, 7, 6, N'Văn', 1, 'Pass'),
    (346, 65, 2, '4,5,6', 4, 6, 4, 5, 4, N'Toán', 1, 'Pass'),
    (346, 65, 3, '7,8,9', 7, 9, 7, 8, 7, N'Anh', 1, 'Pass'),
    (346, 65, 4, '5,6,7', 5, 7, 5, 6, 5, N'Lịch sử', 1, 'Pass'),
    (346, 65, 5, '6,7,8', 6, 8, 6, 7, 6, N'Địa lí', 1, 'Pass'),
    (346, 65, 6, '8,9,9', 8, 9, 8, 9, 8, N'Hóa học', 1, 'Pass'),
    (346, 65, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (346, 65, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),
    (347, 65, 1, '5,6,7', 5, 7, 5, 6, 5, N'Văn', 1, 'Pass'),
    (347, 65, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (347, 65, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (347, 65, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (347, 65, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (347, 65, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (347, 65, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (347, 65, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),
    (348, 65, 1, '4,5,6', 4, 6, 4, 5, 4, N'Văn', 1, 'Pass'),
    (348, 65, 2, '2,3,4', 2, 4, 2, 3, 2, N'Toán', 1, 'Pass'),
    (348, 65, 3, '5,6,7', 5, 7, 5, 6, 5, N'Anh', 1, 'Pass'),
    (348, 65, 4, '3,4,5', 3, 5, 3, 4, 3, N'Lịch sử', 1, 'Pass'),
    (348, 65, 5, '4,5,6', 4, 6, 4, 5, 4, N'Địa lí', 1, 'Pass'),
    (348, 65, 6, '6,7,8', 6, 8, 6, 7, 6, N'Hóa học', 1, 'Pass'),
    (348, 65, 7, '7,8,9', 7, 9, 7, 8, 7, N'Sinh học', 1, 'Pass'),
    (348, 65, 8, '5,6,6', 5, 6, 5, 6, 5, N'Công nghệ', 1, 'Pass'),
    (349, 65, 1, '3,4,5', 3, 5, 3, 4, 3, N'Văn', 1, 'Pass'),
    (349, 65, 2, '1,2,3', 1, 3, 1, 2, 1, N'Toán', 1, 'Pass'),
    (349, 65, 3, '4,5,6', 4, 6, 4, 5, 4, N'Anh', 1, 'Pass'),
    (349, 65, 4, '2,3,4', 2, 4, 2, 3, 2, N'Lịch sử', 1, 'Pass'),
    (349, 65, 5, '3,4,5', 3, 5, 3, 4, 3, N'Địa lí', 1, 'Pass'),
    (349, 65, 6, '5,6,7', 5, 7, 5, 6, 5, N'Hóa học', 1, 'Pass'),
    (349, 65, 7, '6,7,8', 6, 8, 6, 7, 6, N'Sinh học', 1, 'Pass'),
    (349, 65, 8, '4,5,5', 4, 5, 4, 5, 4, N'Công nghệ', 1, 'Pass'),
    (350, 65, 1, '2,3,4', 2, 4, 2, 3, 2, N'Văn', 1, 'Pass'),
    (350, 65, 2, '1,2,3', 1, 3, 1, 2, 1, N'Toán', 1, 'Pass'),
    (350, 65, 3, '3,4,5', 3, 5, 3, 4, 3, N'Anh', 1, 'Pass'),
    (350, 65, 4, '1,2,3', 1, 3, 1, 2, 1, N'Lịch sử', 1, 'Pass'),
    (350, 65, 5, '2,3,4', 2, 4, 2, 3, 2, N'Địa lí', 1, 'Pass'),
    (350, 65, 6, '4,5,6', 4, 6, 4, 5, 4, N'Hóa học', 1, 'Pass'),
    (350, 65, 7, '5,6,7', 5, 7, 5, 6, 5, N'Sinh học', 1, 'Pass'),
    (350, 65, 8, '3,4,4', 3, 4, 3, 4, 3, N'Công nghệ', 1, 'Pass'),
    (351, 65, 1, '1,2,3', 1, 3, 1, 2, 1, N'Văn', 1, 'Pass'),
    (351, 65, 2, '1,1,1', 1, 1, 1, 1, 1, N'Toán', 1, 'Pass'),
    (351, 65, 3, '2,2,3', 2, 3, 2, 2, 2, N'Anh', 1, 'Pass'),
    (351, 65, 4, '1,2,2', 1, 2, 1, 2, 1, N'Lịch sử', 1, 'Pass'),
    (351, 65, 5, '1,1,2', 1, 2, 1, 1, 1, N'Địa lí', 1, 'Pass'),
    (351, 65, 6, '2,3,3', 2, 3, 2, 3, 2, N'Hóa học', 1, 'Pass'),
    (351, 65, 7, '3,4,4', 3, 4, 3, 4, 3, N'Sinh học', 1, 'Pass'),
    (351, 65, 8, '2,3,3', 2, 3, 2, 3, 2, N'Công nghệ', 1, 'Pass');	
	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
	VALUES
	(352, 66, 1, '5,6,7', 5, 7, 5, 6, 5, N'Văn', 1, 'Pass'),
	(352, 66, 2, '5,6,7', 5, 7, 5, 6, 5, N'Toán', 1, 'Pass'),
    (352, 66, 3, '4,5,6', 4, 6, 4, 5, 4, N'Anh', 1, 'Pass'),
    (352, 66, 4, '6,7,8', 6, 8, 6, 7, 6, N'Lịch sử', 1, 'Pass'),
    (352, 66, 5, '7,8,9', 7, 9, 7, 8, 7, N'Địa lí', 1, 'Pass'),
    (352, 66, 6, '8,9,9', 8, 9, 8, 9, 8, N'Hóa học', 1, 'Pass'),
    (352, 66, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (352, 66, 8, '6,6,7', 6, 7, 6, 6, 6, N'Công nghệ', 1, 'Pass'),

    (353, 66, 1, '5,5,6', 5, 6, 5, 5, 5, N'Văn', 1, 'Pass'),
    (353, 66, 2, '7,7,7', 7, 7, 7, 7, 7, N'Toán', 1, 'Pass'),
    (353, 66, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (353, 66, 4, '8,8,8', 8, 8, 8, 8, 8, N'Lịch sử', 1, 'Pass'),
    (353, 66, 5, '9,9,9', 9, 9, 9, 9, 9, N'Địa lí', 1, 'Pass'),
    (353, 66, 6, '8,8,9', 8, 9, 8, 8, 8, N'Hóa học', 1, 'Pass'),
    (353, 66, 7, '7,8,8', 7, 8, 7, 8, 7, N'Sinh học', 1, 'Pass'),
    (353, 66, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),

    (354, 66, 1, '6,6,7', 6, 7, 6, 6, 6, N'Văn', 1, 'Pass'),
    (354, 66, 2, '8,8,8', 8, 8, 8, 8, 8, N'Toán', 1, 'Pass'),
    (354, 66, 3, '7,7,7', 7, 7, 7, 7, 7, N'Anh', 1, 'Pass'),
    (354, 66, 4, '9,9,9', 9, 9, 9, 9, 9, N'Lịch sử', 1, 'Pass'),
    (354, 66, 5, '8,8,8', 8, 8, 8, 8, 8, N'Địa lí', 1, 'Pass'),
    (354, 66, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (354, 66, 7, '8,8,8', 8, 8, 8, 8, 8, N'Sinh học', 1, 'Pass'),
    (354, 66, 8, '8,8,8', 8, 8, 8, 8, 8, N'Công nghệ', 1, 'Pass'),

    (355, 66, 1, '7,7,7', 7, 7, 7, 7, 7, N'Văn', 1, 'Pass'),
    (355, 66, 2, '9,9,9', 9, 9, 9, 9, 9, N'Toán', 1, 'Pass'),
    (355, 66, 3, '8,8,8', 8, 8, 8, 8, 8, N'Anh', 1, 'Pass'),
    (355, 66, 4, '9,9,9', 9, 9, 9, 9, 9, N'Lịch sử', 1, 'Pass'),
    (355, 66, 5, '9,9,9', 9, 9, 9, 9, 9, N'Địa lí', 1, 'Pass'),
    (355, 66, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (355, 66, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (355, 66, 8, '9,9,9', 9, 9, 9, 9, 9, N'Công nghệ', 1, 'Pass'),

    (356, 66, 1, '8,8,8', 8, 8, 8, 8, 8, N'Văn', 1, 'Pass'),
    (356, 66, 2, '9,9,9', 9, 9, 9, 9, 9, N'Toán', 1, 'Pass'),
    (356, 66, 3, '8,8,8', 8, 8, 8, 8, 8, N'Anh', 1, 'Pass'),
    (356, 66, 4, '9,9,9', 9,9, 9, 9, 9, N'Lịch sử', 1, 'Pass'),
    (356, 66, 5, '9,9,9', 9, 9, 9, 9, 9, N'Địa lí', 1, 'Pass'),
    (356, 66, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (356, 66, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (356, 66, 8, '9,9,9', 9, 9, 9, 9, 9, N'Công nghệ', 1, 'Pass'),

    (357, 66, 1, '7,7,7', 7, 7, 7, 7, 7, N'Văn', 1, 'Pass'),
    (357, 66, 2, '8,8,8', 8, 8, 8, 8, 8, N'Toán', 1, 'Pass'),
    (357, 66, 3, '7,7,7', 7, 7, 7, 7, 7, N'Anh', 1, 'Pass'),
    (357, 66, 4, '8,8,8', 8, 8, 8, 8, 8, N'Lịch sử', 1, 'Pass'),
    (357, 66, 5, '8,8,8', 8, 8, 8, 8, 8, N'Địa lí', 1, 'Pass'),
    (357, 66, 6, '8,8,8', 8, 8, 8, 8, 8, N'Hóa học', 1, 'Pass'),
    (357, 66, 7, '8,8,8', 8, 8, 8, 8, 8, N'Sinh học', 1, 'Pass'),
    (357, 66, 8, '8,8,8', 8, 8, 8, 8, 8, N'Công nghệ', 1, 'Pass'),

    (358, 66, 1, '8,8,8', 8, 8, 8, 8, 8, N'Văn', 1, 'Pass'),
    (358, 66, 2, '9,9,9', 9, 9, 9, 9, 9, N'Toán', 1, 'Pass'),
    (358, 66, 3, '8,8,8', 8, 8, 8, 8, 8, N'Anh', 1, 'Pass'),
    (358, 66, 4, '9,9,9', 9, 9, 9, 9, 9, N'Lịch sử', 1, 'Pass'),
    (358, 66, 5, '9,9,9', 9, 9, 9, 9, 9, N'Địa lí', 1, 'Pass'),
    (358, 66, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (358, 66, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (358, 66, 8, '9,9,9', 9, 9, 9, 9, 9, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (359, 67, 1, '6,7,8', 6, 8, 7, 7, 7, N'Văn', 1, 'Pass'),
    (359, 67, 2, '5,6,7', 5, 7, 6, 6, 6, N'Toán', 1, 'Pass'),
    (359, 67, 3, '6,7,8', 6, 8, 7, 7, 7, N'Anh', 1, 'Pass'),
    (359, 67, 4, '5,6,7', 5, 7, 6, 6, 6, N'Lịch sử', 1, 'Pass'),
    (359, 67, 5, '6,7,8', 6, 8, 7, 7, 7, N'Địa lí', 1, 'Pass'),
    (359, 67, 6, '7,8,9', 7, 9, 8, 8, 8, N'Hóa học', 1, 'Pass'),
    (359, 67, 7, '8,9,9', 8, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (359, 67, 8, '7,8,9', 7, 9, 8, 8, 8, N'Công nghệ', 1, 'Pass'),
    (360, 67, 1, '7,8,9', 7, 9, 8, 8, 8, N'Văn', 1, 'Pass'),
    (360, 67, 2, '8,9,9', 8, 9, 9, 9, 9, N'Toán', 1, 'Pass'),
    (360, 67, 3, '7,8,9', 7, 9, 8, 8, 8, N'Anh', 1, 'Pass'),
    (360, 67, 4, '8,9,9', 8, 9, 9, 9, 9, N'Lịch sử', 1, 'Pass'),
    (360, 67, 5, '7,8,9', 7, 9, 8, 8, 8, N'Địa lí', 1, 'Pass'),
    (360, 67, 6, '8,9,9', 8, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (360, 67, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (360, 67, 8, '8,9,9', 8, 9, 9, 9, 9, N'Công nghệ', 1, 'Pass'),
    (361, 67, 1, '6,6,6', 6, 6, 6, 6, 6, N'Văn', 1, 'Pass'),
    (361, 67, 2, '5,5,5', 5, 5, 5, 5, 5, N'Toán', 1, 'Pass'),
    (361, 67, 3, '6,6,6', 6, 6, 6, 6, 6, N'Anh', 1, 'Pass'),
    (361, 67, 4, '5,5,5', 5, 5, 5, 5, 5, N'Lịch sử', 1, 'Pass'),
    (361, 67, 5, '6,6,6', 6, 6, 6, 6, 6, N'Địa lí', 1, 'Pass'),
    (361, 67, 6, '7,7,7', 7, 7, 7, 7, 7, N'Hóa học', 1, 'Pass'),
    (361, 67, 7, '8,8,8', 8, 8, 8, 8, 8, N'Sinh học', 1, 'Pass'),
    (361, 67, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),
    (362, 67, 1, '8,8,8', 8, 8, 8, 8, 8, N'Văn', 1, 'Pass'),
    (362, 67, 2, '7,7,7', 7, 7, 7, 7, 7, N'Toán', 1, 'Pass'),
    (362, 67, 3, '8,8,8', 8, 8, 8, 8, 8, N'Anh', 1, 'Pass'),
    (362, 67, 4, '7,7,7', 7, 7, 7, 7, 7, N'Lịch sử', 1, 'Pass'),
    (362, 67, 5, '8,8,8', 8, 8, 8, 8, 8, N'Địa lí', 1, 'Pass'),
    (362, 67, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (362, 67, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (362, 67, 8, '8,8,8', 8, 8, 8, 8, 8, N'Công nghệ', 1, 'Pass'),
    (363, 67, 1, '7,7,7', 7, 7, 7, 7, 7, N'Văn', 1, 'Pass'),
    (363, 67, 2, '6,6,6', 6, 6, 6, 6, 6, N'Toán', 1, 'Pass'),
    (363, 67, 3, '7,7,7', 7, 7, 7, 7, 7, N'Anh', 1, 'Pass'),
    (363, 67, 4, '6,6,6', 6, 6, 6, 6, 6, N'Lịch sử', 1, 'Pass'),
    (363, 67, 5, '7,7,7', 7, 7, 7, 7, 7, N'Địa lí', 1, 'Pass'),
    (363, 67, 6, '8,8,8', 8, 8, 8, 8, 8, N'Hóa học', 1, 'Pass'),
    (363, 67, 7, '8,8,8', 8, 8, 8, 8, 8, N'Sinh học', 1, 'Pass'),
    (363, 67, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),
    (364, 67, 1, '6,6,6', 6, 6, 6, 6, 6, N'Văn', 1, 'Pass'),
    (364, 67, 2, '5,5,5', 5, 5, 5, 5, 5, N'Toán', 1, 'Pass'),
    (364, 67, 3, '6,6,6', 6, 6, 6, 6, 6, N'Anh', 1, 'Pass'),
    (364, 67, 4, '5,5,5', 5, 5, 5, 5, 5, N'Lịch sử', 1, 'Pass'),
    (364, 67, 5, '6,6,6', 6, 6, 6, 6, 6, N'Địa lí', 1, 'Pass'),
    (364, 67, 6, '7,7,7', 7, 7, 7, 7, 7, N'Hóa học', 1, 'Pass'),
    (364, 67, 7, '8,8,8', 8, 8, 8, 8, 8, N'Sinh học', 1, 'Pass'),
    (364, 67, 8, '7,7,7', 7, 7, 7, 7, 7, N'Công nghệ', 1, 'Pass'),
    (365, 67, 1, '8,8,8', 8, 8, 8, 8, 8, N'Văn', 1, 'Pass'),
    (365, 67, 2, '7,7,7', 7, 7, 7, 7, 7, N'Toán', 1, 'Pass'),
    (365, 67, 3, '8,8,8', 8, 8, 8, 8, 8, N'Anh', 1, 'Pass'),
    (365, 67, 4, '7,7,7', 7, 7, 7, 7, 7, N'Lịch sử', 1, 'Pass'),
    (365, 67, 5, '8,8,8', 8, 8, 8, 8, 8, N'Địa lí', 1, 'Pass'),
    (365, 67, 6, '9,9,9', 9, 9, 9, 9, 9, N'Hóa học', 1, 'Pass'),
    (365, 67, 7, '9,9,9', 9, 9, 9, 9, 9, N'Sinh học', 1, 'Pass'),
    (365, 67, 8, '8,8,8', 8, 8, 8, 8, 8, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES
(366, 68, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(366, 68, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(366, 68, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(366, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(366, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(366, 68, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(366, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(366, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(367, 68, 1, '7,8,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(367, 68, 2, '3,2,4', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(367, 68, 3, '9,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(367, 68, 4, '6,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(367, 68, 5, '5,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(367, 68, 6, '7,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(367, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(367, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(368, 68, 1, '6,5,7', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(368, 68, 2, '5,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(368, 68, 3, '8,8,8', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(368, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(368, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(368, 68, 6, '8,8,7', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(368, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(368, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(369, 68, 1, '7,5,6', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(369, 68, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(369, 68, 3, '8,8,8', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(369, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(369, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(369, 68, 6, '8,8,7', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(369, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(369, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(370, 68, 1, '6,8,7', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(370, 68, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(370, 68, 3, '8,8,8', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(370, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(370, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(370, 68, 6, '8,8,7', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(370, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(370, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(371, 68, 1, '6,8,7', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(371, 68, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(371, 68, 3, '8,8,8', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(371, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(371, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(371, 68, 6, '8,8,7', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(371, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(371, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(372, 68, 1, '6,8,7', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(372, 68, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(372, 68, 3, '8,8,8', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(372, 68, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(372, 68, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(372, 68, 6, '8,8,7', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(372, 68, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(372, 68, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(373, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
(373, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
(373, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
(373, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
(373, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
(373, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
(373, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
(373, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
(374, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (374, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (374, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (374, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (374, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (374, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (374, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (374, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
	(375, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (375, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (375, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (375, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (375, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (375, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (375, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (375, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
	(376, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (376, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (376, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (376, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (376, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (376, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (376, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (376, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
	(377, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (377, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (377, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (377, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (377, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (377, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (377, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (377, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
	(378, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (378, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (378, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (378, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (378, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (378, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (378, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (378, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass'),
	(379, 69, 1, '8,7,9', 8, 9, 8, 9, 8, N'Văn', 1, 'Pass'),
    (379, 69, 2, '4,2,3', 3, 4, 2, 2, 3, N'Toán', 1, 'Not Pass'),
    (379, 69, 3, '8,8,9', 8, 9, 8, 2, 9, N'Anh', 1, 'Pass'),
    (379, 69, 4, '5,7,8', 5, 9, 8, 2, 5, N'Lịch sử', 1, 'Pass'),
    (379, 69, 5, '4,6,3', 4, 3, 5, 2, 4, N'Địa lí', 1, 'Not Pass'),
    (379, 69, 6, '8,8,8', 6, 6, 7, 7, 6, N'Hóa học', 1, 'Pass'),
    (379, 69, 7, '9,9,9', 7, 9, 8, 9, 9, N'Sinh học', 1, 'Pass'),
    (379, 69, 8, '6,6,6', 6, 6, 6, 6, 6, N'Công nghệ', 1, 'Pass');
	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (380, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (380, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (380, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (380, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (380, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (380, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (380, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (380, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (381, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (381, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (381, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (381, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (381, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (381, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (381, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (381, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (382, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (382, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (382, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (382, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (382, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (382, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (382, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (382, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (383, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (383, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (383, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (383, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (383, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (383, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (383, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (383, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (384, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (384, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (384, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (384, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (384, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (384, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (384, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (384, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (385, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (385, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (385, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (385, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (385, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (385, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (385, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (385, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (386, 70, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (386, 70, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (386, 70, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (386, 70, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (386, 70, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (386, 70, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (386, 70, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (386, 70, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
 INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (387, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (387, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (387, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (387, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (387, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (387, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (387, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (387, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (388, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (388, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (388, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (388, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (388, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (388, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (388, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (388, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (389, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (389, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (389, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (389, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (389, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (389, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (389, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (389, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (390, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (390, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (390, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (390, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (390, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (390, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (390, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (390, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (391, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (391, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (391, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (391, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (391, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (391, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (391, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (391, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (392, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (392, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (392, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (392, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (392, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (392, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (392, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (392, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (393, 71, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (393, 71, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (393, 71, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (393, 71, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (393, 71, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (393, 71, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (393, 71, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (393, 71, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
	INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (393, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (393, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (393, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (393, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (393, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (393, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (393, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (393, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (394, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (394, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (394, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (394, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (394, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (394, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (394, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (394, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (395, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (395, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (395, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (395, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (395, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (395, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (395, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (395, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (396, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (396, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (396, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (396, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (396, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (396, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (396, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (396, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (397, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (397, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (397, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (397, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (397, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (397, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (397, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (397, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (398, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (398, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (398, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (398, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (398, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (398, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (398, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (398, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (399, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (399, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (399, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (399, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (399, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (399, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (399, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (399, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (400, 72, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (400, 72, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (400, 72, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (400, 72, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (400, 72, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (400, 72, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (400, 72, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (400, 72, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (401, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (401, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (401, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (401, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (401, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (401, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (401, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (401, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (402, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (402, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (402, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (402, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (402, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (402, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (402, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (402, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (403, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (403, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (403, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (403, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (403, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (403, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (403, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (403, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (404, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (404, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (404, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (404, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (404, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (404, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (404, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (404, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (405, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (405, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (405, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (405, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (405, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (405, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (405, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (405, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (406, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (406, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (406, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (406, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (406, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (406, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (406, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (406, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (407, 73, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (407, 73, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (407, 73, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (407, 73, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (407, 73, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (407, 73, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (407, 73, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (407, 73, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (408, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (408, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (408, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (408, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (408, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (408, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (408, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (408, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (409, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (409, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (409, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (409, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (409, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (409, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (409, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (409, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (410, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (410, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (410, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (410, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (410, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (410, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (410, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (410, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (411, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (411, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (411, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (411, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (411, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (411, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (411, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (411, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (412, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (412, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (412, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (412, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (412, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (412, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (412, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (412, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (413, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (413, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (413, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (413, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (413, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (413, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (413, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (413, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (414, 74, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (414, 74, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (414, 74, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (414, 74, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (414, 74, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (414, 74, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (414, 74, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (414, 74, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');
INSERT INTO Score (StudentId, ClassId, TeacherId, Scores, Score15, Score60, GiuaKi, CuoiKi, TongKet, SubjectTC, Semester, Status)
VALUES 
    (415, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (415, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (415, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (415, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (415, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (415, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (415, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (415, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (416, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (416, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (416, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (416, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (416, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (416, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (416, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (416, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (417, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (417, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (417, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (417, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (417, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (417, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (417, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (417, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (418, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (418, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (418, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (418, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (418, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (418, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (418, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (418, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (419, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (419, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (419, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (419, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (419, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (419, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (419, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (419, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (420, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (420, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (420, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (420, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (420, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (420, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (420, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (420, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass'),

    (421, 75, 1, '7,8,9', 7, 8, 7, 8, 7, N'Văn', 1, 'Pass'),
    (421, 75, 2, '3,4,5', 3, 5, 3, 4, 3, N'Toán', 1, 'Pass'),
    (421, 75, 3, '6,7,8', 6, 8, 6, 7, 6, N'Anh', 1, 'Pass'),
    (421, 75, 4, '4,5,6', 4, 6, 4, 5, 4, N'Lịch sử', 1, 'Pass'),
    (421, 75, 5, '5,6,7', 5, 7, 5, 6, 5, N'Địa lí', 1, 'Pass'),
    (421, 75, 6, '7,8,9', 7, 9, 7, 8, 7, N'Hóa học', 1, 'Pass'),
    (421, 75, 7, '8,9,9', 8, 9, 8, 9, 8, N'Sinh học', 1, 'Pass'),
    (421, 75, 8, '6,7,7', 6, 7, 6, 7, 6, N'Công nghệ', 1, 'Pass');


	INSERT INTO LeaveRequests (StudentId, TeacherId, Reason, RequestDate, ApprovalStatus)
VALUES
    (1, 3, N'Vắng mặt do ốm đau.', '2024-06-01 08:00:00', 'Chưa giải quyết'),
    (2, 3, N'Điều trị y tế.', '2024-06-02 10:00:00', 'Chưa giải quyết');






INSERT INTO Messages (SenderId, ReceiverId, Content, Timestamp, SenderType, ReceiverType)
VALUES
    (1, 2, N'Xin chào, bố mẹ của Bé A!', '2024-05-05 08:00:00', 0, 1),
    (2, 1, N'Chào thầy, có gì cần thông báo không ạ?', '2024-05-05 08:30:00', 1, 0);

INSERT INTO Chats (UserId1, UserId2, Timestamp, UserType1, UserType2, Content)
VALUES
    (1, 2, '2024-05-05 08:00:00', 0, 1, N'Xin chào, bố mẹ của Bé A!'),
    (2, 1, '2024-05-05 08:30:00', 1, 0, N'Chào thầy, có gì cần thông báo không ạ?');

INSERT INTO Notifications (UserId, SenderId, NameContent,Content, Timestamp)
VALUES
    (1, 3, N'Lịch học tuần này đã được cập nhật.',N'Tuần này, lịch học của chúng ta đã được cập nhật với nhiều thay đổi quan trọng. 
	Các bạn học sinh cấp 3 chú ý theo dõi để không bỏ lỡ những buổi học cần thiết.  
	Đầu tiên, vào thứ Hai và thứ Ba, chúng ta sẽ có tiết học Toán vào buổi sáng từ 8h đến 10h, tiếp theo là tiết Văn từ 10h30 đến 12h.  
	Buổi chiều sẽ là thời gian dành cho các môn học tự chọn như Âm nhạc và Hội họa, từ 13h30 đến 15h. 

Thứ Tư và thứ Năm, chúng ta sẽ tập trung vào các môn Khoa học Tự nhiên. Buổi sáng sẽ là tiết Lý và Hóa từ 8h đến 11h.  
Buổi chiều, chúng ta sẽ có tiết Sinh học từ 13h đến 14h30, và sau đó là giờ tự học có giám sát từ 15h đến 16h30. 

Cuối tuần, thứ Sáu, chúng ta sẽ có tiết học Tiếng Anh từ 8h đến 10h, tiếp theo là tiết Giáo dục Công dân từ 10h30 đến 12h. 
 Buổi chiều thứ Sáu sẽ là thời gian dành cho các hoạt động ngoại khóa và thể dục thể thao. 

Các bạn nhớ kiểm tra kỹ lịch học và chuẩn bị đầy đủ sách vở, dụng cụ học tập để có thể học tập hiệu quả.  
Chúc các bạn một tuần học tập thật nhiều năng lượng và thành công! ', '2024-05-05 09:00:00'),
    (2, 3, N'Thông báo về thay đổi khẩu phần ăn.',N'Chào các bạn học sinh, 

Chúng tôi xin thông báo về sự thay đổi trong khẩu phần ăn tại căng-tin trường học bắt đầu từ tuần này. 
 Nhằm đảm bảo sức khỏe và dinh dưỡng cho các bạn, chúng tôi đã tiến hành điều chỉnh thực đơn hàng ngày. 

Thứ Hai: Sáng sẽ có bánh mì kẹp trứng và sữa đậu nành, trưa là cơm với thịt gà xào sả ớt và rau muống luộc, chiều là trái cây tươi. 

Thứ Ba: Sáng có phở bò và nước cam, trưa là cơm với cá kho tộ và canh rau ngót, chiều có yogurt trái cây. 

Thứ Tư: Sáng là xôi mặn và sữa tươi, trưa là cơm với thịt heo kho tàu và cải thìa xào tỏi, chiều là bánh flan. 

Thứ Năm: Sáng có bún thịt nướng và trà chanh, trưa là cơm với thịt bò xào cần tây và canh bí đỏ, chiều là chè đậu xanh. 

Thứ Sáu: Sáng là bánh bao và sữa bắp, trưa là cơm với tôm rim và rau cải xào, chiều là sinh tố trái cây. 

Chúng tôi hy vọng rằng sự thay đổi này sẽ mang lại những bữa ăn ngon miệng và đầy đủ dinh dưỡng cho các bạn. Nếu có bất kỳ thắc mắc hay góp ý nào về khẩu phần ăn, các bạn vui lòng liên hệ với ban quản lý căng-tin. 

Chúc các bạn có những bữa ăn vui vẻ và tràn đầy năng lượng! 

Trân trọng, 
Ban Giám Hiệu', '2024-05-05 09:30:00'),
(2, 2, N'Thông báo về học phí.',N'Chào các bậc phụ huynh và các em học sinh, 

Chúng tôi xin thông báo về việc điều chỉnh học phí cho học kỳ tới, nhằm đảm bảo chất lượng giảng dạy và các dịch vụ học tập tốt nhất cho các em. 

 1. Mức học phí mới:  
- Khối lớp 10: 3,000,000 VNĐ/tháng 
- Khối lớp 11: 3,200,000 VNĐ/tháng 
- Khối lớp 12: 3,500,000 VNĐ/tháng 

 2. Thời gian áp dụng:  
- Mức học phí mới sẽ bắt đầu áp dụng từ học kỳ 1 của năm học 2024 - 2025. 

 3. Phương thức thanh toán:  
- Phụ huynh có thể thanh toán học phí hàng tháng hoặc theo từng học kỳ. 
- Học phí có thể được nộp trực tiếp tại phòng tài vụ của trường hoặc chuyển khoản qua ngân hàng. Thông tin chi tiết về tài khoản ngân hàng sẽ được gửi kèm trong email thông báo. 

 4. Chính sách hỗ trợ:  
- Nhà trường có các chính sách hỗ trợ cho những học sinh có hoàn cảnh khó khăn. Quý phụ huynh có thể liên hệ trực tiếp với phòng tài vụ để biết thêm chi tiết và hoàn tất thủ tục cần thiết. 
- Giảm 5% học phí cho những gia đình có từ hai con trở lên đang theo học tại trường. 

Chúng tôi mong rằng các bậc phụ huynh sẽ thông cảm và đồng hành cùng nhà trường trong việc nâng cao chất lượng giáo dục và tạo điều kiện học tập tốt nhất cho các em học sinh.  Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-05 09:00:00'),
    (2, 3, N'Thông báo về lịch đi tham quan.',N' THÔNG BÁO VỀ LỊCH ĐI THAM QUAN  

Kính gửi quý phụ huynh và các em học sinh, 

Chúng tôi xin thông báo về lịch trình chuyến đi tham quan sắp tới, nhằm mang lại cho các em những trải nghiệm thực tế và bổ ích ngoài giờ học. 

 1. Thời gian và địa điểm:  
-  Ngày:  Thứ Bảy, ngày 25 tháng 5 năm 2024 
-  Địa điểm:  Khu Du Lịch Sinh Thái Tràng An, Ninh Bình 

 2. Lịch trình cụ thể:  
-  6h00:  Tập trung tại sân trường, điểm danh và chuẩn bị lên xe. 
-  6h30:  Xuất phát đi Ninh Bình. 
-  9h00:  Đến Khu Du Lịch Sinh Thái Tràng An, tham quan và tìm hiểu về các danh lam thắng cảnh. 
-  12h00:  Nghỉ trưa và ăn trưa tại nhà hàng địa phương. 
-  13h30:  Tiếp tục tham quan các điểm du lịch trong khu vực. 
-  16h00:  Tập trung ra xe và trở về trường. 
-  18h30:  Về đến trường, kết thúc chuyến tham quan. 

 3. Chi phí tham gia:  
- Mỗi học sinh: 500,000 VNĐ (bao gồm phí di chuyển, vé vào cổng, bữa trưa và nước uống). 

 4. Lưu ý: 
- Học sinh nên mặc đồng phục của trường, đi giày thể thao và mang theo mũ, kem chống nắng. 
- Mang theo nước uống cá nhân và các vật dụng cần thiết. 
- Học sinh không nên mang theo nhiều tiền bạc và đồ trang sức có giá trị. 
- Phụ huynh vui lòng đóng phí tham gia chuyến đi trước ngày 20 tháng 5 năm 2024 tại phòng tài vụ của trường. 

Chúng tôi hy vọng rằng chuyến tham quan sẽ mang lại cho các em học sinh những trải nghiệm thú vị và bổ ích.   Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-05 09:00:00'),
(3, 2, N'Thông báo về ngày nghĩ lễ.',N' THÔNG BÁO VỀ NGÀY NGHỈ LỄ  

Kính gửi quý phụ huynh và các em học sinh, 

Nhà trường xin thông báo lịch nghỉ lễ sắp tới như sau: 

 1. Ngày nghỉ lễ:  
-  Dịp lễ 30/4 - Giải phóng miền Nam và Quốc tế Lao động 1/5:  
  -  Bắt đầu nghỉ:  Thứ Ba, ngày 30 tháng 4 năm 2024  
  -  Kết thúc nghỉ:  Thứ Năm, ngày 2 tháng 5 năm 2024  
  -  Đi học lại:  Thứ Sáu, ngày 3 tháng 5 năm 2024  

 2. Các lưu ý quan trọng:  
- Trong thời gian nghỉ lễ, học sinh cần lưu ý giữ gìn sức khỏe, an toàn khi tham gia các hoạt động vui chơi giải trí. 
- Các bài tập về nhà và dự án học tập cần hoàn thành và nộp đúng hạn theo yêu cầu của giáo viên. 
- Đối với các học sinh lớp 12, cần chú trọng việc ôn tập chuẩn bị cho kỳ thi cuối cấp. 

 3. Hoạt động ngoại khóa:  
- Nhà trường sẽ tổ chức một số hoạt động ngoại khóa sau dịp nghỉ lễ để giúp học sinh thư giãn và học tập hiệu quả hơn. Thông tin chi tiết sẽ được thông báo sau. 

Nhà trường kính chúc quý phụ huynh và các em học sinh có một kỳ nghỉ lễ vui vẻ, an toàn và ý nghĩa.  Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 
Trân trọng, 
Ban Giám Hiệu', '2024-05-05 09:00:00');

INSERT INTO Notifications (UserId, SenderId, NameContent, Content, Timestamp)
VALUES
    (1, 3, N'Thông báo về kỳ thi giữa kỳ.', N'Kỳ thi giữa kỳ sắp tới sẽ bắt đầu từ tuần sau.  
	Các bạn học sinh cấp 3 cần chú ý ôn tập kỹ các môn học để đạt kết quả cao.  
	Lịch thi cụ thể như sau:  
	Thứ Hai, Toán từ 8h đến 10h, tiếp theo là Văn từ 10h30 đến 12h.  
	Thứ Ba, chúng ta sẽ thi Lý và Hóa vào buổi sáng, và Sinh học vào buổi chiều.  
	Chúc các bạn thi tốt! 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

	Trân trọng, 
	Ban Giám Hiệu', '2024-05-12 09:00:00'),
    
    (1, 3, N'Thông báo về buổi dã ngoại cuối tuần.', N'Các bạn học sinh cấp 3 thân mến.  
	Cuối tuần này chúng ta sẽ có buổi dã ngoại tại công viên thành phố. Đây là cơ hội để các bạn thư giãn sau những giờ học căng thẳng.  
	Lịch trình chi tiết sẽ được thông báo sau.  
	Hãy chuẩn bị tinh thần và những vật dụng cần thiết nhé! 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

	Trân trọng, 
	Ban Giám Hiệu', '2024-05-13 09:00:00'),
    
    (1, 3, N'Thay đổi lịch học môn Thể dục.', N'Do sự thay đổi về kế hoạch,  
	lịch học môn Thể dục sẽ được chuyển từ thứ Ba sang thứ Năm.  
	Thời gian học không thay đổi, vẫn từ 13h30 đến 15h.  
	Các bạn học sinh cấp 3 lưu ý và điều chỉnh thời gian học tập sao cho phù hợp. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-14 09:00:00'),
    
    (1, 3, N'Buổi học ngoại khóa về kỹ năng sống.', N'Vào thứ Tư tuần này,  
	chúng ta sẽ có buổi học ngoại khóa về kỹ năng sống. Buổi học sẽ diễn ra từ 14h đến 16h tại phòng hội thảo của trường.  
	Các bạn học sinh cấp 3 hãy tham gia đầy đủ để tích lũy thêm nhiều kỹ năng hữu ích. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-15 09:00:00'),
    
    (1, 3, N'Thay đổi lịch kiểm tra định kỳ.', N'Do lịch trình học tập thay đổi,  
	lịch kiểm tra định kỳ sẽ được điều chỉnh. Môn Toán sẽ được kiểm tra vào thứ Sáu thay vì thứ Năm.  
	Thời gian vẫn giữ nguyên, từ 8h đến 10h.  
	Các bạn học sinh cấp 3 lưu ý để chuẩn bị tốt. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-16 09:00:00'),
    
    (1, 3, N'Thông báo về buổi họp phụ huynh.', N'Các bạn học sinh cấp 3 thông báo đến phụ huynh,  
	buổi họp phụ huynh sẽ được tổ chức vào thứ Bảy tuần này.  
	Đây là cơ hội để nhà trường trao đổi về tình hình học tập và hoạt động của các bạn.  
	Hãy thông báo đến phụ huynh và chuẩn bị các câu hỏi cần thiết. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-17 09:00:00'),
    
    (1, 3, N'Hướng dẫn sử dụng thư viện trực tuyến.', N'Nhằm giúp các bạn học sinh cấp 3 có thêm tài liệu học tập,  
	trường sẽ tổ chức buổi hướng dẫn sử dụng thư viện trực tuyến vào thứ Năm tuần này từ 10h đến 12h.  
	Các bạn sẽ được hướng dẫn cách truy cập và tìm kiếm tài liệu hiệu quả. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-18 09:00:00'),
    
    (1, 3, N'Thông báo về kỳ thi thử đại học.', N'Các bạn học sinh lớp 12 chuẩn bị kỹ lưỡng cho kỳ thi thử đại học sẽ diễn ra vào tuần sau.  
	Lịch thi cụ thể sẽ được thông báo trong buổi học ngày mai.  
	Đây là cơ hội để các bạn đánh giá năng lực và có kế hoạch ôn tập hiệu quả hơn. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-19 09:00:00'),
    
    (1, 3, N'Thông báo về buổi tư vấn hướng nghiệp.', N'Trường sẽ tổ chức buổi tư vấn hướng nghiệp dành cho học sinh cấp 3 vào thứ Sáu tuần này từ 14h đến 16h.  
	Các bạn sẽ được gặp gỡ và lắng nghe chia sẻ từ các chuyên gia về các ngành nghề và cơ hội nghề nghiệp trong tương lai. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-20 09:00:00'),
    
    (1, 3, N'Thông báo về buổi thực hành thí nghiệm.', N'Buổi thực hành thí nghiệm môn Hóa học sẽ diễn ra vào thứ Hai tuần sau từ 13h30 đến 15h30 tại phòng thí nghiệm.  
	Các bạn học sinh cấp 3 cần chuẩn bị đầy đủ dụng cụ và tuân thủ quy định an toàn.  
	Đây là buổi học quan trọng giúp các bạn hiểu rõ hơn về lý thuyết đã học. 
	Mọi thắc mắc xin vui lòng liên hệ với cô Mai qua số điện thoại 0123-456-789 hoặc email: coMai@truonghoc.huit.vn. 

Trân trọng, 
Ban Giám Hiệu', '2024-05-21 09:00:00');
