package AddBookServlet;

import Connection.DBConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.bson.Document;

import java.io.IOException;

@WebServlet("/AddBookServlet")
public class AddBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Read form data
            String bookName = request.getParameter("bookName");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String category = request.getParameter("category");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String publisher = request.getParameter("publisher");

            String yearStr = request.getParameter("year");
            int year = (yearStr != null && !yearStr.isEmpty())
                    ? Integer.parseInt(yearStr)
                    : 0;

            // ✅ Correct method call
            MongoDatabase database = DBConnection.getConnection();
            MongoCollection<Document> booksCollection =
                    database.getCollection("books");

            // Create MongoDB document
            Document book = new Document("bookName", bookName)
                    .append("author", author)
                    .append("isbn", isbn)
                    .append("category", category)
                    .append("quantity", quantity)
                    .append("publisher", publisher)
                    .append("year", year)
                    .append("status", "Available");

            // Insert into DB
            booksCollection.insertOne(book);

            // Redirect after success
            response.sendRedirect("addBook.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addBook.jsp?success=false");
        }
    }
}
