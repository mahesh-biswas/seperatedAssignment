/**
 * @File Name          : GenericRecordCreationEngineTest.cls
 * @Description        : 
 * @Author             : Mahesh Biswas
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/26/2019, 7:31:23 PM
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/26/2019, 3:23:31 PM   Mahesh Biswas     Initial Version
**/
@isTest
public with sharing class GenericRecordCreationEngineTest {

    /**
    * @description
    * @author Mahesh Biswas | 8/26/2019
    * @return @isTest
    */
    @isTest
    public static void createRecord_Positive(){
        List<Event__c> eventList = TestDataFactory.createEvent(1, false);
        String jsonFormatAccountRecordDetails = '['+
            '{'+
            '    "Name": "Account One",'+
            '    "Description": "Added From Event Object"'+
            '},'+
            '{'+
            '    "Name": "Account Two",'+
            '    "Description": "Added From Event Object"'+
            '}'+
        ']';
        for(Event__c eventItr : eventList){
            eventItr.Name = 'Account';
            eventItr.JSON__c = jsonFormatAccountRecordDetails;
        }
        Database.insert(eventList, false);
        System.Test.startTest();
            new GenericRecordCreationEngine().createRecord();
        System.Test.stopTest();
        Integer totalAccountRecordCount = [
            SELECT
                count()
            From
                Account
        ];
        System.assertEquals(
            2,
            totalAccountRecordCount,
            'Exactly 2 account to be created successfully.'
        );
    }

    /**
    * @description
    * @author Mahesh Biswas | 8/26/2019
    * @return @isTest
    */
    @isTest
    public static void createRecord_Negative(){
        List<Event__c> eventList = TestDataFactory.createEvent(2, false);
        String jsonFormatAccountRecordDetails = '['+
            '{'+
            '    "Description": "Added From Event Object"'+
            '},'+
            '{'+
            '    "Name": "Account Two",'+
            '    "Description": "Added From Event Object"'+
            '}'+
        ']';
        String jsonFormatAccountRecordDetailsPassing = '['+
            '{'+
            '    "Name": "Account success",'+
            '    "Description": "Added From Event Object"'+
            '},'+
            '{'+
            '    "Description": "Added From Event Object"'+
            '}'+
        ']';
        for(Event__c eventItr : eventList){
            eventItr.Name = 'Account';
            eventItr.JSON__c = jsonFormatAccountRecordDetails;
        }
        eventList[1].JSON__c = jsonFormatAccountRecordDetailsPassing;
        Database.insert(eventList, false);
        System.Test.startTest();
            new GenericRecordCreationEngine().createRecord();
        System.Test.stopTest();
        Integer totalAccountRecordCount = [
            SELECT
                count()
            From
                Account
        ];
        System.assertNotEquals(
            4,
            totalAccountRecordCount,
            'All 4 Account Records won\'t be added successfully. some have missing required fields.'
        );
    }
}
