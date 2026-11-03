<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>教师端 - 全班成绩</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f4f6fa; padding: 20px; }
        .bar {
            background: #fff; padding: 15px 25px; border-radius: 8px;
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }
        .bar h2 { color: #333; font-size: 20px; }
        .bar a { color: #667eea; text-decoration: none; font-size: 14px; }
        .stats { display: flex; gap: 20px; margin-bottom: 20px; }
        .stat {
            flex: 1; background: #fff; padding: 20px; border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05); text-align: center;
        }
        .stat .num { font-size: 30px; color: #667eea; font-weight: bold; }
        .stat .label { color: #999; font-size: 13px; margin-top: 5px; }
        .panel {
            background: #fff; padding: 20px 25px; border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05); margin-bottom: 20px;
        }
        .panel h3 { color: #333; margin-bottom: 15px; font-size: 16px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 12px; text-align: center; border-bottom: 1px solid #eee; }
        th { background: #f8f9fc; color: #666; font-weight: normal; }
        tr:hover { background: #f9faff; }
        .pass { color: #2ecc71; }
        .fail { color: #e74c3c; }
        form.add { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        form.add select, form.add input {
            padding: 8px 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;
        }
        form.add button {
            padding: 8px 20px; background: #667eea; color: #fff;
            border: none; border-radius: 6px; cursor: pointer;
        }
        .op a { color: #667eea; text-decoration: none; margin: 0 5px; font-size: 13px; }
        .op a.del { color: #e74c3c; }
    </style>
</head>
<body>
    <div class="bar">
        <h2>教师工作台 - 全班成绩管理</h2>
        <div>
            欢迎，${sessionScope.loginUser.username}
            &nbsp;|&nbsp;
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>

    <div class="stats">
        <div class="stat">
            <div class="num"><fmt:formatNumber value="${avg}" maxFractionDigits="2"/></div>
            <div class="label">班级平均分</div>
        </div>
        <div class="stat">
            <div class="num"><fmt:formatNumber value="${passRate}" maxFractionDigits="2"/>%</div>
            <div class="label">及格率（≥60）</div>
        </div>
    </div>

    <div class="panel">
        <h3>＋ 录入新成绩</h3>
        <form class="add" action="${pageContext.request.contextPath}/teacher/list" method="post">
            <select name="studentId" required>
                <c:forEach items="${students}" var="st">
                    <option value="${st.id}">${st.username}</option>
                </c:forEach>
            </select>
            <input type="text" name="subject" required placeholder="科目，如 Java">
            <input type="number" name="score" step="0.5" min="0" max="100" required placeholder="分数">
            <button type="submit">添加</button>
        </form>
    </div>

    <div class="panel">
        <h3>全班成绩列表</h3>
        <table>
            <tr>
                <th>ID</th><th>学生账号</th><th>科目</th><th>分数</th><th>是否及格</th><th>操作</th>
            </tr>
            <c:forEach items="${list}" var="s">
                <tr>
                    <td>${s.id}</td>
                    <td>${s.studentName}</td>
                    <td>${s.subject}</td>
                    <td>${s.score}</td>
                    <td>
                        <c:choose>
                            <c:when test="${s.score >= 60}"><span class="pass">及格</span></c:when>
                            <c:otherwise><span class="fail">不及格</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="op">
                        <a href="${pageContext.request.contextPath}/teacher/edit?id=${s.id}">修改</a>
                        <a class="del" href="${pageContext.request.contextPath}/teacher/delete?id=${s.id}"
                           onclick="return confirm('确认删除这条成绩？')">删除</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr><td colspan="6" style="color:#999">暂无成绩数据</td></tr>
            </c:if>
        </table>
    </div>
</body>
</html>
