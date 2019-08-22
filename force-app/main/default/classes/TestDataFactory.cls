/**
 * @File Name          : TestDataFactory.cls
 * @Description        : 
 * @Author             : Mahesh Biswas
 * @Group              : 
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/22/2019, 12:32:47 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/22/2019, 12:32:32 PM   Mahesh Biswas     Initial Version
**/
@isTest
public with sharing class TestDataFactory {
    public static List<Account> createAccountWithName(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<Account> accountList = new List<Account>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Account accountObject = new Account();
            if(appendItr)
                accountObject.Name = Name+intItr;
            else
                accountObject.Name = Name;
            accountList.add(accountObject);
        }
        return accountList;
    }
    public static List<Contact> createContactWithName(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<Contact> contactList = new List<Contact>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Contact contactObject = new Contact();
            if(appendItr)
                contactObject.LastName = Name+intItr;
            else
                contactObject.LastName = Name;
            contactList.add(contactObject);
        }
        return contactList;
    }
    public static List<Opportunity> createOpportunityWithNameAndRandomCloseDate(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Opportunity opportunityObject = new Opportunity();
            if(appendItr)
                opportunityObject.Name = Name+intItr;
            else
                opportunityObject.Name = Name;
            opportunityObject.CloseDate = System.today()+Integer.valueOf(Math.random()*365);
            opportunityObject.StageName = '--None--';
            opportunityList.add(opportunityObject);
        }
        return opportunityList;
    }
    public static List<Opportunity> createOpportunityWithNameStageAndRandomCloseDate(
            Integer recordCount, String Name,String Stage, Boolean appendItr
    ){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Opportunity opportunityObject = new Opportunity();
            if(appendItr)
                opportunityObject.Name = Name+intItr;
            else
                opportunityObject.Name = Name;
            opportunityObject.CloseDate = System.today()+Integer.valueOf(Math.random()*365);
            opportunityObject.StageName = Stage;
            opportunityList.add(opportunityObject);
        }
        return opportunityList;
    }
    public static List<Lead> createLeadWithFirstname(
            Integer recordCount, String firstName, Boolean appendItr
    ){
        List<Lead> leadList = new List<Lead>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Lead leadObject = new Lead();
            if(appendItr)
                leadObject.FirstName = firstName+intItr;
            else
                leadObject.FirstName = firstName;
            leadList.add(leadObject);
        }
        return leadList;
    }
    public static List<Lead> createLeadWithName(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<Lead> leadList = new List<Lead>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Lead leadObject = new Lead();
            if(appendItr)
                leadObject.LastName = Name+intItr;
            else
                leadObject.LastName = Name;
            leadObject.Company = 'random-company-for-test';
            leadList.add(leadObject);
        }
        return leadList;
    }
    public static List<Opportunity> createAccountWithNameAndStage(
            Integer recordCount, String Name, String Stage, Boolean appendItr
    ){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            Opportunity opportunityObject = new Opportunity();
            if(appendItr){
                opportunityObject.Name = Name+intItr;
            }else{
                opportunityObject.Name = Name;
            }
            opportunityObject.StageName = Stage;
            opportunityObject.CloseDate = Date.today().addMonths(intItr);
            opportunityList.add(opportunityObject);
        }
        return opportunityList;
    }
    public static List<EFT_Transaction_Status__c> createEFTRecordWithNamet(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<EFT_Transaction_Status__c> eftList = new List<EFT_Transaction_Status__c>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            EFT_Transaction_Status__c eft = new EFT_Transaction_Status__c();
            if(appendItr)
                eft.Name = Name+intItr;
            else
                eft.Name = Name;
            eftList.add(eft);
        }
        return eftList;
    }
    public static List<SalesHeader__c> createSalesHeaderRecordWithName(
            Integer recordCount, String Name, Boolean appendItr
    ){
        List<SalesHeader__c> salesHeaderList = new List<SalesHeader__c>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            SalesHeader__c salesHeader = new SalesHeader__c();
            if(appendItr)
                salesHeader.Name = Name+intItr;
            else
                salesHeader.Name = Name;
            salesHeaderList.add(salesHeader);
        }
        return salesHeaderList;
    }
    public static List<A__c> createAWithName(Integer recordCount, String Name, Boolean appendItr){
        List<A__c> AList = new List<A__c>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            A__c AObject = new A__c();
            if(appendItr)
                AObject.Name = Name+intItr;
            else
                AObject.Name = Name;
            AList.add(AObject);
        }
        return AList;
    }
    public static List<B__c> createBWithName(Integer recordCount, String Name, Boolean appendItr){
        List<B__c> BList = new List<B__c>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            B__c BObject = new B__c();
            if(appendItr)
                BObject.Name = Name+intItr;
            else
                BObject.Name = Name;
            BList.add(BObject);
        }
        return BList;
    }
    public static List<C__c> createCWithName(Integer recordCount, String Name, Boolean appendItr){
        List<C__c> CList = new List<C__c>();
        for(Integer intItr=0;intItr<recordCount;intItr++){
            C__c CObject = new C__c();
            if(appendItr)
                CObject.Name = Name+intItr;
            else
                CObject.Name = Name;
            CList.add(CObject);
        }
        return CList;
    }

    /**
        Test method for creating records of Opportunity.
    */
    public static List<Opportunity> createOpportunity(Integer numberOfRecords, Boolean isInsert){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer count=0; count<numberOfRecords; count++){
            opportunityList.add(new Opportunity(
                Name        =   'opportunityName',
                StageName   =   '--None--',
                CloseDate   =   System.today()+Integer.valueOf(Math.random()*365)
            ));
        }
        if(isInsert)
            insert opportunityList;
        return opportunityList;
    }

    /**
        Test method for creating records of Account.
    */
    public static List<Account> createAccount(Integer numberOfRecords, Boolean isInsert){
        List<Account> accountList = new List<Account>();
        for(Integer count=0; count<numberOfRecords; count++){
            accountList.add(new Account(
                Name    =   'accountName'
            ));
        }
        if(isInsert)
            insert accountList;
        return accountList;
    }

    /**
        Test method for creating records of Contact.
    */
    public static List<Contact> createContact(Integer numberOfRecords, Boolean isInsert){
        List<Contact> contactList = new List<Contact>();
        for(Integer count=0; count<numberOfRecords; count++){
            contactList.add(new Contact(
                LastName    =   'contactLastName'
            ));
        }
        if(isInsert)
            insert contactList;
        return contactList;
    }

    /**
        Test method for creating records of Lead.
    */
    public static List<Lead> createLead(Integer numberOfRecords, Boolean isInsert){
        List<Lead> leadList = new List<Lead>();
        for(Integer count=0; count<numberOfRecords; count++){
            leadList.add(new Lead(
                LastName    =   'leadLastName',
                Company     =   'a very fake company INC.'
            ));
        }
        if(isInsert)
            insert leadList;
        return leadList;
    }
}