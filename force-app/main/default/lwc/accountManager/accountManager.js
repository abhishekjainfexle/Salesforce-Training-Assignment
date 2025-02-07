import { LightningElement, track } from 'lwc';
import { ACCOUNT_MANAGER_DATA_TABLE_COLOUMNS } from './Constant/accountManagerConstant';
import getAccount from '@salesforce/apex/AccountManagerController.getAccount';

export default class AccountManager extends LightningElement {

    @track accounts;
    @track error;

    // Getter for columns (you may want to include logic here for actual columns)
    get columns() {
        return ACCOUNT_MANAGER_DATA_TABLE_COLOUMNS;
    }

    // Fetch accounts when component is initialized
    connectedCallback() {
        this.fetchAccounts(); // Corrected to invoke the method
    }

    // Method to fetch account data from Apex
    fetchAccounts() {
        getAccount()
            .then(result => {
                this.accounts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
            })
    }
}