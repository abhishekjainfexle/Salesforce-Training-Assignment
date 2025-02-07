import { LightningElement, track, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

export default class GenericPicklistComponent extends LightningElement {
    @api objectName;
    @api fieldName;
    @api labelToShow;

    @track state = {
        PicklistOptions: [{ label: '--None--', value: '' }],
        errors: {},
        value: ''
    };

    @track props = {
        objectApiName: '$objectName',
        fieldApiName: '$fieldName'
    };
    // get label() {
    //     return `${this.fieldName || ''}`;
    // }

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: '$fieldName',
    })
    picklistValues({ data, error }) {
        if (data) {
            console.log('Picklist Data:', JSON.stringify(data));

            // Correctly assign a new array to trigger reactivity
            this.state.PicklistOptions = [
                { label: '--None--', value: '' },
                ...data.values.map(item => ({ label: item.label, value: item.value }))
            ];
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }

    handleChange(event) {
        this.state.value = event.detail.value;
        this.dispatchEvent(
            new CustomEvent("selectedvalue", {
                detail: {
                    value: event.detail.value
                }
            })
        );
    }
}