
CREATE DATABASE IF NOT EXISTS Demo_Project;
USE Demo_Project;

CREATE TABLE IF NOT EXISTS Department (
    DepartmentID 	TINYINT UNSIGNED AUTO_INCREMENT,
    DepartmentName 	NVARCHAR(100) NOT NULL,
PRIMARY KEY (DepartmentID)
);

CREATE TABLE IF NOT EXISTS `Position` (
    PositionID 		TINYINT UNSIGNED AUTO_INCREMENT,
    PositionName 	NVARCHAR(100) NOT NULL,
PRIMARY KEY (PositionID)
);

CREATE TABLE IF NOT EXISTS `Account` (
    AccountID 		SMALLINT UNSIGNED AUTO_INCREMENT,
    Email 			VARCHAR(255) UNIQUE KEY NOT NULL,
    Username 		NVARCHAR(30) NOT NULL,
    Fullname 		NVARCHAR(30) NOT NULL,
    DeparmentID 	TINYINT,
    PositionID 		TINYINT,
    CreateDate 		DATE,
PRIMARY KEY (AccountID),
FOREIGN KEY (DeparmentID) 	REFERENCES Deparment(DeparmentID) 	ON DELETE CASCADE,
FOREIGN KEY (PositionID) 	REFERENCES `Position` (PositionID) 	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Group` (
    GroupID 		TINYINT UNSIGNED AUTO_INCREMENT,
    GroupName 		NVARCHAR(100) NOT NULL,
<<<<<<< HEAD
    CreatorID 		SMALLINT,
    CreateDate 		DATE,
PRIMARY KEY (GroupID),
FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
=======
    CreatorID 		TINYINT,
    CreateDate 		DATE,
PRIMARY KEY (GroupID)
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
);

CREATE TABLE IF NOT EXISTS GroupAccount (
    GroupID 		TINYINT,
<<<<<<< HEAD
    AccountID 		SMALLINT,
    JoinDate 		DATE,
PRIMARY KEY (GroupID,AccountID),
=======
    AccountID 		TINYINT,
    JoinDate 		DATE,
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
FOREIGN KEY (GroupID)	 	REFERENCES `Group` (GroupID) 		ON DELETE CASCADE,
FOREIGN KEY (AccountID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TypeQuestion (
    TypeID 			TINYINT UNSIGNED AUTO_INCREMENT,
<<<<<<< HEAD
    TypeName 		ENUM('Essay','Multiple-Choice'),
=======
    TypeName 		NVARCHAR(255) NOT NULL,
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
PRIMARY KEY (TypeID)
);

CREATE TABLE IF NOT EXISTS CategoryQuestion (
    CategoryID 		TINYINT UNSIGNED AUTO_INCREMENT,
<<<<<<< HEAD
    CategoryName 	VARCHAR(255) NOT NULL,
=======
    CategoryName 	NVARCHAR(255) NOT NULL,
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
PRIMARY KEY (CategoryID)
);

CREATE TABLE IF NOT EXISTS Question (
    QuestionID 		TINYINT UNSIGNED AUTO_INCREMENT,
<<<<<<< HEAD
    Content 		TEXT NOT NULL,
    CategoryID 		TINYINT,
    TypeID 			TINYINT,
    CreatorID 		SMALLINT,
=======
    Content 		NVARCHAR(250) NOT NULL,
    CategoryID 		TINYINT,
    TypeID 			TINYINT,
    CreatorID 		TINYINT,
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
    CreateDate 		DATE,
PRIMARY KEY (QuestionID),
FOREIGN KEY (CategoryID) 	REFERENCES `CategoryQuestion` (CategoryID) 	ON DELETE CASCADE,
FOREIGN KEY (TypeID) 		REFERENCES `TypeQuestion` (TypeID)			ON DELETE CASCADE,
FOREIGN KEY (CreatorID) 	REFERENCES `Group` (CreatorID) 				ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Answer (
    AnswerID 		TINYINT UNSIGNED AUTO_INCREMENT,
<<<<<<< HEAD
    Content 		TEXT NOT NULL,
=======
    Content 		NVARCHAR(250) NOT NULL,
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
    QuestionID 		TINYINT,
    isCorrect 		ENUM('T', 'F'),
PRIMARY KEY (AnswerID),
FOREIGN KEY (QuestionID) 	REFERENCES `Question` (QuestionID) 			ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Exam (
    ExamID 			TINYINT UNSIGNED AUTO_INCREMENT,
    `Code` 			TINYINT,
    Title 			NVARCHAR(250) NOT NULL,
    CategoryID 		TINYINT,
    Duration 		TIME,
    CreatorID 		TINYINT,
    CreateDate 		DATE,
PRIMARY KEY (ExamID),
FOREIGN KEY (CategoryID) 	REFERENCES `CategoryQuestion` (CategoryID) 	ON DELETE CASCADE,
FOREIGN KEY (CreatorID) 	REFERENCES `Group` (CreatorID) 				ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ExamQuestion (
    ExamID 			TINYINT,
    QuestionID 		TINYINT,
<<<<<<< HEAD
PRIMARY KEY (ExamID,QuestionID),
=======
>>>>>>> 23a99c2b3bcc06d9be9e2145c49874f9a480b785
FOREIGN KEY (ExamID) REFERENCES `Exam` (ExamID) ON DELETE CASCADE,
FOREIGN KEY (QuestionID) 	REFERENCES `Question` (QuestionID) 			ON DELETE CASCADE
);




