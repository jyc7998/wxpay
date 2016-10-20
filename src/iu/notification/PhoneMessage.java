package iu.notification;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.taobao.api.ApiException;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

public class PhoneMessage extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
		
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String code="123456";
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String tel = request.getParameter("telnum");
		TaobaoClient client=new DefaultTaobaoClient("http://gw.api.taobao.com/router/rest","23287356","dd601d8a7b8abc42e9e70dde5cdedcfb","json",300000,300000);
		AlibabaAliqinFcSmsNumSendRequest req= new AlibabaAliqinFcSmsNumSendRequest();
		req.setExtend("123456");
		req.setSmsType("normal");
		req.setSmsFreeSignName("影联科技");
		req.setSmsParamString("{\"code\":'"+code+"',\"name\":\"影联科技\"}");
		req.setRecNum(tel);
		req.setSmsTemplateCode("SMS_3735001");//  SMS_5380523
		AlibabaAliqinFcSmsNumSendResponse rsp;
		try {
			rsp = client.execute(req);
			System.out.println(rsp.getBody());
			out.print(rsp.getBody());
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//out.print(rsp.getBody());
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
