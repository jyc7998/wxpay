package iu.RemoteRequest;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.utils.Sha1Util;
import com.utils.StringUtil;

public class RemoteMainServlet extends HttpServlet {

	/**
	 * The doGet method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	// 网页授权获取用户信息
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 共账号及商户相关参数
		response.setContentType("text/html;charset=UTF-8");
		// response.setCharacterEncoding("UTF-8");
		String appid = "wx2075a7c5fa000226";
		String path = request.getContextPath();
		String basePath = request.getScheme() + "://" + request.getServerName() + path + "/";
		String backUri = basePath + "RemoteTopayServlet";
		String RelatedstudyUID = request.getParameter("RELATEDSTUDYUID");
		String RequestTime = request.getParameter("REQUESTTIME");
		String Groupname = request.getParameter("GROUPNAME");
		String serviceType = request.getParameter("SERVICETYPE");
		String ConsultPrice = request.getParameter("CONSULTPRICE");
		PrintWriter out = response.getWriter();
		if (StringUtil.isEmpty(RelatedstudyUID) || StringUtil.isEmpty(RequestTime) || StringUtil.isEmpty(Groupname) || StringUtil.isEmpty(serviceType)
				|| StringUtil.isEmpty(ConsultPrice)) {
			out.println("<script  language='JavaScript'>alert('所选内容错误，请更换');window.location.href='Remoteindex.jsp';</script>");
		} else if (ConsultPrice.equals("0.00")) {
			out.println("<script  language='JavaScript'>alert('会诊金额为空，请更换');window.location.href='Remoteindex.jsp';</script>");
		} else {

			HttpSession session = request.getSession();

			session.setAttribute("RELATEDSTUDYUID", RelatedstudyUID);
			session.setAttribute("REQUESTTIME", RequestTime);
			session.setAttribute("GROUPNAME", Groupname);
			session.setAttribute("SERVICETYPE", serviceType);

			/*
			 * double price1=0,price2=0,price3=0,price4=0; for (int i = 0; i <
			 * wxpaynum.length; i++) {
			 * 
			 * if(wxpaynum[i].equals("1")){ price1=0.01; }else
			 * if(wxpaynum[i].equals("2")){ price2=0.01; }else
			 * if(wxpaynum[i].equals("3")){ price3=0.01; }else
			 * if(wxpaynum[i].equals("4")){ price4=0.01; } } double
			 * totalmoney=price1+price2+price3+price4; String totalmoneys=
			 * Double.toString(totalmoney);
			 */
			session.setAttribute("totalmoneys", ConsultPrice);
			// 授权后要跳转的链接所需的参数一般有会员号，金额，订单号之类，
			// 最好自己带上一个加密字符串将金额加上一个自定义的key用MD5签名或者自己写的签名,
			// 比如 Sign = %3D%2F%CS%
			String orderNo = appid + Sha1Util.getTimeStamp();
			session.setAttribute("ORDERNO", orderNo);
			backUri = backUri + "?userId=b88001&orderNo=" + orderNo + "&describe=test&money=" + ConsultPrice;
			// URLEncoder.encode 后可以在backUri 的url里面获取传递的所有参数
			backUri = URLEncoder.encode(backUri);
			// scope 参数视各自需求而定，这里用scope=snsapi_base
			// 不弹出授权页面直接授权目的只获取统一支付接口的openid
			String url = "https://open.weixin.qq.com/connect/oauth2/authorize?" + "appid=" + appid + "&redirect_uri=" + backUri
					+ "&response_type=code&scope=snsapi_userinfo&state=123#wechat_redirect";
			response.sendRedirect(url);
		}
		out.close();
	}

	/**
	 * The doPost method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to
	 * post.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
