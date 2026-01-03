<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mongodb.client.MongoDatabase, com.mongodb.client.MongoCollection, com.mongodb.client.FindIterable, org.bson.Document, Connection.DBConnection" %>

<%
    // SESSION CHECK
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");

    if(username == null || userRole == null){
        response.sendRedirect("auth.jsp");
        return;
    }

    boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

    // MongoDB Collections
    MongoDatabase db = DBConnection.getConnection();
    MongoCollection<Document> booksCol = db.getCollection("books");
    MongoCollection<Document> issuedCol = db.getCollection("issued_books");
    MongoCollection<Document> membersCol = db.getCollection("users");

    // Counts
    long totalBooks = booksCol != null ? booksCol.countDocuments() : 0;
    long issuedBooks = issuedCol != null ? issuedCol.countDocuments() : 0;
    long totalMembers = membersCol != null ? membersCol.countDocuments() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Library Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
/* GENERAL */
body { background-color: #eef2f7; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
h3 { color: #2c3e50; }

/* NAVBAR */
.navbar { box-shadow: 0 3px 10px rgba(0,0,0,0.2); }
.navbar .btn-danger { font-weight: bold; }

/* SIDEBAR */
.sidebar {
    height: 100vh;
    background-color: #2c3e50;
    position: sticky;
    top: 0;
}
.sidebar a {
    color: #ecf0f1;
    text-decoration: none;
    padding: 15px 20px;
    display: block;
    font-weight: 500;
    transition: 0.3s;
}
.sidebar a:hover, .sidebar a.active {
    background-color: #1abc9c;
    color: #fff;
}

/* STATS CARDS */
.card-box {
    border-radius: 15px;
    color: #fff;
    text-align: center;
    padding: 25px 15px;
    box-shadow: 0 6px 15px rgba(0,0,0,0.1);
    transition: transform 0.3s;
}
.card-box:hover { transform: translateY(-5px); }
.bg-books { background: linear-gradient(135deg,#3498db,#2980b9); }
.bg-issued { background: linear-gradient(135deg,#e67e22,#d35400); }
.bg-available { background: linear-gradient(135deg,#2ecc71,#27ae60); }
.bg-members { background: linear-gradient(135deg,#9b59b6,#8e44ad); }

/* TABLE */
.table thead { background-color: #34495e; color: #fff; }
.table-striped > tbody > tr:nth-of-type(odd) { background-color: #f7f9fb; }
.table-hover tbody tr:hover { background-color: #d1f0ff; transition: 0.2s; }
.badge-status {
    padding: 0.5em 0.8em;
    font-weight: 500;
    border-radius: 12px;
}

/* SEARCH */
.search-input { max-width: 300px; margin-bottom: 10px; }

/* MESSAGES */
.msg { margin-bottom: 15px; font-weight: bold; text-align: center; color: green; }
</style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark px-4 d-flex justify-content-between">
    <span class="navbar-brand mb-0 h1">📚 Library Management System</span>
    <div>
        <span class="text-light me-3">Welcome, <%= username %> (<%= userRole %>)</span>
        <a href="auth.jsp" class="btn btn-danger btn-sm">Logout</a>
    </div>
</nav>

<div class="container-fluid">
<div class="row">

    <!-- Sidebar -->
    <div class="col-md-2 sidebar p-0">
        <a href="dashboard.jsp" class="active">Dashboard</a>
        <% if(isAdmin){ %>
            <a href="addBook.jsp">Add Book</a>
        <% } %>
        <a href="viewBooks.jsp">View Books</a>
        <a href="issueBook.jsp">Issue Book</a>
        <a href="returnBook.jsp">Return Book</a>
        <a href="members.jsp">Members</a>
    </div>

    <!-- Main content -->
    <div class="col-md-10 p-4">
        <h3 class="mb-4">Dashboard Overview</h3>

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card card-box bg-books">
                    <h5>Total Books</h5>
                    <h2><%= totalBooks %></h2>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-box bg-issued">
                    <h5>Issued Books</h5>
                    <h2><%= issuedBooks %></h2>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-box bg-available">
                    <h5>Available Books</h5>
                    <h2><%= totalBooks - issuedBooks %></h2>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-box bg-members">
                    <h5>Total Members</h5>
                    <h2><%= totalMembers %></h2>
                </div>
            </div>
        </div>

        <!-- Recently Issued Books Table -->
        <div class="card shadow-sm">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <strong>Recently Issued Books</strong>
                <input type="text" id="bookSearch" class="form-control search-input" placeholder="Search by book or return date">
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-hover mb-0" id="booksTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Book Name</th>
                            <th>Return Date</th>
                            <th>Issue Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        boolean hasIssuedBooks = false;
                        if(issuedCol != null){
                            FindIterable<Document> issuedBooksList = issuedCol.find();
                            for(Document doc : issuedBooksList){
                                hasIssuedBooks = true;

                                String bookName = doc.getString("bookName");
                                if((bookName == null || bookName.isEmpty()) && doc.getString("isbn") != null){
                                    Document bookDoc = booksCol.find(new Document("isbn", doc.getString("isbn"))).first();
                                    if(bookDoc != null) bookName = bookDoc.getString("title");
                                    else bookName = "-";
                                }

                                String returnDate = doc.getString("returnDate") != null ? doc.getString("returnDate") : "-";
                                String issueDate = doc.getString("issueDate") != null ? doc.getString("issueDate") : "-";
                                String status = doc.getString("status") != null ? doc.getString("status") : "Unknown";

                                String badgeClass = "bg-secondary";
                                if("Issued".equalsIgnoreCase(status)) badgeClass = "bg-warning";
                                else if("Returned".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                else if("Overdue".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                    %>
                        <tr>
                            <td><%= bookName %></td>
                            <td><%= returnDate %></td>
                            <td><%= issueDate %></td>
                            <td><span class="badge badge-status <%= badgeClass %>"><%= status %></span></td>
                        </tr>
                    <%
                            }
                        }
                        if(!hasIssuedBooks){
                    %>
                        <tr>
                            <td colspan="4" class="text-center">No issued books found</td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
const searchInput = document.getElementById('bookSearch');
searchInput.addEventListener('keyup', function () {
    const filter = searchInput.value.toLowerCase();
    const rows = document.querySelectorAll('#booksTable tbody tr');

    rows.forEach(row => {
        const bookName = row.cells[0].textContent.toLowerCase();
        const returnDate = row.cells[1].textContent.toLowerCase();
        row.style.display = (bookName.includes(filter) || returnDate.includes(filter)) ? '' : 'none';
    });
});
</script>

</body>
</html>
