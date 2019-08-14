/**
    CLASS:  SOQLPart
    ------------------------------------------------------------------
    This Class is for performing SOQL related Queries.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Class for performing
                                                SOQL related Queries.
*/
public with sharing class SOQLPart {

    /**
        Returns Map of all the Active Users in the Org.

        QUESTION:
        Write a SOQL query to retrieve/print all active Users.
        Prepare a Map having User Id as key and User record as value.
        (Hint: Use Map<Id, User>)
    */
    public Map<ID,User> getActiveUsers(){
        Map<ID,User> userMap = new Map<ID,User>(    [
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
        System.debug(userMap);
        return userMap;
    }

    /**
        displays and returns a list of All account with enrollment year
        provided in the input as parameter.

        QUESTION:
        Create a multi-select picklist on Account object called as 'Enrollment Year'
        with values - 2010, 2011, 2012, 2013, 2014, 2015 and 2016.
        Get all account records where in selected 'Enrollment Year' is:
        a. 2010
        b. 2013 and 2014
    */
    public List<Account> getAccountWithEnrollmentYear(String enrolYear){
        // 2010 and 2013;2014
        List<Account> accountList  = [
            SELECT
                Enrollment_Year__c,
                Name
            FROM
                Account
            WHERE
                Enrollment_Year__c INCLUDES (:enrolYear)
        ];
        System.debug('Accounts for year ' + enrolYear + ' \t' + accountList);
        return accountList;
    }

    /**
        Returns the List of Account whose Billing State is not Maharashtra or Kerala

        QUESTION:
        Write a SOQL query to find all Account records where
        'Billing State' is not 'Maharashtra' and 'Kerala'.
        Order the results by Billing State in descending order with null values at the end.
        Display first 10,000 records only.
        Note: Do not use AND operator.
    */
    public List<Account> getAccountNotInMH(){
        List<Account> accountList  = [
            SELECT
                Id,
                Name,
                BillingState
            FROM
                Account
            WHERE
                BillingState NOT IN  ('Maharashtra','Kerala')
            ORDER BY
                BillingState ASC NULLS LAST
        ];
        System.debug('Criterion Satisfied Accounts \t'+accountList);
        return accountList;
    }

    /**
        Returns a List of all Opportunities having Amount
        greater than 10,000 only retrieving records from 50 to 150.

        QUESTION:
        Write a SOQL query to display 100 opportunity records
        with amount greater than 10,000 order by created date.
        Skip first 50 records and include records from recycle bin.
    */
    public List<Opportunity> getOppurtunityWithHighAmount(){
        List<Opportunity> opportunityList = [
            SELECT
                Name,
                Amount
            FROM
                Opportunity
            WHERE
                Amount > 10000
            ORDER BY
                CreatedDate ASC
            LIMIT
                100
            OFFSET
                50
            ALL ROWS
        ];
        System.debug('Oppurtunities are: ' + opportunityList);
        return opportunityList;
    }

}