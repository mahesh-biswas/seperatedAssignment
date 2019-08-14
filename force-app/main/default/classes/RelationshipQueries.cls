/**
    CLASS:  RelationshipQueries
    ---------------------------------------------------------------------
    This Class is for performing Relationship related Queries on Objects.
    ---------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Class for performing
                                                relation related Queries.
*/
public with sharing class RelationshipQueries {

    /**
        Retrieve all Contacts having Parent's Industry as MEDIA and Active

        QUESTION:
        Write a SOQL query on Contact to retrieve all active contacts
        belonging to 'media' Industry. Also display the name of the account
        to which it is associated to.
    */
    public List<Contact> getContactsWithActiveAccountMediaIndustry(){
        List<Contact> contactList = new List<Contact>();
        for(Contact contactItr : [
                SELECT
                    Account.name,
                    Account.Active__c,
                    Account.Industry,
                    Name
                FROM
                    Contact
                WHERE
                    Account.Industry IN ( 'Media') AND Account.Active__c = 'YES'
        ]   ){
            System.debug(contactItr);
            System.debug(
                'AccountId: ' + contactItr.Account.Id +
                '\t\tAccount Name: ' + contactItr.Account.Name
            );
            System.debug('Contact Name: ' + contactItr.Name);
            contactList.add(contactItr);
        }
        return contactList;
    }

    /*
        Retrieve all Parents Child's Name as 'John'.

        QUESTION:
        Write SOQL query on 'C'(created above) to retrieve all records of
        'C' with name 'John' along with parent details.
    */
    public List<C__c> getParentWhoseChildIsJohn(){
        List<C__c> cList = new List<C__c>();
        for(C__c cItr : [
                SELECT
                    A_Relationship__r.Name,
                    A_Relationship__c,
                    B_Relationship__c,
                    B_Relationship__r.Name,
                    Name
                FROM
                    C__c
                WHERE
                    Name = 'John'
        ]   ){
            System.debug(cItr);
            System.debug('AId: '+cItr.A_Relationship__c+' | A Name: '+cItr.A_Relationship__r.Name);
            System.debug('BId: '+cItr.B_Relationship__c+' | B Name: '+cItr.B_Relationship__r.Name);
            System.debug('C\'s Name: '+cItr.Name);
            cList.add(cItr);
        }
        return cList;
    }

    /**
        retrieves the Account and contacts where contact name contains john

        QUESTION:
        Write a SOQL query on Account and find all associated contact records
        of the Account which contains the word 'John'.
        Print all Account and Contact records retrieved above.
    */
    public List<Account> getAccountContactContainingJohn(){
        List<Account> accountList = new List<Account>();
        for(Account accItr : [
                SELECT
                    Name,
                    (
                        SELECT
                            Name
                        FROM
                            Contacts
                        WHERE
                            Name LIKE '%John%'
                    )
                FROM
                    Account
        ]   ){
            if(!accItr.Contacts.isEmpty()){
                for(Contact conItr : accItr.Contacts){
                    System.debug(conItr);
                }
                accountList.add(accItr);
            }
        }
        return accountList;
    }

    /*
        returns account having atleast one close won opportunity
        on Account:     SELECT Name,(Select Name,StageName from Opportunities)
                        FROM Account
                        WHERE Id IN (SELECT AccountId
                                    FROM Opportunity
                                    WHERE IsClosed = True AND IsWon = True
                                    )
        on Opportunity: SELECT Account.Name
                        FROM Opportunity
                        WHERE IsClosed = True AND IsWon = True AND Account.Name NOT IN(null)
                        GROUP BY Account.Name

        QUESTION:
        Write a SOQL query to find all Account records which have at least
        an opportunity record which is 'Closed Won'.
    */
    public List<Account> getAccountsHavingAtleastOneCloseWonOpportunity(){
        List<Account> accountList = new List<Account>();
        for(Account accItr : [
                SELECT
                    Name,
                    (
                        SELECT
                            Name,
                            StageName
                        FROM
                            Opportunities
                    )
                FROM
                    Account
                WHERE
                    Id  IN (
                                SELECT
                                    AccountId
                                FROM
                                    Opportunity
                                WHERE
                                    IsClosed = True AND IsWon = True
                        )
        ]   ){
            System.debug('Account Name: \t'+accItr.Name+'{');
            for(Opportunity oppItr : accItr.Opportunities){
                System.debug('_ _ _Name: '+ oppItr.Name+'\t|\t'+oppItr.StageName);
            }
            System.debug('}');
            accountList.add(accItr);
        }
        return accountList;
    }

    /*
        retrieves the A and C wherer C name contains john.

        QUESTION:
        Write a SOQL query on 'A' and retrieve all parents with all their
        child records where in child name is 'John'.
    */
    public List<A__c> getACContainingJohn(){
        List<A__c> aList = new List<A__c>();
        for(A__c aIterator : [
                SELECT
                    Name,
                    (
                        SELECT
                            Name
                        FROM
                            Ac__r
                    )
                FROM
                    A__c
                WHERE
                    Id IN (
                                SELECT
                                    A_Relationship__c
                                FROM
                                    C__c
                                WHERE
                                    Name LIKE '%John%'
                        )
        ]   ){
            System.debug('A\'s Name: \t'+aIterator.Name+'{');
            for(C__c cIterator : aIterator.ac__r){
                System.debug('_ _ _Name: '+ cIterator.Name);
            }
            System.debug('}');
            aList.add(aIterator);
        }
        return aList;
    }

}