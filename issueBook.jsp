<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="Connection.DBConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Issue Book | Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f5f7fa; font-family: Arial, sans-serif; }
        .sidebar { height: 100vh; background-color: #2c3e50; }
        .sidebar a { color: #ecf0f1; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background-color: #1abc9c; }
        .form-card { border-radius: 10px; background: #fff; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        label { font-weight: bold; }
        .msg { text-align: center; color: green; font-weight: bold; margin-bottom: 10px; }
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
            <a href="viewBooks.jsp">View Books</a>
            <a href="issueBook.jsp" class="bg-success">Issue Book</a>
            <a href="returnBook.jsp">Return Book</a>
            <a href="members.jsp">Members</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <h3 class="mb-4">Issue Book</h3>

            <div class="form-card">
                <%
                    String msg = "";

                    // Fetch all books to populate datalist
                    List<Document> booksList = new ArrayList<>();
                    try {
                        MongoDatabase db = DBConnection.getConnection();
                        MongoCollection<Document> booksCol = db.getCollection("books");
                        FindIterable<Document> books = booksCol.find();
                        for (Document b : books) {
                            booksList.add(b);
                        }
                    } catch (Exception e) {
                        msg = "❌ Error fetching books: " + e.getMessage();
                    }

                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String studentId = request.getParameter("studentId");
                        String bookName = request.getParameter("bookName");
                        String isbn = ""; // default blank

                        // Check if book exists in DB to get ISBN
                        for (Document book : booksList) {
                            if (bookName.equalsIgnoreCase(book.getString("title"))) {
                                isbn = book.getString("isbn");
                                break;
                            }
                        }

                        String issueDate = request.getParameter("issueDate");
                        String returnDate = request.getParameter("returnDate");

                        try {
                            MongoDatabase db = DBConnection.getConnection();
                            MongoCollection<Document> issuedCol = db.getCollection("issued_books");

                            Document issueDoc = new Document("studentId", studentId)
                                    .append("bookName", bookName)
                                    .append("isbn", isbn)
                                    .append("issueDate", issueDate)
                                    .append("returnDate", returnDate)
                                    .append("status", "ISSUED");

                            issuedCol.insertOne(issueDoc);
                            msg = "✅ Book Issued Successfully!";
                        } catch(Exception e) {
                            msg = "❌ Error issuing book: " + e.getMessage();
                        }
                    }
                %>

                <form method="post">
                    <% if (!msg.isEmpty()) { %>
                        <p class="msg"><%= msg %></p>
                    <% } %>

                    <div class="mb-3">
                        <label>Student ID</label>
                        <input type="text" name="studentId" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label>Book Name</label>
                        <input list="booksList" name="bookName" class="form-control" placeholder="Select or type a book name" required>
                        <datalist id="booksList">
                            <% for (Document book : booksList) { %>
                                <option value="<%= book.getString("title") %>"></option>
                            <% } %>
                        </datalist>
                    </div>

                    <div class="mb-3">
                        <label>Issue Date</label>
                        <input type="date" name="issueDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Return Date</label>
                        <input type="date" name="returnDate" class="form-control" required>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-success">Issue Book</button>
                        <button type="reset" class="btn btn-secondary">Clear</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
