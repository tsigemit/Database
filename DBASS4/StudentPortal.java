package JDBC;
/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */
import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.
public class StudentPortal {
	 /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tsigabu";
   static final String PASSWORD = "1234";
    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }
    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
	public static void main(String[] args) throws Exception {
		 try {
	            Class.forName("org.postgresql.Driver");
	            String url = "jdbc:postgresql://127.0.0.1:5432/University";
	            Properties props = new Properties();
	            BufferedReader pass= new BufferedReader(new InputStreamReader(System.in));
	            //System.out.print("Enter you database password ");
                //String PASSWORD = pass.readLine();
	            props.setProperty("user",USERNAME);
	            props.setProperty("password", PASSWORD);
	            Connection  conn = DriverManager.getConnection(url, props);
	             System.out.print("Enter Student Identification Number");
	             Scanner in = new Scanner(System.in);
	             long student=in.nextLong();
	             //student = args[0]; // This is the identifier for the student.
	            //Console console = System.console();
		    //In Eclipse. System.console() returns null due to a bug (https://bugs.eclipse.org/bugs/show_bug.cgi?id=122429)
		    // In that case, use the following line instead:
		   
	            usage();
	            System.out.println("Welcome!");
	            while(true) {
		          System.out.print("? >");
					                String mode = pass.readLine();
					                String[] cmd = mode.split(" +");
					                cmd[0] = cmd[0].toLowerCase();
	                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
			                    /* Information mode */
			                    getInformation(conn, student);
	                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
			                    /* Register student mode */
			                    registerStudent(conn, student, cmd[1]);
	                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
			                    /* Unregister student mode */
			                    unregisterStudent(conn, student, cmd[1]);
	                } else if ("quit".startsWith(cmd[0])) {
	                			break;
	                } else usage();
	            }
	            System.out.println("Goodbye!");
	            			conn.close();
	        } catch (SQLException e) {
				            System.err.println(e);
				            System.exit(2);
	        }
	}
	 /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, Number student) throws SQLException
    {  //Statement stmt=conn.createStatement();
          String SQL=("SELECT distinct student,  branch, program, name from StudentsFollowing NATURAL JOIN Student WHERE ssn=student AND student=?"); 
          PreparedStatement pstmt = conn.prepareStatement(SQL);  
          pstmt.setLong(1, (long) student);
          ResultSet rs = pstmt.executeQuery();
          System.out.println();
          System.out.println("Information for student "+student);
          System.out.println("----------------------------------------------");
  while(rs.next()) {
	        String branch=rs.getString("branch");
            System.out.println("Name: "+rs.getString("name"));
            System.out.println("Student ID: "+student);
            System.out.println("Program: "+rs.getString("program"));
            if(branch==null)
            System.out.println("Branch: None");
            else
          	System.out.println("Branch:"+rs.getString("branch"));
    }
            String SQL1=("SELECT student, name, course, credits, grade FROM Course NATURAL JOIN Taken WHERE code=course AND Taken.student=?"); 
            PreparedStatement pstmt1 = conn.prepareStatement(SQL1);  
            pstmt1.setLong(1, (long) student);
            ResultSet rs1 = pstmt1.executeQuery();
            System.out.println();
            System.out.println("Read courses  (name (code),  credits:  grade):");
            System.out.println("---------------------------------------------------------------");
    while(rs1.next()) {
           System.out.println(rs1.getString("name")+"  ("+rs1.getString("course")+"),  "+rs1.getString("credits")+"p:  "+rs1.getString("grade"));
      }
            String SQL2=("SELECT student, name, course, status, place  from RegisteredAndWaiting NATURAL JOIN Course WHERE code=course AND student=?"); 
            PreparedStatement pstmt2 = conn.prepareStatement(SQL2);  
            pstmt2.setLong(1, (long) student);
            ResultSet rs2= pstmt2.executeQuery();
            System.out.println();
            System.out.println("Registered courses (name (code): status):");
            System.out.println("-----------------------------------------------------------");
   while(rs2.next()) {
	       String status=rs2.getString("place");
	      if(status ==null)
		        System.out.println(rs2.getString("name")+"  ("+rs2.getString("course")+"),  "+rs2.getString("status"));     
	      else
		      System.out.println(rs2.getString("name")+"  ("+rs2.getString("course")+"),  "+rs2.getString("status")+" as position:  "+rs2.getString("place"));
     }
	   		String SQL3=("SELECT  student, seminarCourses, mathCredits,researchCredits,totalCredits,status  FROM pathToGraduation WHERE student=?"); 
	   		PreparedStatement pstmt3 = conn.prepareStatement(SQL3);  
	        pstmt3.setLong(1, (long) student);
	   		ResultSet rs3= pstmt3.executeQuery();
	    	System.out.println();
	   	    System.out.println("-----------------------------------------------------------");
while(rs3.next()) {
		  boolean status= rs3.getBoolean("status");  
		  System.out.println("Seminar courses taken: "+rs3.getString("seminarCourses")); 
		  System.out.println(" Math credits taken: "+rs3.getString("mathCredits")); 
		  System.out.println(" Research credits taken: "+rs3.getString("researchCredits")); 
		  System.out.println("Total credits taken:"+rs3.getString("totalCredits")); 
  if(status==true)
	  System.out.println("Fulfills the requirements for graduation: Yes"); 
  else
	  System.out.println("Fulfills the requirements for graduation: No"); 
    }
	       System.out.println("-----------------------------------------------------------");     
	      System.out.println();
	      System.out.println("Please choose a mode of operation:");
    }
    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, long student, String course)
    throws SQLException
    {
  	//If the student has already passed this course before
    	String SQL=("SELECT distinct student,  course FROM PassedCourses WHERE student=? AND course=?"); 
        PreparedStatement pstmt = conn.prepareStatement(SQL);  
        pstmt.setLong(1,  student);
        pstmt.setString(2, course);
        ResultSet rs = pstmt.executeQuery();
        while(rs.next()) {
        	 long studentResult=rs.getLong(1);
        if(studentResult==student && rs.getString(2).equals(course))
        {
	        System.out.println("Student has already passed the course \t"+rs.getString("course"));  
        }
       return;
        }
           //If the student is already registered to the course
	    	SQL=("SELECT distinct  student, course FROM Registrations WHERE student=? AND course=? AND status='registered' "); 
	        pstmt = conn.prepareStatement(SQL); 
	        pstmt.setLong(1, student);
	        pstmt.setString(2, course);
	        rs = pstmt.executeQuery();
         while(rs.next())
         {
        	  long studentResult=rs.getLong(1);
        	  if(studentResult==student && rs.getString(2).equals(course))
         {
             System.out.println("Student is already registered to the course\t"+rs.getString("course")); 
         }
         return;
         }
         //If the student has not taken all prerequisite courses    	
	         SQL=("SELECT  prerequisite from Prerequisite where course=? group by prerequisite having prerequisite NOT IN (SELECT course from PassedCourses where student=?) "); 
	         pstmt = conn.prepareStatement(SQL); 
	         pstmt.setString(1,  course);
	        pstmt.setLong(2, student);
	         rs = pstmt.executeQuery();
          while(rs.next())
          {
	         System.out.println("Student has not taken all prerequisites for the course");
	          return;
          }
          //If the student is already in the WaitingList generate error
	         SQL=("SELECT student FROM WaitingList WHERE student=? AND course=?"); 
	         pstmt = conn.prepareStatement(SQL); 
	         pstmt.setLong(1, student);
	         pstmt.setString(2,  course);
	         rs = pstmt.executeQuery();
       while(rs.next())
       {
	      System.out.println("The student is already in a waitinList for this course"); 
       return;
       }
         //If the course is full, add student and course to waiting list
	         SQL=("SELECT course FROM fullCourses WHERE course =?"); 
	         pstmt = conn.prepareStatement(SQL); 
	         pstmt.setString(1, course);
	         rs = pstmt.executeQuery();
          while(rs.next())
          {
          PreparedStatement myPstmt =conn.prepareStatement( "INSERT INTO Registrations (student, course) VALUES (?,?)");
		   myPstmt.setLong(1, (long) student);
		   myPstmt.setString(2, course);
	   	  myPstmt.executeUpdate();
	      System.out.println("This course is full, student has been added to waiting list"); 
          return;
          }
               PreparedStatement myPstmt =conn.prepareStatement( "INSERT INTO Registrations (student, course) VALUES (?,?)");
    		   myPstmt.setLong(1, (long) student);
    		   myPstmt.setString(2, course);
    	   	  int count=myPstmt.executeUpdate();
    		  if(count==0)
    		  System.out.println("Registration is successful");
    	//conn.createStatement().executeUpdate("INSERT INTO Registrations  values (student, course)");
    }
    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, long  student, String course)
    throws SQLException
    {
	    	 String SQL=("SELECT distinct  student, course FROM Registrations WHERE student=? AND course=? AND status='registered' "); 
	    	 PreparedStatement  pstmt = conn.prepareStatement(SQL); 
	          pstmt.setLong(1, student);
	          pstmt.setString(2, course);
	          ResultSet rs = pstmt.executeQuery();
          while(rs.next())
           {
          	  long studentResult=rs.getLong(1);
          	  if((studentResult==student && rs.getString(2).equals(course)))
          	  {
          		SQL=("DELETE  FROM Registrations WHERE student =? AND course=?"); 
                pstmt = conn.prepareStatement(SQL);  
                pstmt.setLong(1,  student);
             	pstmt.setString(2, course);
                pstmt.executeUpdate();
                System.out.println("Unregistered Successfully"); 
                return;
          	  }          
           }
               SQL=("SELECT  student, course  FROM WaitingList WHERE student=? AND course=? "); 
	    	  pstmt = conn.prepareStatement(SQL); 
	          pstmt.setLong(1, student);
	          pstmt.setString(2, course);
	           rs = pstmt.executeQuery();
	          while(rs.next())
	           {
	          	  long studentResult=rs.getLong(1);
	          	  if((studentResult==student && rs.getString(2).equals(course)))
	          	  {
	          	SQL=("DELETE  FROM Registrations WHERE student =? AND course=?"); 
	                pstmt = conn.prepareStatement(SQL);  
	                pstmt.setLong(1,  student);
	             	pstmt.setString(2, course);
	                pstmt.executeUpdate();
	                System.out.println("Deleted Successfully from WaitingList"); 
	                return;
	          	  }   
	           }
          System.out.println("You are not in registration databse"); 
    }
}
