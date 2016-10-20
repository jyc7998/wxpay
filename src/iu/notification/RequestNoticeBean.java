package iu.notification;

public class RequestNoticeBean {
	private String sourceUnit;
	private String AccessNumber;
	private String requestTime;
	private String hasProcessed;
	private String processedTime;
	private String RequestImagConsult;
	private String NoticeReqUID;

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
	public String getRequestImagConsult() {
		return RequestImagConsult;
	}

	public void setRequestImagConsult(String RequestImagConsult) {
		this.RequestImagConsult = RequestImagConsult;
	}
	public String getNoticeReqUID() {
		return NoticeReqUID;
	}

	public void setNoticeReqUID(String NoticeReqUID) {
		this.NoticeReqUID = NoticeReqUID;
	}

}
