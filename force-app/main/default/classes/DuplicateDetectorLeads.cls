global with sharing class DuplicateDetectorLeads implements
    Database.Batchable<sObject>,
    Database.Stateful
{
    Integer countTheRecordsDeleted = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(    [
            SELECT
                Id,
                Name,
                Email
            FROM
                Lead
            ORDER BY
                Name,
                Email
        ]   );
    }

    global void execute(Database.BatchableContext bc, List<Lead> leadRecords){
        Set<String> emailSet = new Set<String>();
        Set<String> nameSet = new Set<String>();
        Map<String, List<Lead>> keyToLeadListMap = new Map<String, List<Lead>>();
        List<Lead> leadListToDelete = new List<Lead>();
        for(Lead leadItr : leadRecords){
            String key='';
            if(DuplicateSetting__c.getInstance().Name__c &&
                DuplicateSetting__c.getInstance().Email__c
            ){
                // TODO: use some flags maybe
            }else if(DuplicateSetting__c.getInstance().Name__c){
                key = leadItr.Name;
            }else if(DuplicateSetting__c.getInstance().Email__c){
                if(leadItr.Email!=null)
                    key = leadItr.Email;
            }
            if(keyToLeadListMap.containsKey(key)){
                List<Lead> retrievedFromMap = keyToLeadListMap.get(key);
                retrievedFromMap.add(leadItr);
            }else{
                keyToLeadListMap.put(key, new List<Lead>{leadItr});
            }
        }
        for(String keyItr : keyToLeadListMap.keySet()){
            List<Lead> holdTheMapValues = keyToLeadListMap.get(keyItr);
            if(holdTheMapValues.size()>1){
                if(DuplicateSetting__c.getInstance().Keep_First_Record__c){
                    holdTheMapValues.remove(0);
                }
                leadListToDelete.addAll(holdTheMapValues);
            }
        }
        delete leadListToDelete;
        countTheRecordsDeleted+=leadListToDelete.size();
    }

    global void finish(Database.BatchableContext bc){
        System.debug('..............COMPLETED, DELETED: '+countTheRecordsDeleted);
    }
}