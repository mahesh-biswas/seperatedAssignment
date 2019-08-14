/*
    CLASS:  ContactTriggerHandlerTest
    ----------------------------
    This is a Test Class for ContactTriggerHandler.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created test class for the Contact
                                                related trigger.
                                                Targets the functionality for Duplicate Record
                                                entry on the basis of email and phone field.
*/
@isTest
public with sharing class ContactTriggerHandlerTest {

    /**
        This Method Test the trigger for new contact records attemplting to be added
        with email and phone existing in the contact records.

        CASE:   Email Duplicate
    */
    @isTest
    static void duplicateCheckEmail(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        String email = 'toBeDuplicateEmail@duplicate.com';
        List<Contact> contactList = TestDataFactory.createContactWithName(200, 'duplicate', True);
        for(Contact conItr : contactList){
            conItr.Email = conItr.Name + '@duplicate.com';
        }
        contactList[0].Email = email;
        String contactError;
        Database.insert(contactList,false);
        List<Contact> contactTestList = TestDataFactory.createContactWithName(2, 'duplicate', True);
        contactTestList[0].email = contactList[0].Email;
        System.Test.startTest();
        Database.saveResult[] saveResultList = Database.insert(contactTestList, false);
        System.Test.stopTest();
        for(Database.saveResult saveResultItr : saveResultList){
            if(!saveResultItr.isSuccess()){
                for(Database.Error errorItr : saveResultItr.getErrors()){
                    System.assertEquals(
                        true,
                        errorItr.getMessage().contains(
                            'Contact with the same email address or phone number already exists in system.'
                        )
                    );
                }
            }else{
                System.debug('--:Success:--'+saveResultItr.getId());
            }
        }
    }

    /**
        This Method Test the trigger for new contact records attemplting to be added
        with email and phone existing in the contact records.

        CASE:   Phone Duplicate
    */
    @isTest
    static void duplicateCheckPhone(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        String mobile = '987686754';
        List<Contact> contactList = TestDataFactory.createContactWithName(200, 'duplicate', True);
        Integer integerCounter=0;
        for(Contact conItr : contactList){
            conItr.Phone = String.valueOf(integerCounter++);
        }
        contactList[0].Phone = mobile;
        String contactError;
        insert contactList;
        List<Contact> contactTestList = TestDataFactory.createContactWithName(2, 'duplicate', True);
        contactTestList[1].Phone = contactList[0].Phone;
        System.Test.startTest();
        Database.saveResult[] saveResultList = Database.insert(contactTestList, false);
        System.Test.stopTest();
        for(Database.saveResult saveResultItr : saveResultList){
            if(!saveResultItr.isSuccess()){
                for(Database.Error errorItr : saveResultItr.getErrors()){
                    System.assertEquals(
                        true,
                        errorItr.getMessage().contains(
                            'Contact with the same email address or phone number already exists in system.'
                        )
                    );
                }
            }else{
                System.debug('--:Success:--'+saveResultItr.getId());
            }
        }
    }

    /**
        This Method Test the trigger for new contact records attemplting to be added
        with email and phone existing in the contact records.

        CASE:   Email and Phone Duplicate
    */
    @isTest
    static void duplicateCheckEmailAndPhone(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        String email = 'toBeDuplicateEmail@duplicate.com';
        String mobile = '987686754';
        List<Contact> contactList = TestDataFactory.createContactWithName(200, 'duplicate', True);
        for(Contact conItr : contactList){
            conItr.Email = conItr.Name + '@duplicate.com';
        }
        contactList[0].Email = email;
        contactList[0].Phone = mobile;
        String contactError;
        insert contactList;
        List<Contact> contactTestList = TestDataFactory.createContactWithName(2, 'duplicate', True);
        contactTestList[0].email = contactList[0].Email;
        contactTestList[0].Phone = contactList[0].Phone;
        System.Test.startTest();
        Database.saveResult[] saveResultList = Database.insert(contactTestList, false);
        System.Test.stopTest();
        for(Database.saveResult saveResultItr : saveResultList){
            if(!saveResultItr.isSuccess()){
                for(Database.Error errorItr : saveResultItr.getErrors()){
                    System.assertEquals(
                        true,
                        errorItr.getMessage().contains(
                            'Contact with the same email address or phone number already exists in system.'
                        )
                    );
                }
            }else{
                System.debug('--:Success:--'+saveResultItr.getId());
            }
        }
        /*try {
            insert contactTestList;
        } catch (DMLException insertError) {
            System.debug('msg_emailAndPhoneDuplicate:' + insertError.getMessage());
            System.assertEquals(
                true,
                insertError.getMessage().contains(
                    'Contact with the same email address or phone number already exists in system.'
                )
            );
        }*/
    }

    /**
        This Method Test the trigger for new contact records whose parent(account) are to be
        associated with account name as contact's Email's Domain.
        This is when account already exists.
    */
    @isTest
    static void createLinkParentAccountExists(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        List<Account> accountList = TestDataFactory.createAccountWithName(2,'dell',False);
        accountList[1].Name = 'microsoft';
        insert accountList;
        Integer integerCountBegin = [
            SELECT
                count()
            FROM
                Contact
            WHERE
                AccountId IN (
                                SELECT
                                    Id
                                FROM
                                    Account
                                WHERE
                                    Name IN(
                                            'microsoft',
                                            'dell'
                                            )
                            )
        ];
        System.debug('>>initialCount: ' + integerCountBegin);
        List<Contact> contactList = new List<Contact>();
        Boolean toggle = True;
        for(Contact contactItr : TestDataFactory.createContactWithName(200,'Contact',True)){
            if(toggle){
                contactItr.Email = contactItr.Name + '@dell.com';
                toggle = False;
            }else{
                contactItr.Email = contactItr.Name + '@microsoft.com';
                toggle = True;
            }
            contactList.add(contactItr);
        }

        System.Test.startTest();
        insert contactList;
        System.Test.stopTest();
        Integer integerCountEnd = [
            SELECT
                count()
            FROM
                Contact
            WHERE
                AccountId IN (
                                SELECT
                                    Id
                                FROM
                                    Account
                                WHERE
                                    Name IN(
                                            'microsoft',
                                            'dell'
                                            )
                            )
        ];
        System.debug('<<EndCount: ' + integerCountEnd);
        System.assertNotequals(
            integerCountBegin, integerCountEnd, 'the count will increase'
        );
    }

    /**
        This Method Test the trigger for new contact records whose parent(account) are to be
        associated with account name as contact's Email's Domain.
        This is when account does not exists.
    */
    @isTest
    static void createLinkParentAccountNotExists(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        Integer integerCountBegin = [
            SELECT
                count()
            FROM
                Contact
            WHERE
                AccountId IN (
                                SELECT
                                    Id
                                FROM
                                    Account
                                WHERE
                                    Name IN( 'microsoft' )
                            )
        ];
        System.debug('>>initialCount: ' + integerCountBegin);
        List<Contact> contactList = new List<Contact>();
        Boolean toggle = True;
        for(Contact contactItr : TestDataFactory.createContactWithName(200, 'Contact', True)){
            contactItr.Email = contactItr.Name + '@microsoft.com';
            contactList.add(contactItr);
        }
        System.Test.startTest();
        insert contactList;
        System.Test.stopTest();
        Integer integerCountEnd = [
            SELECT
                count()
            FROM
                Contact
            WHERE
                AccountId IN (
                                SELECT
                                    Id
                                FROM
                                    Account
                                WHERE
                                    Name IN( 'microsoft' )
                            )
        ];
        System.debug('<<EndCount: ' + integerCountEnd);
        System.assertNotequals(
            integerCountBegin, integerCountEnd, 'the count will increase'
        );
    }

    /**
        This Method Test the trigger for new contact records whose parent(account) are to be
        associated with account name as contact's Email's Domain.
        This is for when Email field is empty
    */
    @isTest
    static void createLinkParentEmailNotFilled(){
        insert new TriggerSetting__c(ContactTrigger__c = True);
        Integer integerCountBegin = [
            SELECT
                count()
            FROM
                Account
        ];
        List<Contact> contactList = TestDataFactory.createContactWithName(200, 'Contact', True);
        System.Test.startTest();
        insert contactList;
        System.Test.stopTest();
        Integer integerCountEnd = [
            SELECT
                count()
            FROM
                Account
        ];
        System.debug('<<EndCount: ' + integerCountEnd);
        System.assertequals(
            integerCountBegin, integerCountEnd, 'should be equal to zero.'
        );
    }

}