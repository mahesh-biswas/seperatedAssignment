public with sharing class CountryCityPageController {
    public List<String> countries{get; set;}
    public String country{get; set;}
    public String city{get; set;}
    public String lang{get; set;}
    public String language{get; set;}
    Map<String,List<String>> countryCityMapping = new Map<String,List<String>>();

    public Student__c student{get; set;}

    public CountryCityPageController() {
        Map<string,Country__c> countryMap = Country__c.getAll();
        lang = Languages__c.getInstance(Languages__c.getInstance('selected').language_code__c).language_code__c;
        System.debug('langis: '+lang);
        this.country  = '--SELECT--';
        this.city  = '--SELECT--';
        // System.debug('map'+countryMap);
        countries = new List<String>(countryMap.keySet());
        // System.debug('countries'+countries);
        try {
            for(City__c cityItr : City__c.getAll().values()){
                List<String> tmp;
                if(countryCityMapping.get(cityItr.Country__c)==null){
                    tmp = new List<String>();
                    tmp.add(cityItr.Name);
                    countryCityMapping.put(cityItr.Country__c,tmp);
                }else{
                    tmp = countryCityMapping.get(cityItr.Country__c);
                    tmp.add(cityItr.Name);
                    countryCityMapping.put(cityItr.Country__c,tmp);
                }
            }
            // System.debug('finalMap:'+countryCityMapping);
        } catch (Exception exc) {
            System.debug(exc);
        }
        student = new Student__c();
    }
    public void updateLanguage(){
        Languages__c.getInstance('selected').language_code__c = language;
        update Languages__c.getInstance('selected');
        // return Languages__c.getInstance(languageInFull).language_code__c;
    }
    public List<SelectOption> getCountryItems(){
        List<SelectOption> options = new List<SelectOption>();
        for(String countryItr : countries){
            options.add(new SelectOption(countryItr,countryItr));
        }
        // System.debug('countries:'+options);
        return options;
    }
    public List<SelectOption> getLangItems(){
        List<SelectOption> options = new List<SelectOption>();
        for(Languages__c languageItr : Languages__c.getAll().values()){
            if(languageItr.Name!='selected')
                options.add(new SelectOption(languageItr.Name,languageItr.Name));
            // System.debug('lang: '+languageItr);
        }
        // System.debug('languages:'+options);
        return options;
    }
    public List<SelectOption> getCityItems(){
        List<SelectOption> options = new List<SelectOption>();
        for(String cityItr : countryCityMapping.get(country)){
            options.add(new SelectOption(cityItr,cityItr));
        }
        // System.debug('cities:'+options);
        return options;
    }
    public Boolean getCityReady(){
        return countryCityMapping.get(country)!=null ? True : False;
    }
    public PageReference submit(){
        insert student;
        student = new Student__c();
        return null;
    }
}