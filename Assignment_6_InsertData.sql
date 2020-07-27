USE TestingSystem;

DROP PROCEDURE IF EXISTS getInfoAccount;
DELIMITER $$
CREATE PROCEDURE getInfoAccount(IN user_name VARCHAR(100)
								,OUT account_id INT) 
	BEGIN
		SELECT AccountID INTO account_id
        FROM Account
        WHERE Username = user_name;		

	END $$
DELIMITER ;
set @account_id = 0;
call testingdemo.getInfoAccount('dangblack',@account_id);
select @account_id;


USE TestingSystem;

DROP FUNCTION IF EXISTS getNameOfQuestion;
DELIMITER $$
CREATE FUNCTION getNameOfQuestion(question_id TINYINT(3) UNSIGNED) RETURNS VARCHAR(100)
BEGIN

DECLARE tamp VARCHAR(100) ;
set tamp = '';
SELECT Content INTO tamp
FROM question
WHERE QuestionID = question_id;

RETURN tamp;
END $$
DELIMITER ;
SELECT getNameOfQuestion(1);


/*Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các
account thuộc phòng ban đó*/
DROP PROCEDURE IF EXISTS getInfoAccountOfDept;
DELIMITER $$
CREATE PROCEDURE getInfoAccountOfDept(IN department_name VARCHAR(100))
	BEGIN
		SELECT *
        FROM `account`
        WHERE DepartmentID = (	SELECT DepartmentID
								FROM department
                                WHERE DepartmentName = department_name);
                                
	END $$
DELIMITER $$
call testingsystem.getInfoAccountOfDept ('Bán hàng');

SELECT *
        FROM `department`;
/*Question 2: Tạo store để in ra số lượng account trong mỗi group*/
DROP PROCEDURE IF EXISTS getInfoAccountOfGroup;
DELIMITER $$
CREATE PROCEDURE getInfoAccountOfGroup()
	BEGIN
		SELECT GroupID , COUNT(AccountID) AS "Số Account", JoinDate
        FROM `groupaccount`
        GROUP BY GroupID;
	END $$
DELIMITER $$
CALL testingsystem.getInfoAccountOfGroup;
/*Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo
trong tháng hiện tại*/
DROP PROCEDURE IF EXISTS getInfoTypeOfQuestion;
DELIMITER $$
CREATE PROCEDURE getInfoTypeOfQuestion()
	BEGIN
		SELECT TypeID , COUNT(QuestionID) AS "Số câu" , CreateDate
        FROM `question`
        GROUP BY TypeID
        HAVING MONTH(CreateDate) = MONTH(now());
	END $$
DELIMITER ;
call testingsystem.getInfoTypeOfQuestion();

/*Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất*/
DROP PROCEDURE IF EXISTS getInfoIdOfQuestion;
DELIMITER $$
CREATE PROCEDURE getInfoIdOfQuestion()
	BEGIN
		SELECT TypeID , COUNT(QuestionID) AS "Số câu" , CreateDate
        FROM `question`
        GROUP BY TypeID
        ORDER BY COUNT(QuestionID) DESC
        LIMIT 1;
	END $$
DELIMITER ;
CALL testingsystem.getInfoIdOfQuestion();
/*Question 5: Sử dụng store ở question 4 để tìm ra tên của type question*/
DROP PROCEDURE IF EXISTS getInfoId4OfQuestion;
DELIMITER $$
CREATE PROCEDURE getInfoId4OfQuestion()
	BEGIN
		SELECT TypeID, TypeName, QuestionID , CreateDate
        FROM `question`
        join `typequestion` using (TypeID)
        where QuestionID = 4;
	END $$
DELIMITER ;
CALL testingsystem.getInfoId4OfQuestion;
/*Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
/*chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
người dùng nhập vào*/
DROP PROCEDURE IF EXISTS getInfochuoi;
DELIMITER $$
CREATE PROCEDURE getInfochuoi(IN nhap_vao VARCHAR(100))
	BEGIN
		SELECT AccountID As ID,Username As `name`,1
        FROM `account` a
        WHERE 	Username  	LIKE CONCAT('%' , nhap_vao , '%')
        UNION ALL
        SELECT GroupID As ID,GroupName As `name`,2
        FROM `group` a
        WHERE 	GroupName  	LIKE CONCAT('%' , nhap_vao , '%');        
                                        
	END $$
DELIMITER ;
CALL testingsystem.getInfochuoi ('vti');



/*Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
trong store sẽ tự động gán
username sẽ giống email nhưng bỏ phần @..mail đi
positionID: sẽ có default là developer
departmentID: sẽ được cho vào 1 phòng chờ
Sau đó in ra kết quả tạo thành công*/
DROP PROCEDURE IF EXISTS sp_importInf_Of_Account;
DELIMITER $$
CREATE PROCEDURE sp_importInf_Of_Account
(IN in_email VARCHAR(50), IN in_fullName NVARCHAR(50))
BEGIN
DECLARE Username VARCHAR(150) DEFAULT SUBSTRING_INDEX(in_email,'@',1);
-- SELECT SUBSTRING_INDEX("cuongnm@gmail.com.vn", "@", 1);

