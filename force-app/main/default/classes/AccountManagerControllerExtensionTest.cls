/**
    CLASS Name: AccountManagerControllerExtensionTest
    -------------------------------------------------
    Description:    The Test Class for the AccountManagerControllerExtension
                    used in Account Manager Page.
    ------------------------------------------------------------------------------------------------
    VERSION #       DEVELOPER           CREATED         DESCRIPTION
        1           Mahesh Biswas       5/Aug/19        Initial Creation.

*/
@isTest
public with sharing class AccountManagerControllerExtensionTest {

    /**
        The Helper Methods needed in this Testing Class.
        Description:    Creates Account's Starting with specific Letter(nameStartsWith)
                        and also how many accounts to create can also be specified(count).
                        Returns the List of Accounts created.
    */
    private static List<account> addAccountWithName(String nameStartsWith,Integer count){
        List<Account> accountList = new List<Account>();
        for(Account accountItr : TestDataFactory.createAccountWithName(
                                        count,
                                        nameStartsWith+' name',
                                        True
                                    )
        ){
            accountItr.Phone = ''+Integer.valueOf(Math.random()*Integer.valueOf(math.pow(10,10)));
            accountItr.Website = 'http://www.google.com/search?q='+accountItr.Name;
            accountList.add(accountItr);
        }
        return accountList;
    }
    private static Integer findCountFromSearchResult(
            AccountManagerControllerExtension accountManagerObject,
            String alphabet
    ){
        /**
            The Helper Methods needed in this Testing Class.
            Description:    Searches for Records starting with some specific Alphabet in the
                            ControllerExtension class. And returns the Count of search result.
        */
        accountManagerObject.alphabet = alphabet;
        accountManagerObject.searchFor();
        return accountManagerObject.accountList.size();
    }

    /**
        The Actual testing method, tests the Alphabetic search strip.
    */
    @isTest
    public static void theAlphabetSearchStripTest(){
        List<Account> accountList = new List<Account>();
        accountList.addAll(addAccountWithName('A',20));
        accountList.addAll(addAccountWithName('B',20));
        accountList.addAll(addAccountWithName('C',20));
        accountList.addAll(addAccountWithName('D',20));
        accountList.addAll(addAccountWithName('M',20));
        accountList.addAll(addAccountWithName('T',20));
        insert accountList;
        Map<String,Integer> alphabeticRecordMap = new Map<String,Integer>();
        System.Test.setCurrentPage(
            new PageReference(
                '/apex/AccountManagerPage'
            )
        );
        System.Test.startTest();
        AccountManagerControllerExtension accountmanagerControllerExtensionObject =
            new AccountManagerControllerExtension(
                new ApexPages.StandardSetController(accountList)
        );
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('A',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'A'
        ));
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('B',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'B'
        ));
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('C',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'C'
        ));
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('D',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'D'
        ));
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('E',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'E'
        ));
        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('M',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'M'
        ));
        System.Test.stopTest();
        System.assertEquals(
            20,
            alphabeticRecordMap.get('A'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
        System.assertEquals(
            20,
            alphabeticRecordMap.get('B'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
        System.assertEquals(
            20,
            alphabeticRecordMap.get('C'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
        System.assertEquals(
            20,
            alphabeticRecordMap.get('D'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
        System.assertEquals(
            0,
            alphabeticRecordMap.get('E'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
        System.assertEquals(
            20,
            alphabeticRecordMap.get('M'),
            'The search result When clicked on the alphabetic Strip on top of Table.'
        );
    }

    @isTest
    public static void testThePage(){
        /**
            The Actual testing method, that tests the entire page.
        */
        List<Account> accountList = new List<Account>();
        accountList.addAll(addAccountWithName('A',20));
        accountList.addAll(addAccountWithName('B',20));
        accountList.addAll(addAccountWithName('C',20));
        accountList.addAll(addAccountWithName('D',20));
        accountList.addAll(addAccountWithName('M',20));
        accountList.addAll(addAccountWithName('T',20));
        insert accountList;
        System.debug(accountList);
        Map<String,Integer> alphabeticRecordMap = new Map<String,Integer>();
        System.Test.startTest();
        System.Test.setCurrentPage(
            new PageReference(
                '/apex/AccountManagerPage'
            )
        );
        AccountManagerControllerExtension accountmanagerControllerExtensionObject =
            new AccountManagerControllerExtension(
                new ApexPages.StandardSetController(accountList)
        );
        Integer initialAccountCount = accountmanagerControllerExtensionObject.accountList.size();
        // accountmanagerControllerExtensionObject.alphabet = 'A';
        // accountmanagerControllerExtensionObject.searchFor();
        // alphabeticRecordMap.put('A',accountmanagerControllerExtensionObject.accountList.size());

        //  The Searching using the InputField but character limit not reached.
        accountmanagerControllerExtensionObject.accountObject.Site = 'a';
        Integer resultForCharLenLess3BeforeSearch =
                accountmanagerControllerExtensionObject.retrieveAccounts().size();
        accountmanagerControllerExtensionObject.searchFor();
        Integer resultForCharLenLess3AfterSearch =
                accountmanagerControllerExtensionObject.retrieveAccounts().size();
        Boolean renderErrorMessage = accountmanagerControllerExtensionObject.renderLengthError;
        //  The Searching using the InputField.
        accountmanagerControllerExtensionObject.accountObject.Site = 'B name1';
        accountmanagerControllerExtensionObject.searchFor();
        Integer searchResultCount =
                accountmanagerControllerExtensionObject.retrieveAccounts().size();
        //  The Clearing Event
        accountmanagerControllerExtensionObject.clearAll();
        Integer afterClearListCount =
                accountmanagerControllerExtensionObject.retrieveAccounts().size();

        //  Searching using the ALPHABET STRIP.
        alphabeticRecordMap.put('E',findCountFromSearchResult(
            accountmanagerControllerExtensionObject,
            'E'
        ));
        Boolean norecordsBoolean = accountmanagerControllerExtensionObject.renderList;
        System.debug('from test class..............'+norecordsBoolean);

        Integer afterClearSearchBoxSize =
                accountmanagerControllerExtensionObject.accountObject.Site.length();
        Boolean recordsBoolean = accountmanagerControllerExtensionObject.renderList;
        System.debug('from test class M..............'+recordsBoolean);
        String idToDelete = accountList[0].Id;
        String expectedSuccessDeletion = AccountManagerControllerExtension.deleteAccount(idToDelete);
        String expectedFailedDeletion = AccountManagerControllerExtension.deleteAccount(idToDelete);
        System.Test.stopTest();
        System.debug('all'+alphabeticRecordMap);

        System.assertEquals(
            expectedSuccessDeletion,
            'Deleted Successfully',
            'Success Deletion.'
        );
        System.assertEquals(
            expectedFailedDeletion,
            'Deleted FAILED!!',
            'Failed Deletion.'
        );
        System.assertEquals(
            accountList.size(),
            initialAccountCount,
            'Initial loading of all the account records.'
        );
        System.assertEquals(
            true,
            recordsBoolean,
            'Tells if to render the table or not.'
        );
        System.assertNotEquals(
            true,
            norecordsBoolean,
            'Tells if to render the table or not.'
        );
        System.assertEquals(
            0,
            afterClearListCount,
            'Size of the AccountList rendering in List after clicking the clear button.'
        );
        System.assertEquals(
            0,
            afterClearSearchBoxSize,
            'Length of the InputField after clicking the clear button must reset to empty.'
        );
        System.assertEquals(
            11,
            searchResultCount,
            'The Search result for the InputField.'
        );
        System.assertEquals(
            resultForCharLenLess3BeforeSearch,
            resultForCharLenLess3AfterSearch,
            'AccountList won\'t change because search keyword is less than length approved.'
        );
        System.assertEquals(
            true,
            renderErrorMessage,
            'Search keyword is less than length approved. Error Message will render.'
        );
    }
}