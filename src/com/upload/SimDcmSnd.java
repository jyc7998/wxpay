package com.upload;

import java.io.File;

import org.apache.log4j.Logger;
//import org.dcm4che2.tool.dcmsnd.DcmSnd;

public class SimDcmSnd {
	// Initialize Logger

	private String path;
	private String serverName;

	// Constructor
	public SimDcmSnd(String path, String serverName) {
		this.path = path;
		this.serverName = serverName;
	}

	public void sndDcm() throws Exception {
		try {

				// Get calling aet
				// String dcmURL[] = new String[2];
				// dcmURL[0] = "DICOM://" + server.getAetitle() + ":" +
				// callingAET + "@" + server.getHostname() + ":" +
				// server.getPort();
				// dcmURL[1] = callingAET;
				String[] scuArgs = {
						"DCM4CHEE" + "@" + "210.45.74.77:11112", this.path };
				DcmSnd.main(scuArgs);
											
				//System.out.print("wozhengzaishanchuo");

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
//			File file = new File(this.path);
//			if (file.exists()) {
//				deleteFile(file);
				
//			}
		}

	}

	public void delete(){
		File file = new File(this.path);
		if (file.exists()) {
			deleteFile(file);		
		}
	}
	private void deleteFile(File file) {
		if (file.isDirectory()) {
			File[] files = file.listFiles();
			for (int i = 0; i < files.length; i++) {
				deleteFile(files[i]);
			}
		}
		file.delete();
	}
}