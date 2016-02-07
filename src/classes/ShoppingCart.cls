public with sharing class ShoppingCart {
    public static final String ORDER_SUCCESS_MESSAEG = 'Your request has been successfully submitted';
    public static final String ORDER_ERROR_MESSAGE = 'Something gone wrong with your request. Please contact your administrator.';
    public Map<Decimal, Decimal> prodMap {get;set;}
    public Map<Decimal, Id> cartMap {get;set;}
    public List<Shopping_Cart__c> scList {get;set;}
    public Integer size {get;set;}

    public ShoppingCart() {
        init();
    }

    private void init() {
        prodMap = new Map<Decimal, Decimal>();
        cartMap = new Map<Decimal, Id>();
        scList = [SELECT Product_Id__c, Quantity__c FROM Shopping_Cart__c WHERE Owner.Id = :UserInfo.getUserId()];
        if (scList.size() > 0) {
            for (Shopping_Cart__c sc : scList) {
                prodMap.put(sc.Product_Id__c, sc.Quantity__c);
                cartMap.put(sc.Product_Id__c, sc.Id);
            }
        }
        size = cartMap.size();
    }

    public void add(Decimal productId, Decimal quantity) {
        if (prodMap.containsKey(productId)) {
            prodMap.put(productId, prodMap.get(productId) + quantity);
            Shopping_Cart__c updSc = new Shopping_Cart__c(Id = cartMap.get(productId), Quantity__c = prodMap.get(productId));
            upsert updSc;

        } else {
            prodMap.put(productId, quantity);
            Shopping_Cart__c newSc = new Shopping_Cart__c(Product_Id__c = productId, Quantity__c = quantity);
            insert newSc;
        }
        init();
    }

    public void deleteCart() {
        List<Shopping_Cart__c> sc = [SELECT id FROM Shopping_Cart__c WHERE Owner.Id = :UserInfo.getUserId()];
        delete sc;
        init();
    }

    public PageReference checkout() {
        RestController.ProductOrder prodOrder = new RestController.ProductOrder();

        List<RestController.ProductOrder> orderList = new List<RestController.ProductOrder>();
        for (Decimal key : cartMap.keySet()) {
            RestController.ProductOrder prod = new RestController.ProductOrder();
            prod.id=key.intValue();
            prod.quantity = Integer.valueOf(prodMap.get(key));
            orderList.add(prod);
        }
        RestController.Order order = new RestController.Order();
        order.products = orderList;
        order.user_id = UserInfo.getUserId();
        RestController.OrderResponse orderResponse =  RestController.sendOrder(order);
        if (orderResponse.success == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ORDER_SUCCESS_MESSAEG));
            Product_Order__c po = new Product_Order__c();
            po.Order_ext_id__c = Decimal.valueOf(orderResponse.order.id);
            po.Status__c = Decimal.valueOf(orderResponse.order.status);
            po.Total_Price__c = orderResponse.order.total_price;
            po.Tracking_Code__c = orderResponse.order.tracking_code;
            try {
                insert po;
            }catch(Exception e) {
                System.debug(e);
            }

            deleteCart();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ORDER_ERROR_MESSAGE));
        }

        return null;
    }
}