/*
    CLASS:  SearchingAlgoImplementationTest
    ----------------------------
    This Class is for testing the SearchingAlgoImplementation Class.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   6/Aug/19    Initial Creation.
*/
@isTest
public with sharing class SearchingAlgoImplementationTest {
    /**
        Test for Binary Search.
    */
    @isTest
    public static void binarySearch(){
        List<Integer> integerList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        Integer key = 8;
        Integer result = 7;
        Integer generatedResult = -2;
        System.Test.startTest();
        generatedResult = new SearchingAlgoImplementation(integerList).binarySearch(key);
        System.Test.stopTest();
        System.assertEquals(result,generatedResult,'the index of element must be same.');
    }

    /**
        Test for Linear Search.
    */
    @isTest
    public static void linearSearch(){
        List<Integer> integerList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        Integer key = 8;
        Integer result = 8;
        Integer generatedResult = -2;
        System.Test.startTest();
        generatedResult = new SearchingAlgoImplementation(integerList).linearSearch(key);
        System.Test.stopTest();
        System.assertEquals(
            result,
            generatedResult,
            'the index of element must be same.'
        );
    }

}