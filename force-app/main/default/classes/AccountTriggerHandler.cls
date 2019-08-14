/*
    CLASS:  AccountTriggerHandler
    ------------------------------------------------------------------------------
    This is a Handler Class for AccountTrigger.
    ------------------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created handler class for
                                                Account related Trigger.
                                                Has method that creates
                                                clone of record on Account Update.
*/

public with sharing class AccountTriggerHandler {

    /***
        Creates a clone of the Account's Record attempting to edit.

        QUESTION:
            Write a Trigger on Account which will create the clone record.
    */
    public void createAccountRecordClones(List<Account> accountListfromTrigger){
        List<Account> theAccountList = new List<Account>();
        for(Account acc : accountListfromTrigger){
            Account newClonedAccount;
            if(
                String.isBlank(acc.Description)
                    ||
                !acc.Description.contains('THIS IS A CLONED RECORD.')
            ){
                newClonedAccount = acc.clone(false, true, true, false);
                if(newClonedAccount.Description == null){
                    newClonedAccount.Description = '';
                }
                newClonedAccount.Description += 'THIS IS A CLONED RECORD.';
                theAccountList.add(newClonedAccount);
            }
        }
        insert theAccountList;
    }

    /***
        If Match Billing Address is checked then Shipping Postal
        equals Billing Postal.

        This was a part of a TRAILHEAD Module.
    */
    public void addressVerifier(List<Account> accountListfromTrigger){
        for(Account accountItr : accountListfromTrigger){
            if(accountItr.Match_Billing_Address__c &&
                accountItr.BillingPostalCode != null
            ){
                accountItr.ShippingPostalCode = accountItr.BillingPostalCode;
            }
        }
    }
}