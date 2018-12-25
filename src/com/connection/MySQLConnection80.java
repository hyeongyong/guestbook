package com.connection;

import java.sql.*;

//�����ͺ��̽�(MySQL v8.0) ���� ���� ����� Ŭ����
public class MySQLConnection80 {

	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://192.168.0.11:3306/yong?user=yong&password=1234&useSSL=false&serverTimezone=UTC";

	private static Connection conn;

	// �����ͺ��̽� Ŀ�ؼ� ��ü ���� �޼ҵ�
	public static Connection connect() throws ClassNotFoundException, SQLException {

		// STEP 2: Register JDBC driver
		Class.forName(JDBC_DRIVER);
		// STEP 3: Open a connection
		conn = DriverManager.getConnection(DB_URL);

		return conn;
	}

	// �����׺��̽� Ŀ�ؼ� ��ü �Ҹ� �޼ҵ�
	public static void close() throws SQLException {
		if (conn != null) {
			conn.close();
		}
	}

}
