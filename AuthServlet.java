package AuthServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Connection.DBConnection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import java.io.IOException;

@WebServlet("/AuthServlet")  // must match your form action
public class AuthServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name"); // if present → registration

        MongoDatabase db = DBConnection.getConnection();
        MongoCollection<Document> usersCollection = db.getCollection("users");

        if (name != null && !name.isEmpty()) {
            // === Registration ===
            Document existingUser = usersCollection.find(Filters.eq("username", username)).first();
            if (existingUser != null) {
                request.setAttribute("error", "Username already exists!");
                request.getRequestDispatcher("auth.jsp?mode=register").forward(request, response);
            } else {
                Document newUser = new Document("name", name)
                        .append("gender", request.getParameter("gender"))
                        .append("dob", request.getParameter("dob"))
                        .append("email", request.getParameter("email"))
                        .append("phone", request.getParameter("phone"))
                        .append("address", request.getParameter("address"))
                        .append("memberType", request.getParameter("memberType"))
                        .append("department", request.getParameter("department"))
                        .append("roll", request.getParameter("roll"))
                        .append("username", username)
                        .append("password", password);

                usersCollection.insertOne(newUser);
                response.sendRedirect("auth.jsp?mode=login");
            }
        } else {
            // === Login ===
            Document user = usersCollection.find(
                    Filters.and(Filters.eq("username", username), Filters.eq("password", password))
            ).first();

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", user.getString("memberType"));
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("auth.jsp?mode=login&error=true");
            }
        }
    }
}
