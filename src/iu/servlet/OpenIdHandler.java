package iu.servlet;

import iu.utils.WeixinUtil;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class OpenIdHandler
 */

public class OpenIdHandler extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OpenIdHandler() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String code = request.getParameter("code");
		String fromUrl = request.getParameter("fromUrl");
		if (code != null && !code.isEmpty()) {
			// 获取code码，以获取openid和access_token
			try {
				String openid = WeixinUtil.getOpenId(code);
				if (openid != null && !openid.isEmpty()) {
					request.getSession().setAttribute("openid", openid);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		response.sendRedirect(fromUrl);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}