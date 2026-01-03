<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="Connection.DBConnection" %>
<%@ page import="com.mongodb.client.result.UpdateResult" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Book | Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f5f7fa; font-family: Arial, sans-serif; }
        .sidebar { height: 100vh; background-color: #2c3e50; }
        .sidebar a { color: #ecf0f1; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background-color: #1abc9c; }
        .form-card { border-radius: 10px; background: #fff; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        label { font-weight: bold; }
        .msg { text-align: center; font-weight: bold; margin-bottom: 10px; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>

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
            <a href="issueBook.jsp">Issue Book</a>
            <a href="returnBook.jsp" class="bg-success">Return Book</a>
            <a href="members.jsp">Members</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <h3 class="mb-4">Return Book</h3>

            <div class="form-card">
                <%
                    String msg = "";
                    String msgClass = "";

                    // Connect to database
                    MongoDatabase db = DBConnection.getConnection();
                    MongoCollection<Document> issuedCol = db.getCollection("issued_books");

                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String issuedId = request.getParameter("issuedId");
                        String isbnEntered = request.getParameter("isbn"); // Get edited ISBN
                        try {
                            ObjectId objId = new ObjectId(issuedId);
                            // Case-insensitive ISSUED status check
                            Document filter = new Document("_id", objId)
                                    .append("status", new Document("$regex", "^ISSUED$").append("$options", "i"));

                            // Update both status and ISBN
                            Document updateFields = new Document("status", "RETURNED");
                            if (isbnEntered != null && !isbnEntered.trim().isEmpty()) {
                                updateFields.put("isbn", isbnEntered.trim());
                            }
                            Document update = new Document("$set", updateFields);

                            UpdateResult result = issuedCol.updateOne(filter, update);

                            if (result.getMatchedCount() > 0) {
                                msg = "✅ Book Returned Successfully";
                                msgClass = "success";
                            } else {
                                msg = "❌ No issued book found or already returned";
                                msgClass = "error";
                            }
                        } catch (Exception e) {
                            msg = "❌ Error: " + e.getMessage();
                            msgClass = "error";
                        }
                    }
                %>

                <% if (!msg.isEmpty()) { %>
                    <p class="msg <%= msgClass %>"><%= msg %></p>
                <% } %>

                <form method="post">
                    <div class="mb-3">
                        <label>Select Issued Book</label>
                        <select name="issuedId" class="form-select" id="issuedBookSelect" onchange="fillFields()" required>
                            <option value="">-- Select Book --</option>
                            <%
                                // Fetch all issued books (status = ISSUED)
                                FindIterable<Document> issuedBooks = issuedCol.find(new Document("status", new Document("$regex", "^ISSUED$").append("$options", "i")));
                                for (Document issued : issuedBooks) {
                                    String studentId = issued.getString("studentId");
                                    String isbn = issued.getString("isbn");
                                    String bookName = issued.getString("bookName");

                                    // If bookName is null, get title from ISBN
                                    if (bookName == null || bookName.isEmpty()) {
                                        MongoCollection<Document> booksCol = db.getCollection("books");
                                        Document bookDoc = booksCol.find(new Document("isbn", isbn)).first();
                                        if (bookDoc != null) bookName = bookDoc.getString("title");
                                        else bookName = "-";
                                    }
                            %>
                            <option value="<%= issued.getObjectId("_id") %>"
                                    data-student="<%= studentId %>"
                                    data-isbn="<%= isbn != null ? isbn : "" %>">
                                <%= bookName %> (Student ID: <%= studentId %>)
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label>Student ID</label>
                        <input type="text" id="studentIdInput" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label>Book ISBN</label>
                        <!-- Editable ISBN -->
                        <input type="text" id="isbnInput" name="isbn" class="form-control" placeholder="Enter ISBN if different">
                    </div>

                    <div class="text-end">
                        <button type="submit" class="btn btn-success">Return Book</button>
                        <button type="reset" class="btn btn-secondary" onclick="resetFields()">Clear</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillFields() {
        const select = document.getElementById('issuedBookSelect');
        const selectedOption = select.options[select.selectedIndex];
        document.getElementById('studentIdInput').value = selectedOption.getAttribute('data-student') || '';
        document.getElementById('isbnInput').value = selectedOption.getAttribute('data-isbn') || '';
    }

    function resetFields() {
        document.getElementById('studentIdInput').value = '';
        document.getElementById('isbnInput').value = '';
        document.getElementById('issuedBookSelect').selectedIndex = 0;
    }
</script>

</body>
</html>
