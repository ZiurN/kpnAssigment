/**
 * @description       : Test Class to validate controller behavior
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-24-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-24-2021   jefryruiz@gmail.com   Initial Version
**/
@isTest
public without sharing class AvailableProductsControllerTest {
	private static Date EffectiveDate = Date.today().addMonths(1);
	private static final String PRICEBOOK_ENTRY_NAME = 'Test Order Pricebook';
	private static final String ORDER_NAME = 'ORDER N. 001';
	@TestSetup
	static void makeData(){
		Account acc = testDataBuilder.anAccount()
			.withName('Test Account')
			.build();
		insert acc;
		Pricebook2 testOrderPriceBook =testDataBuilder.aPricebook2()
			.withName(PRICEBOOK_ENTRY_NAME)
			.build();
		insert testOrderPriceBook;
		Order testOrder = testDataBuilder.aOrder()
			.withAccount(acc)
			.withName(ORDER_NAME)
			.withPricebook2(testOrderPriceBook)
			.build();
		insert testOrder;
		/** Build 100 Products */
		List<Product2> testProducts = new List<Product2>();
		for(Integer i = 0; i > 100; i++){
			Product2 testProduct = testDataBuilder.aProduct2()
				.withActive(true)
				.withName('Test Product ' + i)
				.build();
			testProducts.add(testProduct);
		}
		insert testProducts;
		/** Add products to custom pricebook */
		List<PricebookEntry> priceBookList = new List<PricebookEntry>();
		for (Product2 product : testProducts){
			PricebookEntry priceBookEntry = testDataBuilder.aPricebookEntry()
				.withPricebook2(testOrderPriceBook)
				.withProduct2(product)
				.withActive(product.IsActive)
				.withUnitPrice(Integer.valueOf(Math.random()*10))
				.build();
			priceBookList.add(priceBookEntry);
		}
		insert priceBookList;
	}
	@isTest
	public static void returnAvailableProductListOrderedByOrderItems(){
		List<PricebookEntry> pbEntries = getPbEntriesByPbName(PRICEBOOK_ENTRY_NAME);
		List<OrderItem> orderItems = new List<OrderItem>();
		Map<Id, Integer> checkerMap = new Map<Id, Integer>();
		Order testOrder = returnOrder();
		Integer count = 1;
		for(PricebookEntry pbEntrie : pbEntries){
			OrderItem orderItem= testDataBuilder.aOrderItem()
				.withOrder(testOrder)
				.withQuantity(count)
				.withPriceBook(pbEntrie)
				.withUnitPrice(pbEntrie.UnitPrice)
				.build();
			orderItems.add(orderItem);
			checkerMap.put(pbEntrie.Id, count);
			count += 1;
		}
		insert orderItems;
		List<PricebookEntry> pbListToTable = new List<PricebookEntry>();
		Test.startTest();
			// TODO: Controller
		Test.stopTest();
		System.assertEquals(5, pbListToTable.size(), 'Five Products are expected');
		for(Integer i = 0 ; i < pbListToTable.size(); i++){
			System.assertEquals(5 - i, checkerMap.get(pbListToTable[i].Id), 'The list has to be ordered by Order Items quantity');
		}
	}
	@IsTest
	public static void addSelectProductToOrderItems(){
		Order testOrder = returnOrder();
		List<OrderItem> testOrderItems = [SELECT Id FROM OrderItem WHERE OrderId =: testOrder.Id];
		System.assertEquals(0, testOrderItems.size(), 'The Order should not have Order Items');
		List<PricebookEntry> pbEntries = getPbEntriesByPbName(PRICEBOOK_ENTRY_NAME);
		Test.startTest();
			// TODO: Controller
		Test.stopTest();
		testOrderItems = [SELECT Id FROM OrderItem WHERE OrderId =: testOrder.Id];
		System.assertEquals(5, testOrderItems.size(), 'A new Order Item should be added to the Order');
	}
	/**
	* Test Utilities
	**/
	private static List<PricebookEntry> getPbEntriesByPbName(String pbName){
		return [SELECT Product2.Name, UnitPrice FROM PricebookEntry WHERE Pricebook2.Name =: pbName LIMIT 5];
	}
	private static Order returnOrder(){
		return [SELECT id FROM Order WHERE Name =: ORDER_NAME LIMIT 1];
	}
}
