package com.util;

import java.util.Random;

public class Util {

	/* ���� ������ public �޼ҵ� ���� */
	public static String toBin(int a) {
		String result = "";
		while (a != 0) {
			int b = a % 2;
			a = a / 2;
			result = b + result;
		}
		return result;
	}
	
	//�����̸� ���� ���� �޼ҵ�
	public static String randomFileName() {
		String[] arr = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
	    Random r = new Random();
	    StringBuilder rndStr = new StringBuilder();
	    rndStr.append("img_");
	    for(int i = 0; i < 20; ++i){
	    	rndStr.append(arr[r.nextInt(arr.length)]);
	    }
	    return rndStr.toString();
	}
	
}
