/*
    CLASS:  SearchingAlgoImplementation
    ----------------------------
    This Class is for performing Various Searching related Operations.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Initial Creation.
*/

public with sharing class SearchingAlgoImplementation {
    list<Integer> integerInputList;
    Integer depth=1;

    /**
        Initializing the List of Integer as Input.
    */
    public SearchingAlgoImplementation(list<Integer> integerArray) {
        integerInputList = integerArray;
    }

    /**
        the actual binary searching method.
    */
    public Integer binarySearch(Integer key,Integer lowerLimit, Integer higherLimit){
        integerInputList.sort();
        System.debug('at depth: '+depth++);
        Integer mid = (lowerLimit+higherLimit)/2;
        if(higherLimit-lowerLimit>1){
            if(integerInputList[mid]>key){
                //System.debug(key+' < '+ arr[(lowerLimit+higherLimit)/2]);
                binarySearch(key,lowerLimit,mid);
            }else if(integerInputList[mid]<key){
                //System.debug(key+' > '+ arr[(lowerLimit+higherLimit)/2]);
                binarySearch(key,mid,higherLimit);
            }else{
                System.debug('found '+key+' at '+mid);
                return mid;
            }
        }else{
            System.debug('NOT FOUND..');
        }
        return -1;
    }

    /**
        the binary searching method exposed which calls the binary method.
        This exists for simple inputs, only the key.
    */
    public Integer binarySearch(Integer key){
        depth=1;
        return binarySearch(key,0,integerInputList.size());
    }

    /**
        the Linear searching method.
    */
    public Integer linearSearch(Integer key){
        Integer counter=0;
        for(Integer value : integerInputList){
            if(value == key){
                System.debug('found '+key+' at :'+counter);
                return counter;
            }
            counter++;
        }
        System.debug('NOT found '+key);
        return -1;
    }

}