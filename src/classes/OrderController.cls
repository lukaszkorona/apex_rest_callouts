public with sharing class OrderController {
    public List<Product_Order__c> poList {get;set;}
    public Integer poId {get;set;}
    public RestController.Order order {get;set;}

    public OrderController() {
        poList = [SELECT Id, Order_ext_id__c, Status__c, Total_Price__c, Owner.Id, Owner.FirstName, Owner.LastName, LastModifiedDate  FROM Product_Order__c ORDER By LastModifiedDate DESC];
        if (ApexPages.currentPage().getParameters().get('productOrderId') != null) {
            poId = Integer.valueOf(ApexPages.currentPage().getParameters().get('productOrderId'));
        }
    }

    public PageReference checkStatus() {
        if (poId != null) {
            order = RestController.getOrder(poId); 
        }
        return null;
    }


}