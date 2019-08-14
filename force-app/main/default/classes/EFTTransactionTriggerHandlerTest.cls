/*
    CLASS:  EFTTransactionTriggerHandlerTest
    ----------------------------
    This is a Test Class for EFTTransactionTriggerHandler.
    ---------------------------------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created Test Class for the
                                                EFT_Transaction_Status__c related trigger.
                                                Checks if Trigger executes for few conditions on
                                                EFT_Transaction_Status__c's field Value and it's
                                                parent SalesHeader__c's field value.
*/
@isTest
public with sharing class EFTTransactionTriggerHandlerTest {

    /***
        > INITIAL RECORDS.
            1:)     Create an Account's Record.
            2:)     Create an contact's Record.
            3:)     Create an SalesHeader__c's Record.
        > TESTING PHASE.
            1:)     Add an EFT's Record with satisfying Trigger Condition.
            2:)     Add an EFT's Record with unsatisfied Trigger Condition.

        :>  SATISFYING CRITERION
            1:>     EFT's Field
                        1)      Method_Name__c          =   “Credit Card Address Verify”
                        2)      Transaction_Status__c   =   “Declined”
            2:>     SalesHeader's Fields
                        1)      Status__c               =   “Open”
        :>  ON SUCCESS
            Case Record Should Increase.
    */
    @isTest
    public static void AddressDidNotVerify_PositiveCase(){
        //  Create Custom Setting for activating the trigger
        insert new TriggerSetting__c(EFTTransactionTrigger__c = True);
        //     INITIAL RECORDS
        //  ACCOUNT
        List<Account> accountList = TestDataFactory.createAccountWithName(10,'eft Accounts',True);
        //  CONTACT
        List<Contact> contactList = TestDataFactory.createContactWithName(150,'eft Contacts',True);
        //  SalesHeader__c
        List<SalesHeader__c> salesHeaderList =
                TestDataFactory.createSalesHeaderRecordWithName(
                        150,'eft SalesHeaders',True
                );
        Boolean toggle = True;
        insert accountList;
        insert contactList;
        for(SalesHeader__c salesHeaderItr: salesHeaderList){
            Integer accountRandomIndex = Integer.valueof((Math.random() * (accountList.size()-1)));
            Integer contactRandomIndex = Integer.valueof((Math.random() * (contactList.size()-1)));
            salesHeaderItr.Account_Lookup__c = accountList[accountRandomIndex].Id;
            salesHeaderItr.Contack_Lookup__c = contactList[contactRandomIndex].Id;
            salesHeaderItr.Status__c = 'Open';
        }
        insert salesHeaderList;
        List<EFT_Transaction_Status__c> eftList = new List<EFT_Transaction_Status__c>();
        for(EFT_Transaction_Status__c eftItr :
                TestDataFactory.createEFTRecordWithNamet(
                    60, 'eft Status resord', False
                )
        ){
            Integer salesHeaderRandomIndex =
                Integer.valueof((Math.random() * (salesHeaderList.size()-1)));
            eftItr.Method_Name__c = 'Credit Card Address Verify';
            eftItr.Transaction_Status__c = 'Declined';
            SalesHeader__c salesHeaderItr = salesHeaderList[salesHeaderRandomIndex];
            eftItr.SalesHeader_Lookup__c = salesHeaderItr.Id;
            eftList.add(eftItr);
        }
        Integer caseCountStart  = [
            SELECT
                count()
            FROM
                Case
        ];
        System.Test.startTest();
        insert eftList;
        System.Test.stopTest();
        Integer caseCountEnd  = [
            SELECT
                count()
            FROM
                Case
        ];
        System.debug(
            'start: ' + caseCountStart +
            ' : End: ' + caseCountEnd +
            ' : efts: ' + eftList.size()
        );
        System.assertEquals(
            eftList.size(),
            caseCountEnd - caseCountStart,
            'The Case count will increase.'
        );
    }

    /***
        Negative Case:
            Case Record Won't change Increase.
    */
    @isTest
    public static void AddressDidNotVerify_NegativeCase(){
        //  Create Custom Setting for activating the trigger
        insert new TriggerSetting__c(EFTTransactionTrigger__c = True);
        //     INITIAL RECORDS
        //  ACCOUNT
        List<Account> accountList = TestDataFactory.createAccountWithName(10,'eft Accounts',True);
        //  CONTACT
        List<Contact> contactList = TestDataFactory.createContactWithName(150,'eft Contacts',True);
        //  SalesHeader__c
        List<SalesHeader__c> salesHeaderList =
                TestDataFactory.createSalesHeaderRecordWithName(
                        150,'eft SalesHeaders',True
                );
        Boolean toggle = True;
        insert accountList;
        insert contactList;
        for(SalesHeader__c salesHeaderItr: salesHeaderList){
            Integer accountRandomIndex = Integer.valueof((Math.random() * (accountList.size()-1)));
            Integer contactRandomIndex = Integer.valueof((Math.random() * (contactList.size()-1)));
            salesHeaderItr.Account_Lookup__c = accountList[accountRandomIndex].Id;
            salesHeaderItr.Contack_Lookup__c = contactList[contactRandomIndex].Id;
            salesHeaderItr.Status__c = 'Close';
        }
        insert salesHeaderList;
        List<EFT_Transaction_Status__c> eftList = new List<EFT_Transaction_Status__c>();
        for(EFT_Transaction_Status__c eftItr :
                TestDataFactory.createEFTRecordWithNamet(
                    60, 'eft Status resord', False
                )
        ){
            Integer salesHeaderRandomIndex =
                Integer.valueof((Math.random() * (salesHeaderList.size()-1)));
            eftItr.Method_Name__c = 'Credit Card Address Verify';
            eftItr.Transaction_Status__c = 'Declined';
            SalesHeader__c salesHeaderItr = salesHeaderList[salesHeaderRandomIndex];
            eftItr.SalesHeader_Lookup__c = salesHeaderItr.Id;
            eftList.add(eftItr);
        }
        Integer caseCountStart  = [
            SELECT
                count()
            FROM
                Case
        ];
        System.Test.startTest();
        insert eftList;
        System.Test.stopTest();
        Integer caseCountEnd  = [
            SELECT
                count()
            FROM
                Case
        ];
        System.debug(
            'start: ' + caseCountStart +
            ' : End: ' + caseCountEnd +
            ' : efts: ' + eftList.size()
        );
        System.assertEquals(
            0,
            caseCountEnd - caseCountStart,
            'The Case count will increase.'
        );
    }
}