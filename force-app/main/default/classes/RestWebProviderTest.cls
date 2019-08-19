/**
    CLASS:  RestWebProviderTest
    ---------------------------------------------------------------------------
    This Test Class is for Testing the Rest functionalities in RestWebProvider.
    ---------------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   7/Aug/19    Test Class for REST web services.
*/
@isTest
public with sharing class RestWebProviderTest {

    /**
        This tests the get method of this rest web servicre;
    */
    @isTest
    public static void getMethodTest(){
        List<Lead> leadList = TestDataFactory.createLead(200, false);
        for (Lead leadItr : leadList) {
            leadItr.Company = 'The Company Name';
            leadItr.LastName = 'lastName';
            leadItr.Email = 'TheEmail@somedomain.com';
            leadItr.Phone = '9578659845';
        }
        insert leadList;
        Map<ID, Lead> leadIdMap = new Map<ID, Lead>(leadList);

        System.Test.startTest();
        List<Lead> leadListResult = RestWebProvider.getLeads();
        System.Test.stopTest();

        System.assertEquals(
            leadList.size(),
            leadListResult.size(),
            'Leads record added must be equal to the leads recieved.'
        );
    }

    /**
        This tests the post method of this rest web servicre;
    */
    @isTest
    public static void postMethodTest_PositiveCase(){
        RestWebProvider.ResponseClass responseWrapperObject;

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.addLead(
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return True'
        );
        System.assertEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Successful'
        );
        // String putBody = '{'+
        //     '"firstName":"' +   'firstname'  +
        //     '"lastName":"'  +   'lastName'  +
        //     '"email":"'     +   'TheEmail@somedomain.com"'  +
        //     '"phone":"'     +   '9578659845"'  +
        //     '"company":"'   +   'The Company Name"'  +
        // '}';
    }

    /**
        This tests the post method of this rest web service;

        CASE:   Failed Insertion.
    */
    @isTest
    public static void postMethodTest_NegativeCaseInsertionFailed(){
        RestWebProvider.ResponseClass responseWrapperObject;

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.addLead(
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return False'
        );
        System.assertEquals(
            true,
            responseWrapperObject.message.contains('INVALID_EMAIL_ADDRESS'),
            'Should return Invalid Email Error'
        );
    }

    /**
        This tests the patch method of this rest web service;

        CASE:   Positive Updation
    */
    @isTest
    public static void patchMethodTest_PositiveCase() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.updateLead(
            leadList[0].Id,
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return true'
        );
        System.assertEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Successfull'
        );
    }

    /**
        This tests the patch method of this rest web service;

        CASE:   Negative Case, INVALID EMAIL
    */
    @isTest
    public static void patchMethodTest_NegativeCaseInvalidEmail() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.updateLead(
            leadList[0].Id,
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return false'
        );
        System.assertEquals(
            true,
            responseWrapperObject.message.contains('INVALID_EMAIL_ADDRESS'),
            'Should return Email invalid Error.'
        );
    }

    /**
        This tests the patch method of this rest web service;

        CASE:   Negative Case, INVALID Id
    */
    @isTest
    public static void patchMethodTest_NegativeCaseNoId() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.updateLead(
            null,
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return false'
        );
        System.assertEquals(
            true,
            responseWrapperObject.message.contains('Id not specified in an update call'),
            'Should return Invalid Id Error.'
        );
    }

    /**
        This tests the patch method of this rest web service;

        CASE:  Negative Case, No LastName provided.
    */
    @isTest
    public static void patchMethodTest_NegativeCaseNoLastName() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.updateLead(
            leadList[0].Id,
            'Dummy FirstName',
            null,
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return false'
        );
        System.assertEquals(
            true,
            responseWrapperObject.message.contains('Required fields are missing: [LastName]'),
            'Should return Invalid For Empty LastName Field .'
        );
    }

    /**
        This tests the put method of this rest web service;

        CASE:  Positive Case - Insertion.
    */
    @isTest
    public static void putMethodTest_PositiveCaseInsertion() {
        RestWebProvider.ResponseClass responseWrapperObject;

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.upsertLead(
            '',
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return true'
        );
        System.assertEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Success'
        );
    }

    /**
        This tests the put method of this rest web service;

        CASE:  Positive Case - Updation.
    */
    @isTest
    public static void putMethodTest_PositiveCaseUpdation() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.upsertLead(
            leadList[0].Id,
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.assertEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return true'
        );
        System.assertEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Success'
        );
    }

    /**
        This tests the put method of this rest web service;

        CASE:  Negative Case.
    */
    @isTest
    public static void putMethodTest_NegativeCase() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.upsertLead(
            'InvalidId',
            'Dummy FirstName',
            'Dummy LastName',
            'dummy@email.com',
            '9876543210',
            'The Dummy Company'
        );
        System.Test.stopTest();

        System.debug('exceptions is: ' + responseWrapperObject);
        System.assertEquals(
            true,
            responseWrapperObject.message.contains('Invalid id'),
            'Should be a INVALID ID Error.'
        );
        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should not return true'
        );
        System.assertNotEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should not return Success'
        );
    }

    /**
        This tests the delete method of this rest web service;

        CASE:  Positive Case - Successfull Deletion.
    */
    @isTest
    public static void deleteMethodTest_PositiveCase() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);

        RestRequest request = new RestRequest();
        request.requestUri =
            'https://ap15.salesforce.com/services/apexrest/leads?id='
            + leadList[0].Id;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.params.put('id', leadList[0].Id);
        RestContext.request = request;

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.deleteLead();
        System.Test.stopTest();

        List<Lead> leadListAfterDeletion = [
            SELECT
                Id,
                Name
            FROM
                Lead
            WHERE
                Id = :leadList[0].Id
            LIMIT 1
        ];
        System.debug(leadListAfterDeletion+'..................: ' + responseWrapperObject);
        System.assertEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return true'
        );
        System.assertEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Success'
        );
        System.assertEquals(
            0,
            leadListAfterDeletion.size(),
            'Should be equal to 0 as the Lead with that id is deleted'
        );
    }

    /**
        This tests the delete method of this rest web service;

        CASE:  Negative Case - Failed Deletion, Record not exist.
    */
    @isTest
    public static void deleteMethodTest_NegativeCaseFailedDeletion() {
        RestWebProvider.ResponseClass responseWrapperObject;
        List<Lead> leadList = TestDataFactory.createLead(10, true);
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://ap15.salesforce.com/services/apexrest/leads?id=' +
            leadList[0].Id;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.params.put('id', 'invalidId');
        RestContext.request = request;

        delete leadList[0];

        System.Test.startTest();
        responseWrapperObject = RestWebProvider.deleteLead();
        System.Test.stopTest();

        System.debug('..................: ' + responseWrapperObject);
        System.assertNotEquals(
            true,
            responseWrapperObject.isSuccess,
            'Should return true'
        );
        System.assertNotEquals(
            'Successfull',
            responseWrapperObject.message,
            'Should return Success'
        );
    }

}