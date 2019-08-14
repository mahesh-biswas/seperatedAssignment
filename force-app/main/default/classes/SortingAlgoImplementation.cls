/*
    CLASS:  SortingAlgoImplementation
    ----------------------------
    This Class is for performing Various Sorting related Operations.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Initial Creation.
*/
public with sharing class SortingAlgoImplementation {
    List<Integer> integerList;

    public SortingAlgoImplementation(list<Integer> integerArray) {
        this.integerList = integerArray;
    }

    /**
        Code for Bubble sort.
    */
    public List<Integer> bubbleSort(){
        for(Integer itrOuter=0;itrOuter<integerList.size();itrOuter++){
            for(Integer itrInner=0;itrInner<integerList.size();itrInner++){
                if(integerList[itrOuter] > integerList[itrInner]){
                    integerList[itrOuter] += integerList[itrInner];
                    integerList[itrInner] = integerList[itrOuter] - integerList[itrInner];
                    integerList[itrOuter] -= integerList[itrInner];
                }
            }
        }
        System.debug('Sorted!! : '+integerList);
        return integerList;
    }

    /**
        Code for Insertion sort.
    */
    public List<Integer> insertionSort(){
        Integer rounds = 1;
        for(Integer i=0;i<integerList.size()-1;i++){
            for(Integer j=i;j<integerList.size();j++){
                rounds++;
                if(integerList[i] < integerList[j]){
                    integerList[i] += integerList[j];
                    integerList[j] = integerList[i] - integerList[j];
                    integerList[i] -= integerList[j];
                }
            }
        }
        System.debug(integerList);
        System.debug('Rounds: '+rounds);
        return integerList;
    }

    /**
        Code for Merge sort.
    */
    public List<Integer> mergeSort(){
        List<Integer> tmpIntList = integerList.clone();
        mergeList(tmpIntList,0,tmpIntList.size(),integerList);
        System.debug('Sorted: '+tmpIntList);
        System.debug('Sorted: '+integerList);
        return integerList;
    }
    public void mergeList(
        List<Integer> integerList,
        Integer lowerLimit,
        Integer higherLimit,
        List<Integer> tmpStorage
    ){
        if(integerList.size()<2)
            return;
        mergeList(tmpStorage,lowerLimit,(lowerLimit+higherLimit)/2,integerList);
        mergeList(tmpStorage,(lowerLimit+higherLimit)/2,higherLimit,integerList);

        mergethem(integerList,lowerLimit,(lowerLimit+higherLimit)/2,higherLimit,tmpStorage);
    }

    public void mergethem(
        List<Integer> firstIntegerList,
        Integer lowerLimit,
        Integer midLimit,
        Integer higherLimit,List<Integer> secondIntegerList
    ){
        Integer i = lowerLimit;
        Integer j = midLimit;
        for (Integer k = lowerLimit; k < higherLimit; k++) {
            if (i < midLimit && (j >= higherLimit || firstIntegerList[i] <= firstIntegerList[j])) {
                secondIntegerList[k] = firstIntegerList[i];
                i = i + 1;
            } else {
                secondIntegerList[k] = firstIntegerList[j];
                j = j + 1;
            }
        }
    }

    /**
        Code for Selection sort.
    */
    public List<Integer> selectionSort(){
        for(Integer outerIntItr=0;outerIntItr<integerList.size()-1;outerIntItr++){
            for(Integer innerIntItr=outerIntItr;innerIntItr<integerList.size();innerIntItr++){
                if(integerList[outerIntItr] < integerList[innerIntItr]){
                    integerList[outerIntItr] += integerList[innerIntItr];
                    integerList[innerIntItr] = integerList[outerIntItr] - integerList[innerIntItr];
                    integerList[outerIntItr] -= integerList[innerIntItr];
                }
            }
        }
        System.debug(integerList);
        return integerList;
    }
}