package com.example.score.servlet;

import com.example.score.dao.ScoreDAO;
import com.example.score.dao.UserDAO;
import com.example.score.model.Score;
import com.example.score.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 教师端：
 *  GET  /teacher/list            全班成绩列表 + 统计
 *  POST /teacher/list?action=add 新增一条成绩
 *  GET  /teacher/edit?id=x       打开编辑页
 *  POST /teacher/edit            保存编辑
 *  GET  /teacher/delete?id=x      删除一条
 */
@WebServlet(urlPatterns = {"/teacher/list", "/teacher/edit", "/teacher/delete"})
public class TeacherServlet extends HttpServlet {

    private final ScoreDAO scoreDAO = new ScoreDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 教师权限校验
        if (!isTeacher(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        String path = req.getServletPath();

        if ("/teacher/list".equals(path)) {
            showList(req, resp);
        } else if ("/teacher/edit".equals(path)) {
            showEdit(req, resp);
        } else if ("/teacher/delete".equals(path)) {
            String id = req.getParameter("id");
            if (id != null) scoreDAO.delete(Integer.parseInt(id));
            resp.sendRedirect(req.getContextPath() + "/teacher/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!isTeacher(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        String path = req.getServletPath();

        if ("/teacher/list".equals(path)) {
            // 新增
            Score s = new Score();
            s.setStudentId(Integer.parseInt(req.getParameter("studentId")));
            s.setSubject(req.getParameter("subject"));
            s.setScore(Double.parseDouble(req.getParameter("score")));
            scoreDAO.add(s);
            resp.sendRedirect(req.getContextPath() + "/teacher/list");
        } else if ("/teacher/edit".equals(path)) {
            // 修改
            Score s = new Score();
            s.setId(Integer.parseInt(req.getParameter("id")));
            s.setStudentId(Integer.parseInt(req.getParameter("studentId")));
            s.setSubject(req.getParameter("subject"));
            s.setScore(Double.parseDouble(req.getParameter("score")));
            scoreDAO.update(s);
            resp.sendRedirect(req.getContextPath() + "/teacher/list");
        }
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Score> list = scoreDAO.findAll();
        List<User> students = userDAO.findAllStudents();
        double avg = scoreDAO.getAverage();
        double passRate = scoreDAO.getPassRate();

        req.setAttribute("list", list);
        req.setAttribute("students", students);
        req.setAttribute("avg", avg);
        req.setAttribute("passRate", passRate);
        req.getRequestDispatcher("/teacher/list.jsp").forward(req, resp);
    }

    private void showEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Score s = scoreDAO.findById(id);
        List<User> students = userDAO.findAllStudents();
        req.setAttribute("score", s);
        req.setAttribute("students", students);
        req.getRequestDispatcher("/teacher/edit.jsp").forward(req, resp);
    }

    private boolean isTeacher(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        User u = (User) session.getAttribute("loginUser");
        return u != null && "teacher".equals(u.getRole());
    }
}
