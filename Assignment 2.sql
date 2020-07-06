
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
    CreatorID 		SMALLINT,
    CreateDate 		DATE,
PRIMARY KEY (GroupID),
FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS GroupAccount (
    GroupID 		TINYINT,
    AccountID 		SMALLINT,
    JoinDate 		DATE,
PRIMARY KEY (GroupID,AccountID),
FOREIGN KEY (GroupID)	 	REFERENCES `Group` (GroupID) 		ON DELETE CASCADE,
FOREIGN KEY (AccountID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TypeQuestion (
    TypeID 			TINYINT UNSIGNED AUTO_INCREMENT,
    TypeName 		ENUM('Essay','Multiple-Choice'),
PRIMARY KEY (TypeID)
);

CREATE TABLE IF NOT EXISTS CategoryQuestion (
    CategoryID 		TINYINT UNSIGNED AUTO_INCREMENT,
    CategoryName 	VARCHAR(255) NOT NULL,
PRIMARY KEY (CategoryID)
);

CREATE TABLE IF NOT EXISTS Question (
    QuestionID 		TINYINT UNSIGNED AUTO_INCREMENT,
    Content 		TEXT NOT NULL,
    CategoryID 		TINYINT,
    TypeID 			TINYINT,
    CreatorID 		SMALLINT,
    CreateDate 		DATE,
PRIMARY KEY (QuestionID),
FOREIGN KEY (CategoryID) 	REFERENCES `CategoryQuestion` (CategoryID) 	ON DELETE CASCADE,
FOREIGN KEY (TypeID) 		REFERENCES `TypeQuestion` (TypeID)			ON DELETE CASCADE,
FOREIGN KEY (CreatorID) 	REFERENCES `Group` (CreatorID) 				ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Answer (
    AnswerID 		TINYINT UNSIGNED AUTO_INCREMENT,
    Content 		TEXT NOT NULL,
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
PRIMARY KEY (ExamID,QuestionID),
FOREIGN KEY (ExamID) REFERENCES `Exam` (ExamID) ON DELETE CASCADE,
FOREIGN KEY (QuestionID) 	REFERENCES `Question` (QuestionID) 			ON DELETE CASCADE
);




