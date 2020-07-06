DROP DATABASE IF EXISTS Demo_Project;
CREATE DATABASE IF NOT EXISTS Demo_Project;
USE Demo_Project;

DROP TABLE IF EXISTS Department;
CREATE TABLE IF NOT EXISTS Department (
    DepartmentID 	TINYINT UNSIGNED AUTO_INCREMENT,
    DepartmentName 	NVARCHAR(100) NOT NULL,
    PRIMARY KEY (DepartmentID)
);

DROP TABLE IF EXISTS `Position`;
CREATE TABLE IF NOT EXISTS `Position` (
    PositionID 		TINYINT UNSIGNED AUTO_INCREMENT,
    PositionName 	NVARCHAR(100) NOT NULL,
    PRIMARY KEY (PositionID)
);

DROP TABLE IF EXISTS `Account`;
CREATE TABLE IF NOT EXISTS `Account` (
    AccountID 		SMALLINT UNSIGNED AUTO_INCREMENT,
    Email 			VARCHAR(255) UNIQUE KEY NOT NULL,
    Username 		NVARCHAR(30) NOT NULL,
    Fullname 		NVARCHAR(30) NOT NULL,
    DepartmentID 	TINYINT UNSIGNED,
    PositionID 		TINYINT UNSIGNED,
    CreateDate 		DATE,
    PRIMARY KEY (AccountID),
    FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
        ON DELETE CASCADE,
    FOREIGN KEY (PositionID)
        REFERENCES `Position` (PositionID)
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE IF NOT EXISTS `Group` (
    GroupID 		TINYINT UNSIGNED AUTO_INCREMENT,
    GroupName 		NVARCHAR(100) NOT NULL,
    CreatorID 		SMALLINT UNSIGNED,
    CreateDate 		DATE,
	PRIMARY KEY (GroupID),
	FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
);

DROP TABLE IF EXISTS `GroupAccount`;
CREATE TABLE IF NOT EXISTS GroupAccount (
    GroupID 		TINYINT UNSIGNED,
    AccountID 		SMALLINT UNSIGNED,
    JoinDate 		DATE,
	PRIMARY KEY (GroupID,AccountID),
	FOREIGN KEY (GroupID)	 	REFERENCES `Group` (GroupID) 		ON DELETE CASCADE,
	FOREIGN KEY (AccountID) 	REFERENCES `Account` (AccountID) 	ON DELETE CASCADE
);

DROP TABLE IF EXISTS `TypeQuestion`;
CREATE TABLE IF NOT EXISTS TypeQuestion (
    TypeID 			TINYINT UNSIGNED AUTO_INCREMENT,
    TypeName 		ENUM('Essay','Multiple-Choice'),
	PRIMARY KEY (TypeID)
);

DROP TABLE IF EXISTS `CategoryQuestion`;
CREATE TABLE IF NOT EXISTS CategoryQuestion (
    CategoryID 		TINYINT UNSIGNED AUTO_INCREMENT,
    CategoryName 	VARCHAR(255) NOT NULL,
	PRIMARY KEY (CategoryID)
);

DROP TABLE IF EXISTS Question;
CREATE TABLE IF NOT EXISTS Question (
    QuestionID 		TINYINT UNSIGNED AUTO_INCREMENT,
    Content 		TEXT NOT NULL,
    CategoryID 		TINYINT UNSIGNED,
    TypeID 			TINYINT UNSIGNED,
    CreatorID 		SMALLINT UNSIGNED,
    CreateDate 		DATE,
	PRIMARY KEY (QuestionID),
	FOREIGN KEY (CategoryID) 	REFERENCES `CategoryQuestion` (CategoryID) 	ON DELETE CASCADE,
	FOREIGN KEY (TypeID) 		REFERENCES `TypeQuestion` (TypeID)			ON DELETE CASCADE,
	FOREIGN KEY (CreatorID) 	REFERENCES `Group` (CreatorID) 				ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Answer`;
CREATE TABLE IF NOT EXISTS Answer (
    AnswerID 		TINYINT UNSIGNED AUTO_INCREMENT,
    Content 		TEXT NOT NULL,
    QuestionID 		TINYINT UNSIGNED,
    isCorrect 		ENUM('T', 'F'),
	PRIMARY KEY (AnswerID),
	FOREIGN KEY (QuestionID) 	REFERENCES `Question` (QuestionID) 			ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Exam`;
CREATE TABLE IF NOT EXISTS Exam (
    ExamID 			TINYINT UNSIGNED AUTO_INCREMENT,
    `Code` 			TINYINT,
    Title 			NVARCHAR(250) NOT NULL,
    CategoryID 		TINYINT UNSIGNED,
    Duration 		TIME,
    CreatorID 		SMALLINT UNSIGNED,
    CreateDate 		DATE,
	PRIMARY KEY (ExamID),
	FOREIGN KEY (CategoryID) 	REFERENCES `CategoryQuestion` (CategoryID) 	ON DELETE CASCADE,
	FOREIGN KEY (CreatorID) 	REFERENCES `Group` (CreatorID) 				ON DELETE CASCADE
);

DROP TABLE IF EXISTS `ExamQuestion`;
CREATE TABLE IF NOT EXISTS ExamQuestion (
    ExamID 			TINYINT UNSIGNED,
    QuestionID 		TINYINT UNSIGNED,
	PRIMARY KEY (ExamID,QuestionID),
	FOREIGN KEY (ExamID) REFERENCES `Exam` (ExamID) ON DELETE CASCADE,
	FOREIGN KEY (QuestionID) 	REFERENCES `Question` (QuestionID) 			ON DELETE CASCADE
);




