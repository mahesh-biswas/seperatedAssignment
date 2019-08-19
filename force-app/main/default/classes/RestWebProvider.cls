/**
    CLASS:  RestWebProviderTest
    ---------------------------------------------------------------------------
    This Test Class is for Testing the Rest functionalities in RestWebProvider.
    ---------------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   6/Aug/19    Class for REST web services.
*/
@RestResource(urlMapping='/leads')
global with sharing class RestWebProvider{

    /**
        WRAPPER CLASS for Packing/Encapsulating Responses.
    */
    global class ResponseClass{
        global Boolean isSuccess = False;
        global String Id='';
        global String message ='';
        public ResponseClass(Boolean resultStatus, String message){
            this.isSuccess = resultStatus;
            this.message = message;
        }
        public ResponseClass(Boolean resultStatus, String message, String Id){
            this.isSuccess = resultStatus;
            this.message = message;
            this.Id =Id;
        }
    }

    /**
        This is the Get Method for retrieving Lead Record.
    */
    @HttpGet
    global static List<Lead> getLeads(){
        return [SELECT
                    Name,
                    Id,
                    Company,
                    Email,
                    Phone
                FROM
                    Lead
                ORDER BY
                    CreatedDate DESC NULLS LAST
                LIMIT
                    100
        ];
    }

    /**
        This is the Post Method for adding Lead Record.
    */
    @HttpPost
    global static ResponseClass addLead(
            String firstName, String lastName, String email, String phone, String company
    ){
        ResponseClass responseObject;
        try{
            Lead leadObject = new Lead(
                FirstName   =   firstName,
                LastName    =   lastName,
                Email       =   email,
                Phone       =   phone,
                Company     =   company
            );
            insert leadObject;
            responseObject = new ResponseClass(true, 'Successfull', leadObject.Id);
        }catch(DMLException exceptionDML){
            responseObject = new ResponseClass(
                false,
                exceptionDML.getMessage()
            );
        }
        return responseObject;
    }

    /**
        This is the Put Method for upserting Lead Record.
    */
    @HttpPut
    global static ResponseClass upsertLead(
        String id, String firstName, String lastName, String email , String phone, String company
    ){
        Lead leadObjectToInsert;
        ResponseClass responseObject;
        if(!String.isBlank(id)){
            try {
                leadObjectToInsert = new Lead(
                    FirstName   =   firstName,
                    Id          =   id,
                    LastName    =   lastName,
                    Email       =   email,
                    Phone       =   phone,
                    Company     =   company
                );
            } catch (Exception exceptionObject) {
                responseObject = new ResponseClass(false, exceptionObject.getMessage());
                return responseObject;
            }
        }
        else{
            leadObjectToInsert = new Lead(
                FirstName   =   firstName,
                LastName    =   lastName,
                Email       =   email,
                Phone       =   phone,
                Company     =   company
            );
        }
        try {
            upsert leadObjectToInsert;
            responseObject = new ResponseClass(true, 'Successfull', leadObjectToInsert.Id);
        } catch (DMLException dmlExceptionObject) {
            responseObject = new ResponseClass(
                false,
                dmlExceptionObject.getMessage()
            );
        }
        return responseObject;
    }

    /**
        This is the Patch Method for updating Lead Record.
    */
    @HttpPatch
    global static ResponseClass updateLead(
        String id, String firstName, String lastName, String email, String phone, String company
    ){
        System.debug('--------><-- ');
        Lead leadObjectToInsert;
        ResponseClass responseObject;
        leadObjectToInsert = new Lead(
            Id          =   id,
            FirstName   =   firstName,
            LastName    =   lastName,
            Email       =   email,
            Phone       =   phone,
            Company     =   company
        );
        try {
            update leadObjectToInsert;
            responseObject = new ResponseClass(true, 'Successfull', leadObjectToInsert.Id);
        } catch (DMLException dmlExceptionObject) {
            responseObject = new ResponseClass(
                false,
                dmlExceptionObject.getMessage()
            );
        }
        return responseObject;
    }

    /**
        This is the Delete Method deleteing <> Lead Record.
    */
    @HttpDelete
    global static ResponseClass deleteLead(){
        ResponseClass responseObject;
        RestRequest req = RestContext.request;
        // System.debug(JSON.serializePretty(req));
        System.debug(req.params);
        System.debug(req.params.get('id'));
        try {
            String id = String.valueOf(req.params.get('id'));
            System.debug('id is: ' + id);
            List<Lead> leadListToDelete =  [
                SELECT
                    Id
                FROM
                    Lead
                WHERE
                    Id = :id
            ];
            if(leadListToDelete.size()<1){
                responseObject = new ResponseClass(false, 'Invalid ID Passes');
                return responseObject;
            }
            delete leadListToDelete;
            responseObject = new ResponseClass(true, 'Successfull', id);
        } catch (DMLException dmlExceptionObject) {
            responseObject = new ResponseClass(
                false,
                dmlExceptionObject.getMessage()
            );
        }
        return responseObject;
    }


}