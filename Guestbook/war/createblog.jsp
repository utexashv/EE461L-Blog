<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="guestbook.Blogpage" %>
<%@ page import="guestbook.SubscribeServlet" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.Email" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<style>
		textarea{
		background-color:#000066;
		color:#66ccff;
		}
	</style>
	<head>
		<title>Blog - creation</title>
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
    if (user != null) {
      pageContext.setAttribute("user", user);
    
    String email_str = user.getEmail();  
    ObjectifyService.register(Email.class);
    List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
    }
%>
	
<%
     if (user != null) {
%>
	    <form action="/blog" method="post">
	      <p>Title for your blog:</p>
				<div><textarea name="title" rows="1" cols="60"></textarea></div><br/>
				<p>Write your blog:</p>
		    	<div><textarea name="content" rows="20" cols="100"></textarea></div><br/>
		    	<div><input type="submit" value="Post Blog" /></div>
	      <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
	    </form>
	    <br/>
		<p><a class="button" href="/blogpage.jsp">Cancel</a></p>
<%
     } else {
%>
<p>You must
<a class="button" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to post.</p>
<%
     }
%>	

	</body>
</html>