DECLARE PositionID TINYINT UNSIGNED DEFAULT 1;
DECLARE DepartmentID TINYINT UNSIGNED DEFAULT 10;
set FOREIGN_KEY_CHECKS = 0;
INSERT INTO `Account` (Email ,Username, FullName , DepartmentID, PositionID)
VALUE (in_email ,Username, in_fullName , DepartmentID, PositionID);
SELECT *
FROM `Account`A
WHERE A.Username = Username;
END$$
DELIMITER ;


/*Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất*/
DROP PROCEDURE IF EXISTS getInfoContent;
DELIMITER $$
CREATE PROCEDURE getInfoContent(IN nhap_vao ENUM('Essay', 'Multiple-Choice' ))
	BEGIN
		SELECT q.questionID, t.TypeName, q.Content, LENGTH(Content)
        FROM `question` q
        JOIN `typequestion` t USING (TypeID)
        WHERE t.TypeName = nhap_vao
        AND LENGTH(Content) = 	(SELECT MAX(LENGTH(Content)) 
								FROM `question` q 
                                JOIN `typequestion` t USING (TypeID)
        WHERE t.TypeName = nhap_vao);
    
        
	END $$
DELIMITER ;
CALL testingsystem.getInfoContent ('Multiple-Choice');


/*Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID*/
DROP PROCEDURE IF EXISTS getInfoDeleteId;
DELIMITER $$
CREATE PROCEDURE getInfoDeleteId(IN nhap_id INT)
	BEGIN
		SET foreign_key_checks = 0;
		DELETE FROM `exam`
		WHERE
			ExamID = nhap_id;
	END $$
DELIMITER ;
CALL testingsystem.getInfoDeleteId(200);


/*Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
dụng store ở câu 9 để xóa), sau đó in số lượng record đã remove từ các table liên quan
trong khi removing*/
DROP PROCEDURE IF EXISTS sp_DeleteUser3Years;
DELIMITER $$
CREATE PROCEDURE sp_DeleteUser3Years()
BEGIN
	SET foreign_key_checks = 0;
	WITH ExamID3Year AS(
	SELECT ExamID
	FROM Exam
	WHERE (YEAR(NOW()) - YEAR(CreateDate)) > 3
	)
	DELETE
	FROM Exam
	WHERE ExamID = (
	SELECT * FROM ExamID3Year
	);
END$$
DELIMITER ;
select *
FROM Exam;

/*Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng
ban default là phòng ban chờ việc*/
DROP PROCEDURE IF EXISTS sp_DeleteDepartment;
DELIMITER $$
CREATE PROCEDURE sp_DeleteDepartment
(IN in_DepartmentName NVARCHAR(50))
BEGIN
	SET foreign_key_checks = 0;
	UPDATE `Account`
	SET DepartmentID = 10
	WHERE DepartmentID = (SELECT DepartmentID
	FROM Department
	WHERE DepartmentName = in_DepartmentName);
	DELETE
	FROM Department
	WHERE DepartmentName = in_DepartmentName;
END$$
DELIMITER ;




/*Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm
nay2*/
DROP PROCEDURE IF EXISTS getInfoMonthOfQuestion;
DELIMITER $$
CREATE PROCEDURE getInfoMonthOfQuestion()
	BEGIN
		SELECT COUNT(QuestionID) AS "Số câu" , MONTH(CreateDate) AS 'Tháng'
        FROM `question`
        WHERE YEAR(CreateDate) = YEAR(NOW())
        GROUP BY MONTH(CreateDate)
		;
	END $$
DELIMITER ;
CALL testingsystem.getInfoMonthOfQuestion();


/*Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
tháng gần đây nhất (nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào
trong tháng")*/
DROP PROCEDURE IF EXISTS Six_month;
DELIMITER $$
CREATE PROCEDURE Six_month()
BEGIN
	SELECT last_six_months.`month`, 
    IF(COUNT(q.QuestionID) = 0, 'khong co cau hoi nao trong thang', COUNT(q.QuestionID)) AS 'số câu hỏi'
	FROM (SELECT MONTH(CURRENT_DATE - INTERVAL 5 MONTH) AS `month` UNION
		  SELECT MONTH(CURRENT_DATE - INTERVAL 4 MONTH) AS `month` UNION
		  SELECT MONTH(CURRENT_DATE - INTERVAL 3 MONTH) AS `month` UNION
		  SELECT MONTH(CURRENT_DATE - INTERVAL 2 MONTH) AS `month` UNION
		  SELECT MONTH(CURRENT_DATE - INTERVAL 1 MONTH) AS `month` UNION
		  SELECT MONTH(CURRENT_DATE - INTERVAL 0 MONTH) AS `month`) AS last_six_months
	LEFT JOIN question q ON last_six_months.`month` = MONTH(q.CreateDate)
	GROUP BY last_six_months.`month`;
END$$
DELIMITER ;

CALL Six_month();
