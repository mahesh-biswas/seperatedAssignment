/**
    CLASS:  DML
    ----------------------------
    This Class is for performing DML related Queries.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Class for performing
                                                DML operations.
*/
public with sharing class DML {

    /**
        This is a Helper method that helps some other method.
        Randomly Generates a Boolean Value.
    */
    public Boolean toAdd(){
        Integer randomNumber = Integer.valueof((math.random() * 10));
        Boolean randomBoolean = Math.mod(randomNumber,2) == 0 ? true : false;
        return randomBoolean;
    }

    /**
        Creates 100 lead records where few are positive and negative. So by the end
        the simplesent appproach to test so, we assert the count of each log and Lead.
        If all goes fine then Log will be empty.

        Question:
        Create a custom object called as 'Logs'. Create a long text area field called as 'Error'.
        Create 100 Lead records using DML operations having a unique name.
        For all records which were not inserted into Lead object,
        insert a record in Log object along with the reason why a record was not inserted.
        Also, execute assignment rules to auto allocate Lead records to correct owner
    */
    public void create100LeadsAndFailuresBeInLogObject(){
        //creating 100 lead records.
        List<Lead> leadList = new List<Lead>();
        String fname = 'Lead FName Count';
        String lname = 'Lead LName Count';
        String companyName = 'Company ';
        for(Integer itr=0;itr<100;itr++){
            Lead ld = new Lead();
            if(toAdd())
                ld.LastName = lname + '' + itr;
            if(toAdd())
                ld.Company = companyName + '' + itr;
            ld.FirstName = fname + '' + itr;
            ld.Description = 'Added through code';
            leadList.add(ld);
        }
        Database.SaveResult[] srList = Database.insert(leadList, False);
        List<Log__c> logList = new List<Log__c>();
        for (Database.SaveResult sResult : srList){
            if(!sResult.isSuccess()){
                for(Database.Error err : sResult.getErrors()) {
                    Log__c log = new Log__c();
                    log.Error__c =  err.getStatusCode() + ': '
                                    + err.getMessage() + ' on '
                                    + err.getFields();
                    logList.add(log);
                }
            }
        }
        insert logList;
    }

    /**
        deletes all the account not active gor past 90 days.

        QUESTION:
        Delete all inactive Account records created in last 90 days.
    */
    public void deleteInactive90DaysRecord(){
        delete [
            SELECT
                Active__c,
                CreatedDate,
                Id,
                Name
            FROM
                Account
            WHERE
                Active__c NOT IN ('Yes') AND CreatedDate = LAST_N_DAYS:90
        ];
    }

}