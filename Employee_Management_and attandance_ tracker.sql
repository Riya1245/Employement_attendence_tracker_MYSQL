CREATE DATABASE EmployeeDB;
USE EmployeeDB;

-- Departments Table
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Roles Table
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL
);

-- Employees Table
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    role_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Attendance Table
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    check_in DATETIME,
    check_out DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Departments
INSERT INTO Departments (department_name)
VALUES ('HR'), ('Engineering'), ('Marketing'), ('Sales');

-- Roles
INSERT INTO Roles (role_name)
VALUES ('Manager'), ('Developer'), ('Designer'), ('HR Executive');

-- 10 Employees (for example)
INSERT INTO Employees (name, department_id, role_id)
VALUES
('Amit Sharma', 2, 2),
('Neha Singh', 1, 1),
('Ravi Kumar', 3, 3),
('Pooja Yadav', 4, 4),
('Manish Verma', 2, 2),
('Shweta Tiwari', 1, 1),
('Nikhil Rao', 3, 3),
('Kiran Mehta', 4, 4),
('Suresh Das', 2, 1),
('Geeta Bose', 1, 4);

INSERT INTO Attendance (employee_id, check_in, check_out)
VALUES
(1, '2025-08-01 09:10:00', '2025-08-01 17:00:00'),
(2, '2025-08-01 10:15:00', '2025-08-01 18:00:00'),
(3, '2025-08-01 09:05:00', '2025-08-01 17:10:00');

-- Late Status Auto Set triggers 
DELIMITER //

CREATE TRIGGER check_late
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
    IF HOUR(NEW.check_in) > 10 THEN
        SET NEW.status = 'Late';
    ELSE
        SET NEW.status = 'Present';
    END IF;
END//

DELIMITER ;

-- Work Hours Calculate function
DELIMITER //

CREATE FUNCTION calculate_work_hours(start_time DATETIME, end_time DATETIME)
RETURNS TIME
DETERMINISTIC
BEGIN
    RETURN TIMEDIFF(end_time, start_time);
END//

DELIMITER ;

-- Attendance Reports — Queries
SELECT 
    e.name,
    COUNT(a.attendance_id) AS days_present
FROM 
    Employees e
JOIN 
    Attendance a ON e.employee_id = a.employee_id
WHERE 
    MONTH(a.check_in) = 8  -- August
GROUP BY 
    e.name;

-- Late Arrivals Report:
SELECT 
    e.name,
    a.check_in
FROM 
    Employees e
JOIN 
    Attendance a ON e.employee_id = a.employee_id
WHERE 
    a.status = 'Late';

-- Views
CREATE VIEW Attendance_Report AS
SELECT 
    e.name,
    a.check_in,
    a.check_out,
    a.status,
    TIMEDIFF(a.check_out, a.check_in) AS work_duration
FROM Employees e
JOIN Attendance a ON e.employee_id = a.employee_id;






