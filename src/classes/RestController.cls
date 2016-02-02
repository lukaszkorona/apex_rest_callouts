/**
 * Created by koronal on 2016-02-01.
 */

public with sharing class RestController {


    public static String SERVICE_URL = 'http://jsonplaceholder.typicode.com';
    public static String POSTS_ENDPOINT = '/posts';
    public static String USERS_ENPOINT = '/users';
    public List<User> usrList {get;set;}

    public RestController()
    {
        List<user> uList = new List<user>();
        uList = getUsers();
    }

    public static List<SmallPost> getPosts() {
        HttpRequest req = new HttpRequest();

        HTTPResponse res;
        req.setMethod('GET');

        req.setEndpoint(SERVICE_URL+POSTS_ENDPOINT);

        Http http = new http();
        try {
            res = http.send(req);
            System.debug('res '+res);

            //System.debug(res.getBody());
        } catch (System.CalloutException e) {
            System.debug(e);
        }
        String jsonString = res.getBody();
        List<SmallPost> spList = new List<SmallPost>();
        //spList = (SmallPost)JSON.deserialize(jsonString, SmallPost.class);
        /*if (jsonString != null) {
            System.debug('json string');
            JSONParser parser = JSON.createParser(jsonString);
            while(parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    System.debug('start array');
                    while(parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            System.debug('inner most');
                            SmallPost sp = (SmallPost) parser.readValueAs(SmallPost.class);
                            System.debug('sp ' + sp);
                            spList.add(sp);
                        }
                    }
                }
            }
        }*/
        System.debug('spList '+spList);
        return spList;
    }

    public static void getProducts() {
        String productsRes = '[{"id": 1, "name": "Product1"}, {"id": 2, "name": "Product2"}]';
        List<Product> products = (List<Product>)JSON.deserialize(productsRes, List<RestController.Product>.class);
        System.debug('products '+products);
    }

    public static void getProduct() {
        String productRes = '{"id": 1, "name": "Product Name","quantity_available": 555,"categories": [1,2,3],"price": 15.25}';
        Product product = (Product)JSON.deserialize(productRes, RestController.Product.class);
        System.debug('product '+product);
    }

    public static void getCategories() {
        String categoriesRes = '[{ "id": 1, "name": "Clothing", "parent_id": null }, { "id": 2, "name": "Keyboards", "parent_id": null }, { "id": 3, "name": "Hoodies", "parent_id": 1}]';
    }

    public static void getOrder() {
        String orderRes = '{ "id": 1, "status": 0,  "tracking_code": "ABCDEF","timestamp": 1453373251465,"total_price": 19.98,"user_id": "005xxxxx","products":[{"id":20,"product_id": 1,"quantity": 2,"unitprice": 9.99}]}';
    }

    public List<User> getUsers() {
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        req.setMethod('GET');
        String endpoint = SERVICE_URL+USERS_ENPOINT;

        req.setEndpoint(endpoint);
        Http http = new http();
        try {
            res = http.send(req);
            System.debug(res);
            System.debug(res.getBody());
        } catch (System.CalloutException e) {
            System.debug(e);
        }

        List<User> deserializedResult;
        try {
            //Type resultType = Type.forName('RestController.User');
            //System.debug('resultType '+resultType);
            deserializedResult = (List<RestController.User>)JSON.deserialize(res.getBody(), List<RestController.User>.class);
        }catch(Exception e) {
            System.debug(e);
        }

        usrList = new List<user>();
        usrList = deserializedResult;
        return deserializedResult;
    }

    public class Product
    {
        public String id {get;set;}
        public String name {get;set;}
        public String quantity_available {get;set;}
        public List<Integer> categories {get;set;}
        public Decimal price {get;set;}
    }

    public class Category
    {
        public String id { get; set; }
        public String name {get;set;}
        public String parent_id {get;set;}
    }

    public class Order
    {
        public String id {get;set;}
        public String status {get;set;}
        public String tracking_code {get;set;}
        public String timstamp {get;set;}
        public String total_price {get;set;}
        public String user_id {get;set;}
        public List<Product> products {get;set;}
    }

    public class UserResponse
    {
        public List<User> users {get;set;}
    }

    public class User
    {
        public String id {get;set;}
        public String name {get;set;}
        public String username {get;set;}
        public String email {get;set;}
        public Address address {get;set;}
        public String phone {get;set;}
        public String website {get;set;}
        public Company company {get;set;}
    }

    public Class Company
    {
        public String name {get;set;}
        public String catchPharse {get;set;}
        public String bs {get;set;}
    }

    public class Address
    {
        public String street {get;set;}
        public String suit {get;set;}
        public String city {get;set;}
        public String zipcode {get;set;}
        public Geo geo {get;set;}
    }

    public Class Geo
    {
        public String lat {get;set;}
        public String lng {get;set;}
    }

    public class SmallPost
    {
        public String userId {get;set;}
        public String id {get;set;}
        public String title {get;set;}
        public String body {get;set;}
    }
}