/**
    CLASS:  DMLTest
    ----------------------------
    This Test Class for DML Class.
    ------------------------------------------------------------------
    Version#        Developer       Date            Description
        1           Mahesh Biswas   1/August/19     Test Class for testing
                                                    the DML class's methods.
*/
@isTest
public with sharing class DMLTest {

    static Boolean toAdd(){
        Integer randomNumber = Integer.valueof((math.random() * 10));
        Boolean randomBoolean = Math.mod(randomNumber,2) == 0 ? true : false;
        return randomBoolean;
    }

    /**
        This method tests is for when 100 Lead records are inserted then
        succesfull ones should get inserted and failed ones should
        be added to a Log Object's record.
    */
    @isTest
    static void create100Records(){
        Integer initialLeadCount = [
            SELECT
                count()
            FROM
                Lead
        ];
        Integer initialLogCount = [
            SELECT
                count()
            FROM
                Log__c
        ];
        System.Test.startTest();
        new DML().create100LeadsAndFailuresBeInLogObject();
        System.Test.stopTest();
        Integer finalLeadCount = [
            SELECT
                count()
            FROM
                Lead
        ];
        Integer finalLogCount = [
            SELECT
                count()
            FROM
                Log__c
        ];
        System.debug(finalLeadCount + '|' +
            finalLogCount + '|' +
            initialLeadCount + '|' +
            initialLogCount
        );
        System.assertEquals(
            100,
            finalLeadCount+finalLogCount-initialLeadCount-initialLogCount,
            'a total of 100 records to be inserted in either of the case.'+
                'If lead insertion fails then it should be inserted to Log'
        );
    }

    /**
        This method tests if all the inactive and 90 days older records from Account are
        getting deleted.
    */
    @isTest
    static void deleteInactive90DaysRecord(){
        List<Account> accountList = TestDataFactory.createAccountWithName(100,'Account Name',True);
        for(Integer intItr=0; intItr<accountList.size() ; intItr++){
            if(toAdd()){
                accountList[intItr].Active__c = 'Yes';
            }
        }
        insert accountList;
        System.Test.startTest();
            new DML().deleteInactive90DaysRecord();
        System.Test.stopTest();
            for(Account accountItr : [
                    SELECT
                        CreatedDate,
                        Active__c
                    FROM
                        Account
                ]
            ){
                System.assertNotEquals(
                    true,
                    Date.valueOf(accountItr.CreatedDate).daysBetween(Date.today())>90
                        &&
                    accountItr.Active__c != 'Yes',
                    'the account should not be active and created before 90 days'
                );
            }
    }

}