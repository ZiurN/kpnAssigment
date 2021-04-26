import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrderItems from '@salesforce/apex/OrderProductsController.getOrderItems';
import activateOrder from '@salesforce/apex/OrderProductsController.activateOrder';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
const columns = [
	{
		label: 'Name',
		fieldName: 'Link',
		typeAttributes: {
			label: {
				fieldName: 'Name'
			},
			target: '_blank'
		},
		type: 'url',
		hideDefaultActions : 'true',
		sortable: true
	},
	{ label: 'List Price', fieldName: 'UnitPrice', sortable: true, type: 'currency', hideDefaultActions : 'true' },
	{ label: 'Quantity ', fieldName: 'Quantity', sortable: true, type: 'number', hideDefaultActions : 'true' },
	{ label: 'Total Price', fieldName: 'TotalPrice', sortable: true, type: 'currency', hideDefaultActions : 'true' }
];
export default class OrderProducts extends LightningElement {
	orderStatus = 'Draft';
	activatingOrder = false;
	areDetailsVisible = false;
	columns = columns;
	dataTable = [];
	initialOffset = 10
	initialData = [];
	defaultSortDirection = 'asc';
	sortDirection = 'asc';
	sortedBy;
	@api recordId;
	@wire(getRecord, {recordId : '$recordId', fields: ['Order.Status']})
	getRecordCallBack({error, data}){
		if(data){
			this.orderStatus = data.fields.Status.value
			this.activatingOrder = this.orderStatus === 'Activated';
		}else if(error){
			console.log(error);
		}
	}
	@wire(getOrderItems, {OrderId : '$recordId'})
	wiredProject({error, data}){
		if (data) {
			if(data.length > 0){
				data.forEach((orderItem, idx) => {
					let dataToTable = {};
					dataToTable.Id = orderItem.Id;
					dataToTable.Name = orderItem.Product2.Name;
					dataToTable.UnitPrice = orderItem.UnitPrice;
					dataToTable.Link = '/' + orderItem.Id;
					dataToTable.Quantity = orderItem.Quantity;
					dataToTable.TotalPrice = orderItem.TotalPrice;
					this.dataTable.push(dataToTable);
					if(idx < this.initialOffset){
						this.initialData.push(dataToTable);
					}
				});
			}
		}else if(error){
			console.log(error);
		}
		if(this.dataTable.length > 0){
			this.areDetailsVisible = true;
		}
	}
	activateOrder() {
		this.activatingOrder = true;
		let OrderId = this.recordId;
		activateOrder({OrderId: OrderId})
				.then(result => {
					this.sendMessageToUser(result.status, result.message);
					getRecordNotifyChange([{recordId: OrderId}]);
					if(result.orderStatus != 'Activated'){
						this.activatingOrder = false;
					}
				}).catch(error => {
					console.log(error);
					this.sendMessageToUser('error', 'Error activating the Order');
					this.activatingOrder = false;
				});
	}
	sortBy(field, reverse) {
		return function(dataA, dataB) {
			field = field == 'Link' ? 'Name' : field;
			let detailA = dataA[field];
			let detailB = dataB[field];
			if(detailA == detailB){
				return 0;
			}else {
				return (detailA > detailB ? 1 : -1) * reverse;
			}
		};
	}
	sortTable(event) {
		const { fieldName: sortedBy, sortDirection } = event.detail;
		const cloneData = [...this.initialData];
		cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
		this.initialData = cloneData;
		this.sortDirection = sortDirection;
		this.sortedBy = sortedBy;
	}
	loadMoreProducts(){
		let totalElements = this.dataTable.length;
		let offSet = this.initialOffset;
		let currentVisibleElements = this.initialData.length;
		if(totalElements === currentVisibleElements){
			return;
		}
		if(totalElements < offSet){
			this.initialData = this.dataTable;
			return;
		}else{
			let nextOffSet = currentVisibleElements + offSet;
			if(totalElements < nextOffSet){
				this.initialData = this.dataTable;
			}else{
				this.initialData = this.initialData.concat(this.dataTable.slice(currentVisibleElements, nextOffSet));
			}
		}
	}
	sendMessageToUser(status, message){
		const evt = new ShowToastEvent({
			message: message,
			variant: status,
		});
		this.dispatchEvent(evt);
	}
}