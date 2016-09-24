
package guestbook;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.TimeZone;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Greeting implements Comparable<Greeting> {
    @Id Long id;
    User user;
    String title;
    String content;
    Date date;

    private Greeting() {}

    public Greeting(User user, String title, String content) 
    {
        this.user = user;
        this.title = title;
        this.content = content;
        date = Calendar.getInstance(TimeZone.getTimeZone("US/Central")).getTime();
    }

    public User getUser() 
    {
        return user;
    }

    public Date getDate() 
    {
    	return date;
    }
    
    public String getTitle()
    {
        return title;
    }
    
    public String userToString()
    {
    	return user.toString();
    }
    
    public String getContent() 
    {
    	return content;
    }

    @Override
    public int compareTo(Greeting other) 
    {
        if (date.after(other.date))
        {
            return 1;
        }
        else if (date.before(other.date)) 
        {
            return -1;
        }
        return 0;
    }
    
    public String formatDate()
    {
    	SimpleDateFormat temp = new SimpleDateFormat("MMM dd, yyyy @ HH:mm");
    	temp.setTimeZone(TimeZone.getTimeZone("US/Central"));
    	return temp.format(date);
    }
}