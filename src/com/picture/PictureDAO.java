package com.picture;

import java.util.*;

import com.connection.MySQLConnection80;

import java.sql.*;

public class PictureDAO {
	
	//출력
	public List<Picture> pictureList() {
		List<Picture> result = new ArrayList<Picture>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT pid, filename, content FROM pictureList";
			
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String pid = rs.getString("pid");
				String filename = rs.getString("filename");
				String content = rs.getString("content");
				
				result.add(new Picture(pid, filename, content));
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
	

	//입력
	public int pictureAdd(Picture p) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = MySQLConnection80.connect();
			
			String sql = "INSERT INTO pictureList(pid, filename, content) \r\n" + 
					"	VALUES ((SELECT CONCAT('P', LPAD(IFNULL(SUBSTR(MAX(pid),2),0)+1,2,0)) AS newId FROM pictureList p)\r\n" + 
					"			, ? ,?)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, p.getFilename());
			pstmt.setString(2, p.getContent());
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
	
	
	//삭제
	public int pictureRemove(Picture p) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = MySQLConnection80.connect();
			
			String sql = "DELETE FROM pictureList WHERE pid = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, p.getPid());
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

