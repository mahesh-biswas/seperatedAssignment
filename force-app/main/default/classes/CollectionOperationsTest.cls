/*
    CLASS:  CollectionOperationsTest
    ----------------------------
    This is a Test Class for CollectionOperations.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created test class for the Collection
                                                Operation's Function Testing.
                                                Tests the functionality in
                                                CollectionOperation class.
*/
@isTest
public with sharing class CollectionOperationsTest {

    /**
        Sorts list in Ascending format.
    */
    @isTest
    static void sortWithOrderAscending(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        // intList.sort();
        List<Integer> sortedList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        Integer counter = 0;
        System.Test.startTest();
        List<Integer> methodSortedResult = new CollectionOperations(intList).sortWithOrder(
                                                    CollectionOperations.ASCENDING
                                                );
        System.Test.stopTest();
        for(Integer intItr : methodSortedResult){
            System.assertEquals(
                sortedList[intItr],
                intItr,
                'comparing Element by ELement. Should give same result'
            );
        }
    }

    /**
        Sorts list in DESCENDING format.
    */
    @isTest
    static void sortWithOrdeDescending(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        // intList.sort();
        List<Integer> sortedList = new List<Integer>{15,10,8,7,6,5,4,3,2,1};
        Integer counter = 0;
        System.Test.startTest();
        List<Integer> methodSortedResult = new CollectionOperations(intList).sortWithOrder(
                                                    CollectionOperations.DESCENDING
                                                );
        System.Test.stopTest();
        for(Integer intItr : methodSortedResult){
            System.assertEquals(
                sortedList[intItr],
                intItr,
                'comparing Element by ELement. Should give same result'
            );
        }
    }

    /**
        Test for the Maximum number in a list.
    */
    @isTest
    static void findMaximumNumber(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        Integer result = 15;
        System.Test.startTest();
        Integer methodGeneratedResult = new CollectionOperations(intList).findMaxOrMinNumber(
                                                CollectionOperations.MAXIMUM
                                            );
        System.Test.stopTest();
        System.assertEquals(
            result,
            methodGeneratedResult,
            'comparing the result recieved for Maximum element of List.'
        );
    }

    /**
        Test for the Minimum number in a list.
    */
    @isTest
    static void findMinimumNumber(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        Integer result = 1;
        System.Test.startTest();
        Integer methodGeneratedResult = new CollectionOperations(intList).findMaxOrMinNumber(
                                                CollectionOperations.MINIMUM
                                            );
        System.Test.stopTest();
        System.assertEquals(
            result,
            methodGeneratedResult,
            'comparing the result recieved for Minimum element of List.'
        );
    }

    /**
        Test for Simple Interest.
    */
    @isTest
    static void simpleInterestFor(){
        Integer timePeriod = 2;
        Double principleAmount = 1200;
        Integer interestRate = 5;
        Decimal expectedResult = 120;
        System.Test.startTest();
        Decimal generatedResult = new CollectionOperations().simpleInterestFor(
                                            principleAmount,
                                            interestRate,
                                            timePeriod
                                        );
        System.Test.stopTest();
        System.assertEquals(
            expectedResult, generatedResult, 'Simple interest should be same'
        );
    }
}