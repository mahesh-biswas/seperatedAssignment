/*
    CLASS:  RelationshipQueriesTest
    ----------------------------
    This is a Test Class for RelationshipQueries.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   4/Aug/19    Created test class for the RelationshipQueries.
                                                Tests the functionality in RelationshipQueries
                                                class.
*/
@isTest
public with sharing class RelationshipQueriesTest {

    /**
        Test the method which sends the Accounts and Contact's if the Account's Industry is Media.
    */
    @isTest
    static void getContactsWithActiveAccountMediaIndustry(){
        // Tests if valid Contacts having Parent's Industry as MEDIA and Active are fetched.
        List<Account> accountList = new List<Account>();
        Integer intVar = 0;
        // Media    InActive    10
        for (Account accountItr : TestDataFactory.createAccountWithName(
                                        10,'Media Test Accounts',True
                                    )
        ) {
            accountItr.Industry = 'Media';
            accountItr.Active__c = 'No';
            accountList.add(accountItr);
        }
        intVar = 10;
        // Media    Active      20
        for (Account accountItr : TestDataFactory.createAccountWithName(
                                        20,'Media Test Accounts',True
                                    )
        ) {
            accountItr.Industry = 'Media';
            accountItr.Active__c = 'Yes';
            accountList.add(accountItr);
        }
        // Energy    Active      30
        for (Account accountItr : TestDataFactory.createAccountWithName(
                                        30,'Media Test Accounts',True
                                    )
        ) {
            accountItr.Industry = 'Energy';
            accountItr.Active__c = 'Yes';
            accountList.add(accountItr);
        }
        insert accountList;
        // System.debug('fff>'+accountList);
        List<Contact> contactList = new List<Contact>();
        for (Contact contactItr : TestDataFactory.createContactWithName(60,'Contacts',True)) {
            if(intVar>=30){
                intVar=0;
            }
            contactItr.AccountId = accountList[intVar].Id;
            contactList.add(contactItr);
            intVar++;
        }
        intVar = 30;
        for (Contact contactItr : TestDataFactory.createContactWithName(20,'Contacts',True)) {
            contactItr.AccountId = accountList[intVar].Id;
            contactList.add(contactItr);
            intVar++;
        }
        insert contactList;
        System.Test.startTest();
        List<Contact> contactResultList =
                            new RelationshipQueries().getContactsWithActiveAccountMediaIndustry();
        // Map<Id,Contact> contactResultList =
        // new Map<Id,Contact>(new RelationshipQueries().getContactsWithActiveAccountMediaIndustry());
        System.Test.stopTest();
        System.assertEquals(
            60,
            contactResultList.size(),
            'only 60 contacts have Account with Media'
        );
        for(Contact contactItr : contactResultList){
            System.assertEquals(
                'Yes',
                contactItr.Account.Active__c,
                'The Active picklist must be Yes'
            );
            System.assertEquals(
                'Media',
                contactItr.Account.Industry,
                'The Account\'s Name must be Media'
            );
        }
    }

    /**
        Test The Function which returns Parent's and Child's Record whose Child's name is John.
    */
    @isTest
    static void getParentWhoseChildIsJohn(){
        Integer numberOfParents = 3;
        List<A__c> aList = TestDataFactory.createAWithName(numberOfParents,'A name',True);
        List<B__c> bList = TestDataFactory.createBWithName(numberOfParents,'B name',True);
        List<C__c> cList = new List<C__c>();
        insert aList;
        insert bList;
        Map<ID, A__c> aMaps = new Map<ID, A__c>(aList);
        Map<ID, B__c> bMaps = new Map<ID, B__c>(bList);
        Integer intVal = 0;
        for (C__c cItr : TestDataFactory.createCWithName(5*numberOfParents,'John',False)) {
            if(intVal>=numberOfParents){
                intVal = 0;
            }
            cItr.A_Relationship__c = aList[intVal].Id;
            cItr.B_Relationship__c = bList[intVal].Id;
            cList.add(cItr);
            intVal++;
        }
        insert cList;
        Map<ID, C__c> cMaps = new Map<ID, C__c>(cList);
        System.Test.startTest();
        List<C__c> cResultList = new RelationshipQueries().getParentWhoseChildIsJohn();
        System.Test.stopTest();
        // System.debug('cMap'+cMaps);
        for (C__c cItr : cResultList) {
            System.assertEquals(
                cItr.Name, 'John', 'Child\'s name must be John'
            );
            // System.debug('cMapss'+cMaps.get(cItr.Id).A_Relationship__c);
            System.assertEquals(
                cMaps.get(cItr.Id).A_Relationship__c,
                aMaps.get(cItr.A_Relationship__c).Id,
                'The Parent must exist.'
            );
            System.assertEquals(
                cMaps.get(cItr.Id).B_Relationship__c,
                bMaps.get(cItr.B_Relationship__c).Id,
                'The Parent must exist.'
            );
            System.assertEquals(
                cItr.A_Relationship__r.Name,
                aMaps.get(cItr.A_Relationship__c).Name,
                'The Parent\'s Name in his and childs record must be same.'
            );
            System.assertEquals(
                cItr.B_Relationship__r.Name,
                bMaps.get(cItr.B_Relationship__c).Name,
                'The Parent\'s Name in his and childs record must be same.'
            );
        }
    }

    /**
        Test The Function which returns Account's and Contact's Record whose contact's name contain John.
    */
    @isTest
    static void getAccountContactContainingJohn(){
        List<Account> accountList =
                        TestDataFactory.createAccountWithName(150,'Accounts name ',True);
        insert accountList;
        List<Contact> contactList = new List<Contact>();
        for (Contact conItr : TestDataFactory.createContactWithName(200,'John ',True)) {
            conItr.AccountId = accountList[Integer.valueOf(Math.random()*150)].Id;
        }
        insert contactList;
        // Map<ID, Contact> contactMaps = new Map<ID, Contact>(contactList);
        System.Test.startTest();
        List<Account> accountResultList =
                        new RelationshipQueries().getAccountContactContainingJohn();
        System.Test.stopTest();
        for (Account accountItr : accountResultList) {
            for (Contact contactItr : accountItr.Contacts) {
                System.assertEquals(
                    true,
                    contactItr.Name.contains('John'),
                    'contact\'s name must contact John'
                );
            }
        }
    }

    /**
        Test the method of Relationship Query which returns a list of Account and Opportunity
        having opportunity's stagename as Closed Won.
    */
    @isTest
    static void getAccountsHavingAtleastOneCloseWonOpportunity(){
        List<Account> accountList = TestDataFactory.createAccountWithName(200,'Account Name',True);
        insert accountList;
        List<Opportunity> opportunityList = new List<Opportunity>();
        for (Opportunity opportunityItr :
                    TestDataFactory.createOpportunityWithNameStageAndRandomCloseDate(
                                                                200,
                                                                'Opportunity Name','Closed Won',
                                                                True
                                                            )
        ) {
            opportunityItr.AccountId = accountList[Integer.valueOf(Math.random()*200)].Id;
            // opportunityItr.IsClosed = True;
            // opportunityItr.IsWon = True;
        }
        System.Test.startTest();
        List<Account> accountResultList =
                    new RelationshipQueries().getAccountsHavingAtleastOneCloseWonOpportunity();
        System.Test.stopTest();
        for(Account accountItr : accountResultList){
            System.assertEquals(
                true,
                accountItr.Opportunities.size()>0,
                'The Opportunities Must atleast contain One Opportunity Record'
                            +' having Closed Won Stage.'
            );
            for(Opportunity opportunityItr : accountItr.Opportunities){
                System.assertEquals(
                    'Closed Won',
                    opportunityItr.StageName,
                    'each and every opportunity\'s StageName must be CLOSED WON'
                );
            }
        }
    }

    /**
        Test The Function which returns A's and C's Record when C's name contain John.
    */
    @isTest
    static void getACContainingJohn(){
        List<A__c> aList = TestDataFactory.createAWithName(200,'A name',True);
        List<B__c> bList = TestDataFactory.createBWithName(200,'B name',True);
        insert aList;
        insert bList;
        List<C__c> cList = new List<C__c>();
        for (C__c cItr : TestDataFactory.createCWithName(200,'John',True)) {
            cItr.A_Relationship__c = aList[Integer.valueOf(math.random()*200)].Id;
            cItr.B_Relationship__c = bList[Integer.valueOf(math.random()*200)].Id;
            cList.add(cItr);
        }
        insert cList;
        System.Test.startTest();
        List<A__c> aResultList = new RelationshipQueries().getACContainingJohn();
        System.Test.stopTest();
        for (A__c aItr : aResultList) {
            for (C__c cItr : aItr.ac__r) {
                System.assertEquals(
                    true,
                    cItr.Name.contains('John'),
                    'C__c\'s name must contain John.'
                );
            }
        }
    }
}