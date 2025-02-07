import { LightningElement, track, wire } from 'lwc';
import { ACCOUNT_MANAGER_DATA_TABLE_COLOUMNS } from './Constant/accountManagerFetchConstant';
import getAccount from '@salesforce/apex/AccountManagerController.getAccount';

export default class AccountManagerFetch extends LightningElement {

    @track accounts;
    @track error;

    // Getter for columns (you may want to include logic here for actual columns)
    get columns() {
        return ACCOUNT_MANAGER_DATA_TABLE_COLOUMNS;
    }

    @wire (getAccount)
	wiredAccounts({data, error}){
		if(data) {
			this.accounts =data;
			this.error = undefined;
		}else {
			this.accounts =undefined;
			this.error = error;
		}
	}
}