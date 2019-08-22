/**
 * @File Name          : DuplicateDetectorLeads.cls
 * @Description        : 
 * @Author             : Mahesh Biswas
 * @Group              : 
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/22/2019, 12:38:46 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/22/2019, 12:29:36 PM   Mahesh Biswas     Initial Version
**/
global with sharing class DuplicateDetectorLeads implements
    Database.Batchable<sObject>,
    Database.Stateful
{
    Integer countTheRecordsDeleted = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Dup_name: '+DuplicateSetting__c.getInstance().Name__c+'Dup_email: '+DuplicateSetting__c.getInstance().Email__c+'Dup_Keep1st: '+DuplicateSetting__c.getInstance().Keep_First_Record__c);
        return Database.getQueryLocator(    [
            SELECT
                Id,
                Name,
                Email
            FROM
                Lead
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
                // HOW about this approach?
                key = leadItr.Name+':'+leadItr.Email;
            }else if(DuplicateSetting__c.getInstance().Name__c){
                key = leadItr.Name;
            }else if(DuplicateSetting__c.getInstance().Email__c){
                if(!String.isBlank(leadItr.Email)){
                    key = leadItr.Email;
                }else{
                    continue;
                }
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