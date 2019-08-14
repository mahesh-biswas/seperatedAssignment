/*
    CLASS:  ContactTriggerHandler
    ----------------------------
    This is a Handler Class for ContactTrigger.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created Trigger Handler class
                                                for the Contact related trigger.
                                                Checks for Duplicate Record entry
                                                on the basis of email and phone field.

        1.1         Mahesh Biswas   29/July/19  Created a new Functionality to
                                                extract domain from email and
                                                assign that contact to the Account with
                                                name same as the domain.
                                                If Account Not Exists then creates
                                                a new Account and assigns it to that contact.
*/
public with sharing class ContactTriggerHandler {

    /*
        Checks for Duplicate Record entry on the basis of email and phone field.
        the new data should not have email or phone field's value same as any of the existing
        Record.

        QUESTION:
            Contact Duplicate Check Trigger
                Create a new Trigger on Contact that will check for duplicates
                before allowing a new record into the database.
                Validate against the email address and phone number fields.
                An error be thrown with the error message –
                “A Contact with the same email address or phone number already exists in system.”
                Should be bulk safe in nature and must be capable of
                handling at least 200 records at a time.
    */
    public void duplicateCheck(List<Contact> contactListFromTrigger){
        Set<String> emails = new Set<String>();
        Set<String> phoneNumbers = new Set<String>();
        for(Contact con : contactListFromTrigger){
            if(con.Email != null)
                emails.add(con.Email);
            if(con.Phone != null)
                phoneNumbers.add(con.Phone);
        }
        System.debug('Emails: ' + emails);
        System.debug('Phone: ' + phoneNumbers);
        // Map<String, Contact> contactMap = new Map<String, Contact>();
        List<String> contactList = new List<String>();
        for(Contact conItr : [
            SELECT
                Id,
                Email,
                Phone
            FROM
                Contact
            WHERE
                Email
            IN
                :emails
            OR
                Phone
            IN
                :phoneNumbers
        ]   ){
            if(conItr.Email != null)
                contactList.add(conItr.Email);
            if(conItr.Phone != null)
                contactList.add(conItr.Phone);
        }
        for(Contact conItr : contactListFromTrigger){
            if(contactList.contains(conItr.Email)){
                conItr.addError(
                    'A Contact with the same email address' +
                    ' or phone number already exists in system.(EMAIL)'
                );
            }else if(contactList.contains(conItr.Phone)){
                conItr.addError(
                    'A Contact with the same email address' +
                    ' or phone number already exists in system.(PHONE)'
                );
            }
        }
    }

    /**
        Extracts the Domain Name from the email address of contacts.
        Then searches for account whose name = domain.
        if exists: assigns that parent to those contacts.
        else:   creates new account and then assigns it to the contacts.
    */
    public void createLinkParent(List<Contact> contactListFromTrigger){
        Set<String> domains = new Set<String>();
        for(Contact conItr : contactListFromTrigger){
            if(conItr.Email != null || !String.isBlank(conItr.Email)){
                String domain = conItr.Email.split('@')[1].split('\\.')[0];
                if(domain.length()>0)
                    domains.add(domain);
            }
        }
        //  searches for all account with email's domain name then inserts it to map.
        Map<String, String> accountNameIdMap = new Map<String, String>();
        for(Account accountItr  :   [
            SELECT
                Id,
                Name
            FROM
                Account
            WHERE
                Name IN :domains
        ]   ){
            accountNameIdMap.put(accountItr.Name,accountItr.Id);
        }
        System.debug('mapStatus: ' + accountNameIdMap);
        //  orphanContacts is list of contact will having no account record to associate
        List<Contact> orphanContacts = new List<Contact>();
        //  the domain set with which new account records to be created for orphan contacts
        Set<String> newDomianSet = new Set<String>();
        for(Contact contactItr : contactListFromTrigger){
            if(!String.isBlank(contactItr.Email)){
                String domain = contactItr.Email.split('@')[1].split('\\.')[0];
                if(domain.length()>0){
                    if(accountNameIdMap.get(domain)!=null){
                        contactItr.AccountId = accountNameIdMap.get(domain);
                    }else{
                        orphanContacts.add(contactItr);
                        newDomianSet.add(domain);
                        // newParentsToAdd.add(new Account(Name = domain));
                    }
                }
            }
        }
        //  domain set will have unique domains so will avoid duplicate account creation.
        List<Account> newParentsToAdd = new List<Account>();
        for(String domainItr : newDomianSet){
            newParentsToAdd.add(new Account(Name = domainItr));
        }
        // below code block add account's record and attach them to contacts
        insert newParentsToAdd;
        Map<String,String> newlyAddedAccountNameIdMap = new Map<String,String>();
        for(Account accItr : newParentsToAdd){
            newlyAddedAccountNameIdMap.put(accItr.Name,accItr.Id);
        }
        for(Integer intItr=0;intItr<orphanContacts.size();intItr++){
            String domain = orphanContacts[intItr].Email.split('@')[1].split('\\.')[0];
            orphanContacts[intItr].AccountId = newlyAddedAccountNameIdMap.get(domain);
        }
    }

}