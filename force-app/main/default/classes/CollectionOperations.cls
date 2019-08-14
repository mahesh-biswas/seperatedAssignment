/*
    CLASS:  CollectionOperations
    ----------------------------
    This Class is for performing Operations related to Collection.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Created the class for
                                                performing Collection
                                                related Operations.
*/
public with sharing class CollectionOperations {
    List<Integer> integerList;
    public static final Boolean ASCENDING = True;
    public static final Boolean DESCENDING = False;
    public static final Boolean MAXIMUM = True;
    public static final Boolean MINIMUM = False;

    /**
        Initializes the List with predefined values.(Input integerListay)
    */
    public CollectionOperations() {
        integerList = new List<Integer>{1,2,10,5,6,12,3,8,19,2,5,3,1};
    }

    /**
        Initializes the List with another list.
    */
    public CollectionOperations(List<Integer> inputList) {
        integerList = inputList;
    }

    /**
        Sorts the List in Ascending or descending order,
        Based on the Order Boolean passed.
        IF order is true then sorts in Ascending
        else sortd in Descending order and then returns the List.
    */
    public List<Integer> sortWithOrder(Boolean order){
        System.debug(integerList);
        for(Integer i=0;i<integerList.size();i++){
            for(Integer j=0;j<integerList.size();j++){
                if(order){
                    if(integerList[i]<integerList[j]){
                        integerList[i] += integerList[j];
                        integerList[j] = integerList[i] - integerList[j];
                        integerList[i] -= integerList[j];
                    }
                }
                else{
                    if(integerList[i]>integerList[j]){
                        integerList[i] += integerList[j];
                        integerList[j] = integerList[i] - integerList[j];
                        integerList[i] -= integerList[j];
                    }
                }
            }
        }
        System.debug('Sorted:');
        System.debug(integerList);
        return integerList;
    }

    /**
        Finds Maximum or Minimum Number from a List, Based on the Order Boolean passed.
        IF order is true then Maximum element else Minimum element is returned.
    */
    public Integer findMaxOrMinNumber(Boolean order){
        Integer comparingNumber = integerList[0];
        for(Integer intElement : integerList){
            if(order){
            	comparingNumber = intElement > comparingNumber ? intElement : comparingNumber;
            }
            else{
                comparingNumber = intElement < comparingNumber ? intElement : comparingNumber;
            }
        }
        if(order){
        	System.debug('The Maximum number is: '+comparingNumber);
        }
        else{
        	System.debug('The Minimum number is: '+comparingNumber);
        }
        return comparingNumber;
    }

    /**
        In a List this method maps the occurences of each element.
    */
    public Map<Integer, Integer> duplicates(){
        Map<Integer, Integer> occur = new Map<Integer, Integer>();
        for(Integer intElem : integerList){
            //Use Map function
            if(occur.containsKey(intElem)){
                occur.put(intElem,occur.get(intElem)+1);
            }
            else{
                occur.put(intElem,1);
            }
        }
        System.debug('Occurrences are: ');
        System.debug(occur);
        return occur;
    }

    /**
        calculate Simple Interest with given Params.
    */
    public Decimal simpleInterestFor(Double principleAmount,Double interestRate,Integer timePeriod){
        Decimal simpleInterest = principleAmount*interestRate*timePeriod/100;
        System.debug('Simple interest is: '+simpleInterest);
        return simpleInterest;
    }

}