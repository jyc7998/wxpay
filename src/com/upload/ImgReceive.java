package com.upload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sun.misc.BASE64Decoder;

public class ImgReceive extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public ImgReceive() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

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
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String originFile = "d:" + File.separator + "Resourse" + File.separator + "WXupload";
		File dir = new File(originFile);
		if(!dir.exists())
			dir.mkdir();	
/*		System.out.println("sdsd");*/
		response.setContentType("text/html");
		BASE64Decoder decoder = new BASE64Decoder();
		String imgStr = (String) request.getParameter("image");
/*		System.out.println(imgStr);*/
		imgStr = imgStr.replace(" ", "+");
		int index = imgStr.indexOf(",");
		imgStr = imgStr.substring(index + 1);
		byte[] image = decoder.decodeBuffer(imgStr);
		
		for (int i = 0; i < image.length; ++i) {
			if (image[i] < 0) {// �����쳣���
				image[i] += 256;
			}
		}
		// ���jpegͼƬ
		int hashName = imgStr.hashCode();
		try {
			String imgFilePath = originFile + File.separator + hashName + ".jpg";// ����ɵ�ͼƬ
			OutputStream img = new FileOutputStream(imgFilePath);
			img.write(image);
			img.flush();
			img.close();
			
	        response.setContentType("text/html;charset=UTF-8");
	        response.getWriter().write(Integer.toString(hashName));
		} catch (Exception e) {
			e.printStackTrace();
		}
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
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException
	 *             if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
