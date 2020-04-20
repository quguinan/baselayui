package com.cms.controller.sys;




import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.cms.form.SysMenuForm;
import com.cms.model.sys.SysUser;
import com.cms.model.sys.SysUserMenuRoleV;

import my.dao.pool.DBManager;
import my.util.MD5Util;
import my.web.AjaxMsg;
import my.web.BaseController;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/cms")
public class HomeController  extends BaseController {
	
	@RequestMapping("/desktop")
	public String desktop() {
		return "cms/desktop";
	}
	
	
	@RequestMapping("/home")
	public String home(Model m,HttpSession session) {
		//当前登录用户
		SysUser user=(SysUser) session.getAttribute("user");
		JSONArray ja1=new JSONArray();
		/*一级菜单*/
		List<SysUserMenuRoleV> level1s=SysUserMenuRoleV.INSTANCE.query(" userid=? and  pid ='' order by id ", user.getUserid());
		for (SysUserMenuRoleV sysUserMenuRoleV : level1s) {
			JSONObject jo2=new JSONObject();
			jo2=JSONObject.fromObject(sysUserMenuRoleV);
			List<SysUserMenuRoleV> level2s=SysUserMenuRoleV.INSTANCE.query(" userid=? and  pid=? order by id ", user.getUserid(),sysUserMenuRoleV.getId());
			/*二 菜单*/
			if(level2s.size()>0){
				jo2.put("children", JSONArray.fromObject(level2s));
			}
			ja1.add(jo2);
		}
		m.addAttribute("user", user);
		m.addAttribute("m1", ja1);
		return "cms/home";
	}
	

	/**
	 * 修改个人密码
	 * @param session
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/home/modifypassword")
	public JSONObject modifypassword(HttpSession session) {
		String oldpassword=param("oldpassword","");
		String newpassword=param("newpassword","");
		String newpassword2=param("newpassword2","");
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		//当前登录用户
		SysUser user=(SysUser) session.getAttribute("user");
		
		if (!newpassword.equals(newpassword2)) {
			result.put("success", false);
			result.put("msg","两次密码输入不一致!");
			return JSONObject.fromObject(result);
		}else if (!user.getPassword().equals(MD5Util.string2MD5(oldpassword))) {
			result.put("success", false);
			result.put("msg","旧密码输入错误!");
			return JSONObject.fromObject(result);
		}else{
			user.updateField("password", MD5Util.string2MD5(newpassword));// 加密
		}
		
		DBManager.commitAll();
		result.put("success", true);
		result.put("msg","修改密码成功!");
		return JSONObject.fromObject(result);
	}
	/**
	 * 检查密码是否过于简单
	 * @param session
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/home/validpassword")
	public JSONObject validpassword(HttpSession session) {
		HashMap<String, Object> result = new HashMap<String, Object>();
		//当前登录用户
		SysUser user=(SysUser) session.getAttribute("user");
		if (user.getPassword().equals(MD5Util.string2MD5("123"))) {
			result.put("success", true);
			result.put("msg","请修改当前初始密码!");
		} else {
			result.put("success",false);
			result.put("msg","none");
		}
		return JSONObject.fromObject(result);
	}
}
