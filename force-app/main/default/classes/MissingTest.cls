/*
    CLASS:  MissingTest
    ----------------------------
    This is a Test Class for Missing.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   7/Aug/19    Initial Creation
*/
@isTest
public with sharing class MissingTest {
    @isTest
    public static void getListWithNElements(){
        System.Test.startTest();
        List<Integer> resultGenerated = new Missing().getListWithNElements(5);
        System.Test.stopTest();
        System.assertEquals(
            5,
            resultGenerated.size(),
            'The Size of the List must be equal to the Integer variable passed as parameter.'
        );
    }
}