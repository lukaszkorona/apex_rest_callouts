/**
 * Created by koronal on 2016-02-06.
 */

public with sharing class OrderController {
    public RestController.OrderResponse productOrder {get;set;}
    public List<Product_Order__c> poList {get;set;}
    public Integer poId {get;set;}
    public RestController.Order order {get;set;}

    public OrderController() {
        /*Map<String, Object> orderMap = new Map<String, Object>();
        productOrder = RestController.sendOrder(orderMap);*/
        poList = [SELECT Id, Order_ext_id__c, Status__c, Total_Price__c, Owner.Id, Owner.FirstName, Owner.LastName  FROM Product_Order__c];
        if (ApexPages.currentPage().getParameters().get('productOrderId') != null) {
            poId = Integer.valueOf(ApexPages.currentPage().getParameters().get('productOrderId'));
        }
    }

    public PageReference checkStatus() {
        if (poId != null) {
            order = RestController.getOrder(poId);
        }
        System.debug('test');
        return null;
    }
}