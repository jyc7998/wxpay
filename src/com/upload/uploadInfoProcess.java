package com.upload;


import iu.dbc.DatabaseConnection;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.dcm4che2.util.UIDUtils;

import com.convert2dcm.Jpg2DcmSimple;

import sun.misc.BASE64Decoder;

public class uploadInfoProcess extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public uploadInfoProcess() {
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
		
		String imgNum = request.getParameter("imageNum");
		String phrUID = request.getParameter("uid");
		String Type = "TEST" + request.getParameter("imageType");
		
		String imgPath = originFile + File.separator + imgNum + ".jpg";
		String dcmPath = originFile + File.separator + imgNum + ".dcm";
		
		File imgFile = new File(imgPath);
		File dcmFile = new File(dcmPath);
		if(!imgFile.exists())
			System.out.println("文件不存在");
		
		UIDUtils uidGenerator = new UIDUtils();
/*		String objectuid = uidGenerator.createUID();*/
		String StudyUID = uidGenerator.createUID();
		
    	Jpg2DcmSimple jpg2Dcm = new Jpg2DcmSimple();
    	jpg2Dcm.setDcmCfg(phrUID, StudyUID, Type);
    	jpg2Dcm.convert(imgFile, dcmFile);
    	   	
    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");//可以方便地修改日期格式 
		String uploadtime= dateFormat.format(new Date());
    	
		SimDcmSnd snd = new SimDcmSnd(dcmPath, "");
		try {
			snd.sndDcm();
			DatabaseConnection dbc = null;
		 	Connection conn = null;
		 	PreparedStatement ps = null;
		 	ResultSet rs = null;
		 	try {
		 		dbc = new DatabaseConnection();
		 		conn = dbc.getConnection();
		 		String sql = "INSERT INTO IU_PhrOwnerPicData (PhrOwnerUID, PicStudyUID, PicDataKind, UploadTime) VALUES (?, ?, ?, ?)";
		 		
		 		ps = conn.prepareStatement(sql);
		 		ps.setString(1, phrUID);
		 		ps.setString(2, StudyUID);
		 		ps.setString(3, Type);
		 		ps.setString(4, uploadtime);
		 		ps.executeUpdate();

		 		//System.out.print(archives);
		 		conn.close();
		 	} catch (Exception e) {
		 		e.printStackTrace();
		 	}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		snd.delete();
		fileDelete(imgFile, dcmFile);
	}
	
	void fileDelete(File...files) {
	    for (File file : files) {
			if(file.exists())
				file.delete();
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
