/*
    CLASS:  SOQLPartTest
    ----------------------------
    This is a Test Class for SOQLPart.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   3/Aug/19  Created test class for
                                                testing SOQL related functionalities
                                                in SOQLPart class.
*/
@isTest
public with sharing class SOQLPartTest {

    /**
        compares each of the User record so fetched by SOQL class and checks
        each and every record.
    */
    @isTest
    static void theUserRecordTest(){
        Map<ID,User> userMapFromTestClass = new Map<ID,User>(   [
            SELECT
                City,
                Id,
                Name,
                Username
            FROM
                User
            WHERE
                IsActive = True
        ]   );
        System.Test.startTest();
        Map<ID,User> userMapFromNormalClass = new SOQLPart().getActiveUsers();
        System.Test.stopTest();
        for(ID idItr : userMapFromNormalClass.keySet()){
            System.assertEquals(
                userMapFromNormalClass.get(idItr).City,
                userMapFromTestClass.get(idItr).City,
                'City Should be same.'
            );
            System.assertEquals(
                userMapFromNormalClass.get(idItr).Name,
                userMapFromTestClass.get(idItr).Name,
                'Name Should be same.'
            );
            System.assertEquals(
                userMapFromNormalClass.get(idItr).Username,
                userMapFromTestClass.get(idItr).Username,
                'Username Should be same.'
            );
        }
    }

    /**
        Tests for the Query that returns all account records whose
        Enrollment year is some specific value.
    */
    @isTest
    static void getAccountWithEnrollmentYear(){
        List<Account> accountList = new List<Account>();
        Integer randomNumber = 0;
        for(Account accountItr : TestDataFactory.createAccountWithName(120,'Account',True)){
            if(randomNumber==0){
                accountItr.Enrollment_Year__c = '2010';
            }else if(randomNumber==1){
                accountItr.Enrollment_Year__c = '2010;2011;2013';
            }else if(randomNumber==2){
                accountItr.Enrollment_Year__c = '2010;2014;2015';
            }else if(randomNumber==3){
                accountItr.Enrollment_Year__c = '2013;2014;2015';
            }else if(randomNumber==4){
                accountItr.Enrollment_Year__c = '2013;2014;2015';
            }else if(randomNumber==5){
                accountItr.Enrollment_Year__c = '2015;2016';
            }
            randomNumber = Integer.valueOf(Math.random()*5);
            accountList.add(accountItr);
        }
        insert accountList;
        Map<Id,Account> accountMap = new Map<Id,Account>(accountList);
        System.Test.startTest();
        List<Account> accountResultList2010 = new SOQLPart().getAccountWithEnrollmentYear('2010');
        List<Account> accountResultList1314 =
            new SOQLPart().getAccountWithEnrollmentYear('2013;2014');
        System.Test.stopTest();
        for(Account accountItr : accountResultList2010){
            System.assertEquals(
                accountItr.Enrollment_Year__c,
                accountMap.get(accountItr.Id).Enrollment_Year__c,
                'Enrollment Year must be same'
            );
            System.assertEquals(
                accountItr.Enrollment_Year__c=='2010',
                accountMap.get(accountItr.Id).Enrollment_Year__c=='2010',
                'Enrollment Year of both must be 2010'
            );
        }
        for(Account accountItr : accountResultList1314){
            System.assertEquals(
                accountItr.Enrollment_Year__c,
                accountMap.get(accountItr.Id).Enrollment_Year__c,
                'Enrollment Year must be same'
            );
            System.assertEquals(
                accountItr.Enrollment_Year__c=='2013;2014',
                accountMap.get(accountItr.Id).Enrollment_Year__c=='2013;2014',
                'Enrollment Year of both must be 2013 and 2014'
            );
        }
    }

    /**
        Tests for the Query that returns all account records whose
        BillingState is not Maharashtra and Kerala.
    */
    @isTest
    static void getAccountNotInMH(){
        List<Account> accountList = new List<Account>();
        Integer randomNumber = 0;
        for(Account accountItr : TestDataFactory.createAccountWithName(120,'Account',True)){
            if(randomNumber==0){
                accountItr.BillingState = 'Maharashtra';
            }else if(randomNumber==1){
                accountItr.BillingState = 'Kerala';
            }else if(randomNumber==2){
                accountItr.BillingState = 'Uttarakhand';
            }else{
                accountItr.BillingState = 'China';
            }
            randomNumber = Integer.valueOf(Math.random()*3);
            accountList.add(accountItr);
        }
        insert accountList;
        Map<ID,Account> accountMaps = new Map<ID,Account>(accountList);
        System.Test.startTest();
        List<Account> accountResultList =  new SOQLPart().getAccountNotInMH();
        System.Test.stopTest();
        for (Account accountItr : accountResultList) {
            System.assertEquals(
                accountMaps.get(accountItr.Id).BillingState,
                accountItr.BillingState,
                'Billing state of retrieved Record and inserted record must be same.'
            );
            System.assertNotEquals(
                'Maharashtra',
                accountItr.BillingState,
                'Billing state of retrieved Record must not be Maharashtra.'
            );
            System.assertNotEquals(
                'Kerala',
                accountItr.BillingState,
                'Billing state of retrieved Record must not be Kerala.'
            );
        }
    }

    /**
        Test if the records fetched by the method actually has high amount.
    */
    @isTest
    static void getOppurtunityWithHighAmountTest(){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Opportunity opportunityItr :
                TestDataFactory.createOpportunityWithNameAndRandomCloseDate(200,'Opportunity',True)
        ){
            opportunityItr.Amount = Integer.valueOf(Math.random()*20000);
            opportunityList.add(opportunityItr);
        }
        insert opportunityList;
        Map<ID, Opportunity> opportunityMaps = new Map<ID, Opportunity>(opportunityList);
        System.Test.startTest();
        List<Opportunity> opportunityResultList = new SOQLPart().getOppurtunityWithHighAmount();
        System.Test.stopTest();
        for (Opportunity opportunityItr : opportunityResultList) {
            System.assertEquals(
                opportunityMaps.get(opportunityItr.Id).Name,
                opportunityItr.Name,
                'Verificaion that both records are same.'
            );
            System.assertEquals(
                true,
                opportunityItr.Amount>10000,
                'the opportunity amount must be greater than 10,000.'
            );
        }
    }

}