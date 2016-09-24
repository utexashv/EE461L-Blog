package guestbook;

import java.util.*;
import java.util.logging.Logger;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

import com.googlecode.objectify.ObjectifyService;

public class SendEmail
{
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
      // Sender's email 
      String from = "ozuki01@gmail.com";
      String host = "localhost";
      Properties properties = System.getProperties();
      public void send(String[] addresses_str){
	      properties.setProperty("mail.smtp.host", host);
	      Session session = Session.getDefaultInstance(properties);
	
	      try
	      {
	    	  Address[] addresses = new Address[addresses_str.length];
		      for(int i = 0; i < addresses_str.length; i++){
		    	  _logger.info("Address: " + addresses_str[i]);
		    	  addresses[i] = new InternetAddress(addresses_str[i]);
		      }
	         // Create a default MimeMessage object.
	         MimeMessage message = new MimeMessage(session);
	         message.setFrom(new InternetAddress(from));
	         message.addRecipients(Message.RecipientType.BCC, addresses);
	         message.setSubject("Longhorn 5pm activity log");
	
	         StringBuffer emailMessage = new StringBuffer("This is all the new posts in the past 24 hours:\n");
	         
	         
	         List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
	         Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("US/Central"));
	         
	         cal.add(Calendar.DAY_OF_YEAR, -1);
	         Date date = cal.getTime();
	 		
	         for(Greeting greeting: greetings){
	        	 if (date.before(greeting.getDate()))
	        	 {
	        		 emailMessage.append("<br/>");
	        		 emailMessage.append("Title: ");
	        		 emailMessage.append(greeting.getTitle());
	        		 emailMessage.append("<br/>");
	        		 emailMessage.append("Author: ");
	        		 emailMessage.append(greeting.getUser());
	        		 emailMessage.append("<br/>");
	        		 emailMessage.append(greeting.getContent());
	        		 emailMessage.append("<br/>");
	        		 emailMessage.append("<br/>");
	        		 emailMessage.append("<br/>");
	        	 }
	         }
	         message.setText(emailMessage.toString(), "CHARSET_UTF_8", "html");
	         

	         // Send message
	         Transport.send(message);
	         System.out.println("Message has been sent.");
	      }
	      catch (MessagingException mex) 
	      {
	         mex.printStackTrace();
	      }
      }
      
      
}