package com.login;

import java.sql.*;

import com.connection.MySQLConnection80;

public class LoginDAO {

	public Login login(String id_, String pw) {
		Login result = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT id_ \r\n" + 
					"FROM admin_\r\n" + 
					"WHERE id_ = ? AND pw = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id_);
			pstmt.setString(2, pw);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String id = rs.getString("id_");
				result = new Login(id, null); 
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
}
