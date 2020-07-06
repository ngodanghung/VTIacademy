
CREATE DATABASE IF NOT EXISTS fresher;
USE fresher;
DROP TABLE IF EXISTS Trainee;
CREATE TABLE IF NOT EXISTS Trainee (
    TraineeID			INT UNSIGNED AUTO_INCREMENT,
    Full_Name 			NVARCHAR(50) NOT NULL,
    Birth_Date 			DATE NOT NULL,
    Gender 				ENUM('male', 'female', 'unknown'),
    ET_IQ 				TINYINT NOT NULL CHECK (ET_IQ <=20),
    ET_Gmath 			TINYINT NOT NULL CHECK (ET_Gmath <=20),
    ET_English 			TINYINT NOT NULL CHECK (ET_English <=50),
    Training_Class 		VARCHAR(50),
    Evaluation_Notes 	TEXT,
primary key (TraineeID)
);

ALTER TABLE Trainee
ADD VTI_Account INT NOT NULL UNIQUE;