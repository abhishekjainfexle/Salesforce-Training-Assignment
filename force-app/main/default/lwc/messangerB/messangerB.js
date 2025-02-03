import { LightningElement, wire } from 'lwc';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import Messenger_Components_Communication from '@salesforce/messageChannel/MessengerComponentsCommunication__c';

export default class MessangerB extends LightningElement {
    inputMessageToSend = '';
    receivedMessage = '';
    subscription = null;

    @wire(MessageContext) messageContext;

    get isSendDisabled() {
        return this.inputMessageToSend.trim().length === 0;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                Messenger_Components_Communication,
                (message) => {
                    // Ignore messages sent by this component
                    if (message.source !== 'MessangerB') {
                        this.receivedMessage = message.message;
                    }
                }
            );
        }
    }

    handleChange(event) {
        this.inputMessageToSend = event.target.value;
    }

    handleSendMessageClick() {
        publish(this.messageContext, Messenger_Components_Communication, { 
            message: this.inputMessageToSend, 
            source: 'MessangerB'  // Identify the sender
        });
        this.inputMessageToSend = '';
    }

    clearChat() {
        this.chatHistory = [];
        this.receivedMessage = '';
    }
}