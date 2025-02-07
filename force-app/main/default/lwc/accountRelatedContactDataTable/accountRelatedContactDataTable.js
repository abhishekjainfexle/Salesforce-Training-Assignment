import { LightningElement, api, track, wire } from 'lwc';
import { CONTACT_DATA_TABLE_COLOUMNS } from './ContactConstant/accountRelatedContactDataTableConstant';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import updateContacts from '@salesforce/apex/ContactController.updateContacts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountRelatedContactDataTable extends LightningElement {
    @api recordId; // Record ID of the Account
    rowOffset = 0;
    @track draftValues = [];
    @track error;
    @track resultData = []; // Initialize records as an empty array

    // Tracks the wired data for refreshing later
    @track wiredListResult;

    // Getter to fetch columns from constants
    get columns() {
        return CONTACT_DATA_TABLE_COLOUMNS;
    }

    // Wire the related list records using the Lightning UI API
    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId', // Use '$' to bind the recordId dynamically
        relatedListId: 'Contacts', // API name of the related list
        fields: ['Contact.Id', 'Contact.FirstName', 'Contact.LastName', 'Contact.Phone', 'Contact.Email'], // Fields to fetch
    })
    wiredContacts(result) {
        this.wiredListResult = result; // Track the result for refreshApex
        const { error, data } = result;
        if (data) {
            this.resultData = data.records.map(record => ({
                id: record.fields.Id.value,
                firstName: record.fields.FirstName.value || '',
                lastName: record.fields.LastName.value || '',
                phone: record.fields.Phone.value || '',
                email: record.fields.Email.value || '',
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.resultData = [];
        }
    }

    // Handle inline editing save event
    async handleOnSave(event) {
        const updatedContacts = event.detail.draftValues.map(draft => ({
            Id: draft.id,
            FirstName: draft.firstName,
            LastName: draft.lastName,
            Phone: draft.phone,
            Email: draft.email,
        }));

        await updateContacts({ contacts: updatedContacts })
            .then(() => {
                // Show success toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact records updated successfully.',
                        variant: 'success',
                    })
                );

                // Clear draft values
                this.draftValues = [];

                // Refresh the datatable
                return refreshApex(this.wiredListResult);
            })
            .catch(error => {
                console.error('Error updating contacts:', error);
                // Show error toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to update Contact records.',
                        variant: 'error',
                    })
                );
            });
    }

    // Clear draft values on cancel
    handleOnCancel() {
        this.draftValues = [];
    }
}