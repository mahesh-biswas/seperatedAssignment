/*
    CLASS:  AccountTriggerHandlerTest
    ----------------------------
    This is a Test Class for AccountTrigger.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created test method that test
                                                if Account Record is cloned
                                                on Account Update.
*/
@isTest
public with sharing class AccountTriggerHandlerTest {

    /***
        This method test if clone of a record is created when that record is opted for updation,
        for Account Records.

        QUESTION:
            Write a Trigger on Account which will create the clone record.

        CASE:
            test for positive case, i.e when Account record is attemped to update.
    */
    @isTest
    public static void createAccountRecordClone(){
        insert new TriggerSetting__c(AccountTrigger__c = True);
        Account initAccount =
            TestDataFactory.createAccountWithName(1,'Test Account for TESTING',True)[0];
        insert initAccount;
        initAccount.Phone = '9878675649';
        System.Test.startTest();
        update initAccount;
        System.Test.stopTest();
        Integer accountRecordCount = [
            SELECT
                count()
            FROM
                Account
        ];
        System.assertEquals(
            2,
            accountRecordCount,
            'for every uncloned record edited one backup of each record is added.'
        );
    }

    /***
        This method test if clone of a record is created when that record is opted for updation,
        for Account Records.

        QUESTION:
            Write a Trigger on Account which will create the clone record.

        Case:
            test for when cloned record is attemped to changed.
    */
    @isTest
    public static void createAccountRecordClone_EditingClonedRecord(){
        insert new TriggerSetting__c(AccountTrigger__c = True);
        Account initAccount = TestDataFactory.createAccountWithName(1,'Test Account for TESTING',True)[0];
        insert initAccount;
        initAccount.Phone = '9878675649';
        update initAccount;
        List<Account> clonedAccount = [
            SELECT
                Id,
                Phone,
                Name,
                Description
            FROM
                Account
            WHERE
                Id NOT IN (:initAccount.Id)
        ];
        for (Account accountItr : clonedAccount) {
            accountItr.Name = 'New Profile';
        }
        System.Test.startTest();
        update clonedAccount;
        System.Test.stopTest();
        Integer accountRecordCount = [
            SELECT
                count()
            FROM
                Account
        ];
        System.assertEquals(
            2,
            accountRecordCount,
            'The cloned record won\'t be cloned again.'
        );
    }

}