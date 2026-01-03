<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String mode = request.getParameter("mode");
    if (mode == null) {
        mode = "login";
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Library System</title>

<style>
/* ===== GLOBAL BACKGROUND ===== */
body {
    margin: 0;
    padding: 0;
    min-height: 100vh;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    justify-content: center;
    align-items: center;
}

/* ===== GLASS CONTAINER ===== */
.container {
    width: 460px;
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 15px 40px rgba(0,0,0,0.25);
    color: #fff;
}

/* ===== HEADINGS ===== */
h2 {
    text-align: center;
    margin-bottom: 25px;
    font-weight: 600;
}

/* ===== FORM ELEMENTS ===== */
label {
    font-weight: 500;
    margin-bottom: 5px;
    display: block;
}

input, select, textarea {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 8px;
    border: none;
    outline: none;
    font-size: 14px;
}

input:focus, select:focus, textarea:focus {
    box-shadow: 0 0 0 2px rgba(102,126,234,0.7);
}

/* ===== BUTTON ===== */
button {
    width: 100%;
    padding: 12px;
    background: linear-gradient(135deg, #00c6ff, #0072ff);
    color: #fff;
    border: none;
    font-size: 16px;
    border-radius: 10px;
    cursor: pointer;
    font-weight: bold;
    transition: 0.3s ease;
}

button:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.3);
}

/* ===== LINKS ===== */
.switch-link {
    text-align: center;
    margin-top: 18px;
}

.switch-link a {
    color: #ffd369;
    font-weight: bold;
    text-decoration: none;
}

.switch-link a:hover {
    text-decoration: underline;
}

/* ===== ERROR ===== */
.error {
    background: rgba(255,0,0,0.2);
    padding: 10px;
    border-radius: 8px;
    text-align: center;
    margin-top: 10px;
    font-weight: bold;
}
</style>

</head>
<body>

<div class="container">

<%
    switch(mode) {

        case "register":
%>

    <h2>📚 Library Registration</h2>

    <form action="AuthServlet" method="post">

        <label>Full Name</label>
        <input type="text" name="name" required>

        <label>Gender</label>
        <select name="gender">
            <option value="Female">Female</option>
            <option value="Male">Male</option>
        </select>

        <label>Date of Birth</label>
        <input type="date" name="dob">

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Phone Number</label>
        <input type="text" name="phone" required>

        <label>Address</label>
        <textarea name="address" rows="3"></textarea>

        <label>Member Type</label>
        <select name="memberType" required>
            <option value="">-- Select Role --</option>
            <option value="Admin">Admin</option>
            <option value="Teacher">Teacher</option>
            <option value="Staff">Staff</option>
            <option value="Student">Student</option>
        </select>

        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Create Account</button>
    </form>

    <div class="switch-link">
        Already have an account? <a href="auth.jsp?mode=login">Login here</a>
    </div>

<%
        break;

        case "login":
        default:
%>

    <h2>🔐 Library Login</h2>

    <form action="AuthServlet" method="post">

        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Login</button>
    </form>

    <% if(request.getParameter("error") != null) { %>
        <div class="error">❌ Invalid username or password!</div>
    <% } %>

    <div class="switch-link">
        Don’t have an account? <a href="auth.jsp?mode=register">Register here</a>
    </div>

<%
        break;
    }
%>

</div>

</body>
</html>
