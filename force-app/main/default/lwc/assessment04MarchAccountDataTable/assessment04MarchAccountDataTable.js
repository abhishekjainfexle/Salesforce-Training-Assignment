import { LightningElement, track, wire } from 'lwc';
import getAccount from '@salesforce/apex/Assessment04MarchLWCController.getAccounts';
import createAccount from '@salesforce/apex/Assessment04MarchLWCController.createAccount';
import createContact from '@salesforce/apex/Assessment04MarchLWCController.createContact';
import { ACCOUNT_DATA_TABLE_COLOUMNS } from './Constant/Assessment04MarchAccountDataTableConstant';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Assessment04MarchAccountDataTable extends LightningElement {

    get columns() {
        return ACCOUNT_DATA_TABLE_COLOUMNS;
    }

    @track state = {
        accountList: [],
        error: null,
        showModalPopUpToCreateAccount: false,
        showModalPopUpToCreateContact: false,
        name: '',
        phone: '',
        accountNumber: '',
        firstNameInput: '',
        lastNameInput: '',
        emailInput: '',
        phoneInput: '',
        lastNameError: '',
        emailError: '',
        accountId: '',
        accNameToShowInContact: '',
    }

    @wire(getAccount)
    wiredAccounts(result) {
        this.wiredListResult = result; 
        if(result.data){
            this.state.accountList = result.data;
            console.log('asdf', JSON.stringify(result.data));
            this.state.error = undefined; 
        }else if (result.error){
            this.state.error = result.error; 
            this.state.accountList = undefined;
        }
    }

    handleCreateAccountButtonPopUpOnClick(){
        this.state.showModalPopUpToCreateAccount = true;
    }

    hideModalPopUpToCreateAccount(){
        this.state.showModalPopUpToCreateAccount = false;
        // Reset input fields
        this.state.name = '';
        this.state.phone = '';
        this.state.accountNumber = '';
       
    }

    onChangeAccountInput(event) {
        const fieldName = event.target.label;
        const value = event.target.value.trim();
    
        if (fieldName === 'Name') {
            this.state.name = value;
            this.state.accNameToShowInContact = value;
        } else if (fieldName === 'Phone') {
            this.state.phone = value;
        } else {
            this.state.accountNumber = value;
        }
    }

    handleCreateNewAccountButtonOnClick(){
        createAccount({
                        accName: this.state.name,
                        accountNumber: this.state.accountNumber,
                        phone: this.state.phone,
                    })
                    .then((result) => {
                        this.state.showModalPopUpToCreateContact = true;
                        this.state.showModalPopUpToCreateAccount = false;
                        this.state.accountId = result;

                        console.log("success message-->", JSON.stringify(result));
                        this.dispatchEvent(
                          new ShowToastEvent({
                            title: "Success",
                            message: "Account Created Successfully",
                            variant: "success"
                          })
                        );
                        this.hideModalPopUpToCreateAccount();
                        refreshApex(this.wiredListResult);
                      })
                      .catch((error) => {
                        this.dispatchEvent(
                          new ShowToastEvent({
                            title: "Error",
                            message: "Account Record Not Created",
                            variant: "error"
                          })
                        );
                        console.log("Error:-->", error);
                      });
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

                handleCreateNewContactButtonOnClick(){
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
                        accId: this.state.accountId,
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

                get showLastNameError() {
                    return this.state.isSubmitted && this.state.lastNameError;
                }
                
                get showEmailError() {
                    return this.state.isSubmitted && this.state.emailError;
                }
    }