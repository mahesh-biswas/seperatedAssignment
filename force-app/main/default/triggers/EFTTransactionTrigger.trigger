trigger EFTTransactionTrigger on EFT_Transaction_Status__c (before insert) {
    if(TriggerSetting__c.getInstance().EFTTransactionTrigger__c){
        if(Trigger.isBefore && Trigger.isInsert){
            EFTTransactionTriggerHandler.AddressDidNotVerify(Trigger.new);
        }
    }
}