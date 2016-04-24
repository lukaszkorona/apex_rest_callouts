/**
 * Created by lkorona on 4/17/16.
 */

public with sharing class HttpCallout {

    public static HttpResponse callout(String httpMethod, String endpoint, String body) {
        HttpRequest req = new HttpRequest();

        req.setMethod(httpMethod);

        req.setEndpoint(endpoint);

        if (String.isNotBlank(body)) {
            req.setBody(body);
            req.setHeader('Content-Length', String.valueOf(body.length()));
        }
        req.setTimeout(120000);
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setCompressed(true);

        HttpResponse res = new http().send();
        System.debug(res.toString());
        System.debug(res.getBody());
        return res;
    }
}