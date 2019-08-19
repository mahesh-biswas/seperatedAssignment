@isTest
public with sharing class TestUtility {

    /**
        Test method for creating records of Opportunity.
    */
    public static List<Opportunity> createOpportunity(Integer numberOfRecords, Boolean isInsert){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer count=0; count<numberOfRecords; count++){
            opportunityList.add(new Opportunity(
                Name        =   'opportunity name',
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
                Name    =   'account Name'
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
                LastName    =   'contact LastName'
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
                LastName    =   'lead_LastName',
                Company     =   'a very fake company INC.'
            ));
        }
        if(isInsert)
            insert leadList;
        return leadList;
    }
}