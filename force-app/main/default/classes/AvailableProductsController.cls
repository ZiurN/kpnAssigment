/**
 * @description       : Controller class of the LWC AvailableProducts
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-24-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-24-2021   jefryruiz@gmail.com   Initial Version
**/
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class AvailableProductsController {
	/**
	* @description get the Product in the priceboot associated with Order sortered by quantity.
	* @author jefryruiz@gmail.com | 04-24-2021
	* @param OrderId
	* @return List<PBEntrySortable>
	**/
	@AuraEnabled
	public static List<PBEntrySortable> getAvailableProducts(Id OrderId){
		try {
			Order order = [SELECT Pricebook2Id FROM Order WHERE id =: OrderId];
			List<PricebookEntry> pbEntries = [SELECT Product2.Name,
													UnitPrice
												FROM PricebookEntry
												WHERE Pricebook2Id =: order.Pricebook2Id];
			List<OrderItem> orderItems = [SELECT PricebookEntryId,
												Quantity
											FROM OrderItem
											WHERE OrderId =: OrderId];
			Map<Id, Integer> pbEntryByQuantityInOrder = new Map<Id, Integer>();
			for(OrderItem orderItem : OrderItems) {
				pbEntryByQuantityInOrder.put(orderItem.PricebookEntryId, Integer.valueOf(orderItem.Quantity));
			}
			List<PBEntrySortable> pbSortables = new List<PBEntrySortable>();
			for(PricebookEntry pbEntry : pbEntries){
				PBEntrySortable pbSortable;
				if(pbEntryByQuantityInOrder.keySet().contains(pbEntry.Id)){
					pbSortable = new PBEntrySortable(pbEntryByQuantityInOrder.get(pbEntry.Id), pbEntry);
				}else{
					pbSortable = new PBEntrySortable(0, pbEntry);
				}
				pbSortables.add(pbSortable);
			}
			pbSortables.sort();
			return pbSortables;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	public class PBEntrySortable implements Comparable{
		public PricebookEntry pbEntry;
		public Integer productQuantityInOrder;
		public PBEntrySortable(Integer productQuantityInOrder, PricebookEntry pbEntry){
			this.pbEntry = pbEntry;
			this.productQuantityInOrder = productQuantityInOrder;
		}
		public Integer compareTo(Object compareTo){
			PBEntrySortable compareToPbEntry = (PBEntrySortable)compareTo;
			Integer value = 0;
			if(productQuantityInOrder > compareToPbEntry.productQuantityInOrder){
				value = -1;
			}else if(productQuantityInOrder < compareToPbEntry.productQuantityInOrder){
				value = 1;
			}else if(productQuantityInOrder == null && compareToPbEntry.productQuantityInOrder != null){
				value = 1;
			}else if(productQuantityInOrder != null && compareToPbEntry.productQuantityInOrder == null){
				value = -1;
			}
			return value;
		}
	}
}
