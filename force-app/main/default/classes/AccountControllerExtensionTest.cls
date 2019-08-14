/**
    CLASS:  AccountControllerExtensionTest
    ----------------------------
    This is a Test Class for AccountControllerExtension.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   5/Aug/19  Initial creation.
*/
@isTest
public with sharing class AccountControllerExtensionTest {
    @isTest
    public static void testThePage(){
        ApexPages.StandardSetController stdSetControllerObject = new ApexPages.StandardSetController([SELECT Id from Account]);
    }
}