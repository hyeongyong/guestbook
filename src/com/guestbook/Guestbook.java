package com.guestbook;

import java.sql.*;



public class Guestbook {

	private String gid, name_, pw, content, clientIP;
	private Date regDate;
	private int blind;
	private Timestamp ts;
	
	//일반 사용자용
	public Guestbook(String gid, String name_, String content, Date regDate) {
		super();
		this.gid = gid;
		this.name_ = name_;
		this.content = content;
		this.regDate = regDate;
	}
	
	
	//관리자용
	public Guestbook(String gid, String name_, String content, Timestamp ts, String clientIP, int blind) {
		this.gid = gid;
		this.name_ = name_;
		this.content = content;
		this.ts = ts;
		this.clientIP = clientIP;
		this.blind = blind;
	}

	
	//게시물 입력용
	public Guestbook(String name_, String pw, String content, String clientIP) {
		this.name_ = name_;
		this.pw = pw;
		this.content = content;
		this.clientIP = clientIP;
	}
	

	public String getGid() {
		return gid;
	}



	public void setGid(String gid) {
		this.gid = gid;
	}

	public String getName_() {
		return name_;
	}

	public void setName_(String name_) {
		this.name_ = name_;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getClientIP() {
		return clientIP;
	}

	public void setClientIP(String clientIP) {
		this.clientIP = clientIP;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public int getBlind() {
		return blind;
	}

	public void setBlind(int blind) {
		this.blind = blind;
	}


	public Timestamp getTs() {
		return ts;
	}


	public void setTs(Timestamp ts) {
		this.ts = ts;
	}

	
	
	
	
}
