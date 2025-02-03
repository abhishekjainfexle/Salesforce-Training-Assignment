import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LwcAssi2ParentComponent extends LightningElement {

     // Flexipage provides recordId and objectApiName
     @api recordId;
     @api objectApiName;

     @track state = {
        showModalPopUpToCreateContact: false,
     }

     handleOnClick(){
        this.state.showModalPopUpToCreateContact = true;
     }

     handleClickConfirm(){
        this.state.showModalPopUpToCreateContact = false;
     }

     
     hideModalPopUpToCreateContact(){
        this.state.showModalPopUpToCreateContact = false;
     }

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: event.detail.apiName + ' created.',
                variant: 'success',
            })
        );
        this.state.showModalPopUpToCreateContact = false;

    }
    }