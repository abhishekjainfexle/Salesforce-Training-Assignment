import { LightningElement, api } from 'lwc';

//Import static resources
// import { loadStyle } from 'lightning/platformResourceLoader';
// import lightningModalResource from '@salesforce/resourceUrl/lightningModalResource';

const SLDS_MADAL_SMALL = ' slds-modal_small';
const SLDS_MADAL_MEDIUM = ' slds-modal_medium';
const SLDS_MADAL_LARGE = ' slds-modal_large';

export default class LwcAssi2ChildComponent extends LightningElement {
  @api isSmallModal = false;
  @api isLargeModal = false;
  modalClass = 'slds-modal slds-fade-in-open';

//   renderedCallback() {
//     Promise.all([loadStyle(this, lightningModalResource)]).catch(() => {});
//   }



  closeModal() {
    const selectedEvent = new CustomEvent('closelightningmodalpopup', {
        composed: true,
        bubbles: true,
        cancelable: true
      });
       this.dispatchEvent(selectedEvent);
  }

  get getModalSizeClass() {
    if (this.isSmallModal) {
      this.modalClass = this.modalClass + SLDS_MADAL_SMALL;
    } else if (this.isLargeModal) {
      this.modalClass = this.modalClass + SLDS_MADAL_LARGE;
    } else {
      this.modalClass = this.modalClass + SLDS_MADAL_MEDIUM;
    }
    return this.modalClass;
  }
}