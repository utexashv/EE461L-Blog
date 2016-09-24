<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.Guestbook" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>List of Blogs</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
	<%
	   String guestbookName = request.getParameter("guestbookName");
	   if (guestbookName == null) {
	       guestbookName = "default";
	   }
	   pageContext.setAttribute("guestbookName", guestbookName);
	   UserService userService = UserServiceFactory.getUserService();
	   User user = userService.getCurrentUser();  
	%>
	<h1>List of Blogs</h1>
	<p><a class="button" href="/listblogger.jsp">Show All Bloggers</a></p>	
	<p><a class="button" href="/blogpage.jsp">Home</a></p>
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
		for (Greeting Greeting : greetings) {
			pageContext.setAttribute("Greeting_content", Greeting.getContent());	       	
	  		pageContext.setAttribute("Greeting_user", Greeting.getUser());
	  		pageContext.setAttribute("Greeting_date", Greeting.formatDate());
	  		pageContext.setAttribute("Greeting_title", Greeting.getTitle());
	%>
			<div style="background-color: #033863; padding: 10px 20px 40px 20px">
				<h3><a style="color: orange; text-decoration: none;" href="/blog.jsp?user=${fn:escapeXml(Greeting_user)}&date=${fn:escapeXml(Greeting_date)}&title=${fn:escapeXml(Greeting_title)}">${fn:escapeXml(Greeting_title)}</a></h3>			
	   			<blockquote>${fn:escapeXml(Greeting_content)}</blockquote>
	   			by <b><a style="color: white; text-decoration: none;" href="/blogger.jsp?param=${fn:escapeXml(Greeting_user)}">${fn:escapeXml(Greeting_user)}</a></b></b>
	   			 on <b>${fn:escapeXml(Greeting_date)}</b>
	   		</div>
	   		<br/>
	<%
	   	}
	}
	%>
	
	<p><a class="button" href="/blogpage.jsp">Home</a></p>

</body>
</html>