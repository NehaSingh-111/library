<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="Connection.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Books | Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f5f7fa;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            height: 100vh;
            background-color: #2c3e50;
        }

        .sidebar a {
            color: #ecf0f1;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
        }

        .sidebar a:hover {
            background-color: #1abc9c;
        }

        /* ✅ TABLE UI ONLY */
        .table-card {
            border-radius: 14px;
            background: #ffffff;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }

        table {
            border-collapse: separate;
            border-spacing: 0;
        }

        thead th {
            background: linear-gradient(45deg, #34495e, #2c3e50);
            color: #ffffff;
            font-weight: 600;
            text-align: center;
            padding: 12px;
        }

        tbody td {
            text-align: center;
            padding: 10px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background-color: #f2f6fc;
            transition: 0.3s;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        h3 {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand mb-0 h1">📚 Library Management System</span>
    <a href="dashboard.jsp" class="btn btn-secondary btn-sm">Back</a>
</nav>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-2 sidebar p-0">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="addBook.jsp">Add Book</a>
            <a href="viewBooks.jsp" class="bg-success">View Books</a>
            <a href="issueBook.jsp">Issue Book</a>
            <a href="returnBook.jsp">Return Book</a>
            <a href="members.jsp">Members</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <h3>Library Books</h3>

            <div class="table-card">
                <table class="table table-bordered table-striped mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Book Name</th>
                            <th>Author</th>
                            <th>ISBN</th>
                            <th>Category</th>
                            <th>Publisher</th>
                            <th>Year</th>
                            <th>Quantity</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                MongoDatabase database = DBConnection.getConnection();
                                MongoCollection<Document> booksCollection = database.getCollection("books");

                                FindIterable<Document> books = booksCollection.find();
                                boolean hasBooks = false;

                                for (Document book : books) {
                                    hasBooks = true;
                        %>
                        <tr>
                            <td><%= book.getObjectId("_id") %></td>
                            <td><%= book.getString("bookName") != null ? book.getString("bookName") : "-" %></td>
                            <td><%= book.getString("author") != null ? book.getString("author") : "-" %></td>
                            <td><%= book.getString("isbn") != null ? book.getString("isbn") : "-" %></td>
                            <td><%= book.getString("category") != null ? book.getString("category") : "-" %></td>
                            <td><%= book.getString("publisher") != null ? book.getString("publisher") : "-" %></td>
                            <td><%= book.getInteger("year", 0) %></td>
                            <td><%= book.getInteger("quantity", 0) %></td>
                            <td><%= book.getString("status") != null ? book.getString("status") : "-" %></td>
                        </tr>
                        <%
                                }

                                if (!hasBooks) {
                        %>
                        <tr>
                            <td colspan="9" class="text-center text-muted">No books found</td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                        <tr>
                            <td colspan="9" class="text-center text-danger">
                                Error: <%= e.getMessage() %>
                            </td>
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
