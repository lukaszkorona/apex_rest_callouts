/**
 * Created by koronal on 2016-02-01.
 */

public with sharing class RestController {

    public static final String SERVICE_URL = 'http://178.62.161.194:8082';
    public static final String PRODUCT_ENDPOINT = '/product/';
    public static final String CATEGORY_ENDPOINT = '/categories/';
    public static final String ORDER_ENDPOINT = '/order/';
    public static final String GET_METHOD = 'GET';
    public static final String POST_METHOD = 'POST';
    private static String username = 'user7';
    private static String passsword = '3T5erA49';


    public RestController(){}

    public static Map<String, RestController.Product> getProducts() {
//        String restResponse = '[{"id":4,"name":"ECG Hoodie L"},{"id":3,"name":"ECG Hoodie M"},{"id":1,"name":"ECG Hoodie S"},{"id":7,"name":"ECG Sweater L"},{"id":6,"name":"ECG Sweater M"},{"id":5,"name":"ECG Sweater S"},{"id":2,"name":"Salesforce Sweets"}]';
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.PRODUCT_ENDPOINT);
            String restResponse = ctx.send();
            List<RestController.Product> productList = (List<RestController.Product>)JSON.deserialize(restResponse, List<RestController.Product>.class);
            Map<String, RestController.Product> productMap = new Map<String, RestController.Product>();
            for(RestController.Product prod : productList) {
                productMap.put(prod.id, prod);
            }
            return productMap;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }


    public static RestController.Product getProduct(String Id) {
//        String restResponse = '{"id": 1, "name": "Product Name","quantity_available": 555,"categories": [1,2,3],"price": 15.25}';
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.PRODUCT_ENDPOINT + Id);
            String restResponse = ctx.send();
            RestController.Product product = (RestController.Product)JSON.deserialize(restResponse, RestController.Product.class);
            System.debug('product '+product.id);
            return product;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Map<String, RestController.Category> getCategories() {
//        String restResponse = '[{"id":1,"name":"Clothing","parent_id":null},{"id":2,"name":"Candy","parent_id":null},{"id":3,"name":"Hoodies","parent_id":1},{"id":4,"name":"Sweaters","parent_id":1}]';
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.CATEGORY_ENDPOINT);
            String restResponse = ctx.send();
            List<RestController.Category> categoryList = (List<RestController.Category>)JSON.deserialize(restResponse, List<RestController.Category>.class);
            Map<String, RestController.Category> catMap = new Map<String, RestController.Category>();
            for(RestController.Category cat : categoryList) {
                catMap.put(cat.id, cat);
            }
            return catMap;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Map<String, RestController.Order> getOrders() {
//        String orderRes = '{ "id": 1, "status": 0,  "tracking_code": "ABCDEF","timestamp": 1453373251465,"total_price": 19.98,"user_id": "005xxxxx","products":[{"id":20,"product_id": 1,"quantity": 2,"unitprice": 9.99}]}';
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.ORDER_ENDPOINT);
            String restResponse = ctx.send();
            List<RestController.Order> orderList = (List<RestController.Order>)JSON.deserialize(restResponse, List<RestController.Order>.class);
            Map<String, RestController.Order> orderMap = new Map<String, RestController.Order>();
            for(RestController.Order ord : orderList) {
                orderMap.put(ord.id, ord);
            }
            return orderMap;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Order getOrder(String Id) {
//        String restResponse = '{"id": 1, "name": "Order Name","quantity_available": 555,"categories": [1,2,3],"price": 15.25}';
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.ORDER_ENDPOINT + Id);
            String restResponse = ctx.send();
            Order order = (Order)JSON.deserialize(restResponse, RestController.Order.class);
            System.debug('order '+order);
            return order;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Order sendOrder(Map<String, Object> orderBody) {
        try {
            RestControllerContext ctx = new RestControllerContext(orderBody);
            String restResponse = ctx.send();
            Order order = (Order)JSON.deserialize(restResponse, RestController.Order.class);
            System.debug('order '+order);
            return order;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public class RestControllerContext {
        private HttpRequest req;
        private HttpResponse res;
        private Http http;
        private Blob headerValue;
        private String authHeader;

        public RestControllerContext() {
            req = new HttpRequest();
            http = new http();
            headerValue = Blob.valueOf(RestController.username + ':' + RestController.passsword);
            authHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authHeader);
            System.debug(req.getHeader('Authorization'));
        }

        public RestControllerContext(String method, String endpointName) {
            this();
            req.setMethod(method);
            req.setEndpoint(RestController.SERVICE_URL + endpointName);

        }

        public RestControllerContext(Map<String, Object> body) {
            this();
            req.setMethod(RestController.POST_METHOD);
            req.setEndpoint(RestController.SERVICE_URL + ORDER_ENDPOINT);
            String serializedBody = JSON.serialize(body);
            req.setBody(serializedBody);
        }

        public String send() {
            try {
                System.debug('HttpRequest ' + req);
                res = http.send(req);
                System.debug('HttpResponse ' + res);

            } catch (Exception e) {
                System.debug(e);
            }
            return res.getBody();
        }
    }

    public class Product
    {
        public String id {get;set;}
        public String name {get;set;}
        public String quantity_available {get;set;}
        public List<String> categories {get;set;}
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
        public String name {get;set;}
        public String status {get;set;}
        public String tracking_code {get;set;}
        public String timstamp {get;set;}
        public String total_price {get;set;}
        public String user_id {get;set;}
        public List<Product> products {get;set;}
        public String product_id {get;set;}
        public String quantity {get;set;}
        public String unitprice {get;set;}
    }

}