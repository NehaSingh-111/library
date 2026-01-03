<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Book | Library Management System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f5f7fa;
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
        .form-card {
            border-radius: 10px;
        }
    </style>
</head>
<body>

<!-- Top Navbar -->
<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand mb-0 h1">📚 Library Management System</span>
    <a href="dashboard.jsp" class="btn btn-secondary btn-sm">Back</a>
</nav>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-2 sidebar p-0">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="addBook.jsp" class="bg-success">Add Book</a>
            <a href="viewBooks.jsp">View Books</a>
            <a href="issueBook.jsp">Issue Book</a>
            <a href="returnBook.jsp">Return Book</a>
            <a href="members.jsp">Members</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <h3 class="mb-4">Add New Book</h3>

            <div class="card form-card shadow-sm">
                <div class="card-body">

                    <form action="AddBookServlet" method="post">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Book Name</label>
                                <input type="text" name="bookName" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Author Name</label>
                                <input type="text" name="author" class="form-control" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">ISBN Number</label>
                                <input type="text" name="isbn" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Category</label>
                                <select name="category" class="form-select" required>
                                    <option value="">Select</option>
                                    <option>Programming</option>
                                    <option>Database</option>
                                    <option>Networking</option>
                                    <option>Science</option>
                                    <option>Mathematics</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Quantity</label>
                                <input type="number" name="quantity" class="form-control" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Publisher</label>
                                <input type="text" name="publisher" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Year</label>
                                <input type="number" name="year" class="form-control">
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="reset" class="btn btn-secondary">Clear</button>
                            <button type="submit" class="btn btn-success">Add Book</button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>