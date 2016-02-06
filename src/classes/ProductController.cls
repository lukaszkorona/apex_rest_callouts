/**
 * Created by koronal on 2016-02-02.
 */

public with sharing class ProductController {

    public Map<String, RestController.Product> prodMap {get;set;}
    public RestController.Product prod {get;set;}
    public Map<String, RestController.Category> catMap {get;set;}
    public Map<String, RestController.Order> orderMap {get;set;}
    public RestController.Order order {get;set;}
    public ShoppingCart cart {get;set;}
    public Integer quantityOrder {get;set;}
    public String productId;

    public ProductController() {
        cart = new ShoppingCart();
        catMap = RestController.getCategories();
        prodMap = RestController.getProducts();
        productId = ApexPages.currentPage().getParameters().get('productId');
        if (productId != null) {
            prod = RestController.getProduct(productId);
            System.debug(prod);
        }
    }

    private void getCategories() {
        catMap = RestController.getCategories();
    }

    public PageReference addToCart() {
        System.debug('quantityOrder '+quantityOrder);
        System.debug('productId '+productId);
        cart.add(Decimal.valueOf(productId), (Decimal)quantityOrder);
        return null;
    }

    public PageReference deleteCart() {
        cart.deleteCart();
        return null;
    }


}