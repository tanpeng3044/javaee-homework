-- J4A 班级学生成绩管理系统 数据库初始化脚本
-- MySQL 8.0 执行

CREATE DATABASE IF NOT EXISTS score_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE score_system;

DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS user;

-- 用户表（teacher / student 两种角色）
CREATE TABLE user (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20) UNIQUE,
    password VARCHAR(20),
    role     VARCHAR(10)  -- teacher / student
);

-- 成绩表
CREATE TABLE score (
    id         INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject    VARCHAR(20),
    score      DOUBLE,
    FOREIGN KEY (student_id) REFERENCES user(id)
);

-- ========== 测试账号（密码都是 123456） ==========
INSERT INTO user(username, password, role) VALUES
('teacher', '123456', 'teacher'),
('2024001', '123456', 'student'),
('2024002', '123456', 'student'),
('2024003', '123456', 'student');

-- ========== 示例成绩 ==========
INSERT INTO score(student_id, subject, score) VALUES
(2, 'Java',   85),
(2, 'MySQL',  90),
(2, 'JSP',    78),
(3, 'Java',   55),
(3, 'MySQL',  62),
(3, 'JSP',    48),
(4, 'Java',   92),
(4, 'MySQL',  88),
(4, 'JSP',    95);
