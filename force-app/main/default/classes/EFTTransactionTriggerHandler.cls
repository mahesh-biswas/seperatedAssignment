/*
    CLASS:  EFTTransactionTriggerHandler
    ----------------------------
    This is a Handler Class for EFTTransactionTrigger.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created Trigger Handler class
                                                for the EFT_Transaction_Status__c related trigger.
                                                Checks for few conditions on
                                                EFT_Transaction_Status__c's field Value and it's
                                                parent SalesHeader__c's field value,
                                                and Based on that Creates new record in case.
*/
public with sharing class EFTTransactionTriggerHandler {

    /**
        Creates new Case Record if certain field values of EFT_Transaction_Status__c
        and SalesHeader__c satisfies the given criterion.
        Criterion:
            1:>     EFT's Field
                        1)      Method_Name__c          =   "Credit Card Address Verify"
                        2)      Transaction_Status__c   =   "Declined"
            2:>     SalesHeader's Fields
                        1)      Status__c               =   "Open"

        QUESTION:
            Address Did Not Verify – AVS:
                on INSERTION of a EFT_Transaction_Status's record, some criterion to be
                evaluated, if satisfied then create an Case record as well.
    */
    public static void AddressDidNotVerify(List<EFT_Transaction_Status__c> eftList){
        List<Case> caseList = new List<Case>();
        Map<String,SalesHeader__c> salesHeaderMap = new Map<String,SalesHeader__c>();
        Set<String> idSet = new Set<String>();
        for(EFT_Transaction_Status__c efts : eftList){
            // System.debug(efts);
            idSet.add(efts.SalesHeader_Lookup__c);
        }
        for(SalesHeader__c shItr : [
                SELECT
                    Status__c,
                    Name,
                    Id,
                    Account_Lookup__c,
                    Account_Lookup__r.Name,
                    Contack_Lookup__c,
                    Contack_Lookup__r.Name
                FROM
                    SalesHeader__c
                WHERE
                    Id IN :idSet
        ]   ){
            salesHeaderMap.put(shItr.Id,shItr);
        }
        Group avsQueue= [
            SELECT
                Id,
                Name
            FROM
                Group
            WHERE
                Type = 'Queue' AND Name = 'AVS'
            LIMIT
                1
        ];
        /*RecordType assignmentRecordType = [
            SELECT
                Id,
                Name,
                SobjectType
            FROM
                RecordType
            WHERE
                SobjectType = 'Case' AND Name = 'Assignment'
            LIMIT
                1
        ];*/
        // MODIFIED...
        Map<String, Schema.RecordTypeInfo> recordTypeMap =
            Schema.SObjectType.Case.getRecordTypeInfosByName();

        Integer failedcount = 0;
        for(EFT_Transaction_Status__c efts : eftList){
            SalesHeader__c shObject = salesHeaderMap.get(efts.SalesHeader_Lookup__c);
            if( efts.Method_Name__c == 'Credit Card Address Verify'
                && efts.Transaction_Status__c == 'Declined'
                && shObject.Status__c == 'Open'
                ){
                    Case tmpCase = new Case();
                    if(avsQueue!=null){
                        tmpCase.OwnerId = avsQueue.Id;
                    }
                    if(recordTypeMap.containsKey('Assignment')){
                        tmpCase.RecordTypeId = recordTypeMap.get('Assignment').getRecordTypeId();
                    }
                    tmpCase.AccountId = shObject.Account_Lookup__c;
                    tmpCase.ContactId = shObject.Contack_Lookup__c;
                    tmpCase.Origin = 'Internal';
                    tmpCase.Reason = 'Address Did Not Verify';
                    tmpCase.Priority = 'High';
                    tmpCase.Status = 'New';
                    tmpCase.Type = 'Address Did Not Verify';
                    tmpCase.Subject = shObject.Account_Lookup__r.Name + ' ' + tmpCase.Type;
                    tmpCase.Open_Sales_Order__c = shObject.Id;
                    tmpCase.Transaction_Status__c = efts.Transaction_Status__c;
                    tmpCase.Sales_Order_Number__c = shObject.Name;
                    tmpCase.Order_Date__c = efts.Transaction_Date__c;
                    caseList.add(tmpCase);
                }else{
                    failedcount++;
                    // System.debug(efts.Method_Name__c+' > '+efts.Transaction_Status__c+' > '+shObject.Status__c);
                }
        }
        System.debug('failed = '+failedcount+' out of '+eftList.size());
        insert caseList;
    }
}