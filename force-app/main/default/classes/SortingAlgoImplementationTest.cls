/*
    CLASS:  SortingAlgoImplementationTest
    ----------------------------
    This is a Test Class for SortingAlgoImplementations.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Initial Test class.
*/
@isTest
public with sharing class SortingAlgoImplementationTest {

    /**
        Tests the result of Bubble sort.
    */
    @isTest
    static void bubbleSort(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        List<Integer> expectedsortedList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        System.Test.startTest();
        List<Integer> actualSortedList = new SortingAlgoImplementation(intList).bubbleSort();
        System.Test.stopTest();
        for(Integer integerItr=0; integerItr<expectedsortedList.size(); integerItr++){
            System.assertEquals(
                expectedsortedList[integerItr],
                actualSortedList[integerItr],
                'Each element must be same.'
            );
        }
    }

    /**
        Tests the result of Insertion sort.
    */
    @isTest
    static void insertionSort(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        List<Integer> expectedsortedList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        System.Test.startTest();
        List<Integer> actualSortedList = new SortingAlgoImplementation(intList).insertionSort();
        System.Test.stopTest();
        for(Integer integerItr=0; integerItr<expectedsortedList.size(); integerItr++){
            System.assertEquals(
                expectedsortedList[integerItr],
                actualSortedList[integerItr],
                'Each element must be same.'
            );
        }
    }

    /**
        Tests the result of Bubble sort.
    */
    @isTest
    static void mergeSort(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        List<Integer> expectedsortedList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        System.Test.startTest();
        List<Integer> actualSortedList = new SortingAlgoImplementation(intList).mergeSort();
        System.Test.stopTest();
        for(Integer integerItr=0; integerItr<expectedsortedList.size(); integerItr++){
            System.assertEquals(
                expectedsortedList[integerItr],
                actualSortedList[integerItr],
                'Each element must be same.'
            );
        }
    }

    /**
        Tests the result of Bubble sort.
    */
    @isTest
    static void selectionSort(){
        List<Integer> intList = new List<Integer>{1,10,4,2,3,6,5,7,8,15};
        List<Integer> expectedsortedList = new List<Integer>{1,2,3,4,5,6,7,8,10,15};
        System.Test.startTest();
        List<Integer> actualSortedList = new SortingAlgoImplementation(intList).selectionSort();
        System.Test.stopTest();
        for(Integer integerItr=0; integerItr<expectedsortedList.size(); integerItr++){
            System.assertEquals(
                expectedsortedList[integerItr],
                actualSortedList[integerItr],
                'Each element must be same.'
            );
        }
    }

}