public with sharing class RestController {

    public static final String SERVICE_URL = 'http://178.62.161.194:8082';
    public static final String PRODUCT_ENDPOINT = '/product/';
    public static final String CATEGORY_ENDPOINT = '/categories/';
    public static final String ORDER_ENDPOINT = '/order/';
    public static final String GET_METHOD = 'GET';
    public static final String POST_METHOD = 'POST';
    public static final String CONTENT_TYPE = 'Content-Type';
    public static final String JSON_CONTENT = 'application/json';
    private static String username ;
    private static String passsword ;


    public RestController(){}

    static {
        List<ebayapi__c> creds = ebayapi__c.getAll().values();
        username = creds[0].username__c;
        passsword = creds[0].passsword__c;

    }

    public static Map<Integer, RestController.Product> getProducts() {
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.PRODUCT_ENDPOINT);
            String restResponse = ctx.send();
            List<RestController.Product> productList = (List<RestController.Product>)JSON.deserialize(restResponse, List<RestController.Product>.class);
            Map<Integer, RestController.Product> productMap = new Map<Integer, RestController.Product>();
            for(RestController.Product prod : productList) {
                productMap.put(prod.id, prod);
            }
            return productMap;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }


    public static RestController.Product getProduct(Integer Id) {
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.PRODUCT_ENDPOINT + Id);
            String restResponse = ctx.send();
            RestController.Product product = (RestController.Product)JSON.deserialize(restResponse, RestController.Product.class);
            return product;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Map<Integer, RestController.Category> getCategories() {
        try {
            RestControllerContext ctx = new RestControllerContext(RestController.GET_METHOD, RestController.CATEGORY_ENDPOINT);
            String restResponse = ctx.send();
            List<RestController.Category> categoryList = (List<RestController.Category>)JSON.deserialize(restResponse, List<RestController.Category>.class);
            Map<Integer, RestController.Category> catMap = new Map<Integer, RestController.Category>();
            for(RestController.Category cat : categoryList) {
                catMap.put(cat.id, cat);
            }
            return catMap;
        }catch(Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public static Order getOrder(Integer Id) {
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

    public static OrderResponse sendOrder(Order ord) {
        try {
            RestControllerContext ctx = new RestControllerContext(ord);
            String restResponse = ctx.send();
            OrderResponse order = (OrderResponse)JSON.deserialize(restResponse, RestController.OrderResponse.class);
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

        public RestControllerContext(Order ord) {
            this();
            req.setMethod(RestController.POST_METHOD);
            req.setEndpoint(RestController.SERVICE_URL + ORDER_ENDPOINT);
            req.setHeader(CONTENT_TYPE, JSON_CONTENT);
            String serializedBody = JSON.serialize(ord);
            System.debug(serializedBody);
            if (String.isNotBlank(serializedBody)) {
                req.setBody(serializedBody);
                req.setHeader('Content-Length', String.valueOf(serializedBody.length()));
            }
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
        public Integer id {get;set;}
        public String name {get;set;}
        public Integer quantity_available {get;set;}
        public List<String> categories {get;set;}
        public Decimal price {get;set;}

    }

    public class ProductOrder
    {
        public Integer id {get;set;}
        public Integer quantity {get;set;}
        public Decimal unitprice {get;set;}
        public String product_id {get;set;}
    }

    public class Category
    {
        public Integer id { get; set; }
        public String name {get;set;}
        public String parent_id {get;set;}
    }

    public class Order
    {
        public Integer id {get;set;}
        public String name {get;set;}
        public Integer status {get;set;}
        public String tracking_code {get;set;}
        public String timestamp {get;set;}
        public Decimal total_price {get;set;}
        public String user_id {get;set;}
        public List<ProductOrder> products {get;set;}
    }

    public class OrderResponse
    {
        public Boolean success {get;set;}
        public List<String> error {get;set;}
        public Order order {get;set;}
    }

}



