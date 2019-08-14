public with sharing class AccountManagerControllerExtension {
    public Account accountObject{get; set;}
    public List<Account> accountList{get; set;}
    public Boolean displayErrorMessage;
    private String lastAlphabet;
    public Boolean renderLengthError{
        get{
            return displayErrorMessage;
        }
        set;
    }
    public Boolean renderList{
        get{
            if(accountList.size()>0){
                return true;
            }else{
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'No Account Records Found..'
                    )
                );
                return false;
            }
        }
        set;
    }
    public list<String> alphabetStrip {get; set;}
    public String alphabet{get; set;}
    public AccountManagerControllerExtension(ApexPages.StandardSetController standardSetControllerObject) {
        System.debug('ssc:'+standardSetControllerObject);
        accountObject = new Account();
        accountObject.Name='';
        alphabetStrip = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
        accountList = [
            SELECT
                Name,
                Phone,
                Website
            FROM
                Account
        ];
    }
    public void searchFor(){
        if(alphabet!=null){
            String key = alphabet+'%';
            accountList =  [
                SELECT
                    Name,
                    Phone,
                    Website
                FROM
                    Account
                WHERE
                    Name
                LIKE
                    :key
            ];
            lastAlphabet = alphabet;
        }else if(!String.isBlank(accountObject.Site) && accountObject.Site.length()>3){
            String key = '%'+accountObject.Site+'%';
            accountList =  [
                SELECT
                    Name,
                    Phone,
                    Website
                FROM
                    Account
                WHERE
                    Name
                LIKE
                    :key
            ];
            displayErrorMessage = false;
        }else{
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'search Keyword: ('+accountObject.Site+') must be at least 4 characters to perform search'
                )
            );
            displayErrorMessage = true;
        }
        alphabet = null;
    }
    public void clearAll(){
        accountObject.Site = '';
        accountList = new List<Account>();
    }
    public List<Account> retrieveAccounts(){
        return accountList;
    }
    @RemoteAction
    public static String deleteAccount(String accountIdToDelete){
        // return 'heklo';
        try{
            delete new Account(Id=accountIdToDelete);
            return 'Deleted Successfully';
        }catch(DMLException dmlexceptionobject){
            System.System.debug(dmlexceptionobject);
            return 'Deleted FAILED!!';
        }
    }
}