USE TestingSystem;
DROP TRIGGER IF EXISTS verify_create_time_on_account;
DELIMITER $$
CREATE TRIGGER verify_create_time_on_account
-- AFTER
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
IF (NEW.CreateDate > NOW() ) THEN
-- 10000 - 45000
SIGNAL SQLSTATE '10000'
SET MESSAGE_TEXT = 'lỗi create date khi them moi account';

END IF;
END $$
DELIMITER ;

INSERT INTO `Account`(Email , Username , FullName , DepartmentID , PositionID, CreateDate)
VALUES ('cuongnm.vti.edu@gmail.com' , 'cuongnm' ,'Nguyen Manh Cuong' , '5' , '1' ,'2030-03-05');
/*Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo
trước 1 năm trước*/
DROP TRIGGER IF EXISTS verify_create_date_on_group;
DELIMITER $$
CREATE TRIGGER verify_create_date_on_group
BEFORE INSERT ON `group`
FOR EACH ROW
BEGIN
	-- select now();
	IF (DATEDIFF(CURRENT_DATE(), NEW.CreateDate) > 365 ) THEN
		SIGNAL SQLSTATE '10000' 
        SET MESSAGE_TEXT = 'lỗi create date khi them moi group';                        
	END IF;	
    
END $$
DELIMITER ;

INSERT INTO `group`(GroupName , CreatorID, CreateDate)
VALUES ( 'grouptest2' , '1' ,'2017-03-05');
SELECT * FROM `group`;

/*Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add
more user"*/
DROP TRIGGER IF EXISTS Max_dept_Sale;
DELIMITER $$
CREATE TRIGGER Max_dept_Sale
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
	DECLARE Department_ID_Sale TINYINT;
    SELECT DepartmentID INTO Department_ID_Sale
    FROM department
    WHERE DepartmentName = 'Sale';
    
    IF NEW.DepartmentID = Department_ID_Sale THEN
		SIGNAL SQLSTATE '12345' -- disallow insert this record
		SET MESSAGE_TEXT = 'Department "Sale" can not add more user';
	END IF;	
END$$
DELIMITER ;

SET foreign_key_checks = 0;
SET GLOBAL function_creators = 1;
INSERT INTO `account` (Email, Username, FullName, DepartmentID, PositionID)
VALUES				('demo1',	'demo1', 'test',	       2, 			  1);

SELECT * FROM `account`;
SELECT * FROM `department`;

/*Question 3: Cấu hình 1 group có nhiều nhất là 5 user.*/
DROP TRIGGER IF EXISTS Max_Account_In_Group;
DELIMITER $$
CREATE TRIGGER Max_Account_In_Group
BEFORE INSERT ON `GroupAccount`
FOR EACH ROW
BEGIN
	IF (NEW.GroupID IN (SELECT GroupID
		FROM GroupAccount
		GROUP BY GroupID
		HAVING Count(AccountID) >= 5))
	THEN
		SIGNAL SQLSTATE '12345'
		SET MESSAGE_TEXT = 'Một group có nhiều nhất 5 User';
	END IF;
END $$
DELIMITER ;
SELECT *
FROM GroupAccount;

INSERT INTO `GroupAccount` ( GroupID , AccountID , JoinDate )
VALUE ( 1 , 3 ,'2020-03-05');

/*Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question*/
DROP TRIGGER IF EXISTS Max_Question_In_Exam;
DELIMITER $$
CREATE TRIGGER Max_Question_In_Exam
BEFORE INSERT ON `examquestion`
FOR EACH ROW
BEGIN
	IF (NEW.ExamID IN (SELECT ExamID
						FROM examquestion
						GROUP BY ExamID
						HAVING Count(QuestionID) >= 10))
	THEN
		SIGNAL SQLSTATE '12346'
		SET MESSAGE_TEXT = 'Một bài thi có nhiều nhất là 10 Question';
	END IF;
END $$
DELIMITER ;
INSERT INTO `examquestion` (  ExamID, QuestionID )
VALUE ( 1 , 34 );
SELECT *
FROM examquestion;



