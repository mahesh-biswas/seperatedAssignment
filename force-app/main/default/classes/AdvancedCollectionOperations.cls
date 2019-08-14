/*
    CLASS:  AdvancedCollectionOperations
    ----------------------------
    Class for Different types of Loops.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   21/July/19  Created handler class for
                                                Account. To get Active Accounts
                                                update custom count field of some
                                                account record. Add new Contact
                                                associated to some Account, and
                                                Add a new Account Record
*/
public with sharing class AdvancedCollectionOperations {

    /**
        Retrieves the Records and Saves it in List.
        Then uses normal For loop to print.
    */
    public void accountQueryOnForTraditional(){
        list<Account> accountRecords = [
            SELECT
                Id,
                Name
            FROM
                Account
            LIMIT
                500
        ];
        for(Integer itr=0 ; itr<accountRecords.size() ; itr++){
            System.debug(
                itr+
                ' : '+accountRecords[itr].Id+
                ' : '+accountRecords[itr].Name
            );
        }
    }
    /**
        The SOQL Query is directly used inside the For Loop.
        this is enhanced as well as SOQL loop
    */
    public void accountQueryOnForEnhanced(){
        for(Account accountIterator : [
                SELECT
                    Id,
                    Name
                FROM
                    Account
                LIMIT
                    500
        ]   ){
            System.debug(accountIterator.Id+' <:> '+accountIterator.Name);
        }
    }

    /**
        Use of While Loop for iteration.
    */
    public void accountQueryOnWhile(){
        list<Account> accountRecords= [
            SELECT
                Id,
                Name
            FROM
                Account
            LIMIT
                500
        ];
        Integer nthRecord = 0;
        while(nthrecord<accountRecords.size()){
            System.debug(
                nthRecord+
                ' : '+accountRecords[nthRecord].Id+
                ' : '+accountRecords[nthRecord++].Name
            );
        }
    }
}