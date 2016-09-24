package guestbook;


import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import guestbook.Email;

@SuppressWarnings("serial")
public class SubscribeServlet extends HttpServlet 
{
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
	
	static 
	{
        ObjectifyService.register(Email.class);
    }
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException 
	{
        
		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
        Email email = new Email(user.getEmail());
        
        List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
        
        if(!emails.contains(email)) 
        {
        	ofy().save().entity(email).now();   
        	_logger.info("Email added: " + email.toString());
        }
        else 
        {
        	ofy().delete().entity(emails.get(emails.indexOf(email))).now();
        	_logger.info("Email removed: " + email.toString());
        }
        
        resp.sendRedirect("/blogpage.jsp");
    }
}