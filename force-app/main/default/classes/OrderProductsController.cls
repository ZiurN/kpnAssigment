/**
 * @description       : Controller Class of the LWC OrderProducts
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
public with sharing class OrderProductsController {
	@AuraEnabled(cacheable=true)
	public static List<OrderItem> getOrderItems(Id OrderId){
		try {
			return [SELECT Product2.Name,
						Quantity,
						UnitPrice,
						TotalPrice
					FROM OrderItem
					WHERE OrderId =: OrderId
					WITH SECURITY_ENFORCED];
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	@AuraEnabled
	public static Response activateOrder(Id OrderId){
		Response frontResponse = new Response();
		try {
			Order order = [SELECT Status FROM Order WHERE Id =: OrderId WITH SECURITY_ENFORCED];
			// TODO: Call to external System
			order.Status = 'Activated';
			Database.SaveResult result = Database.update(order);
			if(result.isSuccess()){
				frontResponse.status = 'success';
				frontResponse.message = 'Order Activated successfully';
				frontResponse.orderStatus = 'Activated';
			}else {
				frontResponse.status = 'error';
				frontResponse.message = result.getErrors()[0].getMessage();
			}
		} catch (Exception e) {
			frontResponse.status = 'error';
			frontResponse.message = e.getMessage();
		}
		return frontResponse;
	}
	public class Response extends AuraResponse {
		@AuraEnabled public String orderStatus;
	}
}