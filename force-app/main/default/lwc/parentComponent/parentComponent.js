import { LightningElement, track } from 'lwc';

export default class ParentComponent extends LightningElement {

    @track greeting;

    handleOnChangeInput(event){
        this.greeting = event.target.value;  
    }
}