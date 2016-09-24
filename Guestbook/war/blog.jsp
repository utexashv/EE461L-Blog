<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="guestbook.Guestbook" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Blog</title>
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
	   
	   String person = request.getParameter("user");
	   String date = request.getParameter("date");
	   String title = request.getParameter("title");
	   pageContext.setAttribute("Greeting_user", person);
	   pageContext.setAttribute("Greeting_date", date);
	   pageContext.setAttribute("Greeting_title", title);
	%>
	<h1>Blog by ${fn:escapeXml(Greeting_user)}</h1><br/>
	<p><a class="button" href="/blogger.jsp?param=${fn:escapeXml(Greeting_user)}">${fn:escapeXml(Greeting_user)}'s Other Posts</a></p>
	<%	
	// interact with Objectify  
    ObjectifyService.register(Greeting.class);
    List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    Collections.sort(greetings);
    Collections.reverse(greetings);
	%>
<%
	for (Greeting greeting : greetings) {
		if(greeting.getUser()!=null){
			String author = greeting.userToString();
			String time = greeting.formatDate();
			String tit = greeting.getTitle();
			if(author.equals(person) && time.equals(date) && tit.equals(title)){
				pageContext.setAttribute("Greeting_content", greeting.getContent());
				%>
				<div style="background-color: #033863; padding: 10px 20px 40px 20px">
					<h3>${fn:escapeXml(Greeting_title)}</h3>
		   			<blockquote>${fn:escapeXml(Greeting_content)}</blockquote>
		   			<b>${fn:escapeXml(Greeting_date)}</b>
		   		</div>
		   		<br/>
		   		<%
			}
		}
   	}
	%>
	<p><a class="button" href="/listblog.jsp">Show All Blog Posts</a></p>
	<p><a class="button" href="/blogpage.jsp">Home</a></p>

</body>
</html>