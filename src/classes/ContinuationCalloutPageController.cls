/**
 * Created by koronal on 2016-03-25.
 */

public with sharing class ContinuationCalloutPageController {
    public static String URL = 'http://durationservice.herokuapp.com/long?duration=';
    public String result {get;set;}
    public Integer callbackCount {get;set;}

    public ContinuationCalloutPageController() {
        this.callbackCount = 0;
    }

    Integer defaultDuration = 1000;
    public Integer duration = 0;
    public Integer getDuration() {
        return duration;
    }
    public void setDuration(Integer value) {
        duration = value;
    }

    public String requestlabel;

    public Object submit() {
        if (duration <= 0) {
            duration = defaultDuration;
        }
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL + duration);
        request.setMethod('GET');
        request.setTimeout(60000);

        Continuation cont = new Continuation(60);
        this.requestlabel = cont.addHttpRequest(request);
        cont.continuationMethod = 'processContinuationResponse';

        return cont;
    }

    public Object processContinuationResponse() {
        System.debug('Callback called');
        HttpResponse response = Continuation.getResponse(this.requestlabel);
        System.debug('Got response: '+ response.getBody());
        Integer statusCode = response.getStatusCode();
        System.debug('response Code : '+statusCode);
        if (statusCode != 200) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, response.getBody()));
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, response.getBody()));
        }
        return null;
    }

}