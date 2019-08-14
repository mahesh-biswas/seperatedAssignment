trigger ContactTrigger on Contact (before insert, before update) {
    if(TriggerSetting__c.getInstance().ContactTrigger__c){
        if(Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate)){
            System.debug(
                '-------Before:' +
                ' insert?' + Trigger.isInsert +
                ' update?' + Trigger.isUpdate
            );
            ContactTriggerHandler contactTriggerHandlerObject = new ContactTriggerHandler();
            contactTriggerHandlerObject.duplicateCheck(Trigger.new);
            contactTriggerHandlerObject.createLinkParent(Trigger.new);
        }
    }
}