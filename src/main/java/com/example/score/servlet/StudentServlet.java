package com.example.score.servlet;

import com.example.score.dao.ScoreDAO;
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

@WebServlet("/student/my")
public class StudentServlet extends HttpServlet {

    private final ScoreDAO scoreDAO = new ScoreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User u = (User) session.getAttribute("loginUser");
        if (u == null || !"student".equals(u.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Score> myList = scoreDAO.findByStudentId(u.getId());
        double myAvg = scoreDAO.getAverageByStudent(u.getId());

        req.setAttribute("myList", myList);
        req.setAttribute("myAvg", myAvg);
        req.getRequestDispatcher("/student/my.jsp").forward(req, resp);
    }
}
