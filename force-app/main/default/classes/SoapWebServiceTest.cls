/**
    CLASS:  SoapWebServiceTest
    ---------------------------------------------------------------------------
    Test class for the SoapWebService Provider Class.
    ---------------------------------------------------------------------------
    Version#        Developer       Date            Description
        1           Mahesh Biswas   19/Aug/19       Initial Creation
*/
@isTest
public with sharing class SoapWebServiceTest {

    /**
        Tests the get method.
        Case:   Positive, Record Exists.
    */
    @isTest
    public static void getLeadsTest_Positive(){
        List<Lead> leadList = TestUtility.createLead(200,false);
        for(Lead leadItr : leadList){
            leadItr.FirstName = 'dummy firstName';
            leadItr.Email = 'email@dummy.com';
        }
        insert leadList;
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.getLeads();
        System.Test.stopTest();

        System.debug('GET-positive: '+theResponseClassObject.payload);
        System.assertEquals(
            100,
            theResponseClassObject.payload.size(),
            'Response should be true.'
        );
    }

    /**
        Tests the addLead method.
        Case:   Positive record added succesfully.
    */
    @isTest
    public static void addLeadsTest_Positive(){
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.addLead(
            'dummy firstName',
            'dummy_lastName',
            'email@dummy.com',
            '7895457815'
        );
        System.Test.stopTest();

        System.debug('add-positive: '+theResponseClassObject);
        System.assertEquals(
            true,
            theResponseClassObject.isSuccess,
            'Response should be true, as insertion is success.'
        );
        System.assertEquals(
            false,
            String.isBlank(theResponseClassObject.lead),
            'lead contains Id of recently added Record, so won\'t be blank'
        );
    }

    /**
        Tests the addLead method.
        Case:   Negative case, invalid Email.
    */
    @isTest
    public static void addLeadsTest_NegativeInvalidEmail(){
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.addLead(
            'dummy firstName',
            'dummy_lastName',
            'dummy_email',
            '7895457815'
        );
        System.Test.stopTest();

        System.debug('add-negative: '+theResponseClassObject);
        System.assertEquals(
            true,
            theResponseClassObject.status.contains('invalid email address'),
            'Response should be true, as insertion is success.'
        );
        System.assertEquals(
            true,
            String.isBlank(theResponseClassObject.lead),
            'lead is blank in case of failed operation.'
        );
    }

    /**
        Tests the updateLead method.
        Case:   Positive record updated succesfully.
    */
    @isTest
    public static void updateLeadTest_Positive(){
        List<Lead> leadList = TestUtility.createLead(1,false);
        for(Lead leadItr : leadList){
            leadItr.FirstName = 'oldFirstName';
            leadItr.LastName = 'oldLastName';
            leadItr.Email = 'oldEmail@dummy.com';
            leadItr.Phone = '0000000000';
        }
        insert leadList;
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.updateLead(
            'oldFirstName',
            'oldLastName',
            'newEmail@dummy.com',
            '1111111111'
        );
        System.Test.stopTest();

        System.debug('update-positive: '+theResponseClassObject);
        System.assertEquals(
            true,
            theResponseClassObject.isSuccess,
            'Response should be true, as insertion is success.'
        );
        System.assertEquals(
            false,
            String.isBlank(theResponseClassObject.lead),
            'lead contains Id of recently added Record, so won\'t be blank'
        );
    }

    /**
        Tests the addLead method.
        Case:   Negative case, Updating a non-existing record.
    */
    @isTest
    public static void updateLeadTest_NegativeNoMatchFound(){
        List<Lead> leadList = TestUtility.createLead(1,false);
        for(Lead leadItr : leadList){
            leadItr.FirstName = 'oldFirstName';
            leadItr.LastName = 'oldLastName';
            leadItr.Email = 'oldEmail@dummy.com';
            leadItr.Phone = '0000000000';
        }
        insert leadList;
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.updateLead(
            'non-existingFirstName',
            'non-existingLastName',
            'newEmail@dummy.com',
            '1111111111'
        );
        System.Test.stopTest();

        System.debug('update-negative: '+theResponseClassObject);
        System.assertEquals(
            false,
            theResponseClassObject.isSuccess,
            'Response should be false, as updation is failed.'
        );
        System.assertEquals(
            false,
            String.isBlank(theResponseClassObject.lead),
            'lead contains Id of recently added Record, so won\'t be blank'
        );
        System.assertEquals(
            true,
            theResponseClassObject.status.contains('No Record Found to UPDATE!'),
            'status must have NO RECORD FOUND '
        );
    }

    /**
        Tests the deleteLead method.
        Case:   Positive record deleted succesfully.
    */
    @isTest
    public static void deleteLeadTest_Positive(){
        List<Lead> leadList = TestUtility.createLead(1,false);
        for(Lead leadItr : leadList){
            leadItr.FirstName = 'oldFirstName';
            leadItr.LastName = 'oldLastName';
            leadItr.Email = 'oldEmail@dummy.com';
            leadItr.Phone = '0000000000';
        }
        insert leadList;
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.deleteLead(
            'oldFirstName',
            'oldLastName',
            'oldEmail@dummy.com',
            '0000000000'
        );
        System.Test.stopTest();

        System.debug('delete-positive: '+theResponseClassObject);
        System.assertEquals(
            true,
            theResponseClassObject.isSuccess,
            'Response should be true, as deletion is success.'
        );
        System.assertEquals(
            leadList[0].Name,
            theResponseClassObject.lead,
            'lead contains Id of recently deleted Record, so won\'t be blank'
        );
    }

    /**
        Tests deleteLead method.
        Case:   Negative case, deleteing a non-existing record.
    */
    @isTest
    public static void deleteLeadTest_NegativeNoMatchFound(){
        List<Lead> leadList = TestUtility.createLead(1,false);
        for(Lead leadItr : leadList){
            leadItr.FirstName = 'oldFirstName';
            leadItr.LastName = 'oldLastName';
            leadItr.Email = 'oldEmail@dummy.com';
            leadItr.Phone = '0000000000';
        }
        insert leadList;
        System.Test.startTest();
        SoapWebService.ResponseClass theResponseClassObject = SoapWebService.deleteLead(
            'non-existingFirstName',
            'non-existingLastName',
            'newEmail@dummy.com',
            '1111111111'
        );
        System.Test.stopTest();

        System.debug('delete-negative: '+theResponseClassObject);
        System.assertEquals(
            false,
            theResponseClassObject.isSuccess,
            'Response should be false, as updation is failed.'
        );
        System.assertEquals(
            false,
            String.isBlank(theResponseClassObject.lead),
            'lead contains Id of recently added Record, so won\'t be blank'
        );
        System.assertEquals(
            true,
            theResponseClassObject.status.contains('No Record Found to UPDATE!'),
            'status must have NO RECORD FOUND '
        );
    }
}
