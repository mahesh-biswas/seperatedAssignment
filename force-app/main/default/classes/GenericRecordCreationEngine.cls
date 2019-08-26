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
                Id,
                Error__c
            FROM
                Event__c
            WHERE
                Record_Added__c = False
        ];
        Type objectType = null;
        List<SObject> deserializedObjectList;
        Integer integerItr = 0;
        List<Integer> newEventOccuringIndexList = new List<Integer>();
        for (Event__c eventItr : eventList ){
            eventItr.Error__c = '';
            objectType = Type.forName('List<'+eventItr.Name+'>');
            deserializedObjectList =
                (List<SObject>) JSON.deserialize(eventItr.JSON__C, objectType);
            System.debug(deserializedObjectList);
            sObjectListToInsert.addAll(deserializedObjectList);
            integerItr+=deserializedObjectList.size();
            newEventOccuringIndexList.add(integerItr);
        }
        System.debug('list Indexes: '+newEventOccuringIndexList);
        List<Database.saveResult> saveResultList =
                Database.insert(sObjectListToInsert, false);
        integerItr = 0;
        Integer eventIndexCounterInteger = 0;
        Integer withinEventJsonObjectCounter=0;
        for(Database.saveResult saveResultItr : saveResultList){
            if(newEventOccuringIndexList.contains(
                        integerItr
            )   ){
                newEventOccuringIndexList.remove(0);
                eventIndexCounterInteger++;
                withinEventJsonObjectCounter = 0;
            }
            if(saveResultItr.isSuccess()){
                eventList[eventIndexCounterInteger].Record_Added__c = true;
            }else{
                for(Database.Error err : saveResultItr.getErrors()) {
                    eventList[eventIndexCounterInteger].Error__c +=
                        ' for object '+withinEventJsonObjectCounter+': '+err.getMessage()+'\n';
                }
            }
            withinEventJsonObjectCounter++;
            integerItr++;
        }
        Database.update(eventList, false);
        return sObjectListToInsert;
    }
}