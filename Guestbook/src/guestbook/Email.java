package guestbook;


import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Email implements Comparable<Email> 
{
    @Id Long id;
	String email;

    private Email() {}

    public Email(String email)
    {
        this.email = email;
    }
  
    public String getEmail() 
    {
        return email;
    }

    @Override
    public int compareTo(Email other)
    {
        return this.email.compareTo(other.email);
    }
    
    @Override
    public boolean equals(Object other) 
    {
    	Email toCompare = (Email) other;
    	return this.email.equals(toCompare.email);
    }
    
    @Override
    public String toString()
    {
    	return email;
    }
}