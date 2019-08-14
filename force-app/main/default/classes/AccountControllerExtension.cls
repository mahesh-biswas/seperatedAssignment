public with sharing class AccountControllerExtension {
    public Account accountObject{get; set;}
    public Blob fileToUpload{get; set;}
    public String fileName{get; set;}
    public Boolean toggle{get; set;}
    // public List<Attachment> attachmentList{get; set;}
    // ApexPages.StandardController standardControllerObjectClassLevel;
    public AccountControllerExtension(ApexPages.StandardController standardControllerObject) {
        // this.standardControllerObjectClassLevel = standardControllerObject;
        this.accountObject = (Account)standardControllerObject.getRecord();
        this.toggle = False;
        System.debug('toggle value: '+toggle);
        this.accountObject = [
                                SELECT  Name
                                        ,AccountNumber
                                        ,Phone
                                        ,Industry
                                        ,Description
                                        ,Type
                                FROM    Account
                                WHERE   Id = :accountObject.Id
                                LIMIT   1
                            ];
        // this.attachmentList = [SELECT Id,Name,ParentId FROM Attachment Where ParentId = :accountObject.Id];
    }
    public PageReference goToEditPage(){
        PageReference acctPage = new PageReference('/apex/AccountEditThenUploadAttachment?id='+accountObject.Id);
        return acctPage;
    }
    public void toggleView(){
        if(toggle==null)
            toggle = False;
        System.debug('toggle value rerender1: '+toggle);
        if(toggle)
            toggle = False;
        else
            toggle = True;
        System.debug('toggle value rerender: '+toggle);
        // return toggle;
    }
    // @RemoteAction
    // public static Boolean toggleViewRemote(){
    //     return toggleView();
    // }
    public PageReference saveAll(){
        System.debug(accountObject.Name);
            Attachment attachmentBlob = new Attachment();
            attachmentBlob.ParentId = accountObject.Id;
            attachmentBlob.Body = fileToUpload;
            attachmentBlob.Name = fileName;
        try{
            System.debug(attachmentBlob.Name+' | '+attachmentBlob.ParentId);
            System.debug(attachmentBlob);
            insert attachmentBlob;
            update accountObject;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
            // return new PageReference('/'+accountObject.Id);
        }catch(Exception ex){
            System.debug('exc'+ex.getlineNumber()+' '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getlineNumber()+' '+ex.getMessage()));
        }
        return null;
        // return new PageReference('/'+accountObject.Id);
    }
}

/**
SELECT BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp FROM Attachment
 */