/**
 * Created by koronal on 2016-02-01.
 */

public with sharing class SmallPostController {
    public List<RestController.SmallPost> spList {get;set;}
    public List<RestController.User> userResponse {get;set;}

    public SmallPostController()
    {
        //spList = RestController.getPosts();
        userResponse = RestController.getUsers();
        System.debug('userResponse '+userResponse);
    }
}