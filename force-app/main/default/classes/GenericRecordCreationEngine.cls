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
    public List<SObject> createRecord(){
        /**
            Creates Type from Event Record's Name.
            deserialize JSON of type created earlier.
            append the deserialized Objects to one sObject List.
            Insert that List.
        */
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
            Type objectType = Type.forName('List<' + eventItr.Name + '>');
            List<SObject> deserializedObjectList =
                (List<SObject>)JSON.deserialize(eventItr.JSON__C, objectType);
            System.debug(deserializedObjectList);
            sObjectListToInsert.addAll(deserializedObjectList);
        }
        try {
            insert sObjectListToInsert;
            for(Integer intItr=0; intItr<eventList.size();intItr++){
                eventList[intItr].Record_Added__c = True;
            }
            update eventList;
        } catch (Exception exp) {
            System.debug(exp);
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