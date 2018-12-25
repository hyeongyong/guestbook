package com.guestbook;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.connection.MySQLConnection80;

public class GuestbookDAO {

	
	//전체출력
	public List<Guestbook> list() {
		List<Guestbook> result = new ArrayList<Guestbook>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT gid, name_, content, regDate\r\n" + 
					"FROM guestbook\r\n" + 
					"WHERE blind = 0\r\n" + 
					"ORDER BY gid";
			
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String gid = rs.getString("gid");
				String name_ = rs.getString("name_");
				String content = rs.getString("content");
				Date regDate = rs.getDate("regDate");
				
				result.add(new Guestbook(gid, name_, content, regDate));
			}
			rs.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn!=null)
					MySQLConnection80.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	//페이지 출력
	public List<Guestbook> pageList(int pageStart, int pageCount) {
		List<Guestbook> result = new ArrayList<Guestbook>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT gid, name_, content, regDate\r\n" + 
					"FROM guestbook\r\n" + 
					"WHERE blind = 0\r\n" + 
					"ORDER BY gid DESC \r\n" +
					"LIMIT ?, ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pageStart);
			pstmt.setInt(2, pageCount);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String gid = rs.getString("gid");
				String name_ = rs.getString("name_");
				String content = rs.getString("content");
				Date regDate = rs.getDate("regDate");
				
				result.add(new Guestbook(gid, name_, content, regDate));
			}
			rs.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn!=null)
					MySQLConnection80.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	//일반사용자용 전체 갯수 출력
	public int totalCount() {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT COUNT(*) as count_ FROM guestbook WHERE blind=0";
			
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int count_ = rs.getInt("count_");
				
				result = count_;
			}
			rs.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn!=null)
					MySQLConnection80.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	//방명록글 삭제
	public int delete(String gid, String pw) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "DELETE FROM guestbook\r\n" + 
					"WHERE gid = ?\r\n" + 
					"	AND pw = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, gid);
			pstmt.setString(2, pw);
			result = pstmt.executeUpdate();

		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn!=null)
					MySQLConnection80.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	//방명록글 등록
	public int insert(Guestbook g) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "INSERT INTO guestbook (gid, name_, pw, content, regDate, clientIP, blind)\r\n" + 
					"	VALUES ((SELECT CONCAT('G', LPAD(IFNULL(SUBSTR(MAX(gid),2),0)+1,3,0)) AS newId FROM guestbook gb), \r\n" + 
					"			?, ?, ?, NOW(), ?, 0)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, g.getName_());
			pstmt.setString(2, g.getPw());
			pstmt.setString(3, g.getContent());
			pstmt.setString(4, g.getClientIP());
			result = pstmt.executeUpdate();

		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn!=null)
					MySQLConnection80.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
}
