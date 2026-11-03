package com.example.score.dao;

import com.example.score.model.Score;
import com.example.score.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScoreDAO {

    /** 教师：查全班所有成绩（联表带学生账号） */
    public List<Score> findAll() {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.id, s.student_id, u.username, s.subject, s.score " +
                     "FROM score s JOIN user u ON s.student_id = u.id ORDER BY s.id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /** 学生：查自己的成绩 */
    public List<Score> findByStudentId(int studentId) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.id, s.student_id, u.username, s.subject, s.score " +
                     "FROM score s JOIN user u ON s.student_id = u.id " +
                     "WHERE s.student_id=? ORDER BY s.subject";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /** 教师：按主键查一条（编辑页回显用） */
    public Score findById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT s.id, s.student_id, u.username, s.subject, s.score " +
                "FROM score s JOIN user u ON s.student_id=u.id WHERE s.id=?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    /** 教师：新增成绩 */
    public void add(Score s) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "INSERT INTO score(student_id, subject, score) VALUES(?,?,?)");
            ps.setInt(1, s.getStudentId());
            ps.setString(2, s.getSubject());
            ps.setDouble(3, s.getScore());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /** 教师：修改成绩 */
    public void update(Score s) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "UPDATE score SET student_id=?, subject=?, score=? WHERE id=?");
            ps.setInt(1, s.getStudentId());
            ps.setString(2, s.getSubject());
            ps.setDouble(3, s.getScore());
            ps.setInt(4, s.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /** 教师：删除成绩 */
    public void delete(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM score WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /** 全班平均分（所有成绩记录） */
    public double getAverage() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT AVG(score) FROM score");
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    /** 全班及格率（>=60 分占比，百分比 0~100） */
    public double getPassRate() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT SUM(CASE WHEN score>=60 THEN 1 ELSE 0 END)*100.0/COUNT(*) FROM score");
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    /** 学生个人平均分 */
    public double getAverageByStudent(int studentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT AVG(score) FROM score WHERE student_id=?");
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    private Score mapRow(ResultSet rs) throws SQLException {
        Score s = new Score();
        s.setId(rs.getInt("id"));
        s.setStudentId(rs.getInt("student_id"));
        s.setStudentName(rs.getString("username"));
        s.setSubject(rs.getString("subject"));
        s.setScore(rs.getDouble("score"));
        return s;
    }
}
