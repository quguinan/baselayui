package com.cms.bean;

import java.util.ArrayList;
import java.util.List;


public class GridDataModel<T> {
	private int code;
	
	private String msg;
	
	// 显示的总数
	private int count;
	// 行数据
	private List<T> data = new ArrayList<T>();
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public List<T> getData() {
		return data;
	}
	public void setData(List<T> data) {
		this.data = data;
	}
	



}
