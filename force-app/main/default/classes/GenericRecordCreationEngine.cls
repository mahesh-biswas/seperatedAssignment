/**
    CLASS:  GenericRecordCreationEngine
    ----------------------------
    This Class is for creating Records of any object using JSON.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   5/Aug/19    Class for the Generic Record
                                                Creation Based on JSON.
*/
public with sharing class GenericRecordCreationEngine {

    /**
        Creates Type from Event Record's Name.
        deserialize JSON of type created earlier.
        append the deserialized Objects to one sObject List.
        Insert that List.
    */
    public List<SObject> createRecord(){
        List<SObject> sObjectListToInsert = new List<SObject>();
        List<Event__c> eventList = [
            Select
                Name,
                JSON__C,
                Id
            FROM
                Event__c
            WHERE
                Record_Added__c = False
        ];
        for (Event__c eventItr : eventList ){
            Type objectType = Type.forName('List<'+eventItr.Name+'>');
            List<SObject> deserializedObjectList =
                (List<SObject>) JSON.deserialize(eventItr.JSON__C, objectType);
            System.debug(deserializedObjectList);
            sObjectListToInsert.addAll(deserializedObjectList);
        }
        List<Database.saveResult> saveResultList =
                Database.insert(sObjectListToInsert, false);
        Integer intItr = 0;
        for(Database.saveResult saveResultItr : saveResultList){
            if(saveResultItr.isSuccess()){
                eventList[intItr].Record_Added__c = true;
            }else{
                for(Database.Error err : saveResultItr.getErrors()) {
                    eventList[intItr].Error__c += err.getMessage()+'\n';
                }
            }
            intItr++;
        }
        try {
            update eventList;
        } catch (DMLException dmlExceptionObject) {
            System.debug(dmlExceptionObject);
        }
        // Database.SaveResult[] saveResultList = Database.insert(deserializedObjectList, false);
        // Map<Id,sObject> deserializedObjectInsertedMap = new Map<Id,sObject>(deserializedObjectList);
        // for (Database.SaveResult saveResultItr : saveResultList) {
        //     if(saveResultItr.isSuccess()){
        //         deserializedObjectInsertedMap.get(saveResultItr.getId()).
        //     }
        // }
        System.debug('debug:desAllInsert::'+sObjectListToInsert);
        return sObjectListToInsert;
    }
}