package iu.dbc;
import java.sql.* ;

public class DatabaseConnection {
	private static final String DBDRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
 	private static final String DBURL = "jdbc:sqlserver://114.215.236.179:1433;DatabaseName=pacsdb" ;
	private static final String DBUSER = "pacs" ;
	private static final String DBPASSWORD = "Lab114114" ;
	private Connection conn = null ;
	public DatabaseConnection() throws Exception{
		try{
			Class.forName(DBDRIVER) ;
			this.conn = DriverManager.getConnection(DBURL,DBUSER,DBPASSWORD) ;
		}catch(Exception e){
			throw e ;
		}
	}
	public Connection getConnection(){
		return this.conn ;
	}
	public void close() throws Exception{
		if(this.conn != null){
			try{
				this.conn.close() ;
			}catch(Exception e){
				throw e ;
			}
		}
	}
}
