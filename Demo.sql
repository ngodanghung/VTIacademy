
create database if not exists Demo_Project;
use Demo_Project;

create table if not exists Department (
	DepartmentID	int, 	
    DepartmentName	varchar(50)
);

create table if not exists Position (
	PositionID		int,
    PositionName	varchar(20)
);

create table if not exists Accounts (
	AccountID 		int,
    Email			varchar(50),
    Username		varchar(20),
    Fullname		varchar(30),
    DeparmentID		int,
    PositionID		int,
    CreateDate		date
);

create table if not exists Group_ (
	GroupID			int,
    GroupName		varchar(50),
    CreatorID		int,
    CreateDate		date
);

create table if not exists GroupAccount (
	GroupID			int,
	AccountID 		int,
	JoinDate		date
);

create table if not exists TypeQuestion (
	TypeID 			int,
    TypeName		char
);

create table if not exists CategoryQuestion (
	CategoryID		int,
    CategoryName	char
);

create table if not exists Question (
	QuestionID		int,
    Content			varchar(100),
	CategoryID		int,
	TypeID 			int,
    CreatorID		int,
	CreateDate		date
);

create table if not exists Answer (
	AnswerID		int,
    Content			varchar(100),
	QuestionID		int,
	isCorrect		char
);

create table if not exists Exam (
	ExamID			int,
    CodeID			char(10),
    Title			varchar(20),
 	CategoryID		int,
	Duration		time,
    CreatorID		int,
    CreateDate		date
);

create table if not exists ExamQuestion (
	ExamID			int,
  	QuestionID		int
);





