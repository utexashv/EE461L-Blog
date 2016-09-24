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
<title>List of Posters</title>
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
	<h1>People Who Have Posted</h1>
	
	<p><a class="button" href="/listblog.jsp">Show All Blog Posts</a></p>
	<%	
	// interact with Objectify  
    ObjectifyService.register(Greeting.class);
    List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    Collections.sort(greetings);
    Collections.reverse(greetings);

	if (greetings.isEmpty()) {
	%>
		<h3>No one has posted anything yet.</h3>
	<%
	} else {
	%>
		<h3>People</h3>
	<%
		List<String> ppl = new ArrayList<String>();
		for (Greeting greeting : greetings) {
			String author;
			if(greeting.getUser()!=null){
				author = greeting.userToString();
		        if(!ppl.contains(author)){
		        	ppl.add(author);
		        }
			}		
	   	}
		for(String person : ppl){
	  		pageContext.setAttribute("greeting_user", person);
	 %>
			<div style="background-color: #033863; padding: 10px 20px 10px 20px">
				<a style="color: white; text-decoration: none;" href="/blogger.jsp?param=${fn:escapeXml(greeting_user)}">${fn:escapeXml(greeting_user)}</a>
	   		</div>
	   		<br/>
   	<%
		}
	}
	%>
	<p><a class="button" href="/listblog.jsp">Show All Blog Posts</a></p>

</body>
</html>