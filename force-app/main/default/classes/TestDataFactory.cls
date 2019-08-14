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
}