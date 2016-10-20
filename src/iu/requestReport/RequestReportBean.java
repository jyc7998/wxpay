package iu.requestReport;

import javax.servlet.http.HttpServlet;

public class RequestReportBean extends HttpServlet {
	private String sourceUnit;
	private String AccessNumber;
	private String requestTime;
	private String hasProcessed;
	private String processedTime;
	private String relatedStudyUID;
	private boolean IsAvailable;
	
	public String getRelatedStudyUID() {
		return relatedStudyUID;
	}

	public void setRelatedStudyUID(String relatedStudyUID) {
		this.relatedStudyUID = relatedStudyUID;
	}

	public String getSourceUnit() {
		return sourceUnit;
	}

	public void setSourceUnit(String sourceUnit) {
		this.sourceUnit = sourceUnit;
	}

	public String getAccessNumber() {
		return AccessNumber;
	}

	public void setAccessNumber(String accessNumber) {
		AccessNumber = accessNumber;
	}

	public String getRequestTime() {
		return requestTime;
	}

	public void setRequestTime(String requestTime) {
		this.requestTime = requestTime;
	}

	public String getHasProcessed() {
		return hasProcessed;
	}

	public void setHasProcessed(String hasProcessed) {
		this.hasProcessed = hasProcessed;
	}

	public String getProcessedTime() {
		return processedTime;
	}

	public void setProcessedTime(String processedTime) {
		this.processedTime = processedTime;
	}

	public boolean getIsAvailable() {
		return IsAvailable;
	}

	public void setIsAvailable(boolean isAvailable) {
		this.IsAvailable = isAvailable;
	}

}