/*Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó*/
DROP TRIGGER IF EXISTS before_accounts_delete;
DELIMITER $$
CREATE TRIGGER before_accounts_delete 
BEFORE DELETE ON account
FOR EACH ROW
BEGIN
	DECLARE v_account_id TINYINT;
    
    SELECT AccountID INTO v_account_id
    FROM account
    WHERE Email = OLD.Email;
	
	IF OLD.Email = 'admin@gmail.com' THEN
		SIGNAL SQLSTATE '12345' 
		SET MESSAGE_TEXT = 'This is Admin account, you can not delete!';
	ELSE 
		DELETE FROM groupaccount WHERE AccountID = v_account_id;
        UPDATE `group` SET CreatorID = NULL WHERE CreatorID = v_account_id;
        UPDATE exam SET CreatorID = NULL WHERE CreatorID = v_account_id;
        UPDATE question SET CreatorID = NULL WHERE CreatorID = v_account_id;
    END IF;
END$$
DELIMITER ;

SET foreign_key_checks = 0;
SET GLOBAL log_bin_trust_function_creators = 1;
DELETE FROM account
WHERE Email = 'haidang29productions@gmail.com';

SELECT * FROM account;


/*Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
Account, hãy tạo trigger cho phép người dùng khi tạo account không điền vào
departmentID thì sẽ được phân vào phòng ban "waiting Department"*/
DROP TRIGGER IF EXISTS Not_Use_Default;
DELIMITER $$
CREATE TRIGGER Not_Use_Default 
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
	DECLARE v_department_id TINYINT ;
    
    SELECT DepartmentID INTO v_department_id 
    FROM department
    WHERE DepartmentName = 'Waiting Department';
    
    IF NEW.DepartmentID IS NULL THEN
		SET NEW.DepartmentID = v_department_id;
	END IF;
END$$
DELIMITER ; 

/*Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
question, trong đó có tối đa 2 đáp án đúng.*/


/*Question 8: Viết trigger sửa lại dữ liệu cho đúng: nếu người dùng nhập vào gender
của account là nam, nữ, chưa xác định thì sẽ đổi lại thành M, F, U cho giống với cấu
hình ở database*/
alter table `account`
add Gender varchar(50);	
select * from `account`;

/*drop trigger if exists Auto_Gender_Update;
delimiter $$
create trigger Auto_Gender_Update
before insert on `account`
for each row
begin
	if new.Gender = 'Nam' Then
		set new.Gender = 'M';
	if new.Gender = 'Nu' Then
		set new.Gender = 'F';
	if new.Gender = 'Chưa xác định' Then
		set new.Gender = 'U';
	end if ;

end $$
delimiter ;*/

DROP TRIGGER IF EXISTS Auto_Gender_Update;
DELIMITER $$
CREATE TRIGGER Auto_Gender_Update
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
IF NEW.Gender = 'Nam' THEN
SET NEW.Gender = 'M';
ELSEIF NEW.Gender = 'Nu' THEN
SET NEW.Gender = 'F';
ELSEIF NEW.Gender = 'Chưa xác định' THEN
SET NEW.Gender = 'U';
END IF ;
END $$n
DELIMITER ;
INSERT INTO `Account`(Email , Username , FullName ,Gender , DepartmentID , PositionID, CreateDate)
VALUE ('haidang29productions@gmail.com1' , 'dangblack1' ,'Nguyen Hai Dang' ,'Nu' , '5' , '1' ,'2020-03-05');
select * from `Account`;

/*Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày*/
/*Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
question khi question đó chưa nằm trong exam nào*/
/*Question 12: Lấy ra thông tin exam trong đó
Duration <= 30 thì sẽ đổi thành giá trị "Short time"
30 < duration <= 60 thì sẽ đổi thành giá trị "Medium time"
duration >60 thì sẽ đổi thành giá trị "Long time"*/
SELECT ExamID,Title,`Code`,Duration,
	CASE 	WHEN Duration <= 30 THEN "Short time" 
            WHEN Duration > 30 and Duration <= 60 THEN "Medium time"
            WHEN Duration > 60 THEN "Long time"             
	END AS Duration
FROM exam;
/*Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
là the_number_user_amount và mang giá trị được quy định như sau:
Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher2*/
/*Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
không có user thì sẽ thay đổi giá trị 0 thành "Không có User"*/

