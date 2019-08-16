/**
    CLASS:  SoapWebService
    ---------------------------------------------------------------------------
    This Provider class for SOAP services.
    ---------------------------------------------------------------------------
    Version#        Developer       Date            Description
        1           Mahesh Biswas   16/Aug/19       Initial Creation
*/
global with sharing class SoapWebService {

    final static String SUCCESS = 'Success';

    /**
        WRAPPER CLASS for Packing/Encapsulating Responses.
    */
    global class ResponseClass{
        global Boolean isSuccess = False;
        global String lead='';
        global String status ='';
        global List<Lead> payload;
        public ResponseClass(List<Lead> payload){
            this.payload = payload;
        }
        public ResponseClass(Boolean resultStatus, String status){
            this.isSuccess = resultStatus;
            this.status = status;
        }
        public ResponseClass(Boolean resultStatus, String status, String lead){
            this.isSuccess = resultStatus;
            this.status = status;
            this.lead =lead;
        }
    }

    /**
        This method is the webservice for Retrieval of Records.
    */
    webservice static ResponseClass getLeads(){
        return new ResponseClass(   [
            SELECT
                Id,
                FirstName,
                LastName,
                Email,
                Phone
            FROM
                Lead
            LIMIT
                200
        ]   );
    }

    /**
        This method is the webservice for Creation of Record.
    */
    webservice static ResponseClass addLead(
        String firstName, String lastName, String email, String phone
    ){
        try {
            Lead leadObjectToInsert = new Lead(
                FirstName   =   firstName,
                LastName    =   lastName,
                Email       =   email,
                Phone       =   phone
            );
            insert leadObjectToInsert;
            return new ResponseClass(true, SUCCESS, leadObjectToInsert.Id);
        } catch (DMLException dmlExceptionObject) {
            return new ResponseClass(false, dmlExceptionObject.getMessage());
        }
    }

    /**
        This method is the webservice for Updataion of Record.
    */
    webservice static ResponseClass updateLead(
        String oldFirstName, String oldLastName, String newEmail, String newPhone
    ){
        List<Lead> leadList = [
            SELECT
                Id
            FROM
                Lead
            WHERE
                FirstName = :oldFirstName AND LastName = :oldLastName
            LIMIT
                1
        ];
        for(Lead leadItr : leadList){
            leadItr.Email = newEmail;
            leadItr.Phone = newPhone;
        }
        try {
            if(leadList.size() > 0){
                update leadList;
                return new ResponseClass(true, SUCCESS, leadList[0].Id);
            }
            else {
                return new ResponseClass(false, 'No Record Found to UPDATE!');
            }
        } catch (DMLException dmlExceptionObject) {
            return new ResponseClass(false, dmlExceptionObject.getMessage());
        }
    }

    /**
        This method is the webservice for Deletion of Record.
    */
    webservice static ResponseClass deleteLead(
        String firstName, String lastName, String email, String phone
    ){
        try {
            Lead leadObjectToDelete = [
                SELECT
                    Id
                FROM
                    Lead
                WHERE
                    FirstName = :firstName
                    AND LastName = :lastName
                    AND Email = :email
                    AND Phone = :phone
            ];
            delete leadObjectToDelete;
            return new ResponseClass(true, SUCCESS, firstName);
        } catch (DMLException dmlExceptionObject) {
            return new ResponseClass(false, dmlExceptionObject.getMessage());
        }
    }

}
