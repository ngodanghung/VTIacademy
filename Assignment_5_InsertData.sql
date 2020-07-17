
USE TestingSystem;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
DROP VIEW IF EXISTS test_department;
CREATE VIEW test_department AS
    SELECT 
        *
    FROM
        `account`
	JOIN department 
    USING (DepartmentID)
    WHERE
        DepartmentName = 'Sale';
SELECT 
    *
FROM
    test_department;
-- 
WITH CTE_account AS
    (SELECT AccountID,FullName,Email,DepartmentID
    FROM
        `account`
    WHERE
        DepartmentID = 2)

SELECT *
FROM CTE_account;

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
WITH CTE_ac_group AS
(SELECT *, GROUP_CONCAT(GroupID) 
FROM groupaccount 
GROUP BY AccountID 
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        groupaccount
    GROUP BY AccountID
    ORDER BY COUNT(1) DESC 
    LIMIT 1))
    SELECT * FROM CTE_ac_group;
  --   
DROP VIEW IF EXISTS ac_group;
CREATE VIEW ac_group AS
    SELECT 
        *, GROUP_CONCAT(GroupID)
    FROM
		groupaccount
    GROUP BY AccountID 
    HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        groupaccount
    GROUP BY AccountID
    ORDER BY COUNT(1) DESC 
    LIMIT 1);
SELECT 
    *
FROM
    ac_group;   
    

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
-- được coi là quá dài) và xóa nó đi

WITH CTE_Content300 AS
    (SELECT *, LENGTH(Content)
    FROM
        `question`
    WHERE
        LENGTH(Content) >= 300)

SELECT *
FROM CTE_Content300;
SET foreign_key_checks = 0;
DELETE FROM question 
WHERE
    LENGTH(Content) >= 300;
-- 
DROP VIEW IF EXISTS Content300;
CREATE VIEW Content300 AS
SELECT *, LENGTH(Content)
FROM
	`question`
WHERE
	LENGTH(Content) >= 300;
SELECT 
    *
FROM
    Content300;
SET foreign_key_checks = 0;
DELETE FROM question 
WHERE
    LENGTH(Content) >= 300;


-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
WITH CTE_Ac_Department AS
(SELECT *, GROUP_CONCAT(AccountID) 
FROM `account` 
GROUP BY DepartmentID 
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        `account`
    GROUP BY DepartmentID
    ORDER BY COUNT(1) DESC 
    LIMIT 1))
    SELECT * FROM CTE_Ac_Department;
--
DROP VIEW IF EXISTS Ac_Department;
CREATE VIEW Ac_Department AS
SELECT *, GROUP_CONCAT(AccountID) 
FROM `account` 
GROUP BY DepartmentID 
HAVING COUNT(1) = (SELECT 
	COUNT(1)
FROM
	`account`
GROUP BY DepartmentID
ORDER BY COUNT(1) DESC 
LIMIT 1);
SELECT 
    *
FROM
    Ac_Department;

-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo

WITH CTE_User_Nguyen AS
(SELECT 
	QuestionID, Content, CategoryID, TypeID, AccountID, FullName
FROM
	question q
JOIN
	`account` a ON q.CreatorID = a.AccountID
WHERE 
	a.FullName LIKE 'Nguyễn %')
SELECT 
	QuestionID 
FROM
	CTE_User_Nguyen;
--
DROP VIEW IF EXISTS User_Nguyen;
CREATE VIEW User_Nguyen AS
SELECT 
	QuestionID, Content, CategoryID, TypeID, AccountID, FullName
FROM
	question q
		JOIN
	`account` a ON q.CreatorID = a.AccountID
WHERE
	a.FullName LIKE 'Nguyễn %';
SELECT 
    *
FROM
    User_Nguyen;

