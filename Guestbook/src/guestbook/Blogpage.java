package guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;
import java.util.Date;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class Blogpage extends HttpServlet 
{
	
	static 
	{
        ObjectifyService.register(Greeting.class);
    }
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException 
	{
		
		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        Greeting Greeting = new Greeting(user, title, content);
        ofy().save().entity(Greeting).now(); 
        
        resp.sendRedirect("/blogpage.jsp");
    }
}