public with sharing class Missing {
    public List<Integer> getListWithNElements(Integer count){
        //  Question 1
        List<Integer> integerList = new List<Integer>();
        for(Integer intItr=0; intItr<count ; intItr++){
            integerList.add(intItr+intItr*2);
        }
        return integerList;
    }
    public void queryOnContactToGetItsParentsName(){
        // Retrieves Parent's detail by making query on Child
        for(Contact contactItr : [
            SELECT
                Name,
                Account.Name,
                Account.Id
            FROM
                Contact
        ]   ){
            System.debug('Child(contact){');
            System.debug('....Contact_Name: '+contactItr.Name);
            System.debug('....Parent(Account){');
            System.debug('........Account_ID: '+contactItr.Account.Id);
            System.debug('........Account_Name: '+contactItr.Account.Name);
            System.debug('....}');
            System.debug('}');
        }
    }
}