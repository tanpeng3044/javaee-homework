package com.example.score.servlet;

import com.example.score.dao.UserDAO;
import com.example.score.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.login(username, password);
        if (user == null) {
            req.setAttribute("error", "账号或密码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("loginUser", user);

        // 按角色分流
        if ("teacher".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/teacher/list");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/my");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 直接访问 /login 就回登录页
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
