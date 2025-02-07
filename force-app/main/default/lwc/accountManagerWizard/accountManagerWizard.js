import { LightningElement, api, track, wire } from 'lwc';
import { CONTACT_DATA_TABLE_COLOUMNS } from './constant/accountManagerWizardConstant';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import { getRecord } from "lightning/uiRecordApi";
import createContact from '@salesforce/apex/LWCAccountManagerWizardController.createContact';
import getContact from '@salesforce/apex/LWCAccountManagerWizardController.getContacts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = ["Account.Name",];

export default class AccountManagerWizard extends LightningElement {

    @api recordId; // Record ID of the Account
    @api objectApiName;

    // Owned locally & Mutable Properties
    @track state = {
        rowOffset: 0,
        draftValues: [],
        error: null,
        resultData: [], // Initialize resultData as an empty array
        filteredContacts: [], // Stores filtered contacts for search
        searchKey: '',
        showModalPopUpToCreateContact: false,
        accountName: "",
        firstNameInput: '',
        lastNameInput: '',
        emailInput: '',
        phoneInput: '',
        lastNameError: '',
        emailError: '',
        value: '',
    };

    wiredListResult;

    @track props = {
        columns: CONTACT_DATA_TABLE_COLOUMNS,
        relatedObjectApiName: 'Contacts',
        fieldApiNames: ['Contact.Id', 'Contact.FirstName', 'Contact.LastName', 'Contact.Phone', 'Contact.Email', 'Contact.AccountId'],
    };

    //Wire the Account Name to show in Create Contact
    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.state.accountName = data.fields.Name.value;
        } else if (error) {
            console.error("Error retrieving account:", error);
            this.state.accountName = "No Name Available";
        }
    }
      
    @wire (getContact, {accId: '$recordId'})
        wiredContacts(result) {
        this.wiredListResult = result; // Track the result for refreshApex
        // console.log('json', JSON.stringify(this.wiredListResult));
        //const { error, data } = result;
        if (result.data) {
            this.state.resultData = result.data.map(record => ({
                id: record.Id,
                firstName: record.FirstName || '',
                lastName: record.LastName || '',
                phone: record.Phone || '',
                email: record.Email || ''
            }));
            this.state.filteredContacts = this.state.resultData;
            this.state.error = undefined;
        } else if (result.error) {
            this.state.error = result.error;
            this.state.resultData = [];
            this.state.filteredContacts = [];
        }
	}
    handleSearchInputChange(event){
            this.state.searchKey = event.target.value.toLowerCase();        
            // Ensure contacts array exists before filtering
            if (!this.state.resultData || this.state.resultData.length === 0) {
                this.state.filteredContacts = [];
                return;
            }
            // Filter contacts based on searchKey
            if (this.state.searchKey) {
                this.state.filteredContacts = this.state.resultData.filter(contact => {
                    const searchTerm = this.state.searchKey.toLowerCase();
                    return (
                        (contact.firstName && contact.firstName.toLowerCase().includes(searchTerm)) ||
                        (contact.lastName && contact.lastName.toLowerCase().includes(searchTerm)) ||
                        (contact.email && contact.email.toLowerCase().includes(searchTerm)) ||
                        (contact.phone && contact.phone.toLowerCase().includes(searchTerm))
                    );
                });
                
            } 
            else {
                this.state.filteredContacts = [...this.state.resultData]; // Reset to original data when search is cleared
            }
    }

    onChangeContactInput(event) {
        const fieldName = event.target.label;
        const value = event.target.value.trim();
    
        if (fieldName === 'FirstName') {
            this.state.firstNameInput = value;
        } else if (fieldName === 'LastName') {
            this.state.lastNameInput = value;
        } else if (fieldName === 'Email') {
            this.state.emailInput = value;
        } else {
            this.state.phoneInput = value;
        }
    }
    

        handleCreateNewButtonOnClick(){
            this.state.isSubmitted = true; // Mark form as submitted

            // Validate Last Name (must not be empty)
            this.state.lastNameError = this.state.lastNameInput === '' ? 'Last Name cannot be blank' : '';

            // Validate Email (only if entered)
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            this.state.emailError = this.state.emailInput && !emailRegex.test(this.state.emailInput)
                ? 'Enter a valid email address'
                : '';

            // Stop execution if validation fails
            if (this.state.lastNameError || this.state.emailError) {
                return;
            }

            createContact({
                firstName: this.state.firstNameInput,
                lastName: this.state.lastNameInput,
                email: this.state.emailInput,
                phone: this.state.phoneInput,
                accId: this.recordId,
                customerstatus: this.state.value
            })
            .then((result) => {
                this.state.showModalPopUpToCreateContact = false;
                console.log("success message-->", result);
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Success",
                    message: "Contact Created Successfully",
                    variant: "success"
                  })
                );
                this.hideModalPopUpToCreateContact();
                refreshApex(this.wiredListResult);
              })
              .catch((error) => {
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Error",
                    message: "Contact Record Not Created",
                    variant: "error"
                  })
                );
                console.log("Error:-->", error);
              });
        }

            get isNoResults() {
                return this.state.filteredContacts.length === 0 && this.state.searchKey !== ''; 
            }  
            
            handleCreateContactButtonPopUpOnClick(){
                this.state.showModalPopUpToCreateContact = true;
            }

            hideModalPopUpToCreateContact(){
                this.state.showModalPopUpToCreateContact = false;
                // Reset input fields
                this.state.firstNameInput = '';
                this.state.lastNameInput = '';
                this.state.emailInput = '';
                this.state.phoneInput = '';

                // Reset validation errors
                this.state.lastNameError = '';
                this.state.emailError = '';

                // Reset submission attempt flag
                this.state.isSubmitted = false;
            }
            get showLastNameError() {
                return this.state.isSubmitted && this.state.lastNameError;
            }
            
            get showEmailError() {
                return this.state.isSubmitted && this.state.emailError;
            }

            handleEvent(event){
                this.state.value = event.detail.value; 
                console.log('value@@', JSON.stringify(this.state.value));
            }
}