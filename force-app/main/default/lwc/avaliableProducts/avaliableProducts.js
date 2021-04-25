import { LightningElement, api, wire, track } from 'lwc';
import getAvailableProducts from '@salesforce/apex/AvailableProductsController.getAvailableProducts';
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
    { label: 'List Price', fieldName: 'UnitPrice', sortable: true, type: 'currency', hideDefaultActions : 'true' }
];
export default class AvailableProductsController extends LightningElement {
    areDetailsVisible = false;
    columns = columns;
    dataTable = [];
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    @api recordId;
    @wire(getAvailableProducts, {OrderId : '$recordId'})
    wiredProject({error, data}){
        if (data) {
            if(data.length > 0){
                data.forEach(sortedData => {
                    let dataToTable = {};
                    dataToTable.Id = sortedData.pbEntry.Id;
                    dataToTable.Name = sortedData.pbEntry.Product2.Name;
                    dataToTable.UnitPrice = sortedData.pbEntry.UnitPrice;
                    dataToTable.Link = '/' + sortedData.pbEntry.Id;
                    this.dataTable.push(dataToTable);
                });
            }
        }else if(error){
            console.log(error);
        }
        if(this.dataTable.length > 0){
            this.areDetailsVisible = true;
        }
    }
    sortBy(field, reverse) {
        console.log(field);
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
        const cloneData = [...this.dataTable];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.dataTable = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
}