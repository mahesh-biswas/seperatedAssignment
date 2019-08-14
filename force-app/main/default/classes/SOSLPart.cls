/**
    CLASS:  SOSLPart
    ---------------------------------------------------------------------
    This Class is for performing SOAL Queries on Objects.
    ---------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Initial Creation.
*/
public with sharing class SOSLPart {

    /*
        Retrieves all the record from Account, Contact, Lead and User Where
        Name Field have 'test'.

        QUESTION:
        Find the word 'test' in all name fields returning Contact, Account, Lead and User.
    */
    public void findTestInAllField(){
        List<List<SObject>> searchList = [
            FIND 'test'
            IN NAME FIELDS
            RETURNING
                Contact,
                Account,
                Lead,
                User
        ];
        for(Contact conItr : (List<Contact>)searchList[0]){
            System.debug('Contacts: '+conItr);
        }
        for(Account accItr : (List<Account>)searchList[1]){
            System.debug('Accounts: '+accItr);
        }
        for(Lead leadItr : (List<Lead>)searchList[2]){
            System.debug('Leads: '+leadItr);
        }
        for(User userItr : (List<User>)searchList[3]){
            System.debug('Users: '+userItr);
        }
    }
}