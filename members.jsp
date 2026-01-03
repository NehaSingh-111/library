<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="Connection.DBConnection" %>

<%
    // SESSION CHECK: only logged-in users can view
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    if(username == null || userRole == null){
        response.sendRedirect("auth.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Members | Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f5f7fa; font-family: Arial, sans-serif; }
        .sidebar { height: 100vh; background-color: #2c3e50; }
        .sidebar a { color: #ecf0f1; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background-color: #1abc9c; }
        .table-card { border-radius: 10px; background: #fff; padding: 20px; margin-top: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        th { background-color: #34495e; color: white; }
        td, th { text-align: center; vertical-align: middle; }
        h3 { margin-bottom: 20px; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand mb-0 h1">📚 Library Management System</span>
    <span class="text-light me-3">Welcome, <%= username %> (<%= userRole %>)</span>
    <a href="dashboard.jsp" class="btn btn-secondary btn-sm">Back</a>
</nav>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-2 sidebar p-0">
            <a href="dashboard.jsp">Dashboard</a>
            <% if("Admin".equalsIgnoreCase(userRole)){ %>
                <a href="addBook.jsp">Add Book</a>
            <% } %>
            <a href="viewBooks.jsp">View Books</a>
            <a href="issueBook.jsp">Issue Book</a>
            <a href="returnBook.jsp">Return Book</a>
            <a href="members.jsp" class="bg-success">Members</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <h3>Library Members</h3>

            <div class="table-card">
                <table class="table table-bordered table-striped mb-0">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Member Type</th>
                            <th>Date of Birth</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            MongoDatabase database = DBConnection.getConnection();
                            MongoCollection<Document> usersCollection = database.getCollection("users");

                            // Only non-admin users
                            FindIterable<Document> users = usersCollection.find(new Document("memberType", new Document("$ne", "Admin")));
                            boolean hasUsers = false;

                            for (Document user : users) {
                                hasUsers = true;
                    %>
                        <tr>
                            <td><%= user.getString("name") != null ? user.getString("name") : "-" %></td>
                            <td><%= user.getString("email") != null ? user.getString("email") : "-" %></td>
                            <td><%= user.getString("phone") != null ? user.getString("phone") : "-" %></td>
                            <td><%= user.getString("memberType") != null ? user.getString("memberType") : "-" %></td>
                            <td><%= user.getString("dob") != null ? user.getString("dob") : "-" %></td>
                        </tr>
                    <%
                            }
                            if (!hasUsers) {
                    %>
                        <tr>
                            <td colspan="5" class="text-center">No users found</td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                        <tr>
                            <td colspan="5" class="text-center text-danger">Error: <%= e.getMessage() %></td>
                        </tr>
                    <%
                            e.printStackTrace();
                        }
                    %>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
