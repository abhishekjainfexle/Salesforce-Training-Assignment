import { LightningElement, track } from 'lwc';

export default class CustomCalculator extends LightningElement {

    @track state = {
        no1: '',
        no2:  '',
        result: ''
    }

    handlechange(event) {
        const currentInputName = event.target.label;
        const currentval = event.target.value;
        if (currentInputName === 'Number_1') {
            this.state.no1 = currentval;
        } else {
            this.state.no2 = currentval;
        }
    }

    handleValidation() {
        let number_1 = this.template.querySelector(".number1");
        let number_2 = this.template.querySelector(".number2");

        if (!number_1.value || isNaN(number_1.value) || !Number.isInteger(Number(number_1.value))) {
            number_1.setCustomValidity("Please provide a valid integer value.");
        } else {
            number_1.setCustomValidity(""); // Clear previous validation error
        }
        number_1.reportValidity();

        if (!number_2.value || isNaN(number_2.value) || !Number.isInteger(Number(number_2.value))) {
            number_2.setCustomValidity("Please provide a valid integer value.");
        } else {
            number_2.setCustomValidity(""); // Clear previous validation error
        }
        number_2.reportValidity();
        
    }

    doAdd() {
        this.state.result = parseInt(this.state.no1) + parseInt(this.state.no2);
    }

    doDiv() {
        this.state.result = parseInt(this.state.no1) / parseInt(this.state.no2);
    }

    doMul() {
        this.state.result = parseInt(this.state.no1) * parseInt(this.state.no2);
    }

    doSub() {
        this.state.result = parseInt(this.state.no1) - parseInt(this.state.no2);
    }

    get resultClass() {
        
        if ( !this.state.result || isNaN(this.state.result)) {
            return 'slds-text-color_default';
        }
        return this.state.result > 0 
            ? 'slds-text-color_success' 
            : this.state.result < 0 
            ? 'slds-text-color_error' 
            : 'slds-text-color_default';
    }

    get resultMessage() {
        if ( !this.state.result || isNaN(this.state.result)) {
            return 'Enter values to see the result';
        }
        return `${this.state.result}`;
    }

    constructor(){
        super();
        console.log('Constructor');
    }

    connectedCallback(){
        console.log('connectedCallBack');
    }

    renderedCallback(){
        console.log('renderedCallback');
    }
}