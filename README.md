# J4A 班级学生成绩管理系统

技术栈：**JavaEE（Jakarta EE）+ Servlet + JSP + MySQL 8.0 + Tomcat 10 + Maven**

---

## 一、功能清单

| 角色 | 功能 |
| --- | --- |
| 教师 | 登录、录入成绩、修改成绩、删除成绩、查看全班成绩、查看班级平均分/及格率 |
| 学生 | 登录、查询自己的成绩、查看个人平均分 |

测试账号（密码都是 `123456`）：

- 教师：`teacher`
- 学生：`2024001` / `2024002` / `2024003`

---

## 二、目录结构

```
student-score-system/
├── pom.xml
├── sql/
│   └── init.sql                 # 建库 + 建表 + 测试数据
└── src/main/
    ├── java/com/example/score/
    │   ├── util/DBUtil.java     # 数据库连接（MySQL 密码在这里改）
    │   ├── model/               # User.java / Score.java
    │   ├── dao/                 # UserDAO.java / ScoreDAO.java
    │   └── servlet/             # Login / Logout / Teacher / Student
    └── webapp/
        ├── WEB-INF/web.xml
        ├── login.jsp
        ├── teacher/list.jsp     # 教师主页：列表 + 新增 + 统计
        ├── teacher/edit.jsp     # 修改成绩
        └── student/my.jsp       # 学生主页
```

---

## 三、运行环境说明

本项目运行在 **Tomcat 10** 上。Tomcat 10 及以后版本使用 **Jakarta EE** 命名空间，
Servlet 相关包名是 `jakarta.servlet.*`，而不是旧的 `javax.servlet.*`。

对应依赖版本（见 `pom.xml`）：

| 依赖 | 版本 |
| --- | --- |
| jakarta.servlet-api | 6.0.0 |
| jakarta.servlet.jsp-api | 3.0.0 |
| jakarta.servlet.jsp.jstl（Glassfish 实现） | 3.0.1 |
| mysql-connector-j | 8.0.33 |
| JDK | 17 |

JSP 页面中的 JSTL 标签库使用 Jakarta 命名空间：

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
```

---

## 四、IDEA 跑通步骤

### 1. 建数据库

登录 MySQL：

```bash
sudo mysql
```

执行 `sql/init.sql`，或直接：

```sql
SOURCE /home/vboxuser/IdeaProjects/student-score-system/sql/init.sql;
```

成功后用 `SHOW DATABASES;` 能看到 `score_system`。

### 2. 确认数据库密码

打开 `src/main/java/com/example/score/util/DBUtil.java`，确认密码与本机 MySQL 一致：

```java
private static final String DB_PASSWORD = "root";
```

### 3. 导入项目

1. IDEA → `File` → `Open` → 选择 `student-score-system` 文件夹（含 pom.xml）。
2. 等 Maven 依赖下载完成。
3. `File` → `Project Structure` → `Project`，SDK 选择 JDK 17。

### 4. 配置 Tomcat 10

1. 右上角运行配置 → `Edit Configurations` → `+` → `Tomcat Server` → `Local`。
2. Application server 选择 Tomcat 10 主目录 `/usr/share/tomcat10`。
3. 切到 `Deployment` 标签 → `+` → `Artifact` → 选 `student-score-system:war exploded`。
4. Application context 改成 `/score`。

### 5. 启动

点绿色三角启动，控制台出现 `Server startup in xxx ms` 即成功。浏览器访问：

```
http://localhost:8080/score/login.jsp
```

用 `teacher / 123456` 登录测试录入成绩，再用 `2024001 / 123456` 查看学生端。

---

## 五、常见问题

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| 中文乱码 | 请求编码未设置 | Servlet 已统一 `setCharacterEncoding("UTF-8")` |
| `Communications link failure` | MySQL 未启动或密码错误 | `sudo systemctl start mysql`；检查 DBUtil |
| `Unknown database 'score_system'` | 未执行 init.sql | 回到第一步 |
| Tomcat 报 `ClassNotFoundException: jakarta.servlet...` | 依赖或包名不匹配 | 确认使用 Tomcat 10 与 jakarta 依赖 |
| 404 | 未部署 Artifact 或 context 错误 | 检查 Deployment 与 `/score` |

---

## 六、主要访问路径

| 路径 | 说明 |
| --- | --- |
| `/score/login.jsp` | 登录页 |
| `POST /score/login` | 登录接口 |
| `/score/teacher/list` | 教师主页（列表 + 统计 + 新增） |
| `/score/teacher/edit?id=x` | 编辑成绩 |
| `/score/student/my` | 学生主页（我的成绩） |
| `/score/logout` | 退出 |
