<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>学生端 - 我的成绩</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f4f6fa; padding: 20px; }
        .bar {
            background: #fff; padding: 15px 25px; border-radius: 8px;
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }
        .bar h2 { color: #333; font-size: 20px; }
        .bar a { color: #667eea; text-decoration: none; font-size: 14px; }
        .avg {
            background: #fff; padding: 20px; border-radius: 8px;
            text-align: center; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }
        .avg .num { font-size: 32px; color: #667eea; font-weight: bold; }
        .avg .label { color: #999; margin-top: 5px; }
        .panel {
            background: #fff; padding: 20px 25px; border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: center; border-bottom: 1px solid #eee; }
        th { background: #f8f9fc; color: #666; font-weight: normal; }
        .pass { color: #2ecc71; }
        .fail { color: #e74c3c; }
    </style>
</head>
<body>
    <div class="bar">
        <h2>我的成绩</h2>
        <div>
            欢迎，${sessionScope.loginUser.username}
            &nbsp;|&nbsp;
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>

    <div class="avg">
        <div class="num"><fmt:formatNumber value="${myAvg}" maxFractionDigits="2"/></div>
        <div class="label">我的平均分</div>
    </div>

    <div class="panel">
        <table>
            <tr><th>科目</th><th>分数</th><th>是否及格</th></tr>
            <c:forEach items="${myList}" var="s">
                <tr>
                    <td>${s.subject}</td>
                    <td>${s.score}</td>
                    <td>
                        <c:choose>
                            <c:when test="${s.score >= 60}"><span class="pass">及格</span></c:when>
                            <c:otherwise><span class="fail">不及格</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty myList}">
                <tr><td colspan="3" style="color:#999">老师还没给你录成绩</td></tr>
            </c:if>
        </table>
    </div>
</body>
</html>
