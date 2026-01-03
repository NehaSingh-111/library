//package BookServlet;
//
//import Connection.DBConnection;
//import com.mongodb.client.MongoCollection;
//import com.mongodb.client.MongoDatabase;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import org.bson.Document;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//
//public class BookServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        MongoDatabase db = DBConnection.getConnection();
//        MongoCollection<Document> collection = db.getCollection("books");
//
//        List<Document> bookList = new ArrayList<>();
//        for (Document doc : collection.find()) {
//            bookList.add(doc);
//        }
//
//        request.setAttribute("books", bookList);
//        request.getRequestDispatcher("viewBooks.jsp")
//               .forward(request, response);
//    }
//}
