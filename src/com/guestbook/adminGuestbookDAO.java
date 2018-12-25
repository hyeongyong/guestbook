package com.guestbook;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

import com.connection.MySQLConnection80;

public class adminGuestbookDAO {
	
	
	//전체 출력
	public List<Guestbook> list() {
		List<Guestbook> result = new ArrayList<Guestbook>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT gid, name_, content, regDate, clientIP, blind\r\n" + 
					"FROM guestbook\r\n" + 
					"ORDER BY gid";
			
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String gid = rs.getString("gid");
				String name_ = rs.getString("name_");
				String content = rs.getString("content");
				
				//날짜 시간 같이 얻어오는 메소드
				Timestamp ts = rs.getTimestamp("regDate", Calendar.getInstance(Locale.getDefault()));
				String clientIP = rs.getString("clientIP");
				int blind = rs.getInt("blind");
				
				result.add(new Guestbook(gid, name_,content, ts, clientIP, blind));
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
	
	
	//블라인드 처리 및 해제
	public int blind(String gid, int blind) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "UPDATE guestbook SET blind = ?\r\n" + 
					"	WHERE gid = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, blind);
			pstmt.setString(2, gid);
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
	
	//관리자용 전체 갯수 출력
	public int totalCount() {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT COUNT(*) as count_ FROM guestbook";
			
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
	
	//페이지 출력
	public List<Guestbook> pageList(int pageStart, int pageCount) {
		List<Guestbook> result = new ArrayList<Guestbook>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = MySQLConnection80.connect();
			
			String sql = "SELECT gid, name_, content, regDate, clientIP, blind\r\n" + 
					"FROM guestbook\r\n" + 
					"ORDER BY gid DESC\r\n" +
					"LIMIT ?, ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pageStart);
			pstmt.setInt(2, pageCount);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String gid = rs.getString("gid");
				String name_ = rs.getString("name_");
				String content = rs.getString("content");
				
				//날짜 시간 같이 얻어오는 메소드
				Timestamp ts = rs.getTimestamp("regDate", Calendar.getInstance(Locale.getDefault()));
				String clientIP = rs.getString("clientIP");
				int blind = rs.getInt("blind");
				
				result.add(new Guestbook(gid, name_,content, ts, clientIP, blind));
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