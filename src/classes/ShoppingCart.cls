/**
 * Created by koronal on 2016-02-02.
 */

public with sharing class ShoppingCart {
   /* public Integer productId {get;set;}
    public Integer quantity {get;set;}*/
    public Map<Decimal, Decimal> prodMap {get;set;}
    public Map<Decimal, Id> cartMap {get;set;}
    public List<Shopping_Cart__c> scList {get;set;}

    public ShoppingCart() {
        init();

    }

    private void init() {
        prodMap = new Map<Decimal, Decimal>();
        cartMap = new Map<Decimal, Id>();
        scList = [SELECT Product_Id__c, Quantity__c FROM Shopping_Cart__c WHERE Owner.Id = :UserInfo.getUserId()];
        System.debug('scList '+scList);
        if (scList.size() > 0) {
            for (Shopping_Cart__c sc : scList) {
                prodMap.put(sc.Product_Id__c, sc.Quantity__c);
                cartMap.put(sc.Product_Id__c, sc.Id);
            }
        }
        System.debug('cartMap '+cartMap);
    }

    public void add(Decimal productId, Decimal quantity) {
        System.debug('productId '+productId);
        System.debug('quantity ' +quantity);
        if (prodMap.containsKey(productId)) {
            prodMap.put(productId, prodMap.get(productId) + quantity);
            Shopping_Cart__c updSc = new Shopping_Cart__c(Id = cartMap.get(productId), Quantity__c = prodMap.get(productId));
            upsert updSc;

        } else {
            prodMap.put(productId, quantity);
            Shopping_Cart__c newSc = new Shopping_Cart__c(Product_Id__c = productId, Quantity__c = quantity);
            insert newSc;
        }
        System.debug('prodmap '+prodmap);
        init();
    }

    public void deleteCart() {
        List<Shopping_Cart__c> sc = [SELECT id FROM Shopping_Cart__c WHERE Owner.Id = :UserInfo.getUserId()];
        delete sc;
        init();
    }

    public PageReference checkout() {
        for ()
        RestController.sendOrder()
        Product_Order__c po = new Product_Order__c();
        return null;
    }
}