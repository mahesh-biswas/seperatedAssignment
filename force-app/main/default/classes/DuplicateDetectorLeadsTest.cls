/**
 * @File Name          : DuplicateDetectorLeadsTest.cls
 * @Description        : Tests the DuplicateDetectorLead Class.
 * @Author             : Mahesh Biswas
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/22/2019, 3:05:53 PM
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/22/2019, 12:07:17 PM   Mahesh Biswas     Initial Version
**/
@isTest
public with sharing class DuplicateDetectorLeadsTest {

    /**
    * @description: Test for Positive Case - Duplicates Based on Email.
    * @author Mahesh Biswas | 8/22/2019
    * @return void
    */
    @isTest
    public static void testDuplicateDetectorLeadsBatchClass_PositiveEmailExistsForAllRecord(){
        insert new DuplicateSetting__c(
            Email__c = true,
            Keep_First_Record__c = true,
            Name__c = false
        );
        List<Lead> leadListForTest = TestDataFactory.createLead(400, false);
        Integer counter=0;
        // <LastName><Counter++>@email.com
        // biswas0@email.com
        for (Lead leadItr : leadListForTest) {
            leadItr.Email = leadItr.LastName+(counter++)+'@email.com';
        }
        leadListForTest[0].Email = 'duplicate@email.com';
        leadListForTest[1].Email = 'duplicate@email.com';
        leadListForTest[2].Email = 'duplicate@email.com';
        insert leadListForTest;
        System.Test.startTest();
        Database.executeBatch(new DuplicateDetectorLeads(),400);
        System.Test.stopTest();

        System.assertEquals(
            398,
            [
                SELECT
                    count()
                FROM
                    Lead
            ],
            '2 records will be deleted and the 1st will be saved.'
        );
    }

    /**
    * @description: Test for Negative Case - Duplicates Based on Email and Email Field can be empty.
    * @author Mahesh Biswas | 8/22/2019
    * @return void
    */
    @isTest
    public static void testDuplicateDetectorLeadsBatchClass_NegativeEmailNotExistsForRecords(){
        insert new DuplicateSetting__c(
            Email__c = true,
            Keep_First_Record__c = true,
            Name__c = false
        );
        List<Lead> leadListForTest = TestDataFactory.createLead(400, false);
        //  NOT SETTING EMAIL FIELD FOR ANY OF THE RECORD.
        leadListForTest[0].Email = 'duplicate@email.com';
        leadListForTest[1].Email = 'duplicate@email.com';
        leadListForTest[2].Email = 'duplicate@email.com';
        insert leadListForTest;
        System.Test.startTest();
        Database.executeBatch(new DuplicateDetectorLeads(),400);
        System.Test.stopTest();

        System.assertEquals(
            398,
            [
                SELECT
                    count()
                FROM
                    Lead
            ],
            '2 records will be deleted and the 1st along with all others with no value be saved.'
        );
    }

    /**
    * @description: Test for Positive Case - Duplicates Based on Name.
    * @author Mahesh Biswas | 8/22/2019
    * @return void
    */
    @isTest
    public static void testDuplicateDetectorLeadsBatchClass_PositiveName(){
        insert new DuplicateSetting__c(
            Email__c = false,
            Keep_First_Record__c = true,
            Name__c = true
        );
        List<Lead> leadListForTest = TestDataFactory.createLead(400, false);
        Integer counter=0;
        // <LastName><Counter++>
        // biswas0
        for (Lead leadItr : leadListForTest) {
            leadItr.LastName += (counter++);
        }
        leadListForTest[0].LastName = 'duplicateName';
        leadListForTest[1].LastName = 'duplicateName';
        leadListForTest[2].LastName = 'duplicateName';
        insert leadListForTest;
        System.Test.startTest();
        Database.executeBatch(new DuplicateDetectorLeads(),400);
        System.Test.stopTest();

        System.assertEquals(
            398,
            [
                SELECT
                    count()
                FROM
                    Lead
            ],
            '2 records will be deleted and the 1st will be saved.'
        );
    }

    /**
    * @description: Test for Negative Case - Duplicates Based on Name and records have unique name.
    * @author Mahesh Biswas | 8/22/2019
    * @return void
    */
    @isTest
    public static void testDuplicateDetectorLeadsBatchClass_NegativeAllUniqueName(){
        insert new DuplicateSetting__c(
            Email__c = false,
            Keep_First_Record__c = true,
            Name__c = true
        );
        List<Lead> leadListForTest = TestDataFactory.createLead(400, false);
        //  ALL records have unique Name.
        Integer counter=0;
        for (Lead leadItr : leadListForTest) {
            leadItr.LastName += (counter++);
        }
        insert leadListForTest;
        System.Test.startTest();
        Database.executeBatch(new DuplicateDetectorLeads(),400);
        System.Test.stopTest();

        System.assertEquals(
            400,
            [
                SELECT
                    count()
                FROM
                    Lead
            ],
            'no records be deleted becaue all records are unique.'
        );
    }

    /**
    * @description: Test for Positive Case - Duplicates Based on Name and Email.
    * @author Mahesh Biswas | 8/22/2019
    * @return void
    */
    @isTest
    public static void testDuplicateDetectorLeadsBatchClass_PositiveNameAndEmailDuplicate(){
        insert new DuplicateSetting__c(
            Email__c = true,
            Keep_First_Record__c = true,
            Name__c = true
        );
        List<Lead> leadListForTest = TestDataFactory.createLead(400, false);
        Integer counter=0;
        // <LastName><Counter++>
        // biswas0
        for (Lead leadItr : leadListForTest) {
            leadItr.LastName += (counter++);
        }
        leadListForTest[0].LastName = 'duplicateName';
        leadListForTest[1].LastName = 'duplicateName';
        leadListForTest[1].Email = 'duplicate@email.com';
        leadListForTest[2].LastName = 'duplicateName';
        leadListForTest[2].Email = 'duplicate@email.com';
        leadListForTest[3].Email = 'duplicate@email.com';
        insert leadListForTest;
        System.Test.startTest();
        Database.executeBatch(new DuplicateDetectorLeads(), 400);
        System.Test.stopTest();

        System.assertEquals(
            399,
            [
                SELECT
                    count()
                FROM
                    Lead
            ],
            '1 records will be deleted and the 1st will be saved.'
        );
    }
}