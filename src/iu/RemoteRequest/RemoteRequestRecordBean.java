package iu.RemoteRequest;

public class RemoteRequestRecordBean {
	private String requestTime;
	private String transactionNumber;
	private String transactionTime;
	private String transactionStatus;
	private String reqGroupName;
	private String relatedStudyUID;

	public String getRequestTime() {
		return requestTime;
	}

	public void setRequestTime(String requestTime) {
		this.requestTime = requestTime;
	}

	public String getTransactionNumber() {
		return transactionNumber;
	}

	public void setTransactionNumber(String transactionNumber) {
		this.transactionNumber = transactionNumber;
	}

	public String getTransactionTime() {
		return transactionTime;
	}

	public void setTransactionTime(String transactionTime) {
		this.transactionTime = transactionTime;
	}

	public String getTransactionStatus() {
		return transactionStatus;
	}

	public void setTransactionStatus(String transactionStatus) {
		this.transactionStatus = transactionStatus;
	}

	public String getReqGroupName() {
		return reqGroupName;
	}

	public void setReqGroupName(String reqGroupName) {
		this.reqGroupName = reqGroupName;
	}

	public String getRelatedStudyUID() {
		return relatedStudyUID;
	}

	public void setRelatedStudyUID(String relatedStudyUID) {
		this.relatedStudyUID = relatedStudyUID;
	}

}
