/**
 * @description       : Class dedicate to Callouts
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-27-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
public without sharing class CalloutUtils {
	public static HttpResponse call(String msgBody, String endpoint, String method){
		HttpRequest request = new HttpRequest();
		request.setBody(msgBody);
		request.setEndpoint(endpoint);
		request.setMethod(method);
		Http h = new Http();
		HttpResponse response = h.send(request);
		return response;
	}
}