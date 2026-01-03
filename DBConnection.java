package Connection;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class DBConnection {

    public static MongoDatabase getConnection() {
        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db = client.getDatabase("librarydb");
            System.out.println("Connected to MongoDB successfully!");
            return db;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        MongoDatabase db = getConnection();
        if (db != null) {
            System.out.println("Database name: " + db.getName());
        } else {
            System.out.println("Connection failed!");
        }
    }

	
}
