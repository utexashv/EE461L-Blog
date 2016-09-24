<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="guestbook.SubscribeServlet" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.Email" %>
<%@ page import="guestbook.Guestbook" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<title>Longhorn Blog</title>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>

	<body>
		<%
		String blogName = request.getParameter("blogName");
	    if (blogName == null) {
	    	blogName = "default";
	    }
	    pageContext.setAttribute("blogName", blogName);
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();  
		%>	
		    
	    <div>
	    	<h1>Welcome to Longhorn Blog!</h1>
		    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Texas_Longhorn_logo.svg/2000px-Texas_Longhorn_logo.svg.png"
	    		style="width:400px; height:200px;">
	    </div>
	    
		<%
	    if (user != null) 
	    {
	    	pageContext.setAttribute("user", user);
	    	
	        String email_str = user.getEmail(); 
	        ObjectifyService.register(Email.class);
	        List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
		%>	
			<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
				<a class="button" href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>	
			<p><a class="button" href="/createblog.jsp">Create a Blog</a></p>	
			<form action="/subscribe" method="post">
			<%
			        if(!emails.contains(new Email(email_str))) {
			%>
			            <div><input class="btn" type="submit" value="Subscribe"/></div>
			<%
			        } else {
			%>
			            <div><input class="btn" type="submit" value="Unsubscribe"/></div>
			<%
			        }
			%>
			        </form>
		<%
		} 
	    else {
		%>
			<p>Hello!
			<a class="button" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to post blogs.</p>
		<%
		}
		%>
		<p><a class="button" href="/listblog.jsp">Show All Blog Posts</a></p>
		<%
		// interact with Objectify  
		ObjectifyService.register(Greeting.class);
  		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
   		Collections.sort(greetings);
		Collections.reverse(greetings);
		if (greetings.isEmpty()) {
		%>
			<h3>There are no blogs yet. :(</h3>
		<%
		} else {
		%>
			<h3>Blog(s)</h3>
		<%
			ListIterator<Greeting> pt = greetings.listIterator();
			for (int i = 0; i < 5; i+=1) {
				if(pt.hasNext()){
					Greeting Greeting = pt.next();
					pageContext.setAttribute("Greeting_user", Greeting.getUser());
		            pageContext.setAttribute("Greeting_title", Greeting.getTitle());
		            pageContext.setAttribute("Greeting_content", Greeting.getContent());
		            pageContext.setAttribute("Greeting_date", Greeting.formatDate());
		            
			%>
				<div style="background-color: #033863; padding: 10px 20px 40px 20px">
					<h3><a style="color: orange; text-decoration: none;" href="/blog.jsp?user=${fn:escapeXml(Greeting_user)}&date=${fn:escapeXml(Greeting_date)}&title=${fn:escapeXml(Greeting_title)}">${fn:escapeXml(Greeting_title)}</a></h3>			
		   			<blockquote>${fn:escapeXml(Greeting_content)}</blockquote>
		   			by <b><a style="color: white; text-decoration: none;" href="/blogger.jsp?param=${fn:escapeXml(Greeting_user)}">${fn:escapeXml(Greeting_user)}</a></b>
		   			 on <b>${fn:escapeXml(Greeting_date)}</b>
		   		</div>
	   			<br/>
			<%
				}
			}
		}
		%>
		<p><a class="button" href="/listblog.jsp">Show All Blog Posts</a></p>

	</body>
</html>

 