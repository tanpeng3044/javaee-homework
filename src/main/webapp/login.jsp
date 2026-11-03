<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>学生成绩管理系统 - 登录</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
        }
        .card {
            background: #fff; width: 380px; padding: 40px 35px;
            border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,.2);
        }
        h2 { text-align: center; color: #333; margin-bottom: 25px; }
        .field { margin-bottom: 18px; }
        label { display: block; color: #666; font-size: 14px; margin-bottom: 6px; }
        input {
            width: 100%; padding: 10px 12px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 14px; outline: none;
        }
        input:focus { border-color: #667eea; }
        button {
            width: 100%; padding: 11px; background: #667eea; color: #fff;
            border: none; border-radius: 6px; font-size: 16px; cursor: pointer;
        }
        button:hover { background: #5568d3; }
        .error {
            background: #ffe5e5; color: #d80000; padding: 10px;
            border-radius: 6px; font-size: 13px; margin-bottom: 15px; text-align: center;
        }
        .tip { text-align: center; color: #999; font-size: 12px; margin-top: 15px; line-height: 1.8; }
    </style>
</head>
<body>
    <div class="card">
        <h2>成绩管理系统</h2>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="field">
                <label>账号</label>
                <input type="text" name="username" required placeholder="教师: teacher / 学生: 2024001">
            </div>
            <div class="field">
                <label>密码</label>
                <input type="password" name="password" required placeholder="默认 123456">
            </div>
            <button type="submit">登 录</button>
        </form>
        <div class="tip">
            教师账号：teacher / 123456<br>
            学生账号：2024001 / 123456
        </div>
    </div>
</body>
</html>
