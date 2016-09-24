package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.*;

import javax.mail.Message;
import javax.mail.internet.InternetAddress;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.Date;
import java.util.Calendar;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import guestbook.Email;

@SuppressWarnings("serial")
public class CronServlet extends HttpServlet 
{
	
	static
	{
		ObjectifyService.register(Greeting.class);
        ObjectifyService.register(Email.class);
    }
	
private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());

public void doGet(HttpServletRequest req, HttpServletResponse resp)throws IOException
{
	
	SendEmail sender = new SendEmail();
	try 
	{
		List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
		if (emails.size() != 0)
		{
			
			String[] addresses = new String[emails.size()];
			for(int i = 0; i < emails.size(); i++) 
			{
				addresses[i] = emails.get(i).toString();
			}
			
			List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
	        
	        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("US/Central"));
	        cal.add(Calendar.DAY_OF_YEAR, -1);
	        Date date = cal.getTime();
		
			for (Greeting greeting : greetings)
			{
				if (date.before(greeting.getDate()))
				{
					sender.send(addresses);
					_logger.info("Email has been sent");
					break;
				}
			}
			
		}

		_logger.info("Cron Job has been executed");
	}
	catch (Exception ex) 
	{
		_logger.info("Exception: " + ex);
	}
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException 
	{
		doGet(req, resp);
	}
}
