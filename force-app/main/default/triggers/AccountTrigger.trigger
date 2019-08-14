trigger AccountTrigger on Account (before update) {
    if(TriggerSetting__c.getInstance().AccountTrigger__c){
        AccountTriggerHandler accountTriggerHandlerObject = new AccountTriggerHandler();
        if(Trigger.isBefore && Trigger.isUpdate){
            accountTriggerHandlerObject.createAccountRecordClones(Trigger.old);
        }
    }

}