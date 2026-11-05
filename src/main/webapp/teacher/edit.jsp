<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>修改成绩</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f4f6fa; padding: 40px; }
        .card {
            max-width: 450px; margin: 0 auto; background: #fff;
            padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,.08);
        }
        h2 { color: #333; margin-bottom: 20px; font-size: 20px; }
        .field { margin-bottom: 15px; }
        label { display: block; color: #666; font-size: 14px; margin-bottom: 6px; }
        select, input {
            width: 100%; padding: 9px 12px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 14px;
        }
        .btns { margin-top: 20px; display: flex; gap: 10px; }
        button, .back {
            flex: 1; padding: 10px; border: none; border-radius: 6px;
            font-size: 15px; cursor: pointer; text-align: center; text-decoration: none;
        }
        button { background: #667eea; color: #fff; }
        .back { background: #eee; color: #666; }
    </style>
</head>
<body>
    <div class="card">
        <h2>修改成绩 #${score.id}</h2>
        <form action="${pageContext.request.contextPath}/teacher/edit" method="post">
            <input type="hidden" name="id" value="${score.id}">
            <div class="field">
                <label>学生</label>
                <select name="studentId">
                    <c:forEach items="${students}" var="st">
                        <option value="${st.id}"
                            <c:if test="${st.id == score.studentId}">selected</c:if>>
                            ${st.username}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="field">
                <label>科目</label>
                <input type="text" name="subject" value="${score.subject}" required>
            </div>
            <div class="field">
                <label>分数</label>
                <input type="number" name="score" step="0.5" min="0" max="100"
                       value="${score.score}" required>
            </div>
            <div class="btns">
                <a class="back" href="${pageContext.request.contextPath}/teacher/list">返回</a>
                <button type="submit">保存修改</button>
            </div>
        </form>
    </div>
</body>
</html>
