# J4A 班级学生成绩管理系统

技术栈：**JavaEE + Servlet + JSP + MySQL 8.0 + Tomcat 9 + Maven**

---

## 一、功能清单

| 角色 | 功能 |
| --- | --- |
| 教师 | 登录、录入成绩、修改成绩、删除成绩、查看全班成绩、看班级平均分/及格率 |
| 学生 | 登录、查询自己的成绩、看个人平均分 |

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
    │   ├── util/DBUtil.java     # 数据库连接（⚠️ 改这里的 MySQL 密码）
    │   ├── model/               # User.java / Score.java
    │   ├── dao/                 # UserDAO.java / ScoreDAO.java
    │   └── servlet/            # Login / Logout / Teacher / Student
    └── webapp/
        ├── WEB-INF/web.xml
        ├── login.jsp
        ├── teacher/list.jsp     # 教师主页：列表 + 新增 + 统计
        ├── teacher/edit.jsp     # 修改成绩
        └── student/my.jsp       # 学生主页
```

---

## 三、Ubuntu IDEA 跑通步骤（保姆级）

### 1. 建数据库

打开终端，登录 MySQL：

```bash
mysql -u root -p
```

输入密码后，把 `sql/init.sql` 整个文件粘进去回车，或者执行：

```sql
SOURCE /你的路径/student-score-system/sql/init.sql;
```

看到报错就检查一下路径对不对。成功后用 `SHOW DATABASES;` 应该能看到 `score_system`。

### 2. 改数据库密码

打开 `src/main/java/com/example/score/util/DBUtil.java`，把这一行改成你自己的 MySQL root 密码：

```java
private static final String DB_PASSWORD = "root"; // ← 改成你的密码
```

### 3. IDEA 导入项目

1. 打开 IDEA → `File` → `Open` → 选 `student-score-system` 文件夹（有 pom.xml 的那一层）→ 弹框选 **Open as Project**。
2. 等 Maven 右下角进度条跑完（第一次会下依赖，慢一点正常）。
3. `File` → `Project Structure` → `Project`：SDK 选你装的 JDK（8/11/17 都行）。
4. `File` → `Project Structure` → `Facets` → 确认 Web  facet 已经识别到 `src/main/webapp`，如果没有就点 `+` → Web。

### 4. 配 Tomcat 9

1. 右上角运行配置下拉 → `Edit Configurations` → 左上角 `+` → 选 **Tomcat Server** → **Local**。
2. `Application server` 选你 Ubuntu 上装的 Tomcat 9 目录（没有就点 `Configure` 加一个）。
3. 切到 `Deployment` 标签 → 点 `+` → `Artifact` → 选 **student-score-system:war exploded**。
4. 下面 `Application context` 改成 `/score`。
5. 点 `OK` 保存。

### 5. 启动

点绿色三角启动，控制台出现 `Server startup in xxx ms` 就成功了。
浏览器访问：

```
http://localhost:8080/score/login.jsp
```

用 `teacher / 123456` 登录试一下录成绩，再换 `2024001 / 123456` 看学生端。

---

## 四、常见坑

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| 中文乱码 | 请求编码没设 | 已在 Servlet 里 `request.setCharacterEncoding("UTF-8")`，不用管 |
| 报 `Communications link failure` | MySQL 没启动或密码错 | `sudo systemctl start mysql`；检查 DBUtil 里密码 |
| 报 `Unknown database 'score_system'` | 没执行 init.sql | 回到第 1 步 |
| Tomcat 10 启动报 `ClassNotFoundException: javax.servlet.http.HttpServlet` | Tomcat 10 用 jakarta 包名 | 装 Tomcat 9；或者把所有 `javax.servlet` 改成 `jakarta.servlet`（不推荐，课程要求 Tomcat 9） |
| 404 | Deployment 没加 Artifact 或 context 不是 `/score` | 回到第 4 步 |

---

## 五、推 GitHub

项目根目录已经是干净的，直接：

```bash
cd student-score-system
git init
git add .
git commit -m "feat: J4A 学生成绩管理系统初版"
git branch -M main
git remote add origin 你刚建好的GitHub仓库地址.git
git push -u origin main
```

---

## 六、主要访问路径

| 路径 | 说明 |
| --- | --- |
| `/score/login.jsp` | 登录页 |
| `POST /score/login` | 登录接口 |
| `/score/teacher/list` | 教师主页（列表+统计+新增） |
| `/score/teacher/edit?id=x` | 编辑成绩 |
| `/score/student/my` | 学生主页（我的成绩） |
| `/score/logout` | 退出 |
