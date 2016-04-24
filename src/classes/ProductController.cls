public with sharing class ProductController {

    public Map<Integer, RestController.Product> prodMap {get;set;}
    public RestController.Product prod {get;set;}
    public Map<Integer, RestController.Category> catMap {get;set;}
    public ShoppingCart cart {get;set;}
    public Integer quantityOrder {get;set;}
    public Integer productId;

    public ProductController() {
        cart = new ShoppingCart();
        catMap = RestController.getCategories();
        prodMap = RestController.getProducts();
        if (ApexPages.currentPage().getParameters().get('productId') != null) {
            productId = Integer.valueOf(ApexPages.currentPage().getParameters().get('productId'));
        }
        if (productId != null) {
            prod = RestController.getProduct(productId);
            System.debug(prod);
        }
    }

    private void getCategories() {
        catMap = RestController.getCategories();
    }

    public PageReference addToCart() {
        cart.add(productId, (Decimal)quantityOrder);
        return null;
    }

    public PageReference deleteCart() {
        cart.deleteCart();
        return null;
    }
}