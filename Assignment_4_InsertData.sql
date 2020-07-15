USE TestingSystem;
-- Exercise 1: Join
-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
-- Jion
SELECT 	*
FROM	Department d1
JOIN 	Account a1  on d1.DepartmentID = a1.DepartmentID;

SELECT 
    *
FROM
    Department
        JOIN
    `Account` USING (DepartmentID);

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT 
    *
FROM
    `account`
WHERE
    CreateDate > '2020-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT 
    *
FROM
    position
        JOIN
    `Account` USING (PositionID)
WHERE
    PositionName = 'Dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT 
   * , count(1)
FROM
    `account`
GROUP BY DepartmentID
HAVING COUNT(1) > 3;
-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
/*SELECT 
    QuestionID, COUNT(1)
FROM
    examquestion
GROUP BY QuestionID
ORDER BY COUNT(1) DESC
LIMIT 1;*/

SELECT 
   * , COUNT(1) , group_concat(ExamID)
FROM
    examquestion
GROUP BY QuestionID
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        examquestion
    GROUP BY QuestionID 
    ORDER BY COUNT(1) DESC 
    LIMIT 1);
    
SELECT *,count(1),group_concat(ExamID)
FROM	examquestion
group by QuestionID
having count(1) = (	SELECT MAX(tansuatcauhoi)
					From (	SELECT count(1) AS tansuatcauhoi,QuestionID
					FROM	examquestion
					group by QuestionID) AS table_tamp);

--  Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT 
    *, COUNT(1)
FROM
    question
GROUP BY CategoryID;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT 
    *, COUNT(1)
FROM
    examquestion
GROUP BY QuestionID;
-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
/*SELECT 
   * , COUNT(1)
FROM
    answer
GROUP BY QuestionID
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        answer
    GROUP BY QuestionID 
    ORDER BY COUNT(1) DESC 
    LIMIT 1);*/
SELECT 
   * , COUNT(1) , group_concat(AnswersID)
FROM
    answer
GROUP BY QuestionID
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        answer
    GROUP BY QuestionID 
    ORDER BY COUNT(1) DESC 
    LIMIT 1);
-- Question 9: Thống kê số lượng account trong mỗi group
SELECT 
    *, COUNT(1)
FROM
    groupaccount
GROUP BY AccountID;
-- Question 10: Tìm chức vụ có ít người nhất
SELECT 
   * , COUNT(1) , group_concat(AccountID) 
FROM
	`account`
JOIN Position USING (PositionID)
GROUP BY PositionID
HAVING COUNT(1) = (SELECT 
        COUNT(1)
    FROM
        `account`
    GROUP BY PositionID
    ORDER BY COUNT(1)
    LIMIT 1);
-- Question 11: thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT 
    *, COUNT(1)
FROM
    position
        JOIN
    `Account` USING (PositionID)
GROUP BY PositionID;
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT 
    *
FROM
    answer
        JOIN
    `question` USING (QuestionID);
-- Question 13: lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 
    *, COUNT(1)
FROM
    typequestion
        JOIN
    `question` USING (TypeID)
GROUP BY TypeID;
-- Question 14: lấy ra group không có account nào
SELECT 
    g.GroupID, g.GroupName, AccountID
FROM
    `group` g
        LEFT JOIN
    groupaccount ga ON g.GroupID = ga.GroupID
WHERE
    ga.AccountID IS NULL
GROUP BY g.GroupID;


-- Question 15: lấy ra group không có account nào
-- Question 16: lấy ra question không có answer nào
SELECT 
    q.QuestionID, a.AnswersID, AnswersID
FROM
    `question` q
        LEFT JOIN
    answer a ON q.QuestionID = a.QuestionID
WHERE
    a.Content IS NULL
GROUP BY q.QuestionID;
-- Exercise 2: Union
/* Question 17:
a) Lấy các account thuộc nhóm thứ 1
b) Lấy các account thuộc nhóm thứ 2
c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau*/
SELECT 
    AccountID
FROM
    groupaccount
WHERE
    GroupID = 1
UNION
SELECT 
    AccountID
FROM
    groupaccount
WHERE
    GroupID = 3;


/*Question 18:
a) Lấy các group có lớn hơn 5 thành viên
b) Lấy các group có nhỏ hơn 7 thành viên
c) Ghép 2 kết quả từ câu a) và câu b)*/

SELECT 
    *
FROM
    groupaccount
GROUP BY GroupID
HAVING COUNT(GroupID) > 5 
UNION 
SELECT 
    *
FROM
    groupaccount
GROUP BY GroupID
HAVING COUNT(GroupID) > 7;

-- lấy ra danh sách các câu hỏi có id > id của câu hỏi : "Hỏi về C#"
SELECT  *
FROM 	question
WHERE	questionid > (	SELECT 
							questionid
						FROM
							question
						WHERE
							Content = 'Hỏi về C#');

-- lấy ra danh sách các tài khoản có DepartmentID > DepartmentID của tài khoản có tên là "Nguyen Van Chien"
SELECT 
    *
FROM
    `account`
WHERE
    DepartmentID > (SELECT 
            DepartmentID
        FROM
            `account`
        WHERE
            FullName = 'Nguyen Van Chien');

